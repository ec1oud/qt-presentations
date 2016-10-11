/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QML Presentation System.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/
#include <QtQml>

#ifndef EXAMPLEHELPER_H
#define EXAMPLEHELPER_H

class ExampleHelper: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString content READ content NOTIFY contentChanged)
    Q_PROPERTY(QString contentWithoutComments READ contentWithoutComments NOTIFY contentChanged)
    Q_PROPERTY(QString sourcePath READ sourcePath NOTIFY sourcePathChanged)
    Q_PROPERTY(QString qtSourceModule READ qtSourceModule WRITE setQtSourceModule NOTIFY qtSourceModuleChanged)

public:
    QString source() const { return m_source; }
    QString sourcePath() const { return m_sourcePath; }
    QString content() const { return m_content; }
    QString contentWithoutComments() const { return m_contentWithoutComments; }
    QString qtSourceModule() const { return m_qtSourceModule; }

public slots:
    void setSource(const QString &path)
    {
        if (m_source == path)
            return;

        m_source = path;
        emit sourceChanged(path);

        load();
    }

    void setQtSourceModule(QString qtSourceModule)
    {
        if (m_qtSourceModule == qtSourceModule)
            return;

        m_qtSourceModule = qtSourceModule;
        emit qtSourceModuleChanged(qtSourceModule);

        load();
    }

signals:
    void sourceChanged(const QUrl &arg);
    void sourcePathChanged(const QUrl &arg);
    void contentChanged(const QString &arg);
    void qtSourceModuleChanged(QString qtSourceModule);

protected:
    void load() {
        if (m_source.isEmpty())
            return; // it wasn't set yet; maybe qtSourceModule was set first
        QString prefix;
        if (!m_qtSourceModule.isEmpty()) {
            static const QString qtSrcDir = qgetenv("QTSRCDIR");
            if (qtSrcDir.isEmpty()) {
                qWarning("QTSRCDIR isn't set; you need to use qtchooser to select a Qt version when you use ExampleHelper.qtSourceModule");
            } else {
                QDir dir(qtSrcDir);
                dir.cdUp();
                if (!dir.cd(m_qtSourceModule))
                    qWarning() << "failed to find directory for" << m_qtSourceModule;
                else
                    prefix = dir.absolutePath() + QDir::separator();
            }
        }

        m_sourcePath = QFileInfo(prefix + m_source).absoluteFilePath();

        QFile file(m_sourcePath);
        if (!file.open(QFile::ReadOnly)) {
            qWarning() << "Could not read file:" << m_sourcePath;
            return;
        }

        emit sourcePathChanged(m_sourcePath);

        m_content = QString::fromUtf8(file.readAll());
        stripComments();
        emit contentChanged(m_content);
    }

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
    QString m_sourcePath;
    QString m_content;
    QString m_contentWithoutComments;
    QString m_qtSourceModule;
};

#endif
