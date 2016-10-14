QT += qml quick widgets printsupport quickcontrols2 widgets
TARGET = present
TEMPLATE = app
SOURCES += main.cpp ../tools/printslides/slideview.cpp
HEADERS += ../tools/printslides/slideview.h
OTHER_FILES = *.qml examples/*.qml diagrams/*.qml
