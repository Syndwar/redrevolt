#include "test_sound_screen.h"

#include "system_tools.h"

namespace redrevolt
{
TestSoundScreen::TestSoundScreen(const std::string & id)
    : stren::Screen(id)
{
    SystemTools * systemTools = new SystemTools("systemTools");
    attach(systemTools);

    stren::Button * btn = new stren::Button("backBtn");
    btn->setText("Exit");
    btn->setFont("system_15_fnt");
    btn->setColour("red");
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setRect(0, 0, 256, 64);
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestSoundScreen::onBackBtnClick);
    attach(btn);
    
    btn = new stren::Button("playMusicBtn");
    btn->setText("Music On");
    btn->setFont("system_15_fnt");
    btn->setColour("red");
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setRect(256, 0, 256, 64);
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestSoundScreen::onPlayMusicBtnClick);
    attach(btn);
    
    btn = new stren::Button("stopMusicBtn");
    btn->setText("Music Off");
    btn->setFont("system_15_fnt");
    btn->setColour("red");
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setRect(256, 64, 256, 64);
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestSoundScreen::onStopMusicBtnClick);
    attach(btn);

    btn = new stren::Button("playSoundBtn");
    btn->setText("Play Sound");
    btn->setFont("system_15_fnt");
    btn->setColour("red");
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setRect(512, 0, 256, 64);
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestSoundScreen::onPlaySoundBtnClick);
    attach(btn);

    btn = new stren::Button("playDoubleSoundBtn");
    btn->setText("Play Double Sound");
    btn->setFont("system_15_fnt");
    btn->setColour("red");
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setRect(512, 64, 256, 64);
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestSoundScreen::onPlayDoubleSoundBtnClick);
    attach(btn);
}

TestSoundScreen::~TestSoundScreen()
{
}

void TestSoundScreen::onBackBtnClick(stren::Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestScreen");
    command.execute();
}

void TestSoundScreen::onPlayMusicBtnClick(stren::Widget * sender)
{
    stren::PlayMusicCommand command;
    command.setTrack("main_menu_mus");
    command.execute();
}

void TestSoundScreen::onStopMusicBtnClick(stren::Widget * sender)
{
    stren::StopMusicCommand command;
    command.execute();
}

void TestSoundScreen::onPlaySoundBtnClick(stren::Widget * sender)
{
    stren::PlaySoundCommand command;
    command.setSound("kick_snd");
    command.setLoop(0);
    command.execute();
}

void TestSoundScreen::onPlayDoubleSoundBtnClick(stren::Widget * sender)
{
    stren::PlaySoundCommand command;
    command.setSound("kick_snd");
    command.setLoop(1);
    command.execute();
}
} // redrevolt

