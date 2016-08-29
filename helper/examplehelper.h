#include <QtQuick>

#ifndef EXAMPLEHELPER_H
#define EXAMPLEHELPER_H

class ExampleHelper: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString content READ content NOTIFY contentChanged)
    Q_PROPERTY(QString contentWithoutComments READ contentWithoutComments NOTIFY contentChanged)
    Q_PROPERTY(QString sourcePath READ sourcePath NOTIFY sourcePathChanged)

public:
    QString source() const { return m_source; }
    QString sourcePath() const { return m_sourcePath; }
    QString content() const { return m_content; }
    QString contentWithoutComments() const { return m_contentWithoutComments; }

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
        stripComments();
        emit contentChanged(m_content);
    }

signals:
    void sourceChanged(const QUrl &arg);
    void sourcePathChanged(const QUrl &arg);
    void contentChanged(const QString &arg);

protected:
    void stripComments() {
        // TODO configurable to strip specific comment types: one-liners, doc comments, block comments, copyright etc.
        // for now we strip C-style comments but not double-slash comments
        static const QString stripBegin = QStringLiteral("/*");
        static const QString stripEnd = QStringLiteral("*/");
        m_contentWithoutComments.clear();
        bool inComment = false;
        for (const QString &line : m_content.split(QChar('\n'))) {
            QString trimmed = line.trimmed();
            if (inComment) {
                if (trimmed.endsWith(stripEnd))
                    inComment = false;
            } else {
                if (trimmed.startsWith(stripBegin))
                    inComment = true;
                else
                    m_contentWithoutComments += line + QChar('\n');
            }
        }
    }

protected:
    QString m_source;
    QString m_content;
    QString m_contentWithoutComments;
    QString m_sourcePath;
};

#endif
