#ifndef APPLICATIONDATA_H
#define APPLICATIONDATA_H

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QObject>

#include "src/Tag.h"
#include "src/Note.h"

class ApplicationData : public QObject {
    Q_OBJECT

public:
    ApplicationData(int argc, char *argv[], QObject* parent=nullptr);
    ~ApplicationData();

    Q_INVOKABLE void updatePopupBackground();
    Q_INVOKABLE void createTag(const QString& tagName, const QColor& tagColor);

    QQmlApplicationEngine* engine();

    int exec();

    void loadTags();
    void loadNotes();

    void save() const;

public slots:
    void removeTag();
    void removeNote();

private:

    void write(QJsonObject& json) const;

    QGuiApplication* m_app;
    QQmlApplicationEngine* m_engine;


    std::vector<Tag*> m_tags;
    std::vector<Note*> m_notes;

    QList<QObject*> m_qnotes;
    QList<QObject*> m_qtags;

};

#endif // APPLICATIONDATA_H
