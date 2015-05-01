#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include "pointingfilter.h"
#include <QDebug>
#include <QQuickView>

int main(int argc, char ** argv)
{
    QGuiApplication app(argc, argv);
    QQuickView view;
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    PointingFilter *filter = new PointingFilter(&view);
    view.rootContext()->setContextProperty(QLatin1String("pointingFilter"), filter);
    if (app.arguments().count() > 1) {
        int startWith = (app.arguments()[1]).toInt();
        qDebug() << "would like to start with slide" << startWith;
    }
    view.setSource(QUrl("main.qml"));
    view.show();

    return app.exec();
}
