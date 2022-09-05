#include "debug_panel.h"

namespace redrevolt
{
DebugPanel::DebugPanel(const std::string & id)
    : stren::Dialog(id)
    , m_fpsLabel(nullptr)
    , m_mousePosLabel(nullptr)
    , m_timer(nullptr)
{
    stren::Label * fpsLabel = new stren::Label("fpsLbl");
    fpsLabel->setFont("system_15_fnt");
    fpsLabel->setTextAlignment("CENTER|MIDDLE");
    fpsLabel->setRect(0, 0, 100, 30);
    fpsLabel->setColour("green");
    fpsLabel->setAlignment("LEFT|TOP", 0, 0);
    fpsLabel->setText("0");
    attach(fpsLabel);
    m_fpsLabel = fpsLabel;

    stren::Label * mousePosLabel = new stren::Label("mousePosLbl");
    mousePosLabel->setFont("system_15_fnt");
    mousePosLabel->setTextAlignment("CENTER|MIDDLE");
    mousePosLabel->setRect(0, 0, 120, 30);
    mousePosLabel->setColour("green");
    mousePosLabel->setAlignment("RIGHT|TOP", 0, 0);
    mousePosLabel->setText("0");
    attach(mousePosLabel);
    m_mousePosLabel = mousePosLabel;

    stren::Timer * timer = new stren::Timer("updateTimer");
    timer->restart(100);
    timer->addCallback("TimerElapsed", this, &DebugPanel::onTimerElapsed);
    attach(timer);
    m_timer = timer;
}

DebugPanel::~DebugPanel()
{
}

void DebugPanel::onTimerElapsed(Widget * sender)
{
    if (m_fpsLabel)
    {
        char str[16];
        sprintf(str, "%d", stren::Engine::getFPS());
        m_fpsLabel->setText(str);
    }
    if (m_mousePosLabel)
    {
        const stren::Point & pos = stren::Engine::getMousePos();
        char str[16];
        sprintf(str, "%d|%d", pos.getX(), pos.getY());
        m_mousePosLabel->setText(str);
    }
    if (m_timer)
    {
        m_timer->restart(100);
    }
}
} // redrevolt
