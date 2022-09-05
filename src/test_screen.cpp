#include "test_screen.h"

#include "system_tools.h"

namespace redrevolt
{
TestScreen::TestScreen(const std::string & id)
    : Screen(id)
{
    SystemTools * systemTools = new SystemTools("systemTools");
    attach(systemTools);

    stren::Button * btn = new stren::Button("backBtn");
    btn->setText("Main Screen");
    btn->setFont("system_15_fnt");
    btn->setColour("red");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|TOP", -64, 64);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScreen::onBackBtnClicked);
    attach(btn);

    btn = new stren::Button("testPrimitiveScreenBtn");
    btn->setText("Test Primitive Screen");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|TOP", -64, 138);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScreen::toTestPrimitiveScreen);
    attach(btn);
    
    btn = new stren::Button("testFaderScreenBtn");
    btn->setText("Test Fader Screen");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|TOP", -64, 212);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScreen::toTestFaderScreen);
    attach(btn);
    
    btn = new stren::Button("testSoundScreenBtn");
    btn->setText("Test Sound Screen");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|TOP", -64, 286);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScreen::toTestSoundScreen);
    attach(btn);
    
    btn = new stren::Button("testWidgetsScreenBtn");
    btn->setText("Widgets Screen");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|TOP", -64, 360);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScreen::toTestWidgetsScreen);
    attach(btn);

    btn = new stren::Button("testScrollScreenBtn");
    btn->setText("Test Scroll Screen");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|TOP", -64, 434);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScreen::toTestScrollScreen);
    attach(btn);
    
    btn = new stren::Button("testFontScreenBtn");
    btn->setText("Test Font Screen");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|TOP", -64, 508);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScreen::toTestFontScreen);
    attach(btn);

    btn = new stren::Button("testAtlasScreenBtn");
    btn->setText("Test Atlas Screen");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|TOP", -64, 582);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScreen::toTestAtlasScreen);
    attach(btn);

    btn = new stren::Button("testBattlefieldScreenBtn");
    btn->setText("Test Battlefield Screen");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|TOP", -64, 656);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestScreen::toTestBattlefieldScreen);
    attach(btn);
}

TestScreen::~TestScreen()
{
}

void TestScreen::onBackBtnClicked(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("MainScreen");
    command.execute();
}

void TestScreen::toTestPrimitiveScreen(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestPrimitivesScreen");
    command.execute();
}

void TestScreen::toTestFaderScreen(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestFaderScreen");
    command.execute();
 }

void TestScreen::toTestSoundScreen(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestSoundScreen");
    command.execute();
}

void TestScreen::toTestWidgetsScreen(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestWidgetsScreen");
    command.execute();
 }

void TestScreen::toTestScrollScreen(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestScrollScreen");
    command.execute();
 }

void TestScreen::toTestFontScreen(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestFontScreen");
    command.execute();
}

void TestScreen::toTestAtlasScreen(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestAtlasScreen");
    command.execute();
 }

void TestScreen::toTestBattlefieldScreen(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestBattlefieldScreen");
    command.execute();
 }
} // redrevolt
