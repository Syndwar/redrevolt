#include "stren.h"

using namespace stren;

namespace redrevolt
{
    class Console : public Dialog
    {
        std::list<Label *> m_labels;
        int m_labelHeight;
        int m_labelsCount;
    public:
        Console(const std::string & id)
            : Dialog(id)
            , m_labelHeight(16) 
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

            m_labelsCount = dialogHeight / m_labelHeight;
            for (int i = 0; i < m_labelsCount; ++i)
            {
                Label * lbl = new Label();
                lbl->setRect(0, i * m_labelHeight, screenWidth, screenHeight);
                lbl->setColour("green");
                lbl->setTextAlignment("LEFT|TOP");
                lbl->setFont("system_15_fnt");
                attach(lbl);
                m_labels.push_back(lbl);
            }
        }

        virtual ~Console()
        {
            m_labels.clear();
        }

        void log(const char * msg)
        {
            for (Label * lbl : m_labels)
            {
                if (lbl)
                {
                    lbl->moveBy(0, -m_labelHeight);
                }
            }
            Label * firstLabel = m_labels.front();
            if (firstLabel)
            {
                firstLabel->setText(msg);
                firstLabel->moveBy(0, m_labelsCount * m_labelHeight);
            }
            m_labels.pop_front();
            m_labels.push_back(firstLabel);
        }
    };

    class DebugPanel : public Dialog
    {
    private:
        Label * m_fpsLabel;
        Label * m_mousePosLabel;
        Timer * m_timer;
    public:
        DebugPanel(const std::string & id)
            : Dialog(id)
            , m_fpsLabel(nullptr)
            , m_mousePosLabel(nullptr)
            , m_timer(nullptr)
        {
            Label * fpsLabel = new Label("fpsLbl");
            fpsLabel->setFont("system_15_fnt");
            fpsLabel->setTextAlignment("CENTER|MIDDLE");
            fpsLabel->setRect(0, 0, 100, 30);
            fpsLabel->setColour("green");
            fpsLabel->setAlignment("LEFT|TOP", 0, 0);
            fpsLabel->setText("0");
            attach(fpsLabel);
            m_fpsLabel = fpsLabel;

            Label * mousePosLabel = new Label("mousePosLbl");
            mousePosLabel->setFont("system_15_fnt");
            mousePosLabel->setTextAlignment("CENTER|MIDDLE");
            mousePosLabel->setRect(0, 0, 120, 30);
            mousePosLabel->setColour("green");
            mousePosLabel->setAlignment("RIGHT|TOP", 0, 0);
            mousePosLabel->setText("0");
            attach(mousePosLabel);
            m_mousePosLabel = mousePosLabel;

            Timer * timer = new Timer("updateTimer");
            timer->restart(100);
            timer->addCallback("TimerElapsed", this, &DebugPanel::onTimerElapsed);
            attach(timer);
            m_timer = timer;
        }

        virtual ~DebugPanel()
        {
        }

        void onTimerElapsed(Widget * sender)
        {
            if (m_fpsLabel)
            {
                char str[16];
                sprintf(str, "%d", EngineHandler::getFPS());
                m_fpsLabel->setText(str);
            }
            if (m_mousePosLabel)
            {
                const Point & pos = EngineHandler::getMousePos();
                char str[16];
                sprintf(str, "%d|%d", pos.getX(), pos.getY());
                m_mousePosLabel->setText(str);
            }
            if (m_timer)
            {
                m_timer->restart(100);
            }
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
                screen->setDebugView(!screen->isDebugView());
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

    class LoadingScreen : public Screen
    {
    public:
        LoadingScreen(const std::string & id = String::kEmpty)
        {
            Label * lbl = new Label();
            lbl->setRect(0, 0, 200, 40);
            lbl->setAlignment("CENTER|MIDDLE", 0, 0);
            lbl->setText("Loading...");
            lbl->setFont("system_24_fnt");
            lbl->setColour("white");
            lbl->setTextAlignment("CENTER|BOTTOM");
            attach(lbl);

            Timer * timer = new Timer();
            timer->addCallback("TimerElapsed", this, &LoadingScreen::onTimerElapsed);
            attach(timer);

            timer->restart(1000);
        }

        virtual ~LoadingScreen()
        {
        }

        void onTimerElapsed(Widget * sender)
        {
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
            log("new game");
        }

        void onLoadGameBtnClicked(Widget * sender)
        {
            log("load game");
        }

        void onOptionsBtnClicked(Widget * sender)
        {
            log("options");
            // Screens.load("LoadingScreen", "OptionsScreen")
        }

        void onMapEditorBtnClicked(Widget * sender)
        {
            log("map editor");
            // Screens.load("LoadingScreen", "MapEditorScreen")
        }

        void onExitBtnClicked(Widget * sender)
        {
            EngineHandler::shutdown();
        }
        
        void log(const char * msg)
        {
            Widget * widget = findWidget("systemTools");
            if (widget)
            {
                SystemTools * tools = dynamic_cast<SystemTools *>(widget);
                if (tools)
                {
                    tools->log(msg);
                }
            }
        }
    };

    class RedRevoltGame : public Game
    {
    public:
        RedRevoltGame()
            : Game()
        {
            init();

            switchScreen("LoadingScreen");
        }

        virtual ~RedRevoltGame()
        {
        }

        virtual Screen * createScreen(const std::string & id) override
        {
            if ("LoadingScreen" == id)
            {
                return new LoadingScreen(id);
            }
            else if ("MainScreen" == id)
            {
                return new MainScreen(id);
            }
            return nullptr;
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
