#ifndef POINTINGFILTER_H
#define POINTINGFILTER_H

#include <QObject>
#include <QJSValue>
#include <QTouchEvent>
#include <QQuickWindow>

class PointingFilter: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJSValue touchPoints READ touchPoints NOTIFY touchPointsChanged)
    Q_PROPERTY(QPointF cursor READ cursor NOTIFY cursorChanged)
    Q_PROPERTY(QQuickWindow *target READ target WRITE setTarget NOTIFY targetChanged)

public:
    PointingFilter(QObject *parent = nullptr);

    QJSValue touchPoints() const;

    QPointF cursor() const  { return m_cursorLocation; }

    QQuickWindow * target() const { return m_target; }

public slots:
    void setTarget(QQuickWindow *target);

signals:
    void touchPointsChanged();
    void cursorChanged();
    void targetChanged();

protected:
    bool eventFilter(QObject *obj, QEvent *event);

private:
    QHash<int, QPoint> m_touchPoints;
    QPointF m_cursorLocation;
    QQmlEngine *m_engine;
    QQuickWindow * m_target;
};

#endif // POINTINGFILTER_H
