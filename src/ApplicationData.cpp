#include "ApplicationData.h"

#include <iostream>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>


ApplicationData::ApplicationData(int argc, char** argv, QObject* parent) : QObject(parent)
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    m_app = new QGuiApplication(argc, argv);
    m_engine = new QQmlApplicationEngine();

    m_engine->rootContext()->setContextProperty("_applicationData", this);
}

ApplicationData::~ApplicationData()
{

}

void ApplicationData::updatePopupBackground() {
    foreach(QObject* obj, m_engine->rootObjects())
    {
        QQuickWindow* window = qobject_cast<QQuickWindow*>(obj);

        if(window)
        {
            QImage image = window->grabWindow();
            image.save("popupBackground.png");
        }
    }
}

void ApplicationData::createTag(const QString& tagName, const QColor& tagColor)
{
    auto* const tag = new Tag();

    tag->setName(tagName);
    tag->setColor(tagColor);

    connect(tag, &Tag::removed, this, &ApplicationData::removeTag);

    m_tags.push_back(tag);
    m_qtags.append(tag);

    QQmlContext* ctxt = m_engine->rootContext();
    ctxt->setContextProperty("tagModel", QVariant::fromValue(m_qtags));
    std::cout << "Create Tag name " << tagName.toStdString() << std::endl;
}

QQmlApplicationEngine* ApplicationData::engine()
{
    return m_engine;
}

int ApplicationData::exec()
{
    return m_app->exec();
}

void ApplicationData::loadTags()
{
    auto* const tagA = new Tag();
    auto* const tagB = new Tag();

    tagA->setName(QString("TAG A"));
    tagB->setName(QString("TAG B"));

    tagA->setColor(Qt::red);
    tagB->setColor(Qt::green);

    m_tags.push_back(tagA);
    m_tags.push_back(tagB);

    connect(tagA, &Tag::removed, this, &ApplicationData::removeTag);
    connect(tagB, &Tag::removed, this, &ApplicationData::removeTag);

    // Data Filtering
    for(auto* tag : m_tags)
    {
        m_qtags.append(tag);
    }

    QQmlContext* ctxt = m_engine->rootContext();
    ctxt->setContextProperty("tagModel", QVariant::fromValue(m_qtags));
}

void ApplicationData::removeTag()
{
    auto* removedTag = sender();

    //ctxt->setContextProperty("tagModel", QVariant::fromValue(nullptr));
    m_tags.erase(
        std::remove_if(m_tags.begin(), m_tags.end(),
            [removedTag](auto* tag)
            {
                if(tag == removedTag)
                {
                    tag->deleteLater();
                    return true;
                }
                return false;
            }),
    m_tags.end());

    m_qtags.clear();
    for(auto* tag : m_tags)
    {
        m_qtags.append(tag);
    }

    QQmlContext* ctxt = m_engine->rootContext();
    ctxt->setContextProperty("tagModel", QVariant::fromValue(m_qtags));
}

void ApplicationData::removeNote()
{
    auto* removedNote = sender();
    m_notes.erase(
        std::remove_if(m_notes.begin(), m_notes.end(),
            [removedNote](auto* note)
            {
                if(note == removedNote)
                {
                    note->deleteLater();
                    return true;
                }
                return false;
            }),
    m_notes.end());

    m_qnotes.clear();
    for(auto* note : m_notes)
    {
        m_qnotes.append(note);
    }

    QQmlContext* ctxt = m_engine->rootContext();
    ctxt->setContextProperty("noteModel", QVariant::fromValue(m_qnotes));
}

void ApplicationData::loadNotes()
{
    auto* const noteA = new Note();
    auto* const noteB = new Note();

    noteA->setContent(QString("Note A\n ligne 2\n \t ligne 3"));
    noteB->setContent(QString("Note B"));

    noteA->setDate(QDate(1989, 9, 16));
    noteB->setDate(QDate(1989, 9, 17));

    noteA->setDuration(0.5f);
    noteB->setDuration(2.0f);

    noteA->addTag(m_tags[0]);

    connect(noteA, &Note::removed, this, &ApplicationData::removeNote);
    connect(noteB, &Note::removed, this, &ApplicationData::removeNote);

    // if append after setContextProperty have to set the list again
    m_notes.push_back(noteA);
    m_notes.push_back(noteB);
    m_notes.push_back(noteA);
    m_notes.push_back(noteB);

    // Data Filtering
    for(auto* note : m_notes)
    {
        m_qnotes.append(note);
    }

    QQmlContext* ctxt = m_engine->rootContext();
    ctxt->setContextProperty("noteModel", QVariant::fromValue(m_qnotes));
}


void ApplicationData::save() const
{
    //QFile saveFile(saveFormat == Json ? QStringLiteral("test_save.json") : QStringLiteral("test_save.dat"));
    QFile saveFile(QStringLiteral("test_save.json"));

    if (!saveFile.open(QIODevice::WriteOnly)) {
        qWarning("Couldn't open save file.");
        return;
    }

    QJsonObject gameObject;
    write(gameObject);
    QJsonDocument saveDoc(gameObject);
    //saveFile.write(saveFormat == Json ? saveDoc.toJson() : saveDoc.toBinaryData());
    saveFile.write(saveDoc.toJson());
}

void ApplicationData::write(QJsonObject& json) const
{
/*
    QJsonObject playerObject;
    mPlayer.write(playerObject);
    json["player"] = playerObject;

    QJsonArray levelArray;
    foreach (const Level level, mLevels) {
        QJsonObject levelObject;
        level.write(levelObject);
        levelArray.append(levelObject);
    }*/

    QJsonArray tagArray;
    for(const auto* tag : m_tags)
    {
        QJsonObject tagObject;
        tag->write(tagObject);
        tagArray.append(tagObject);
    }
    json["tags"] = tagArray;
    json["notes"] = "NOTES";
}
