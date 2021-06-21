#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QRegularExpression>

QT_BEGIN_NAMESPACE
namespace Ui { class Dialog; }
QT_END_NAMESPACE

class Dialog : public QDialog
{
    Q_OBJECT

public:
    Dialog(QWidget *parent = nullptr);
    ~Dialog();

private slots:
    void on_quaternion_le_textEdited(const QString &arg1);

private:
    Ui::Dialog *ui;
    QRegularExpression separators;
};
#endif // DIALOG_H
