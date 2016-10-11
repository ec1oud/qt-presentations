CXX_MODULE = qml
TARGET  = examplehelper
TARGETPATH=Qt/labs/presentation/helper
IMPORT_VERSION = 1.0

QT += quick

SOURCES += plugin.cpp pointingfilter.cpp
HEADERS += examplehelper.h pointingfilter.h

load(qml_plugin)
