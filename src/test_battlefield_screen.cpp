#include "test_battlefield_screen.h"

namespace redrevolt
{
TestBattlefieldScreen::TestBattlefieldScreen(const std::string & id)
    : stren::Screen(id)
{
    stren::Button * btn = new stren::Button("backBtn");
    btn->setText("Exit");
    btn->setFont("system_15_fnt");
    btn->setColour("red");
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setRect(0, 0, 64, 64);
    btn->setAlignment("LEFT|BOTTOM", 0, 0);
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestBattlefieldScreen::onBackBtnClick);
    attach(btn);
}

TestBattlefieldScreen::~TestBattlefieldScreen()
{
}

void TestBattlefieldScreen::onBackBtnClick(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestScreen");
    command.execute();
}
} // redrevolt
