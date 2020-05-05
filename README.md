# QtPDF Presentation

This is a repository of various Qt-related presentations given as talks at
various conferences.  It depends on 
[https://github.com/ec1oud/qml-presentation-system](https://github.com/ec1oud/qml-presentation-system)
which is a fork of 
[http://code.qt.io/cgit/qt-labs/qml-presentation-system.git/](http://code.qt.io/cgit/qt-labs/qml-presentation-system.git/)

Different branches have different presentations.  You are now looking at the
presentation about the QtPDF module, first given in May 2020 at the Qt Virtual
Tech Con.

## Requirements

* Qt 5.15
  * qtbase, qtdeclarative, qtquickcontrols2, qtpdf

## Running

Install the QML Presentation System.

Then `cd presentation; qml Slides.qml`

## QtPDF

The QtPDF source code is within the qtwebengine repository under src/pdf.  How
to build:

```
$ git clone https://code.qt.io/qt/qtwebengine.git
$ cd qtwebengine
$ git submodule update --init --recursive
$ qmake . -- -no-build-qtwebengine-core
Info: creating stash file /home/myname/dev/qtwebengine/.qmake.stash 
Info: creating cache file /home/myname/dev/qtwebengine/.qmake.cache 

Running configuration tests... 
Checking for architecture supported... yes
... (many more tests)
Done running configuration tests. 

Configure summary: 

Qt WebEngine Build Tools:
  Use System Ninja ....................... yes
  Use System Gn .......................... no
  Jumbo Build Merge Limit ................ 8
  Developer build ........................ no
  QtWebEngine required system libraries:
    fontconfig ........................... yes
    dbus ................................. yes
    nss .................................. yes
    khr .................................. yes
    glibc ................................ yes
  QtWebEngine required system libraries for qpa-xcb:
    x11 .................................. yes
    libdrm ............................... yes
    xcomposite ........................... yes
    xcursor .............................. yes
    xi ................................... yes
    xtst ................................. yes
  Optional system libraries used:
    re2 .................................. yes
    icu .................................. no
    libwebp, libwebpmux and libwebpdemux . yes
    opus ................................. yes
    ffmpeg ............................... no
    libvpx ............................... yes
    snappy ............................... yes
    glib ................................. yes
    zlib ................................. yes
    minizip .............................. yes
    libevent ............................. yes
    jsoncpp .............................. yes
    protobuf ............................. yes
    libxml2 and libxslt .................. yes
    lcms2 ................................ yes
    png .................................. yes
    JPEG ................................. yes
    harfbuzz ............................. yes
    freetype ............................. yes
    xkbcommon ............................ yes
Qt PDF:
  Support V8 ............................. no
  Support XFA ............................ no
  Support XFA-BMP ........................ no
  Support XFA-GIF ........................ no
  Support XFA-PNG ........................ no
  Support XFA-TIFF ....................... no
Qt PDF Widgets:
  Support Qt PDF Widgets ................. yes

Note: QtWebEngine build is disabled by user.

Note: The following modules are not being compiled in this configuration:
    webenginecore
    webengine
    webenginewidgets

Qt is now configured for building. Just run 'make'. 
Once everything is built, you must run 'make install'. 
Qt will be installed into '/usr'.

$ make && make install
```
First it builds tools if necessary (gn and ninja), then QtPDF.
(If you don't give the `-no-build-qtwebengine-core` argument, it will
spend a lot of time building QtWebEngine before building QtPDF.)

Examples are in `examples/pdf` and `examples/pdfwidgets`.
The examples in this presentation are simpler and adapted
to being Items residing on slides, whereas the QtPDF examples
use ApplicationWindow and are meant to run standalone.

