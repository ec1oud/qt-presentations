#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include "pointingfilter.h"
#include <QDebug>
#include <QQuickView>
#include <QQuickItem>

int main(int argc, char ** argv)
{
    QGuiApplication app(argc, argv);
    QQuickView view;
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    PointingFilter *filter = new PointingFilter(&view);
    view.rootContext()->setContextProperty(QLatin1String("pointingFilter"), filter);
    view.setSource(QUrl("main.qml"));
    if (app.arguments().count() > 1) {
        int startWith = (app.arguments()[1]).toInt();
        view.rootObject()->setProperty("currentSlide", startWith - 1);
    }
    view.show();

    return app.exec();
}
