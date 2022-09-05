#include "start_screen.h"

namespace redrevolt
{
StartScreen::StartScreen(const std::string & id) 
    : stren::Screen(id)
{
    const int screenWidth = stren::Engine::getScreenWidth();
    const int screenHeight = stren::Engine::getScreenHeight();

    stren::Button * btn = new stren::Button("logoBtn");
    btn->setRect(0, 0, screenWidth, screenHeight);
    btn->setAlignment("LEFT|TOP", 0, 0);
    btn->addCallback("MouseUp_Left", this, &StartScreen::goToNextScreen);
    attach(btn);

    stren::Label * lbl = new stren::Label();
    lbl->setRect(0, 0, 200, 400);
    lbl->setText("Click to continue...");
    lbl->setAlignment("CENTER|BOTTOM", -40, 0);
    lbl->setFont("system_24_fnt");
    lbl->setColour("white");
    lbl->setTextAlignment("CENTER|BOTTOM");
    attach(lbl);

    stren::Timer * timer = new stren::Timer();
    timer->addCallback("TimerElapsed", this, &StartScreen::goToNextScreen);
    attach(timer);

    timer->restart(5000);
}

StartScreen::~StartScreen()
{
}

void StartScreen::goToNextScreen(Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("MainScreen");
    command.execute();
}
} // redrevolt

