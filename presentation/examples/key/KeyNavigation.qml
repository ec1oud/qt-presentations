import QtQuick 2.1

FocusRect {
    title: "root"
    width: 800; height: 600;
    RowL {
        VisualFocusScope {
            title: "1"
            ColumnL {
                FocusRect {
                    id: n2; title: "2"
                    KeyNavigation.down: n3
                    KeyNavigation.right: n5
                    KeyNavigation.tab: n5
                }
                FocusRect {
                    id: n3; title: "3"
                    KeyNavigation.tab: n6
                }
            }
        }
        VisualFocusScope {
            title: "4"
            ColumnL {
                FocusRect {
                    id: n5; title: "5"
                    KeyNavigation.tab: n3
                }
                FocusRect {
                    id: n6; title: "6"
                    KeyNavigation.up: n5
                    KeyNavigation.left: n3
                    KeyNavigation.tab: n2
                }
            }
        }
    }
}
