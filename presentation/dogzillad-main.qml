import QtQml // not QtQuick
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
       // could also include velocity, effort, if we could measure it
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

    // Ros2Node only allows childEntities as children
    property Controller controller: Controller {
        serialPort: "/dev/ttyAMA0"
        baudRate: 115200
        onBatteryPercentChanged: console.log("batt", batteryPercent);
    }

    property UniversalInput univin: UniversalInput {
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
            controller.roll = poseSub.pose.orientation.rpyDegrees.x
            controller.pitch = poseSub.pose.orientation.rpyDegrees.y
            controller.yaw = poseSub.pose.orientation.rpyDegrees.z
        }
    }

    // Feedback from the IMU, published symmetric with body_pose/command.
    // Controller's yaw drifts too much, so heading must come from odometry.
    PoseStampedPublisher {
        id: posePub
        topic: `${root.nodeNamespace}/body_pose/state`
        // tared real degrees (since startup / controller.tareAttitude() )
        pose.orientation: Quaternion.fromEulerAngles(controller.measuredRoll,
                                                      controller.measuredPitch,
                                                      0) // yaw
    }

    CompressedImagePublisher {
        id: imagePublisher
        topic: `${root.nodeNamespace}/camera/image/compressed`
        // Best-effort: drop frames in case of congestion; CompressedImageSubscriber must match qos
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
            interval: 200 // TODO adaptive?
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
    // (xyz="-0.016732 4.4164E-05 0.10335" rpy="0 0 0"). lidar.cpp already stamps f
    // rame_id="laser_frame", for SLAM to resolve.
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

    // Push-to-talk speech-to-text. The digital twin toggles /dogzilla/speech/listen 
    // (true = button pressed); while held, silence the fan and capture the mic; 
    // on release, stop capture, transcribe the utterance and append to /dogzilla/speech/log
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
			// If the utterance is short and ends with a taught pose
			// ("please sit"), play it directly; otherwise, send to the LLM.
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

    // Remote LLM: whisper transcripts go in via chat();
    // reply is spoken and goes into /speech/log
    property LanguageModel lm: LanguageModel {
        apiUrl: "http://laptop.local:11434" // Ollama/llama.cpp host IP
        model: "qwen3.5:4b"                 // chosen model
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

    // QtTextToSpeech via the offline flite engine -> PipeWire; default engine/voice
    // say() is async (state goes Speaking then Ready)
    property TextToSpeech tts: TextToSpeech {
        onErrorOccurred: (reason, msg) => console.warn("tts:", msg)
        onStateChanged: {
            if (tts.state === TextToSpeech.Ready && root.speakingGoal) {
                // there was a goal, and it succeeded
                root.speakingGoal.succeed({ spokenText: root.activeSpokenText, completed: true });
                if (root.activeSpeak === root.speakingGoal)
                    root.activeSpeak = null;
                root.speakingGoal = null;
            }
        }
    }

    // Speak text and record it in the chat log. The single entry point for the
    // robot's voice: the Speak action and the autonomous STT->LLM path both call
    // this, so every spoken line is logged exactly once.
    function speak(text: string) {
        if (!text)
            return;
        tts.say(stripForSpeech(text)); // strip markdown so it doesn't say "asterisk" etc.
        logChat(chatSpoken, text, 0.0); // markdown is good for the log
    }

    // Drop typical LLM-reply markdown so it isn't spoken literally. 
    // QtCore-only JS: it's a headless QCoreApplication, can't use QTextDocument.
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

    // Append one line to the conversation log on /dogzilla/speech/log.
    // header.stamp is auto-filled by the publisher from the node clock
    function logChat(source: int, text: string, confidence: real) {
        speechLog.publish({ "source": source, "text": text, "confidence": confidence });
    }

    // Mirror of dogzilla_interfaces/ChatMessage's source constants
    // in sync with the .msg (TODO: make available to QML from the wrapper)
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

	// Start executing a Speak goal from the twin. Stays active until TTS
	// finishes (succeed) or is aborted via /speech/stop service (stopSpeaking)
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

	// Stop the robot's voice NOW, whatever started it, directly rather than
	// through a goal (autonomous STT->LLM speech has no goal to cancel).
    function stopSpeaking() {
        speakingGoal = null;   // before stop(): suppress the stray Ready
        tts.stop();
        if (activeSpeak) {
            activeSpeak.abort({ spokenText: activeSpokenText, completed: false });
            activeSpeak = null;
        }
    }

    // Speak text as part of the active goal: publish "speaking" feedback, then
    // hand off to speak() (TTS + chat log).
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
    // joint angles between points (at ~20 Hz) so motion is smooth and timed.
    // A held pose is just two consecutive points with the same positions.
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
    // STT confidence) and SPOKEN (what the dog said) lines, timestamped. 
    // Custom dogzilla_interfaces/ChatMessage carries source + confidence and is Header-stamped. 
    // Default (reliable) QoS for live chat log; the twin accumulates from when it connects.
    ChatMessagePublisher {
        id: speechLog
        topic: `${root.nodeNamespace}/speech/log`
    }

    // The twin's "Speak" / "Send" buttons: one Speak goal at a time.
    SpeakActionServer {
        topic: `${root.nodeNamespace}/speech/speak`
        onGoalReceived: (goal, handle) => root.beginSpeak(handle, goal)
    }

    // "Stop the voice" service
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
        // declarative single-field publisher exposes one bindable property
        // that auto-publishes on change, and latched topics republish the 
        // stored state on connect.
        data: stt.busy ? "transcribing"
            : mic.listening ? "listening" : "idle"
    }

    // Audio mixer (wpctl -> PipeWire): "master" is the default sink,
	// "mic" the default source (capture gain for PTT). Each channel is read once 
    // at startup and echoed on set; external changes are not tracked.
    property VolumeController volumeCtl: VolumeController {}

    // Each mixer channel is one node parameter: settable with feedback
    // (ros2 param set / RemoteParameter; out-of-range requests are rejected
	// by rclcpp from the declared bounds before we ever see them), observable
	// via /parameter_events, introspectable with ros2 param describe.
	// VolumeController is the source of truth: the value binding publishes its
	// state, and valueEdited routes external sets back into it.
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

    // Engage (load/stand) or disengage (unload/relax) the leg servos from the twin.
    // A bool node parameter so it's both settable and observable-with-feedback:
    // Controller is the source of truth; the value binding republishes when the 
	// joystick Start toggles motorsEngaged; valueEdited is for external sets
    Ros2.Parameter {
        name: "motors.engaged"
        value: controller.motorsEngaged
        description: "Leg servos engaged (loaded/standing) vs relaxed"
        onValueEdited: (v) => controller.motorsEngaged = v
    }

    // System telemetry (fan level, CPU temperature, CPU load) at 1 Hz
    property Telemetry telemetry: Telemetry {}

    // fan + cpu via our custom dogzilla_interfaces/StampedTelemetry message
    // Generated from the dogzilla_interfaces package by qtros2_generate_from_package.
    // Binding updates cause auto republish. Because StampedTelemetry leads with a
    // std_msgs/Header, publisher extends QRos2StampedPublisherBase and
    // auto-fills header.stamp from the node clock.
    StampedTelemetryPublisher {
        topic: `${root.nodeNamespace}/telemetry/system`
        fanLevel: telemetry.fanLevel
        cpuPercent: telemetry.cpuPercent
    }

    // Temperature via the standard sensor_msgs/Temperature
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
