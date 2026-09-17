import QtQuick
// import QtQuick.VectorImage

Item {
    property alias source: image.source
    Image {
        id: image
        anchors.fill: parent
        anchors.margins: 40
        fillMode: Image.PreserveAspectFit
        sourceSize.width: 3840
    }
}
