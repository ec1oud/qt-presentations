#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QDebug>
#include <QQuickView>
#include <QQuickItem>
#include "../tools/printslides/slideview.h"

int main(int argc, char ** argv)
{
    QGuiApplication app(argc, argv);
    SlideView view;
    view.setFlags(view.flags() | Qt::WindowFullscreenButtonHint);
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.connect(view.engine(), SIGNAL(quit()), &app, SLOT(quit()));
    view.setSource(QUrl("main.qml"));
    view.show();
    foreach (const QString &arg, app.arguments()) {
        if (arg.startsWith(QChar('-'))) {
            if (arg == QLatin1String("-f"))
                view.setWindowState(Qt::WindowFullScreen);
        } else {
            bool ok = false;
            int startWith = arg.toInt(&ok);
            if (ok)
                view.rootObject()->setProperty("currentSlide", startWith - 1);
        }
    }

    return app.exec();
}
