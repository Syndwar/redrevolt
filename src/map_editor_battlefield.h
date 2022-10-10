#ifndef MAP_EDITOR_BATTLEFIELD_H
#define MAP_EDITOR_BATTLEFIELD_H

#include "battlefield.h"

#include <vector>

namespace redrevolt
{
class MapHandler;

class MapEditorBattlefield : public Battlefield
{
private:
    stren::Primitive * m_grid;
    stren::Primitive * m_cursor;
    MapHandler * m_map;

public:
    MapEditorBattlefield(const std::string & id = stren::String::kEmpty);

    virtual ~MapEditorBattlefield();

    void switchGrid();

private:
    void createMapContent();

    void createGridLines(std::vector<stren::Point> & points);
};
} // redrevolt
#endif // MAP_EDITOR_BATTLEFIELD_H
