#include "options_screen.h"

#include "system_tools.h"

namespace redrevolt
{
struct Resolution
{
    int width;
    int height;
};

const std::vector<Resolution> KResolutions = {
    {800, 600},
    {1024, 768},
    {1280, 720},
    {1360, 768},
    {1600, 1900},
    {1920, 1080}
};

OptionsScreen::OptionsScreen(const std::string & id)
    : stren::Screen(id)
    , m_vsyncBtn(nullptr)
    , m_borderlessBtn(nullptr)
    , m_fullscreenBtn(nullptr)
    , m_isVSync(false)
    , m_isBorderless(false)
    , m_isFullscreen(false)
    , m_resIndex(0)
{
    SystemTools * systemTools = new SystemTools("systemTools");
    attach(systemTools);

    stren::GetConfigCommand command;
    command.execute();

    m_isVSync = command.isVSync();
    m_isFullscreen = command.isFullscreen();
    m_isBorderless = command.isBorderless();

    stren::Button * btn = new stren::Button("backBtn");
    btn->setText("Main Screen");
    btn->setFont("system_15_fnt");
    btn->setColour("red");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|TOP", -64, 64);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &OptionsScreen::onBackBtnClick);
    attach(btn);

    btn = new stren::Button("applyBtn");
    btn->setText("Apply");
    btn->setFont("system_15_fnt");
    btn->setColour("white");
    btn->setRect(0, 0, 256, 64);
    btn->setAlignment("RIGHT|BOTTOM", -64, -64);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &OptionsScreen::onApplyBtnClick);
    attach(btn);

    m_vsyncBtn = new stren::Button("vsyncBtn");
    m_vsyncBtn->setText(m_isVSync ? "VSync On" : "VSync Off");
    m_vsyncBtn->setColour(m_isVSync ? "green" : "red");
    m_vsyncBtn->setFont("system_15_fnt");
    m_vsyncBtn->setRect(0, 0, 256, 64);
    m_vsyncBtn->setAlignment("LEFT|TOP", 64, 64);
    m_vsyncBtn->setTextAlignment("CENTER|MIDDLE");
    m_vsyncBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    m_vsyncBtn->addCallback("MouseUp_Left", this, &OptionsScreen::onVSyncBtnClick);
    attach(m_vsyncBtn);

    m_borderlessBtn = new stren::Button("borderlessBtn");
    m_borderlessBtn->setText(m_isBorderless ? "Window Border On" : "Window Border Off");
    m_borderlessBtn->setColour(m_isBorderless ? "green" : "red");
    m_borderlessBtn->setFont("system_15_fnt");
    m_borderlessBtn->setRect(0, 0, 256, 64);
    m_borderlessBtn->setAlignment("LEFT|TOP", 64, 128);
    m_borderlessBtn->setTextAlignment("CENTER|MIDDLE");
    m_borderlessBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    m_borderlessBtn->addCallback("MouseUp_Left", this, &OptionsScreen::onBorderlessBtnClick);
    attach(m_borderlessBtn);

    m_fullscreenBtn = new stren::Button("m_fullscreenBtn");
    m_fullscreenBtn->setText(m_isFullscreen ? "Fullscreen On" : "Fullscreen Off");
    m_fullscreenBtn->setColour(m_isFullscreen ? "green" : "red");
    m_fullscreenBtn->setFont("system_15_fnt");
    m_fullscreenBtn->setRect(0, 0, 256, 64);
    m_fullscreenBtn->setAlignment("LEFT|TOP", 64, 196);
    m_fullscreenBtn->setTextAlignment("CENTER|MIDDLE");
    m_fullscreenBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    m_fullscreenBtn->addCallback("MouseUp_Left", this, &OptionsScreen::onFullscreenBtnClick);
    attach(m_fullscreenBtn);

    const int screenWidth = stren::Engine::getScreenWidth();
    const int screenHeight = stren::Engine::getScreenHeight();

    size_t i(0);
    for (const Resolution & res : KResolutions)
    {
        const std::string resStr = std::to_string(res.width) + "x" + std::to_string(res.height);
        const bool isSelected = screenWidth == res.width && screenHeight == res.height;
        stren::Button * btn = new stren::Button();
        btn->setText(resStr);
        btn->setFont("system_15_fnt");
        btn->setTextAlignment("CENTER|MIDDLE");
        btn->setRect(0, 0, 256, 64);
        btn->setAlignment("LEFT|TOP", 320, (i + 1) * 64);
        btn->setColour(isSelected ? "green" : "red");
        btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
        btn->addCallback("MouseUp_Left", this, &OptionsScreen::onResolutionBtnClick);
        m_resButtons.push_back(btn);
        attach(btn);

        if (isSelected)
        {
            m_resIndex = i;
        }
        ++i;
    }
}

OptionsScreen::~OptionsScreen()
{
}

void OptionsScreen::onBackBtnClick(Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("MainScreen");
    command.execute();
}

void OptionsScreen::onApplyBtnClick(Widget * sender)
{
    stren::UpdateConfigCommand configCommand;
    if (m_resIndex < KResolutions.size())
    {
        const Resolution & res = KResolutions[m_resIndex];
        configCommand.setScreenWidth(res.width);
        configCommand.setScreenHeight(res.height);
    }
    configCommand.setBorderless(m_isBorderless);
    configCommand.setFullscreen(m_isFullscreen);
    configCommand.setVSync(m_isVSync);
    configCommand.execute();

    stren::SerializeCommand serializeCommand;
    serializeCommand.execute();

    stren::RestartCommand restartCommand;
    restartCommand.execute();
}

void OptionsScreen::onVSyncBtnClick(Widget * sender)
{
    m_isVSync = !m_isVSync;
    if (m_vsyncBtn)
    {
        m_vsyncBtn->setText(m_isVSync ? "VSync On" : "VSync Off");
        m_vsyncBtn->setColour(m_isVSync ? "green" : "red");
    }
}

void OptionsScreen::onBorderlessBtnClick(Widget * sender)
{
    m_isBorderless = !m_isBorderless;
    if (m_borderlessBtn)
    {
        m_borderlessBtn->setText(m_isBorderless ? "Window Border On" : "Window Border Off");
        m_borderlessBtn->setColour(m_isBorderless ? "green" : "red");
    }
}

void OptionsScreen::onFullscreenBtnClick(Widget * sender)
{
    m_isFullscreen = !m_isFullscreen;
    if (m_fullscreenBtn)
    {
        m_fullscreenBtn->setText(m_isFullscreen ? "Fullscreen On" : "Fullscreen Off");
        m_fullscreenBtn->setColour(m_isFullscreen ? "green" : "red");
    }
}

void OptionsScreen::onResolutionBtnClick(Widget * sender)
{
    size_t i(0);
    for (stren::Button * btn : m_resButtons)
    {
        if (btn == sender)
        {
            btn->setColour("green");
            m_resIndex = i;
        }
        else
        {
            btn->setColour("red");
        }
        ++i;
    }
}
} // redrevolt
