#ifndef MAP_EDITOR_SCREEN_H
#define MAP_EDITOR_SCREEN_H

#include "stren.h"

#include <vector>

namespace redrevolt
{

class MapEditorBattlefield;

class MapEditorScreen : public stren::Screen
{
private:
    MapEditorBattlefield * m_battlefield;
    std::vector<stren::Observer *> m_observers;
public:
    MapEditorScreen(const std::string & id = stren::String::kEmpty);

    virtual ~MapEditorScreen();

    void exitScreen();

    void swichGrid();

private:
    void viewMainMenu(stren::Widget * sender);

};
} // redrevolt
#endif // MAP_EDITOR_SCREEN_H  
   
