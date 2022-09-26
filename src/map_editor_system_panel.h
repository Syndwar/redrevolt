#ifndef MAP_EDITOR_SYSTEM_PANEL_H
#define MAP_EDITOR_SYSTEM_PANEL_H

#include "stren.h"

namespace redrevolt
{
class MapEditorSystemPanel :  public stren::Container
{
public:
    enum Events
    {
        Event_SaveMap = 0,
        Event_LoadMap,
        Event_StartNewMap,
        Event_SwitchGrid,
        Event_ExitScreen
    };
private:
    bool m_isGridOn;
    stren::EventListener m_eventListener;
    stren::Observer * m_switchGridObserver;
public:
    MapEditorSystemPanel(const std::string & id = stren::String::kEmpty);

    ~MapEditorSystemPanel();

    void addObserver(stren::Observer * observer);

    void removeObserver(stren::Observer * observer);

    void onGridSwitched();
private:
    void update();

    void onBackBtnClick(stren::Widget * sender);

    void onSaveBtnClick(stren::Widget * sender);

    void onLoadBtnClick(stren::Widget * sender);

    void onGridBtnClick(stren::Widget * sender);

    void onNewMapBtnClick(stren::Widget * sender);
}; // MapEditorSystemPanel
}
#endif // MAP_EDITOR_SYSTEM_PANEL_H
