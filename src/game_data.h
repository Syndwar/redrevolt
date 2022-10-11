#ifndef GAME_DATA_H
#define GAME_DATA_H
namespace redrevolt
{
struct EntitySize
{
    int width;
    int height;
};

struct EntityGeometry
{
    std::vector<std::vector<bool>> lines;
};

struct EntityData
{
    enum Type
    {
        Unknown = 0,
        Unit,
        Weapon,
        Item
    }

    std::string id;
    std::string sprite;
    int entity_type;
    int layer;
    EntitySize size;
    EntityGeometry geometry;

    EntityData()
        : layer(0)
        , entity_type(Type::Unknown)
    {
    }
};

struct ItemData : public EntityData
{
    ItemData() : EntityData() {}
};


struct UnitData : public EntityData
{
};

struct ObjectData : public EntityData
{
};

class GameData
{
private:
    std::vector<ItemData> m_items;
    std::vector<UnitData> m_units;
    std::vector<ObjectData> m_objects;
public:
    enum Factions
    {
        Operatives = 0,
        Raiders
    }

    enum WeaponType
    {
        Unknown = 0,
        Melee,
        Ranged
    }

    enum ItemType
    {
        Unknown = 0,
        Ammo,
        UseSelf,
        UseThem
    }

    GameData();

    ~GameData();
};
} // redrevolt
#endif // GAME_DATA_H
