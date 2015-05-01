#include "pointingfilter.h"
#include <QEvent>
#include <QDebug>
#include <QTouchEvent>
#include <QJSEngine>
#include <QQmlEngine>

PointingFilter::PointingFilter(QQuickView *installOn)
    : QObject(installOn), m_engine(installOn->engine())
{
    installOn->installEventFilter(this);
}

QJSValue PointingFilter::touchPoints() const
{
    QJSValue ret = m_engine->newArray(m_touchPoints.size());
    int i = 0;
    foreach (QPointF p, m_touchPoints) {
        QJSValue pv = m_engine->newObject();
        pv.setProperty("x", p.x());
        pv.setProperty("y", p.y());
        ret.setProperty(i++, pv);
    }
    return ret;
}

bool PointingFilter::eventFilter(QObject *, QEvent *event)
{
    switch(event->type()) {

    case QEvent::MouseMove: {
        QMouseEvent *ev = static_cast<QMouseEvent *>(event);
        m_cursorLocation = ev->pos();
        emit cursorChanged();
    } break;
    case QEvent::TouchBegin:
    case QEvent::TouchUpdate:
    case QEvent::TouchEnd: {
        QTouchEvent *ev = static_cast<QTouchEvent *>(event);
        foreach (const QTouchEvent::TouchPoint& tp, ev->touchPoints()) {
            switch (tp.state()) {
            case Qt::TouchPointMoved:
            case Qt::TouchPointPressed:
                m_touchPoints.insert(tp.id(), tp.pos().toPoint());
                break;
            case Qt::TouchPointReleased:
                m_touchPoints.remove(tp.id());
                break;
            }
        }
        emit touchPointsChanged();
//        qDebug() << "filter sees" << ev << obj;
    } break;
    default:
        break;
    }
    return false;
}
