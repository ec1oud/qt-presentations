
import QtQuick

import QtQuick.Svg // experimental hackathon API: not released

Item {
    width: 800; height: 800
    layer.enabled: true
    layer.samples: 8

    SvgView { // experimental hackathon API: not released
        x: 600; y: 300; scale: 2
        source: Application.arguments.length > 2 ?
                    Application.arguments[Application.arguments.length - 1] : Qt.resolvedUrl("primitives.svg")
        observesViewport: false
        DragHandler { }
        WheelHandler { property: "scale" }
        PinchHandler { }
    }
}
