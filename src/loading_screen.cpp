#include "loading_screen.h"

namespace redrevolt
{
LoadingScreen::LoadingScreen(const std::string & id, const std::string & nextId)
    : stren::Screen(id)
    , m_nextScreenId(nextId)
{
    stren::Label * lbl = new stren::Label();
    lbl->setRect(0, 0, 200, 40);
    lbl->setAlignment("CENTER|MIDDLE", 0, 0);
    lbl->setText("Loading...");
    lbl->setFont("system_24_fnt");
    lbl->setColour("white");
    lbl->setTextAlignment("CENTER|BOTTOM");
    attach(lbl);

    stren::Timer * timer = new stren::Timer();
    timer->addCallback("TimerElapsed", this, &LoadingScreen::onTimerElapsed);
    attach(timer);

    timer->restart(1000);
}

LoadingScreen::~LoadingScreen()
{
}

void LoadingScreen::onTimerElapsed(Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen(m_nextScreenId);
    command.execute();
}
 } // redrevolt
