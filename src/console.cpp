#include "console.h"

namespace redrevolt
{
Console::Console(const std::string & id)
    : stren::Dialog(id)
    , m_labelHeight(16) 
{
    const int screenWidth = stren::Engine::getScreenWidth();
    const int screenHeight = stren::Engine::getScreenHeight();
    const int dialogHeight = screenHeight / 2;

    stren::Image * backImg = new stren::Image();
    backImg->setRect(0, 0, screenWidth, dialogHeight);
    backImg->setSprite("dark_img_spr");
    attach(backImg);

    stren::Primitive * line = new stren::Primitive();
    line->createLines({{0, 0}, {screenWidth, 0}});
    line->moveBy(0, dialogHeight);
    line->setColour("green");
    attach(line);

    m_labelsCount = dialogHeight / m_labelHeight;
    for (int i = 0; i < m_labelsCount; ++i)
    {
        stren::Label * lbl = new stren::Label();
        lbl->setRect(0, i * m_labelHeight, screenWidth, screenHeight);
        lbl->setColour("green");
        lbl->setTextAlignment("LEFT|TOP");
        lbl->setFont("system_15_fnt");
        attach(lbl);
        m_labels.push_back(lbl);
    }
}

Console::~Console()
{
    m_labels.clear();
}

void Console::log(const char * msg)
{
    for (stren::Label * lbl : m_labels)
    {
        if (lbl)
        {
            lbl->moveBy(0, -m_labelHeight);
        }
    }
    stren::Label * firstLabel = m_labels.front();
    if (firstLabel)
    {
        firstLabel->setText(msg);
        firstLabel->moveBy(0, m_labelsCount * m_labelHeight);
    }
    m_labels.pop_front();
    m_labels.push_back(firstLabel);
}
} // redrevolt

