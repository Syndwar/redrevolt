#include "map_editor_system_panel.h"

namespace redrevolt
{
MapEditorSystemPanel::MapEditorSystemPanel(const std::string & id)
    : stren::Container(id)
    , m_isGridOn(true)
{
    setRect(0, 0, 64, 320);

    stren::Image * img = new stren::Image();
    img->setRect(0, 0, 64, 320);
    img->setSprite("dark_img_spr");
    attach(img);

    stren::Button * btn = new stren::Button("backBtn");
    btn->setRect(0, 0, 64, 64);
    btn->setText("Exit");
    btn->setColour("red");
    btn->setFont("system_13_fnt");
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &MapEditorSystemPanel::onBackBtnClick);
    attach(btn);

    stren::Button * saveBtn = new stren::Button("saveBtn");
    saveBtn->setRect(0, 64, 64, 64);
    saveBtn->setText("Save");
    saveBtn->setColour("red");
    saveBtn->setFont("system_13_fnt");
    saveBtn->setTextAlignment("CENTER|MIDDLE");
    saveBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    saveBtn->addCallback("MouseUp_Left", this, &MapEditorSystemPanel::onSaveBtnClick);
    attach(saveBtn);

    stren::Button * loadBtn = new stren::Button("loadBtn");
    loadBtn->setRect(0, 128, 64, 64);
    loadBtn->setText("Load");
    loadBtn->setColour("red");
    loadBtn->setFont("system_13_fnt");
    loadBtn->setTextAlignment("CENTER|MIDDLE");
    loadBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    loadBtn->addCallback("MouseUp_Left", this, &MapEditorSystemPanel::onLoadBtnClick);
    attach(loadBtn);

    stren::Button * gridBtn = new stren::Button("gridBtn");
    gridBtn->setRect(0, 192, 64, 64);
    gridBtn->setText("Grid");
    gridBtn->setColour("red");
    gridBtn->setFont("system_13_fnt");
    gridBtn->setTextAlignment("CENTER|MIDDLE");
    gridBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    gridBtn->addCallback("MouseUp_Left", this, &MapEditorSystemPanel::onGridBtnClick);
    attach(gridBtn);

    stren::Button * newMapBtn = new stren::Button("newMapBtn");
    newMapBtn->setRect(0, 256, 64, 64);
    newMapBtn->setText("New Map");
    newMapBtn->setColour("red");
    newMapBtn->setFont("system_13_fnt");
    newMapBtn->setTextAlignment("CENTER|MIDDLE");
    newMapBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    newMapBtn->addCallback("MouseUp_Left", this, &MapEditorSystemPanel::onNewMapBtnClick);
    attach(newMapBtn);

    // Observer::addListener("SwitchGrid", this, $MapEditorSystemPanel::onGridSwitched)

    update();
}

MapEditorSystemPanel::~MapEditorSystemPanel()
{
}

void MapEditorSystemPanel::addObserver(stren::Observer * observer)
{
    if (!observer) return;
    m_eventListener.add(observer);
}

void MapEditorSystemPanel::removeObserver(stren::Observer * observer)
{
   if (observer)
   {
       m_eventListener.remove(observer);
   }
}

void MapEditorSystemPanel::update()
{
    stren::Button * btn = find<stren::Button *>("gridBtn");
    if (btn)
    {
        btn->setText(m_isGridOn ? "Grid On" : "Grid Off");
        btn->setColour(m_isGridOn ? "green" : "red");
    }
}

void MapEditorSystemPanel::onGridSwitched()
{
    m_isGridOn = !m_isGridOn;
    update();
}

void MapEditorSystemPanel::onBackBtnClick(Widget * sender)
{
    m_eventListener.notify(Event_ExitScreen);
}

void MapEditorSystemPanel::onSaveBtnClick(Widget * sender)
{
    m_eventListener.notify(Event_SaveMap);
}

void MapEditorSystemPanel::onLoadBtnClick(Widget * sender)
{
    m_eventListener.notify(Event_LoadMap);
}

void MapEditorSystemPanel::onGridBtnClick(Widget * sender)
{
    m_eventListener.notify(Event_SwitchGrid);
}

void MapEditorSystemPanel::onNewMapBtnClick(Widget * sender)
{
    m_eventListener.notify(Event_StartNewMap);
}
} // redrevolt
