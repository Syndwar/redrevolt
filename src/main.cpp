#include "stren.h"

using namespace stren;

namespace redrevolt
{
    class SystemTools : public Container
    {
    public:
        SystemTools(const std::string & id = String::kEmpty)
            : Container(id)
        {

        }

        virtual ~SystemTools()
        {

        }
    };


    class MainScreen : public Screen
    {
    public:
        MainScreen(const std::string & id = String::kEmpty)
            : Screen(id)
        {
            {
                Button * btn = Button::create("testBtn");
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
                Button * btn = Button::create("newGameBtn");
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
                Button * btn = Button::create("loadGameBtn");
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
                Button * btn = Button::create("optionsBtn");
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
                Button * btn = Button::create("mapEditorBtn");
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
                Button * btn = Button::create("exitBtn");
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

        virtual ~MainScreen()
        {
            // Screens.load("LoadingScreen", "TestScreen")
        }

        void onTestBtnClicked(Widget * sender)
        {
        }

        void onNewGameBtnClicked(Widget * sender)
        {
        }

        void onLoadGameBtnClicked(Widget * sender)
        {
        }

        void onOptionsBtnClicked(Widget * sender)
        {
            // Screens.load("LoadingScreen", "OptionsScreen")
        }

        void onMapEditorBtnClicked(Widget * sender)
        {
            // Screens.load("LoadingScreen", "MapEditorScreen")
        }

        void onExitBtnClicked(Widget * sender)
        {
            EngineHandler::shutdown();
        }
    };

    class RedRevoltGame : public Game
    {
    public:
        RedRevoltGame()
            : Game()
        {
            init();

            Screen * screen = new MainScreen("MainScreen");
            switchScreen(screen);
        }

        virtual ~RedRevoltGame()
        {
        }

        void init()
        {
            EngineHandler::deserialize();
        }
    };
} // redrevolt

int main(int argc, char * args[])
{
    Stren engine; // create first
    redrevolt::RedRevoltGame * game = new redrevolt::RedRevoltGame();
    engine.setGame(game);
    engine.run();
    return 0;
}
