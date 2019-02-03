#ifndef REPORT_H
#define REPORT_H

#include <string>
#include <QObject>
#include <QDate>
#include <QColor>
#include <QQmlListProperty>

#include "Tag.h"

class Note : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString content READ content WRITE setContent NOTIFY contentChanged)
    Q_PROPERTY(QDate date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(float duration READ duration WRITE setDuration NOTIFY durationChanged)
    Q_PROPERTY(QList<QObject*> tags READ tags NOTIFY tagsChanged)

    // UI
    Q_PROPERTY(bool collapsed READ collapsed WRITE setCollapsed NOTIFY collapsedChanged)

public:
    Note(QObject* parent=nullptr) : QObject(parent), m_collasped(false) { }
    ~Note() { }

    QDate date() { return m_date; }
    void setDate(const QDate& date) { m_date = date; }

    QString content() const { return m_content; }
    void setContent(const QString& content) { m_content = content; }

    float duration() const { return m_duration; }
    void setDuration(const float duration) { m_duration = duration; }

    Q_INVOKABLE void addTag(Tag* tag)
    {
        m_tags.append(tag);
        connect(tag, &Tag::removed, this, &Note::tagRemoved);
        emit tagsChanged(m_tags);
    }

    Q_INVOKABLE void remove(){
        emit removed();
    }

    const QList<QObject*>& tags() const { return m_tags; }

    std::string serialize()
    {
        QString str;
        str +=  m_content + "\n";
        str += m_date.toString() + "\n";
        str += QString::number(static_cast<double>(m_duration)) + "\n";
        return str.toStdString();
    }

    bool collapsed() const { return m_collasped; }
    void setCollapsed(const bool value) { m_collasped = value; emit collapsedChanged(m_collasped); }

signals:
    void contentChanged(QString);
    void dateChanged(QDate);
    void durationChanged(float);
    void tagsChanged(QList<QObject*>);
    void collapsedChanged(bool);
    void removed();

private slots:
    void tagRemoved() {
        auto* obj = sender();
        if(m_tags.removeOne(obj))
            emit tagsChanged(m_tags);
    }

private:
    QString m_content;
    QDate m_date;
    float m_duration;
    QList<QObject*> m_tags;

    bool m_collasped;
};

#endif // REPORT_H
