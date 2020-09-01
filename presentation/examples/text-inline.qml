import QtQuick 2.14

Text {
    width: 500
    y: 100
    textFormat: Text.MarkdownText
    wrapMode: Text.WordWrap
    font.pointSize: 16
    // onLinkHovered: statusText.text = link
    onLinkActivated: Qt.openUrlExternally(link)
    text:
"Yes *this* is [Markdown](https://spec.commonmark.org/0.29/) not ~~plain text~~\n
- bullets?\n  + nested bullets?\n
- [ ] checkboxes?\n
- [x] yes of course"
}
