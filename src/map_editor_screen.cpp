#include "map_editor_screen.h"

#include "system_tools.h"
#include "map_editor_system_panel.h"

namespace redrevolt
{
class StartNewMapObserver : public stren::Observer
{
private:
    MapEditorScreen * m_screen;
public:
    StartNewMapObserver(MapEditorScreen * screen) : stren::Observer({MapEditorSystemPanel::Event_StartNewMap}) , m_screen(screen) {}

    virtual ~StartNewMapObserver() {}
    
    virtual void notify(const stren::Event & event, bool & isEventCaptured) override {}
};

class LoadMapObserver : public stren::Observer
{
private:
    MapEditorScreen * m_screen;
public:
    LoadMapObserver(MapEditorScreen * screen) : stren::Observer({MapEditorSystemPanel::Event_LoadMap}) , m_screen(screen) {}

    virtual ~LoadMapObserver() {}

    virtual void notify(const stren::Event & event, bool & isEventCaptured) override {}
};

class SaveMapObserver : public stren::Observer
{
private:
    MapEditorScreen * m_screen;
public:
    SaveMapObserver(MapEditorScreen * screen) : stren::Observer({MapEditorSystemPanel::Event_SaveMap}) , m_screen(screen) {}

    virtual ~SaveMapObserver() {}
    
    virtual void notify(const stren::Event & event, bool & isEventCaptured) override {}
};

class SwitchGridMapObserver : public stren::Observer
{
private:
    MapEditorScreen * m_screen;
public:
    SwitchGridMapObserver(MapEditorScreen * screen) : stren::Observer({MapEditorSystemPanel::Event_SwitchGrid}) , m_screen(screen) {}

    virtual ~SwitchGridMapObserver() {}

    virtual void notify(const stren::Event & event, bool & isEventCaptured) override {}
};

class ExitScreenMapObserver : public stren::Observer
{
private:
    MapEditorScreen * m_screen;
public:
    ExitScreenMapObserver(MapEditorScreen * screen) : stren::Observer({MapEditorSystemPanel::Event_ExitScreen}) , m_screen(screen) {}

    virtual ~ExitScreenMapObserver() {}

    virtual void notify(const stren::Event & event, bool & isEventCaptured) override
    {
        if (m_screen)
        {
            m_screen->exitScreen();
        }
    }
};

MapEditorScreen::MapEditorScreen(const std::string & id)
{
    SystemTools * systemTools = new SystemTools("systemTools");
    attach(systemTools);

    stren::Observer * observer = new StartNewMapObserver(this);
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

    for (stren::Observer * observer : m_observers)
    {
        systemPanel->addObserver(observer);
    }
    
    stren::Button * menuBtn = new stren::Button("menuBtn");
    menuBtn->setRect(0, 0, 64, 64);
    menuBtn->setAlignment("LEFT|BOTTOM", 0, 0);
    menuBtn->setText("Menu");
    menuBtn->setFont("system_15_fnt");
    menuBtn->setColour("red");
    menuBtn->setTextAlignment("CENTER|MIDDLE");
    menuBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    menuBtn->addCallback("MouseUp_Left", this, &MapEditorScreen::viewMainMenu);
    attach(menuBtn);

}

MapEditorScreen::~MapEditorScreen()
{
    for (stren::Observer * observer : m_observers)
    {
        MapEditorSystemPanel * panel = find<MapEditorSystemPanel *>("systemPanel");
        if (panel)
        {
            panel->removeObserver(observer);
        }
        delete observer;
    }
    m_observers.clear();
}

void MapEditorScreen::viewMainMenu(stren::Widget * sender)
{
    MapEditorSystemPanel * panel = find<MapEditorSystemPanel *>("systemPanel");
    if (panel)
    {
        panel->instantView(!panel->isOpened());
    }
}

void MapEditorScreen::exitScreen()
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("MainScreen");
    command.execute();
}
} // redrevolt
