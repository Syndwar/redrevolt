#include "test_atlas_screen.h"

#include "system_tools.h"

namespace redrevolt
{
TestAtlasScreen::TestAtlasScreen(const std::string & id)
    : stren::Screen(id)
{

    SystemTools * systemTools = new SystemTools("systemTools");
    attach(systemTools);

    lua::Table spritesTbl("Sprites");
    const size_t spritesCount = spritesTbl.getSize();
    for (size_t i = 1; i <= spritesCount; ++i)
    {
        lua::Table spriteTbl(spritesTbl.get(i));
        const std::string id = spriteTbl.get("id").getString();
        const std::string textureId = spriteTbl.get("texture").getString();
        if ("atlas_1_tex" == textureId)
        {
            stren::Image * img = new stren::Image();
            lua::Table rectTbl(spriteTbl.get("rect"));
            const int x = rectTbl.get(1).getInt();
            const int y = rectTbl.get(2).getInt();
            const int w = rectTbl.get(3).getInt();
            const int h = rectTbl.get(4).getInt();
            img->setSprite(id);
            img->setRect(x, y, w, h);
            attach(img);
        }
   }

    stren::Button * btn = new stren::Button("backBtn");
    btn->setText("Exit");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|BOTTOM", -64, -64);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestAtlasScreen::onBackBtnClick);
    attach(btn);
}

TestAtlasScreen::~TestAtlasScreen()
{
}

void TestAtlasScreen::onBackBtnClick(Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestScreen");
    command.execute();
 }
} // redrevolt
