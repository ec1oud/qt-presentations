import QtQuick 2.1

FocusRect {
    title: "root"
    width: 800; height: 600;

    RowL {
        FocusRect {
            title: "1"
            ColumnL {
                FocusRect { title: "2" }
                FocusRect { title: "3" }
            }
        }
        FocusRect {
            title: "4"
            ColumnL {
                FocusRect { title: "5" }
                FocusRect { title: "6" }
            }
        }
    }
}
