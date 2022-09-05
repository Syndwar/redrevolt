#include "test_fader_screen.h"

#include "system_tools.h"

namespace redrevolt
{
TestFaderScreen::TestFaderScreen(const std::string & id)
    : stren::Screen(id)
    , m_fadeSpeed(100)
    , m_fader(nullptr)
    , m_fadeSpeedLbl(nullptr)
{
    SystemTools * systemTools = new SystemTools("systemTools");
    attach(systemTools);

    const int screenWidth = stren::Engine::getScreenWidth();
    const int screenHeight = stren::Engine::getScreenHeight();

    stren::Primitive * primitive = new stren::Primitive();
    primitive->setColour("white");
    const stren::Rect rect(0, 0, screenWidth, screenHeight);
    primitive->createRect(rect, true);
    attach(primitive);

    stren::Button * btn = new stren::Button("backBtn");
    btn->setText("Exit");
    btn->setFont("system_15_fnt");
    btn->setColour("red");
    btn->setRect(0, 0, 256, 64);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setOrder(2);
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestFaderScreen::onBackBtnClick);
    attach(btn);

    m_fader = new stren::Fader("fader");
    m_fader->setRect(0, 0, screenWidth, screenHeight);
    m_fader->setFadeSpeed(m_fadeSpeed);
    m_fader->setSprite("dark_img_spr");
    attach(m_fader);

    btn = new stren::Button("fadeInBtn");
    btn->setText("Fade In");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 70, 256, 64);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestFaderScreen::onFadeInBtnClick);
    attach(btn);
    
    btn = new stren::Button("fadeOutBtn");
    btn->setText("Fade Out");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 140, 256, 64);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestFaderScreen::onFadeOutBtnClick);
    attach(btn);

    btn = new stren::Button("fadeSpeedUpBtn");
    btn->setText("+");
    btn->setFont("system_15_fnt");
    btn->setRect(50, 210, 64, 64);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestFaderScreen::onFadeSpeedUpBtnClick);
    attach(btn);

    btn = new stren::Button("fadeSpeedDownBtn");
    btn->setText("-");
    btn->setFont("system_15_fnt");
    btn->setRect(150, 210, 64, 64);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestFaderScreen::onFadeSpeedDownBtnClick);
    attach(btn);

    stren::Label * lbl = new stren::Label();
    lbl->setRect(50, 280, 100, 64);
    lbl->setText("Fade speed:");
    lbl->setFont("system_15_fnt");
    lbl->setTextAlignment("RIGHT|MIDDLE");
    lbl->setColour("red");
    attach(lbl);

    m_fadeSpeedLbl = new stren::Label("fadeSpeedLbl");
    m_fadeSpeedLbl->setRect(164, 280, 256, 64);
    m_fadeSpeedLbl->setText(std::to_string(m_fadeSpeed));
    m_fadeSpeedLbl->setFont("system_15_fnt");
    m_fadeSpeedLbl->setTextAlignment("LEFT|MIDDLE");
    m_fadeSpeedLbl->setColour("blue");
    attach(m_fadeSpeedLbl);

}

TestFaderScreen::~TestFaderScreen()
{
}

void TestFaderScreen::onBackBtnClick(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestScreen");
    command.execute();
 }

void TestFaderScreen::onFadeInBtnClick(stren::Widget * sender)
{
    if (m_fader)
    {
        m_fader->fadeIn();
    }
}

void TestFaderScreen::onFadeOutBtnClick(stren::Widget * sender)
{
    if (m_fader)
    {
        m_fader->fadeOut();
    }
}

void TestFaderScreen::onFadeSpeedUpBtnClick(stren::Widget * sender)
{
    if (m_fader)
    {
        int speed = m_fader->getFadeSpeed();
        m_fader->setFadeSpeed(speed + 1);
        if (m_fadeSpeedLbl)
        {
            speed = m_fader->getFadeSpeed();
            m_fadeSpeedLbl->setText(std::to_string(speed));
        }
    }
}

void TestFaderScreen::onFadeSpeedDownBtnClick(stren::Widget * sender)
{
    if (m_fader)
    {
        int speed = m_fader->getFadeSpeed();
        m_fader->setFadeSpeed(speed - 1);
        if (m_fadeSpeedLbl)
        {
            speed = m_fader->getFadeSpeed();
            m_fadeSpeedLbl->setText(std::to_string(speed));
        }
     }
}
} // redrevolt

