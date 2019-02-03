#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "src/Note.h"
#include "src/Tag.h"
#include "src/ApplicationData.h"

#include <QQuickWindow>
#include <QObject>
#include <iostream>


int main(int argc, char *argv[])
{
    ApplicationData appData(argc, argv);

    appData.loadTags();
    appData.loadNotes();

    appData.engine()->load(QUrl(QLatin1String("qrc:/main.qml")));

    if(appData.engine()->rootObjects().isEmpty())
        return -1;

    appData.save();
    return appData.exec();
}
