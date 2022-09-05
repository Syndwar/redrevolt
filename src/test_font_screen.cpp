#include "test_font_screen.h"

#include "system_tools.h"

namespace redrevolt
{
TestFontScreen::TestFontScreen(const std::string & id)
    : stren::Screen(id)
    , m_index(0)
    , m_fontImg(nullptr)
{
    SystemTools * systemTools = new SystemTools("systemTools");
    attach(systemTools);

    m_fontImg = new stren::Image("fontImg");
    attach(m_fontImg);

    stren::Button * btn = new stren::Button("backBtn");
    btn->setText("Exit");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|BOTTOM", 0, 0);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->setColour("red");
    btn->addCallback("MouseUp_Left", this, &TestFontScreen::onBackBtnClick);
    attach(btn);

    btn = new stren::Button("changeFontBtn");
    btn->setText("Show Next Font");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|BOTTOM", 0, -70);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestFontScreen::onChangeFontBtnClick);
    attach(btn);
}

TestFontScreen::~TestFontScreen()
{
}

void TestFontScreen::onBackBtnClick(Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestScreen");
    command.execute();
 }

void TestFontScreen::onChangeFontBtnClick(Widget * sender)
{
    if (!m_fontImg) return;

    lua::Table fontsTbl("Fonts");
    lua::Table spritesTbl("Sprites");
    m_index += 1;
    if (m_index > fontsTbl.getSize())
    {
        m_index = 1;
    }
    lua::Table fontTbl(fontsTbl.get(m_index));
    const std::string fontId = fontTbl.get("id").getString();
    log(fontId.c_str());
    const size_t spritesCount = spritesTbl.getSize();
    for (size_t i = 1; i <= spritesCount; ++i)
    {
        lua::Table spriteTbl(spritesTbl.get(i));
        const std::string textureId = spriteTbl.get("texture").getString();
        if (textureId == fontId)
        {
            const std::string id = spriteTbl.get("id").getString();
            m_fontImg->setSprite(id);
            int width(0);
            int height(0);
            stren::Engine::debugGetTextureSize(fontId, width, height);
            m_fontImg->setRect(0, 0, width, height);
            break;
        }
    }
}

void TestFontScreen::log(const char * msg)
{
    stren::Widget * widget = findWidget("systemTools");
    if (widget)
    {
        SystemTools * tools = dynamic_cast<SystemTools *>(widget);
        if (tools)
        {
            tools->log(msg);
        }
    }
}
} // redrevolt
