#include <QtQuick>

#ifndef EXAMPLEHELPER_H
#define EXAMPLEHELPER_H

class ExampleHelper: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString content READ content NOTIFY contentChanged)
    Q_PROPERTY(QString sourcePath READ sourcePath NOTIFY sourcePathChanged)

    QString m_source;
    QString m_content;
    QString m_sourcePath;

public:

    QString source() const
    {
        return m_source;
    }

    QString sourcePath() const
    {
        return m_sourcePath;
    }

    QString content() const
    {
        return m_content;
    }

public slots:
    void setSource(const QString &path)
    {
        if (m_source == path)
            return;

        m_source = path;
        emit sourceChanged(path);

        QFile file(path);
        if (!file.open(QFile::ReadOnly)) {
            qWarning() << "Could not read file: " << path;
            return;
        }

        m_sourcePath = QFileInfo(m_source).absoluteFilePath();
        emit sourcePathChanged(m_sourcePath);

        m_content = QString::fromUtf8(file.readAll());
        emit contentChanged(m_content);
    }

signals:
    void sourceChanged(const QUrl &arg);
    void sourcePathChanged(const QUrl &arg);
    void contentChanged(const QString &arg);
};

#endif
