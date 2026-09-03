// Copyright (C) 2026 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause
import QtQml
import QtMultimedia
import QtTextToSpeech
import QtUniversalInput
import Dogzilla
import Dogzilla.Interfaces
import QtRos2.Core as Ros2
import QtRos2.GeometryMsgs
import QtRos2.SensorMsgs
import QtRos2.StdMsgs
import QtRos2.StdSrvs
import QtRos2.Transforms

Ros2.Node {
    id: root
    nodeName: "dogzillad"   // FQN /dogzilla/dogzillad
    // Namespace the node so TF lands on /dogzilla/tf_static (QtRos2 remaps
    // tf2's absolute /tf, /tf_static to follow the namespace). All other
    // topics below derive their /dogzilla/ prefix from this too, so the
    // node name is free to describe the program rather than the robot.
    nodeNamespace: "/dogzilla"

    TwistPublisher {
        id: twp
        topic: `${root.nodeNamespace}/vel`
        linear.x: controller.walkSpeed
        linear.y: controller.sideStepSpeed
        angular.z: controller.steerAngle
    }

    JointStatePublisher {
        id: jsp
        topic: `${root.nodeNamespace}/joint_states`
        name:  [
                "lf_lower_leg_joint",
                "lf_upper_leg_joint",
                "lf_hip_joint",

                "rf_lower_leg_joint",
                "rf_upper_leg_joint",
                "rf_hip_joint",

                "lh_lower_leg_joint",
                "lh_upper_leg_joint",
                "lh_hip_joint",

                "rh_lower_leg_joint",
                "rh_upper_leg_joint",
                "rh_hip_joint",
          ]
        position: controller.jointAngles
       // could also include velocity, effort
   }

    BatteryStatePublisher {
        id: bsp
        topic: `${root.nodeNamespace}/battery_state`
        percentage: controller.batteryPercent / 100
        present: true
    }

    property ConsoleDashboard dash: ConsoleDashboard {
        batteryLevel: controller.batteryPercent
        tty: "/dev/tty1"
    }

    // Ros2Node apparently only allows childEntities as children:
    // if we don't declare a property, we get
    // Cannot assign object of type "QQmlConnections" to list property "childEntities"; expected "QRos2Entity"
    property Controller controller: Controller {
        serialPort: "/dev/ttyAMA0"
        baudRate: 115200
        onBatteryPercentChanged: console.log("batt", batteryPercent);
    }

    property UniversalInput univin: UniversalInput {
        /*!
            Note: to get xbox mode, hold down the mode button on the controller to
            switch to the mode where the green LED is lit. The default mode with the
            red LED is almost as good, but the shoulder axes become binary rather
            than giving a range of values.
        */
        onJoyAxisEvent:
            (device, axis, value) => {
                console.log("axis", axis, value)
                switch (axis) {
                // left stick: yaw speed (steer) and walk speed
                case 0: // JoyAxis.LeftX
                    controller.steerAngle = value * -90
                    break;
                case 1: // JoyAxis.LeftY
                    controller.walkSpeed = value * -50
                    break;
                // right stick: side step (strafe) and pitch angle (look up/down)
                case 2: // JoyAxis.RightX
                    controller.sideStepSpeed = value * -50
                    break;
                case 3: // JoyAxis.RightY
                    controller.pitch = value * 15
                    break;
                }
            }
        onJoyButtonEvent:
            (device, button, isPressed) => {
                console.log("button", button, isPressed)
                switch (button) {
                case 6: // JoyButton.Start
                    if (!isPressed)
                        return
                    const engage = !controller.motorsEngaged
                    controller.motorsEngaged = engage
                    lidar.running = engage
                    break
                case 4: // JoyButton.Back
                    if (isPressed)
                        controller.stop()
                    break
                case 0: // JoyButton.A
                    mic.listening = isPressed
                    break
                }
            }
    }

    // JoySubscriber is also possible, but would usually drive a TwistPublisher

    TwistSubscriber {
        id: cmdVelSub
        topic: `${root.nodeNamespace}/cmd_vel`
        // TODO declarative multi-binding: either this or univin can comnmand the controller;
        // or, drive TwistPublisher from univin
        onMessageReceived: (msg) => {
            console.log("--- twist", JSON.stringify(msg), msg.linear)
            controller.sideStepSpeed = msg.linear.y
            controller.walkSpeed = msg.linear.x
            // linear.z angular.x and angular.y are documented for "aerial vehicles only"
            controller.steerAngle = msg.angular.z
        }
    }

    PoseStampedSubscriber {
        id: poseSub
        topic: `${root.nodeNamespace}/body_pose/command`
        onPoseChanged: {
            // pose.orientation.rpyDegrees is a ROS vector3 (degrees, double)
            // eulerAngles is a single-precision QVector3D, and would need QtQuick
            // header.frameId is available if we later want to validate/transform the frame
            controller.roll = poseSub.pose.orientation.rpyDegrees.x
            controller.pitch = poseSub.pose.orientation.rpyDegrees.y
            controller.yaw = poseSub.pose.orientation.rpyDegrees.z
        }
    }

    // Feedback from the IMU, published symmetric with body_pose/command.
    // measuredRoll/measuredPitch are tared real degrees (relative to startup, or
    // to the last controller.tareAttitude()). Yaw is published as 0: the firmware's
    // yaw is a free-running gyro integral that drifts ~14 deg/s, so the twin's
    // heading should come from odometry, not here. Referencing the measured*
    // properties is also how the Controller detects interest and starts IMU polling.
    // (Same fromEulerAngles pattern the digital twin uses on the command side.)
    PoseStampedPublisher {
        id: posePub
        topic: `${root.nodeNamespace}/body_pose/state`
        pose.orientation: Quaternion.fromEulerAngles(controller.measuredRoll,
                                                      controller.measuredPitch,
                                                      0)
    }

    CompressedImagePublisher {
        id: imagePublisher
        topic: `${root.nodeNamespace}/camera/image/compressed`
        // Best-effort: over a congested Wi-Fi link, drop frames rather than
        // retransmit/block. Stale video is useless, and reliable delivery of a
        // high-rate JPEG stream is what clogs the link. The digitwin's
        // CompressedImageSubscriber must request best-effort too, to match.
        qos: Ros2.QualityOfService.sensorData()
    }

    property CaptureSession captureSession: CaptureSession {
        property LoggingCategory cameraCategory: LoggingCategory {
            id: cameraCategory
            name: "dogzilla.camera"
            defaultLogLevel: LoggingCategory.Warning
        }

        imageCapture: ImageCapture {
            id: imageCapture
            onImageCaptured: (reqId, image) => {
                const timeMs = new Date().getTime()
                console.log(cameraCategory, "image captured", reqId, image)
                const msg = {
                    "header": {
                        "stamp": {
                            "sec": Math.trunc(timeMs / 1000),
                            "nanosec": timeMs % 1000 * 1000000
                        },
                        "frameId": reqId
                    },
                    "format": "jpeg",
                    "image": image
                };
                imagePublisher.publish(msg)
            }
        }
        camera: Camera {
            id: camera
            onErrorOccurred: (err, errorString) => console.log("camera error", errorString)
        }

        property Timer cameraTimer: Timer {
            interval: 200 // TODO increase the frequency; how to make it adaptive?
            repeat: true
            running: true // TODO only when the network is up, DDS is ok and some client is listening
            onTriggered: imageCapture.capture()
        }
    }

    LaserScanPublisher {
        id: frickenLaserPublisher
        topic: `${root.nodeNamespace}/sensor_msgs/msg/LaserScan`
    }

    // Static base_link -> laser_frame transform, from the URDF laser_Joint origin
    // (xyz="-0.016732 4.4164E-05 0.10335" rpy="0 0 0"). The lidar.cpp scan already
    // stamps frame_id="laser_frame", so SLAM (rf2o + slam_toolbox) can resolve it.
    // StaticTransformBroadcaster wraps tf2_ros and latches the declared transform
    // on /tf_static (transient_local), so a tf2 listener that starts later (e.g.
    // the slam node) still receives it. Declared (not sent imperatively) so it is
    // (re)published from setupConnection once the node is initialized, with no
    // race against Component.onCompleted.
    StaticTransformBroadcaster {
        transforms: [{
            "header": { "frameId": "base_link" },
            "childFrameId": "laser_frame",
            "transform": {
                "translation": { "x": -0.016732, "y": 4.4164e-05, "z": 0.10335 },
                "rotation": { "x": 0, "y": 0, "z": 0, "w": 1 }
            }
        }]
    }

    property Lidar lidar: Lidar {
        serialPort: "/dev/ttyAMA1"
        onSectorScanned: (msg) => frickenLaserPublisher.publish(msg)
    }

    // Push-to-talk speech-to-text. The digital twin toggles
    // /dogzilla/speech/listen (true = button pressed, false = released): while
    // held we silence the fan and capture the mic; on release we stop capture,
    // transcribe the utterance (whisper, on a worker thread) and append it to
    // the conversation log on /dogzilla/speech/log as a HEARD line.
    property FanController fan: FanController {
        quiet: mic.listening
    }
    property AudioCapture mic: AudioCapture {
        onCaptured: (pcm) => stt.transcribe(pcm)
    }
    property WhisperSpeechToText stt: WhisperSpeechToText {
        // tiny.en-q5_1 is the fast default; swap to ggml-base.en.bin for accuracy.
        modelPath: "/usr/share/whisper.cpp/models/ggml-tiny.en-q5_1.bin"
        onTranscriptReady: (text, confidence) => {
            console.log("heard:", text, "confidence", confidence);
            root.logChat(root.chatHeard, text, confidence);
            // Voice command? If the utterance is short and ends with a
            // taught pose ("please sit"), play it directly -- no LLM round-trip.
            // Otherwise it's conversation, so hand it to the LLM (async reply below).
            const motion = root.matchMotionCommand(text);
            if (motion) {
                root.logChat(root.chatSystem, "▶ " + motion, 0.0);
                root.playTrajectory(root.motionLibrary[motion], null);
                return;
            }
            root.lm.chat(text)
        }
        onErrorOccurred: (msg) => console.warn("stt:", msg)
    }

    // Remote Ollama LLM: whisper transcripts go in via chat(), and the reply
    // comes back on responseReceived(), which we route to speak() so the dog
    // answers out loud (and the line lands in the /speech/log chat the twin
    // shows). Set apiUrl to your Ollama host (e.g. http://192.168.x.x:11434)
    // and model to an installed model; both are still placeholders here.
    property LanguageModel lm: LanguageModel {
        // set to the actual LLM host IP; empty means chat() is a no-op.
        apiUrl: "http://laptop.local:11434"
        model: "qwen3.5:4b"
        // promptSource: "/usr/share/dogzillad/prompt.txt"
        promptSource: Qt.resolvedUrl("prompt.txt")
        onResponseReceived: (text) => {
            // If a twin Speak(use_llm) goal is waiting on this reply, speak it
            // as part of that goal so the twin's stop button can interrupt it;
            // otherwise this is the autonomous STT->LLM path.
            if (root.activeSpeak)
                root.speakForGoal(text);
            else
                root.speak(text);
        }
    }

    // Text-to-speech (QtTextToSpeech via the offline flite engine -> PipeWire).
    // The default engine/voice is fine; say() is async (state goes Speaking then
    // Ready). Non-Ros2 type, so it hangs off a property like the others.
    property TextToSpeech tts: TextToSpeech {
        onErrorOccurred: (reason, msg) => console.warn("tts:", msg)
        // TTS returned to Ready: succeed the goal whose speech was actually
        // playing. We key off speakingGoal, not activeSpeak, because Ready is
        // ALSO the state after stop() -- so a stop() from a supersede/cancel
        // would otherwise land here and falsely succeed the *next* goal (which
        // is only "thinking", not speaking). Clearing speakingGoal before every
        // stop() makes those stray Ready transitions no-ops.
        onStateChanged: {
            if (tts.state === TextToSpeech.Ready && root.speakingGoal) {
                root.speakingGoal.succeed({ spokenText: root.activeSpokenText, completed: true });
                if (root.activeSpeak === root.speakingGoal)
                    root.activeSpeak = null;
                root.speakingGoal = null;
            }
        }
    }

    // Speak text and record it in the chat log. The single entry point for the
    // robot's voice: the Speak action and the autonomous STT->LLM path both call
    // this, so every spoken line is logged exactly once. The chat log keeps the
    // original text (the twin's ChatView renders markdown), but TTS gets a
    // stripped copy -- flite/QTextToSpeech have no emphasis/SSML support, so an
    // LLM's "**bold**" would otherwise be read aloud as "asterisk asterisk".
    function speak(text: string) {
        if (!text)
            return;
        tts.say(stripForSpeech(text));
        logChat(chatSpoken, text, 0.0);
    }

    // Drop markdown so it isn't spoken literally. QtCore-only (plain JS RegExp):
    // dogzillad is a headless QCoreApplication, so QTextDocument (QtGui) is out.
    // Handles the inline markup an LLM typically emits; the log keeps the raw
    // text for rich display in the twin.
    function stripForSpeech(md: string): string {
        return md
            .replace(/```[\s\S]*?```/g, " ")         // fenced code blocks
            .replace(/`([^`]+)`/g, "$1")             // inline code
            .replace(/!\[[^\]]*\]\([^)]*\)/g, "")    // images
            .replace(/\[([^\]]+)\]\([^)]*\)/g, "$1") // links -> link text
            .replace(/(\*\*|__)(.*?)\1/g, "$2")      // bold
            .replace(/(\*|_)(.*?)\1/g, "$2")         // italic
            .replace(/~~(.*?)~~/g, "$2")             // strikethrough
            .replace(/^\s{0,3}#{1,6}\s+/gm, "")      // headings
            .replace(/^\s*>+\s?/gm, "")              // blockquotes
            .replace(/^\s*[-*+]\s+/gm, "")           // bullet lists
            .replace(/^\s*\d+\.\s+/gm, "")           // numbered lists
            .replace(/\s+/g, " ")                    // collapse whitespace
            .trim();
    }

    // Append one line to the conversation log on /dogzilla/speech/log. Imperative
    // (not a binding): each call is a distinct event. header.stamp is auto-filled
    // by the publisher from the node clock, so we omit it here.
    function logChat(source: int, text: string, confidence: real) {
        speechLog.publish({ "source": source, "text": text, "confidence": confidence });
    }

    // Mirror of dogzilla_interfaces/ChatMessage's source constants: the QtRos2
    // wrapper doesn't surface ROS message constants to QML, so keep them in sync
    // with the .msg by hand (HEARD=0, SPOKEN=1, SYSTEM=2).
    readonly property int chatHeard: 0
    readonly property int chatSpoken: 1
    readonly property int chatSystem: 2

    // ---- Speak action (the twin's "Speak"/"Send" buttons + "stop") --------
    // The currently-executing Speak goal handle, or null. TTS and LLM
    // completion are tied to it so the twin's stop button (an action cancel)
    // can interrupt speech and report the goal as canceled.
    property var activeSpeak: null
    property string activeSpokenText: ""
    // The goal whose TTS is actually playing right now (set when say() starts,
    // cleared before any stop() and on completion). Distinct from activeSpeak:
    // an active goal can be "thinking" (awaiting the LLM) and not yet speaking.
    property var speakingGoal: null

    // Start executing a Speak goal from the twin. use_llm=false speaks the text
    // verbatim; use_llm=true asks the LLM first and speaks the reply. The goal
    // stays active until TTS finishes (succeed) or stopSpeaking() interrupts it
    // (abort) -- there's no goal-scoped cancel: the twin's stop button hits the
    // /speech/stop service instead, so it silences autonomous speech too.
    function beginSpeak(handle, goal) {
        // One voice, one goal: stop anything already speaking before taking over.
        if (activeSpeak && activeSpeak !== handle)
            stopSpeaking();
        activeSpeak = handle;
        activeSpokenText = "";
        if (goal.useLlm) {
            handle.publishFeedback({ state: "thinking", spokenSoFar: "" });
            lm.chat(goal.text);
        } else {
            speakForGoal(goal.text);
        }
    }

    // Stop the robot's voice NOW, whatever started it. The single stop authority:
    // TTS is the one voice, so we stop it directly rather than through a goal --
    // autonomous STT->LLM speech (speak() with no handle) has no goal to cancel.
    // If a twin Speak goal is mid-utterance, abort it so the twin sees it finish.
    // Called by the /speech/stop service and by beginSpeak when superseding.
    function stopSpeaking() {
        speakingGoal = null;   // before stop(): suppress the stray Ready (see tts.onStateChanged)
        tts.stop();
        if (activeSpeak) {
            activeSpeak.abort({ spokenText: activeSpokenText, completed: false });
            activeSpeak = null;
        }
    }

    // Speak text as part of the active goal: publish "speaking" feedback, then
    // hand off to speak() (TTS + chat log). Empty text completes immediately.
    function speakForGoal(text: string) {
        activeSpokenText = text;
        if (!activeSpeak)
            return;
        if (!text) {
            activeSpeak.succeed({ spokenText: "", completed: true });
            activeSpeak = null;
            return;
        }
        activeSpeak.publishFeedback({ state: "speaking", spokenSoFar: text });
        speakingGoal = activeSpeak;   // this goal's speech is starting; Ready now means "done"
        speak(text);
    }

    // ---- PlayMotion action (the twin's teach-pendant playback + "stop") ----
    // Plays a taught trajectory_msgs/JointTrajectory the standard ROS way:
    // time_from_start is each point's ARRIVAL time, and we LINEARLY INTERPOLATE the
    // joint angles between points (at ~20 Hz) so motion is smooth and timed -- not a
    // step to each target left to the firmware's fixed-speed slew (which was jerky).
    // A held pose is just two consecutive points with the same positions. At 115200
    // baud, 12 servo writes per tick @ 20 Hz is ~15% of the link -- comfortable.
    property var activeMotion: null            // the in-flight PlayMotion handle, or null (voice-triggered)
    property bool motionRunning: false         // a motion is playing (with or without a handle)
    property var motionPositions: []           // per-point 12-elem radian arrays (canonical order), incl. the t=0 start pose
    property var motionTimes: []               // per-point arrival time in ms (motionTimes[0] === 0)
    property double motionStartMs: 0           // wall-clock start of the motion

    // Named motions synced from the twin (name -> JointTrajectory {jointNames, points}),
    // so a spoken command like "dogzilla, please sit" can play one locally. See the
    // /motion/library subscriber and matchMotionCommand below.
    property var motionLibrary: ({})
    // Persists the library to disk so it survives restarts / twin disconnects.
    property MotionStore motionStore: MotionStore {}

    // Canonical joint order = the JointStatePublisher name list above = the order
    // Controller::setJointAngles expects. Incoming trajectories are reordered to it.
    readonly property var motionJointOrder: [
        "lf_lower_leg_joint", "lf_upper_leg_joint", "lf_hip_joint",
        "rf_lower_leg_joint", "rf_upper_leg_joint", "rf_hip_joint",
        "lh_lower_leg_joint", "lh_upper_leg_joint", "lh_hip_joint",
        "rh_lower_leg_joint", "rh_upper_leg_joint", "rh_hip_joint",
    ]

    // Held in a property, not a bare child: the root Ros2.Node only accepts
    // QRos2NodeChild in its default childEntities list (same reason controller/tts
    // are properties above), so a bare Timer aborts QML load.
    property Timer motionTimer: Timer {
        interval: 50            // ~20 Hz interpolation
        repeat: true
        onTriggered: root.interpolateTick()
    }

    // Action entry point: the twin's PlayMotion goal.
    function beginMotion(handle, goal) {
        root.playTrajectory(goal ? goal.trajectory : null, handle);
    }

    // Play a JointTrajectory. `handle` is the PlayMotion goal handle for
    // twin-initiated motions (feedback + cancel); null for voice-triggered ones.
    function playTrajectory(traj, handle) {
        // One motion at a time: abort/stop any in flight.
        if (motionRunning) {
            console.warn("playTrajectory: already in motion, aborting");
            motionTimer.stop();
            if (activeMotion)
                activeMotion.abort({ completed: false });
            activeMotion = null;
            motionRunning = false;
        }
        const pts = traj ? traj.points : [];
        if (!pts || pts.length === 0) {
            console.warn("playTrajectory: empty trajectory");
            if (handle) handle.abort({ completed: false });
            return;
        }
        if (!controller.motorsEngaged) {
            if (handle) {                      // twin: the operator engages first
                console.warn("playTrajectory: motors disengaged; aborting");
                handle.abort({ completed: false });
                return;
            }
            controller.motorsEngaged = true;   // voice: stand up, then play
        }
        // Anchor the interpolation at the dog's CURRENT pose (t=0), then each
        // trajectory point at its arrival time. Reorder positions to canonical
        // joint order (requires all 12 joints).
        let positions = [controller.jointAngles];   // radians, canonical order already
        let times = [0];
        for (let k = 0; k < pts.length; ++k) {
            const canon = root.toCanonicalPositions(traj.jointNames, pts[k].positions);
            if (!canon) {
                console.warn("playTrajectory: point", k, "is not a full 12-joint pose");
                if (handle) handle.abort({ completed: false });
                return;
            }
            const t = pts[k].timeFromStart;
            positions.push(canon);
            times.push(t.sec * 1000 + t.nanosec / 1e6);
        }

        root.motionPositions = positions;
        root.motionTimes = times;
        activeMotion = handle;   // may be null (voice)
        motionRunning = true;
        if (handle) {
            // Stop button = action cancel (property-shadows-signal caveat as Speak).
            handle.cancelRequestedChanged.connect(() => {
                if (!handle.cancelRequested || root.activeMotion !== handle)
                    return;
                motionTimer.stop();
                handle.canceled({ completed: false });   // hold the current pose
                root.activeMotion = null;
                root.motionRunning = false;
            });
        }

        // Fast servo slew so the servos track the interpolated setpoints tightly
        // (the interpolation, not the firmware, sets the effective speed).
        controller.setMotorSpeed(200);
        root.motionStartMs = Date.now();
        root.interpolateTick();     // apply the first setpoint immediately
        motionTimer.start();
    }

    // Send the interpolated joint setpoint for the elapsed time (or finish).
    function interpolateTick() {
        if (!motionRunning)
            return;
        const times = root.motionTimes;
        const pos = root.motionPositions;
        const n = times.length;
        const total = times[n - 1];
        const elapsed = Date.now() - root.motionStartMs;

        if (elapsed >= total) {                 // done: land exactly on the last pose
            controller.setJointAngles(pos[n - 1]);
            motionTimer.stop();
            if (activeMotion)
                activeMotion.succeed({ completed: true });
            activeMotion = null;
            motionRunning = false;
            return;
        }
        // Find the segment [k, k+1] containing elapsed, and lerp within it.
        let k = 0;
        while (k < n - 1 && times[k + 1] <= elapsed)
            ++k;
        const span = times[k + 1] - times[k];
        const a = span > 0 ? (elapsed - times[k]) / span : 1;
        const p0 = pos[k], p1 = pos[k + 1];
        let interp = new Array(12);
        for (let j = 0; j < 12; ++j)
            interp[j] = p0[j] + (p1[j] - p0[j]) * a;
        controller.setJointAngles(interp);
        if (activeMotion)
            activeMotion.publishFeedback({ currentPoint: k, progress: elapsed / total });
    }

    // If the transcript is a "... <pose>" command whose last word(s) name a
    // motion in the synced library, return that name; else "".
    // Only when the sentence is 3 words or less, to avoid triggering
    // on ordinary conversation.
    function matchMotionCommand(text) {
        const words = text.toLowerCase().replace(/[.!?:;,]/g, "").trim().split(" ")
        if (words.length > 3)
            return "" // don't use long sentences for simple commands
        const lastWord = words.pop()
        for (const name of Object.keys(root.motionLibrary)) {
            const n = name.toLowerCase()
            if (lastWord === n)
                return name
        }
        return ""
    }

    // Reorder a waypoint's positions into canonical joint order. Returns null if it
    // isn't a full 12-joint pose (a name is missing, or the wrong length) -- v1
    // plays whole-body poses only. Empty joint_names => assume already canonical.
    function toCanonicalPositions(names, positions) {
        if (!positions || positions.length !== 12)
            return null;
        if (!names || names.length === 0)
            return positions;
        let out = new Array(12);
        for (let c = 0; c < 12; ++c) {
            const idx = names.indexOf(root.motionJointOrder[c]);
            if (idx < 0)
                return null;
            out[c] = positions[idx];
        }
        return out;
    }

    BoolSubscriber {
        topic: `${root.nodeNamespace}/speech/listen`
        // std_msgs/Bool single-field collapse: the handler gets the bool directly.
        onMessageReceived: (listening) => mic.listening = listening
    }

    // The conversation, for the twin's chat log: HEARD (what the human said, with
    // STT confidence) and SPOKEN (what the dog said) lines, timestamped. Custom
    // dogzilla_interfaces/ChatMessage (not the deprecated std_msgs/String), so it
    // carries source + confidence and is Header-stamped. Default (reliable) QoS:
    // a chat log is a live stream; the twin accumulates from when it connects.
    ChatMessagePublisher {
        id: speechLog
        topic: `${root.nodeNamespace}/speech/log`
    }

    // The twin's "Speak" / "Send" buttons: one Speak goal at a time. The goal's
    // use_llm flag selects verbatim TTS ("Speak") vs LLM-then-speak ("Send").
    // The goal isn't cancelled to stop speech -- see /speech/stop below: the
    // twin's stop button is a service that silences TTS regardless of how the
    // speech started, so it also stops the autonomous STT->LLM voice, which has
    // no goal. Replaces the older fire-and-forget /speech/say, /speech/respond.
    SpeakActionServer {
        topic: `${root.nodeNamespace}/speech/speak`
        onGoalReceived: (goal, handle) => root.beginSpeak(handle, goal)
    }

    // "Stop the voice": the single authority for silencing TTS, regardless of
    // how speech started (twin Speak goal or autonomous STT->LLM). std_srvs/
    // Trigger so the caller gets an ack; the response is declarative. Distinct
    // from an action cancel, which could only reach a goal the twin itself sent
    // -- never the robot's own autonomous speech.
    TriggerServiceServer {
        topic: `${root.nodeNamespace}/speech/stop`
        onRequestReceived: root.stopSpeaking()
        response: ({ success: true, message: "speech stopped" })
    }

    // Teach-pendant playback: the twin sends a taught JointTrajectory here; the
    // robot walks its waypoints (see beginMotion). Cancel = the twin's stop button.
    PlayMotionActionServer {
        topic: `${root.nodeNamespace}/motion/play`
        onGoalReceived: (goal, handle) => root.beginMotion(handle, goal)
    }

    // The twin's named-motion library, as a JSON object { name: JointTrajectory }.
    // Latched (transient-local) so we get the current set on (re)connect; lets a
    // spoken pose name be played locally without the twin in the loop each time.
    StringSubscriber {
        topic: `${root.nodeNamespace}/motion/library`
        qos: Ros2.QualityOfService.transientLocal()
        onMessageChanged: {
            try {
                const lib = JSON.parse(message) || ({});
                // Ignore an empty publish so a fresh/motionless twin can't wipe the
                // robot's persisted poses; a non-empty library is authoritative.
                if (Object.keys(lib).length === 0)
                    return;
                root.motionLibrary = lib;
                root.motionStore.save(message);
                console.log("motion library:", Object.keys(lib).join(", "));
            } catch (e) {
                console.warn("motion library parse error:", e);
            }
        }
    }

    // Readiness/status for the twin: "idle" (ready) / "listening" / "transcribing".
    // Latched (transient-local) so a twin that connects later immediately gets
    // the current state and can, e.g., enable the PTT button only when idle.
    StringPublisher {
        id: statePub
        topic: `${root.nodeNamespace}/speech/state`
        qos: Ros2.QualityOfService.transientLocal()
        // Fully declarative: single-field publishers expose one bindable
        // property (named after the field, `data` for std_msgs/String) that
        // auto-publishes on change, and latched topics republish the stored
        // state on connect -- so the initial "idle" is latched for late
        // twins without an imperative publish. No binding loop: this reads
        // busy/listening and never writes them back.
        data: stt.busy ? "transcribing"
            : mic.listening ? "listening" : "idle"
    }

    // Audio mixer (wpctl -> PipeWire): "master" is the default sink,
    // "mic" the default source (capture gain for PTT). dogzillad shares
    // pi's user session, so no sudo. Each channel is read once at startup
    // and echoed on set; external changes (alsamixer etc.) are not tracked.
    property VolumeController volumeCtl: VolumeController {}

    // Each mixer channel is one node parameter: settable with feedback
    // (ros2 param set / RemoteParameter; out-of-range requests are rejected
    // by rclcpp from the declared bounds before we ever see them),
    // observable via /parameter_events, introspectable with
    // ros2 param describe. VolumeController is the source of truth: the
    // value binding publishes its state, and valueEdited routes external
    // sets back into it.
    Ros2.Parameter {
        name: "audio.master"
        value: volumeCtl.master
        minimum: 0.0
        maximum: 1.0
        description: "Master (default audio sink) volume"
        onValueEdited: (v) => volumeCtl.master = v
    }
    Ros2.Parameter {
        name: "audio.mic"
        value: volumeCtl.mic
        minimum: 0.0
        maximum: 1.0
        description: "Microphone (default audio source) capture gain"
        onValueEdited: (v) => volumeCtl.mic = v
    }

    // Engage (load/stand) or disengage (unload/relax) the leg servos from the
    // twin, without needing the joystick -- and the teach pendant needs the dog
    // engaged before playing a motion. A bool node parameter so it's both
    // settable and observable-with-feedback like audio.*: the value binding
    // republishes when the joystick Start toggles motorsEngaged (so the twin
    // stays in sync with the actual state), and valueEdited routes external sets
    // into the controller. Controller is the source of truth.
    Ros2.Parameter {
        name: "motors.engaged"
        value: controller.motorsEngaged
        description: "Leg servos engaged (loaded/standing) vs relaxed"
        onValueEdited: (v) => controller.motorsEngaged = v
    }

    // System telemetry (fan level, CPU temperature, CPU load) at 1 Hz, for the
    // twin's line charts -- e.g. watch PTT silence the fan and the temp/CPU
    // response.
    property Telemetry telemetry: Telemetry {}

    // fan + cpu via our custom dogzilla_interfaces/StampedTelemetry message. It's
    // multi-field, so it binds DECLARATIVELY -- no publish() in JS; the publisher
    // republishes when either metric changes. Because StampedTelemetry leads with a
    // std_msgs/Header, the generated publisher extends QRos2StampedPublisherBase and
    // auto-fills header.stamp from the node clock -- no manual timestamping here.
    // Generated from the dogzilla_interfaces package by qtros2_generate_from_package.
    StampedTelemetryPublisher {
        topic: `${root.nodeNamespace}/telemetry/system`
        fanLevel: telemetry.fanLevel
        cpuPercent: telemetry.cpuPercent
    }

    // Temperature via the standard sensor_msgs/Temperature -- also declarative.
    TemperaturePublisher {
        topic: `${root.nodeNamespace}/telemetry/temperature`
        temperature: telemetry.temperatureC
    }

    Component.onCompleted: {
        camera.start();
        console.log("chosen camera", camera.cameraDevice, camera.cameraFormat, "active", camera.active, "feat", camera.supportedFeatures);
        // Seed the motion library from disk; a connected twin's latched publish
        // (if any) overrides this shortly after.
        const saved = motionStore.load();
        if (saved) {
            try {
                root.motionLibrary = JSON.parse(saved) || ({});
                console.log("loaded persisted motions:", Object.keys(root.motionLibrary).join(", "));
            } catch (e) {
                console.warn("persisted motions parse error:", e);
            }
        }
    }
}
