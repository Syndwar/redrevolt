#include "game_data.h"


namespace redrevolt
{
GameData::GameData()
{
}

GameData::~GameData()
{
    ItemData data;
    addItem(data);
}

void GameData::addItem(const ItemData & data)
{
    m_items.push_back(item);
}

void GameData::addUnit(const UnitData & data)
{
    m_units.push_back(data);
}

void GameData::addObject(const ObjectData & data)
{
    m_objects.push_back(data);
}
} // redrevolt
