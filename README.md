This is a slide presentation system written in QML, forked from
http://code.qt.io/cgit/qt-labs/qml-presentation-system.git/
and containing branches with various Qt-related presentations,
and modifications which helped to create them.

If you want to create unrelated presentations, you'd better use
the original rather than this fork.

# Requirements

* Qt 5.8
  * qtbase, qtdeclarative, qtcharts, qtquickcontrols, qtquickcontrols2

# Running

Do 'make install' in the root directory to install the files to QTDIR/imports.

Then 

cd presentation; qmake; make; ./present to run the presentation

The "present" executable optionally takes a number of the slide to start on.

