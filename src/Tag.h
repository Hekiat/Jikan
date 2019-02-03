#ifndef TAG_H
#define TAG_H

#include <QObject>
#include <QColor>
#include <QString>
#include <iostream>

class Tag : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)

public:
    Tag(QObject* parent = nullptr) : QObject(parent) {
    }

    ~Tag() {
    }

    Q_INVOKABLE void remove();

    QString name() { return m_name; }
    void setName(const QString& name) { m_name = name; emit nameChanged(m_name); }

    QColor color() const { return m_color; }
    void setColor(const QColor& color) { m_color = color; emit colorChanged(m_color); }

    void write(QJsonObject& json) const;

signals:
    void nameChanged(QString);
    void colorChanged(QColor);

    void removed();

private:
    QString m_name;
    QColor m_color;
};

class TagList {

};

#endif // TAG_H
