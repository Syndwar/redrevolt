#include "test_scroll_screen.h"

#include "system_tools.h"

namespace redrevolt
{
TestScrollScreen::TestScrollScreen(const std::string & id)
    : Screen(id)
    , m_fieldWidth(80)
    , m_fieldHeight(50)
    , m_tileWidth(128)
    , m_tileHeight(64)
    , m_tileSpr("test_tile_spr")
    , m_scrollCnt(nullptr)
{
    SystemTools * systemTools = new SystemTools("systemTools");
    attach(systemTools);

    const int screenWidth = stren::Engine::getScreenWidth();
    const int screenHeight = stren::Engine::getScreenHeight();

    m_scrollCnt = new stren::ScrollContainer("scrollCnt");
    m_scrollCnt->setRect(0, 0, screenWidth, screenHeight);
    m_scrollCnt->setScrollSpeed(1000);
    attach(m_scrollCnt);

    stren::Area * leftArea = new stren::Area("scrollLeftArea");
    leftArea->setRect(0, 0, 20, 700);
    leftArea->setAlignment("LEFT|MIDDLE", 0, 0);
    leftArea->addCallback("MouseOver", this, &TestScrollScreen::scrollLeftOn);
    leftArea->addCallback("MouseLeft", this, &TestScrollScreen::scrollLeftOff);
    attach(leftArea);
    
    stren::Area * upArea = new stren::Area("scrollUpArea");
    upArea->setRect(0, 0, 1000, 20);
    upArea->setAlignment("CENTER|TOP", 0, 0);
    upArea->addCallback("MouseOver", this, &TestScrollScreen::scrollUpOn);
    upArea->addCallback("MouseLeft", this, &TestScrollScreen::scrollUpOff);
    attach(upArea);
    
    stren::Area * downArea = new stren::Area("scrollDownArea");
    downArea->setRect(0, 0, 1000, 20);
    downArea->setAlignment("CENTER|BOTTOM", 0, 0);
    downArea->addCallback("MouseOver", this, &TestScrollScreen::scrollDownOn);
    downArea->addCallback("MouseLeft", this, &TestScrollScreen::scrollDownOff);
    attach(downArea);
    
    stren::Area * rightArea = new stren::Area("scrollRightArea");
    rightArea->setRect(0, 0, 20, 700);
    rightArea->setAlignment("RIGHT|MIDDLE", 0, 0);
    rightArea->addCallback("MouseOver", this, &TestScrollScreen::scrollRightOn);
    rightArea->addCallback("MouseLeft", this, &TestScrollScreen::scrollRightOff);
    attach(rightArea);

    stren::Button * btn = new stren::Button("backBtn");
    btn->setText("Exit");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 64, 64);
    btn->setAlignment("RIGHT|BOTTOM", 0, 0);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScrollScreen::onBackBtnClick);
    btn->setColour("red");
    attach(btn);

    btn = new stren::Button("jumpBtn");
    btn->setText("Jump");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 64, 64);
    btn->setAlignment("RIGHT|BOTTOM", 0, -64);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScrollScreen::onJumpBtnClick);
    btn->setColour("red");
    attach(btn);

    btn = new stren::Button("scrollBtn");
    btn->setText("Scroll");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 64, 64);
    btn->setAlignment("RIGHT|BOTTOM", 0, -128);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScrollScreen::onScrollBtnClick);
    btn->setColour("red");
    attach(btn);

    addScrollContent();
}

TestScrollScreen::~TestScrollScreen()
{
}

void TestScrollScreen::scrollTo(const int direction, const bool value)
{
    if (m_scrollCnt)
    {
        m_scrollCnt->scrollTo(direction, value);
    }
}

void TestScrollScreen::scrollUpOn()
{
    scrollTo(stren::ScrollContainer::Up, true);
}

void TestScrollScreen::scrollUpOff()
{
    scrollTo(stren::ScrollContainer::Up, false);
}

void TestScrollScreen::scrollLeftOn()
{
    scrollTo(stren::ScrollContainer::Left, true);
}

void TestScrollScreen::scrollLeftOff()
{
    scrollTo(stren::ScrollContainer::Left, false);
}

void TestScrollScreen::scrollRightOn()
{
    scrollTo(stren::ScrollContainer::Right, true);
}

void TestScrollScreen::scrollRightOff()
{
    scrollTo(stren::ScrollContainer::Right, false);
}

void TestScrollScreen::scrollDownOn()
{
    scrollTo(stren::ScrollContainer::Down, true);
}

void TestScrollScreen::scrollDownOff()
{
    scrollTo(stren::ScrollContainer::Down, false);
}

void TestScrollScreen::onBackBtnClick(Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestScreen");
    command.execute();
 }

void TestScrollScreen::onJumpBtnClick(Widget * sender)
{
    if (m_scrollCnt)
    {
        m_scrollCnt->jumpTo(1024, 768);
    }
}

void TestScrollScreen::onScrollBtnClick(Widget * sender)
{
    if (m_scrollCnt)
    {
        if (!m_scrollCnt->isScrolling())
        {
            m_scrollCnt->scrollTo(0, 0);
        }
    }
}

void TestScrollScreen::addScrollContent()
{
    if (m_scrollCnt)
    {
        int contentWidth(0);
        int contentHeight(0);
        for (int i = 0; i < m_fieldWidth; ++i)
        {
            for (int j = 0; j < m_fieldHeight; ++j)
            {
                const bool isOdd = 1 == (j & 1);
                const int offsetX = isOdd ? (m_tileWidth * 0.5) : 0;
                const int x = m_tileWidth * (m_fieldWidth - 1 - i) + offsetX;
                const int y = m_tileHeight * 0.5 * j;

                stren::Image * img = new stren::Image();
                img->setRect(x, y, m_tileWidth, m_tileHeight);
                img->setSprite(m_tileSpr);
                m_scrollCnt->attach(img);

                if (x + m_tileWidth > contentWidth)
                {
                    contentWidth = x + m_tileWidth;
                }
                if (y + m_tileHeight > contentHeight)
                {
                    contentHeight = y + m_tileHeight;
                }
            }
        }
        m_scrollCnt->setContentRect(0, 0, contentWidth, contentHeight);
    }
}
} // redrevolt

