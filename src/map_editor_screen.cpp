#include "map_editor_screen.h"

#include "system_tools.h"

namespace redrevolt
{
MapEditorScreen::MapEditorScreen(const std::string & id)
{
    SystemTools * systemTools = new SystemTools("systemTools");
    attach(systemTools);

    /*
    Observer * observer = new StartNewMapObserver(this);
    m_observers.push_back(observer);
    observer = new LoadMapObserver(this);
    m_observers.push_back(observer);
    observer = new SaveMapObserver(this);
    m_observers.push_back(observer);
    observer = new SwitchGridMapObserver(this);
    m_observers.push_back(observer);
    observer = new ExitScreenMapObserver(this);
    m_observers.push_back(observer);

    MapEditorSystemPanel * systemPanel = new MapEditorSystemPanel("systemPanel");
    systemPanel->instantView(false);
    systemPanel->setAlignment("LEFT|BOTTOM", 0, -64);
    attach(systemPanel);

    for (Observer * observer : m_observers)
    {
        systemPanel->addObserver(observer);
    }
    */
}

MapEditorScreen::~MapEditorScreen()
{
    /*
    for (Observer * observer : m_observers)
    {
        MapEditorSystemPanel * panel = find<MapEditorSystemPanel *>("systemPanel");
        if (panel)
        {
            panel->removeObserver(observer);
        }
        delete observer;
    }
    m_observers.clear();
    */
}
} // redrevolt
