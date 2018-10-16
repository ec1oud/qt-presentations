import QtQuick 2.0

Item {
    /*
      A slide can only be instantiated as a direct child of a Presentation {}
      as it relies on several properties there.
    */

    id: slide
    objectName: title

    property bool isSlide: true;

    property bool delayPoints: false;
    property int _pointCounter: 0;
    function _advance() {
        if (!parent.allowDelay)
            return false;

        _pointCounter = _pointCounter + 1;
        if (_pointCounter < content.length)
            return true;
        _pointCounter = 0;
        return false;
    }

    property string title;
    property variant content: []
    property alias text: html.text
    property alias textFormat: html.textFormat
    property alias textStyle: html.style
    property alias textStyleColor: html.styleColor
    property alias htmlItem: html
    property string writeInText;
    property string notes;

    property real fontSize: parent.height * 0.05
    property real fontScale: parent.fontScale

    property real baseFontSize: fontSize * fontScale
    property real titleFontSize: fontSize * 1.2 * fontScale
    property real bulletSpacing: 1

    width: parent.width
    height: parent.height

    property real masterWidth: parent.width
    property real masterHeight: parent.height

    property color titleColor: parent.titleColor;
    property color textColor: parent.textColor;
    property string fontFamily: parent.fontFamily;

    visible: false
    layer.enabled: true
    layer.sourceRect: Qt.rect(-x, -y, parent.width, parent.height)

    Text {
        id: html
        x: parent.width * 0.05
        y: parent.height * 0.05
        font.pixelSize: baseFontSize
        font.family: slide.fontFamily
        color: slide.textColor
        wrapMode: Text.Wrap
        textFormat: Text.RichText
    }
}
