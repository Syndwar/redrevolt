#include "stren.h"

using namespace stren;

namespace redrevolt
{
    class Console : public Dialog
    {
    public:
        Console(const std::string & id)
            : Dialog(id)
        {
            const int screenWidth = EngineHandler::getScreenWidth();
            const int screenHeight = EngineHandler::getScreenHeight();
            const int dialogHeight = screenHeight / 2;

            Image * backImg = new Image();
            backImg->setRect(0, 0, screenWidth, dialogHeight);
            backImg->setSprite("dark_img_spr");
            attach(backImg);

            Primitive * line = new Primitive();
            line->createLines({{0, 0}, {screenWidth, 0}});
            line->moveBy(0, dialogHeight);
            line->setColour("green");
            attach(line);

        }

        virtual ~Console()
        {
        }

        void log(const char * msg)
        {

        }
    };

    class DebugPanel : public Dialog
    {
    public:
        DebugPanel(const std::string & id)
            : Dialog(id)
        {
        }

        virtual ~DebugPanel()
        {
        }
    };

    class WidgetsTree : public ScrollContainer
    {
    public:
        WidgetsTree(const std::string & id)
            : ScrollContainer(id)
        {
        }

        virtual ~WidgetsTree()
        {
        }
    };
    
    class SystemTools : public Container
    {
    private:
        Console * m_console;
        WidgetsTree * m_widgetsTree;
        DebugPanel * m_debugPanel;
        

    public:
        SystemTools(const std::string & id = String::kEmpty)
            : Container(id)
            , m_console(nullptr)
            , m_widgetsTree(nullptr)
            , m_debugPanel(nullptr)
        {
            addCallback("KeyDown_Grave", this, &SystemTools::viewConsole);
            addCallback("KeyDown_F1", this, &SystemTools::viewSystemInfo);
            addCallback("KeyDown_F2", this, &SystemTools::viewDebugView);
            addCallback("KeyDown_F3", this, &SystemTools::viewWidgetsTree);

            m_console = new Console("console");
            attach(m_console);
            m_widgetsTree = new WidgetsTree("widgetsTree");
            attach(m_widgetsTree);
            m_debugPanel = new DebugPanel("debugPanel");
            attach(m_debugPanel);

            setOrder(999);
        }

        virtual ~SystemTools()
        {
            if (m_console)
            {
                delete m_console;
                m_console = nullptr;
            }
            if (m_widgetsTree)
            {
                delete m_widgetsTree;
                m_widgetsTree = nullptr;
            }
            if (m_debugPanel)
            {
                delete m_debugPanel;
                m_debugPanel = nullptr;
            }
        }

        void viewConsole(Widget * sender)
        {
            if (m_console)
            {
                m_console->view(!m_console->isOpened());
            }
        }

        void viewSystemInfo(Widget * sender)
        {
            if (m_debugPanel)
            {
                m_debugPanel->view(!m_debugPanel->isOpened());
            }
        }

        void viewDebugView(Widget * sender)
        {
            Screen * screen = EngineHandler::getCurrentScreen();
            if  (screen)
            {
                screen->switchDebugView();
            }
        }

        void viewWidgetsTree(Widget * sender)
        {
            if (m_widgetsTree)
            {
                m_widgetsTree->view(!m_widgetsTree->isOpened());
            }
        }

        void log(const char * msg)
        {
            if (m_console)
            {
                m_console->log(msg);
            }
        }

        void reset()
        {
            if (m_widgetsTree)
            {
                m_widgetsTree->instantClose();
            }
        }
    };

    class MainScreen : public Screen
    {
    public:
        MainScreen(const std::string & id = String::kEmpty)
            : Screen(id)
        {
            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);
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
