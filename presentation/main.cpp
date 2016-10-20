#include <QApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char ** argv)
{
    // QApplication if you need any widget features, otherwise QGuiApplication
    // (Controls 1 desktop style, widget-based dialogs)
    QApplication app(argc, argv);

    // Custom style for the whole application:
    // QQuickStyle::setStyle("examples/customstyle", "Material");
    QQuickStyle::setStyle("Material");

    // Controls 1: env variable
    qputenv("QT_QUICK_CONTROLS_1_STYLE", "Flat");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("main.qml")));

    return app.exec();
}
