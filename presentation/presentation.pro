QT += qml quick widgets printsupport
TARGET = present
TEMPLATE = app
SOURCES += main.cpp \
    pointingfilter.cpp \
    ../tools/printslides/slideview.cpp
HEADERS += pointingfilter.h ../tools/printslides/slideview.h
OTHER_FILES = *.qml examples/*.qml
