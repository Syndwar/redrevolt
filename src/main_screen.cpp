#include "main_screen.h"

#include "system_tools.h"

namespace redrevolt
{
    MainScreen::MainScreen(const std::string & id)
        : stren::Screen(id)
    {
        SystemTools * systemTools = new SystemTools("systemTools");
        attach(systemTools);
        {
            stren::Button * btn = new stren::Button("testBtn");
            btn->setText("Test Screen");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("LEFT|TOP", 64, 64);
            btn->setColour("green");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &MainScreen::onTestBtnClicked);
            attach(btn);
        }
        {
            stren::Button * btn = new stren::Button("newGameBtn");
            btn->setText("New Game");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 64);
            btn->setColour("white");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &MainScreen::onNewGameBtnClicked);
            attach(btn);
        }
        {
            stren::Button * btn = new stren::Button("loadGameBtn");
            btn->setText("Load Game");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 138);
            btn->setColour("white");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &MainScreen::onLoadGameBtnClicked);
            attach(btn);
        }
        {
            stren::Button * btn = new stren::Button("optionsBtn");
            btn->setText("Options");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 212);
            btn->setColour("white");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &MainScreen::onOptionsBtnClicked);
            attach(btn);
        }
        {
            stren::Button * btn = new stren::Button("mapEditorBtn");
            btn->setText("Map Editor");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 286);
            btn->setColour("white");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &MainScreen::onMapEditorBtnClicked);
            attach(btn);
        }
        {
            stren::Button * btn = new stren::Button("exitBtn");
            btn->setText("Exit");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|BOTTOM", -64, -64);
            btn->setColour("red");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &MainScreen::onExitBtnClicked);
            attach(btn);
        }
    }

    MainScreen::~MainScreen()
    {
    }

    void MainScreen::onTestBtnClicked(Widget * sender)
    {
        stren::SwitchScreenCommand command;
        command.setScreen("LoadingScreen");
        command.setNextScreen("TestScreen");
        command.execute();
    }

    void MainScreen::onNewGameBtnClicked(Widget * sender)
    {
        log("new game");
    }

    void MainScreen::onLoadGameBtnClicked(Widget * sender)
    {
        log("load game");
    }

    void MainScreen::onOptionsBtnClicked(Widget * sender)
    {
        stren::SwitchScreenCommand command;
        command.setScreen("LoadingScreen");
        command.setNextScreen("OptionsScreen");
        command.execute();
    }

    void MainScreen::onMapEditorBtnClicked(Widget * sender)
    {
        stren::SwitchScreenCommand command;
        command.setScreen("LoadingScreen");
        command.setNextScreen("MapEditorScreen");
        command.execute();
    }

    void MainScreen::onExitBtnClicked(Widget * sender)
    {
        stren::Engine::shutdown();
    }

    void MainScreen::log(const char * msg)
    {
        stren::Widget * widget = findWidget("systemTools");
        if (widget)
        {
            SystemTools * tools = dynamic_cast<SystemTools *>(widget);
            if (tools)
            {
                tools->log(msg);
            }
        }
    }
} // redrevolt

