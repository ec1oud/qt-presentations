This is a repository of various Qt-related presentations given as 
talks at various conferences.  It depends on
https://github.com/ec1oud/qml-presentation-system
which is a fork of
http://code.qt.io/cgit/qt-labs/qml-presentation-system.git/
Each presentation has its own git branch, so check out the one you want to see.
Also, init any submodules that may be required on that branch.
The TableView presentation depends on qps as a submodule.

# Requirements

* Qt 5.12
  * qtbase, qtdeclarative

# Running

Install the QML Presentation System.

Then `cd presentation; qml main.qml` or `qml main.qml -- 3` to start on slide 3, for example.

