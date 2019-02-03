#include "Tag.h"
#include <QJsonObject>
#include <iostream>

void Tag::remove()
{
    emit removed();
}

void Tag::write(QJsonObject& json) const
{
    json["name"] = m_name;
    /*QJsonArray npcArray;
    foreach (const Character npc, mNpcs)
    {
        QJsonObject npcObject;
        npc.write(npcObject);
        npcArray.append(npcObject);
    }*/
    json["color"] = "red";
}
