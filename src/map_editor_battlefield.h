#ifndef MAP_EDITOR_BATTLEFIELD_H
#define MAP_EDITOR_BATTLEFIELD_H

#include "battlefield.h"

namespace redrevolt
{
class MapEditorBattlefield : public Battlefield
{
public:
    MapEditorBattlefield(const std::string & id = stren::String::kEmpty);

    virtual ~MapEditorBattlefield();
};
} // redrevolt
#endif // MAP_EDITOR_BATTLEFIELD_H
