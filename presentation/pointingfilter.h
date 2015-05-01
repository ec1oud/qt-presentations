#ifndef POINTINGFILTER_H
#define POINTINGFILTER_H

#include <QObject>
#include <QJSValue>
#include <QTouchEvent>
#include <QQuickView>

class PointingFilter: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJSValue touchPoints READ touchPoints NOTIFY touchPointsChanged)
    Q_PROPERTY(QPointF cursor READ cursor NOTIFY cursorChanged)

public:
    PointingFilter(QQuickView *installOn);

    QJSValue touchPoints() const;

    QPointF cursor() const  { return m_cursorLocation; }

signals:
    void touchPointsChanged();
    void cursorChanged();

protected:
    bool eventFilter(QObject *obj, QEvent *event);

private:
    QHash<int, QPoint> m_touchPoints;
    QPointF m_cursorLocation;
    QQmlEngine *m_engine;
};

#endif // POINTINGFILTER_H
