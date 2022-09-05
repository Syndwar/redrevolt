#ifndef MAP_EDITOR_SCREEN_H
#define MAP_EDITOR_SCREEN_H

#include "stren.h"

#include <vector>

namespace redrevolt
{

class MapEditorScreen : public stren::Screen
{
private:
    std::vector<stren::Observer *> m_observers;
public:
    MapEditorScreen(const std::string & id = stren::String::kEmpty);

    virtual ~MapEditorScreen();
};
} // redrevolt
#endif // MAP_EDITOR_SCREEN_H  
   
