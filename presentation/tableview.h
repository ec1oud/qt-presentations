

class QQuickTableView : public QQuickFlickable
{
    Q_PROPERTY(int rows READ rows NOTIFY rowsChanged)
    Q_PROPERTY(int columns READ columns NOTIFY columnsChanged)
    Q_PROPERTY(qreal rowSpacing READ rowSpacing WRITE setRowSpacing NOTIFY rowSpacingChanged)
    Q_PROPERTY(qreal columnSpacing READ columnSpacing WRITE setColumnSpacing NOTIFY columnSpacingChanged)
    Q_PROPERTY(QJSValue rowHeightProvider READ rowHeightProvider WRITE setRowHeightProvider NOTIFY rowHeightProviderChanged)
    Q_PROPERTY(QJSValue columnWidthProvider READ columnWidthProvider WRITE setColumnWidthProvider NOTIFY columnWidthProviderChanged)
    Q_PROPERTY(QVariant model READ model WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(QQmlComponent *delegate READ delegate WRITE setDelegate NOTIFY delegateChanged)
    Q_PROPERTY(bool reuseItems READ reuseItems WRITE setReuseItems NOTIFY reuseItemsChanged)
    Q_PROPERTY(qreal contentWidth READ contentWidth WRITE setContentWidth NOTIFY contentWidthChanged)
    Q_PROPERTY(qreal contentHeight READ contentHeight WRITE setContentWidth NOTIFY contentHeightChanged)

public:
    Q_INVOKABLE void forceLayout();
    ...
}
