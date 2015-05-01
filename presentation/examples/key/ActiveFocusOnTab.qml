import QtQuick 2.1
import QtQuick.Layouts 1.0

FocusRect {
    title: "root"
    width: 800
    height: 600

    RowL {
        VisualFocusScope {
            focus: true
            title: "1"
            ColumnL {
                FocusRect {
                    title: "2"
                    activeFocusOnTab: true
                }
                FocusRect {
                    focus: true
                    title: "3"
                    activeFocusOnTab: true
                }
            }
        }

        VisualFocusScope {
            title: "4"
            ColumnL {
                FocusRect {
                    title: "5"
                    activeFocusOnTab: true
                }
                FocusRect {
                    title: "6"
                    activeFocusOnTab: true
                }
            }
        }
    }
}
