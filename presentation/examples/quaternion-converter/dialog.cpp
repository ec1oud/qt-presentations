#include "dialog.h"
#include "ui_dialog.h"

#include <QQuaternion>

Dialog::Dialog(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::Dialog)
    , separators("[^0-9\\.-]+")
{
    ui->setupUi(this);
}

Dialog::~Dialog()
{
    delete ui;
}

void Dialog::on_quaternion_le_textEdited(const QString &arg1)
{
    QStringList valueStr = arg1.split(separators);
    bool ok = valueStr.count() == 4;
    float s, x, y, z;
    if (ok)
        s = valueStr.at(0).toFloat(&ok);
    if (ok)
        x = valueStr.at(1).toFloat(&ok);
    if (ok)
        y = valueStr.at(2).toFloat(&ok);
    if (ok)
        z = valueStr.at(3).toFloat(&ok);
    ui->quaternion_le->setForegroundRole(ok ? QPalette::WindowText : QPalette::LinkVisited);
    QQuaternion q(s, x, y, z);
    q.getEulerAngles(&x, &y, &z);
    qDebug() << q << "->" << x << y << z;
    ui->euler_le->setText(QString(QLatin1String("%1, %2, %3")).arg(x).arg(y).arg(z));
}
