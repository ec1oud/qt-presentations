import QtQuick 2.1

FocusRect {
    title: "root"
    width: 800
    height: 600

    RowL {
        VisualFocusScope {
            title: "1"
            ColumnL {
                FocusRect { title: "2" }
                FocusRect { title: "3" }
            }
        }
        VisualFocusScope {
            title: "4"
            ColumnL {
                FocusRect { title: "5" }
                FocusRect { title: "6" }
            }
        }
    }
}
