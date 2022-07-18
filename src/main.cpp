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

    class StartScreen : public Screen
    {
    public:
        StartScreen(const std::string & id = String::kEmpty) 
            : Screen(id)
        {
            const int screenWidth = EngineHandler::getScreenWidth();
            const int screenHeight = EngineHandler::getScreenHeight();

            Button * btn = new Button("logoBtn");
            btn->setRect(0, 0, screenWidth, screenHeight);
            btn->setAlignment("LEFT|TOP", 0, 0);
            btn->addCallback("MouseUp_Left", this, &StartScreen::goToNextScreen);
            attach(btn);

            Label * lbl = new Label();
            lbl->setRect(0, 0, 200, 400);
            lbl->setText("Click to continue...");
            lbl->setAlignment("CENTER|BOTTOM", -40, 0);
            lbl->setFont("system_24_fnt");
            lbl->setColour("white");
            lbl->setTextAlignment("CENTER|BOTTOM");
            attach(lbl);

            Timer * timer = new Timer();
            timer->addCallback("TimerElapsed", this, &StartScreen::goToNextScreen);
            attach(timer);

            timer->restart(5000);
        }

        virtual ~StartScreen()
        {
        }

        void goToNextScreen(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("MainScreen");
            EngineHandler::executeCommand(command);
        }
    };

    class LoadingScreen : public Screen
    {
    private:
        std::string m_nextScreenId;
    public:
        LoadingScreen(const std::string & id = String::kEmpty, const std::string & nextId = String::kEmpty)
            : Screen(id)
            , m_nextScreenId(nextId)
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
            EngineCommand command(EngineCommand::Type::SwitchScreen, m_nextScreenId); 
            EngineHandler::executeCommand(command);
        }
    };
    
    class OptionsScreen : public Screen
    {
    public:
        OptionsScreen(const std::string & id = String::kEmpty)
            : Screen(id)
        {
        }

        virtual ~OptionsScreen()
        {
        }
    };

    class MapEditorScreen : public Screen
    {
    public:
        MapEditorScreen(const std::string & id = String::kEmpty)
            : Screen(id)
        {
        }

        virtual ~MapEditorScreen()
        {
        }
    };

    class TestScreen : public Screen
    {
    public:
        TestScreen(const std::string & id = String::kEmpty)
            : Screen(id)
        {
            Button * btn = new Button("backBtn");
            btn->setText("Main Screen");
            btn->setFont("system_15_fnt");
            btn->setColour("red");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 64);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScreen::onBackBtnClicked);
            attach(btn);

            btn = new Button("testPrimitiveScreenBtn");
            btn->setText("Test Primitive Screen");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 138);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScreen::toTestPrimitiveScreen);
            attach(btn);
            
            btn = new Button("testFaderScreenBtn");
            btn->setText("Test Fader Screen");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 212);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScreen::toTestFaderScreen);
            attach(btn);
            
            btn = new Button("testSoundScreenBtn");
            btn->setText("Test Sound Screen");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 286);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScreen::toTestSoundScreen);
            attach(btn);
            
            btn = new Button("testWidgetsScreenBtn");
            btn->setText("Test Widgets Screen");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 360);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScreen::toTestWidgetsScreen);
            attach(btn);

            btn = new Button("testScrollScreenBtn");
            btn->setText("Test Scroll Screen");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 434);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScreen::toTestScrollScreen);
            attach(btn);
            
            btn = new Button("testFontScreenBtn");
            btn->setText("Test Font Screen");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 508);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScreen::toTestFontScreen);
            attach(btn);

            btn = new Button("testAtlasScreenBtn");
            btn->setText("Test Atlas Screen");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 582);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScreen::toAtlasScreen);
            attach(btn);

            btn = new Button("testBattlefieldScreenBtn");
            btn->setText("Test Battlefield Screen");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 656);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScreen::toBattlefieldScreen);
            attach(btn);
        }

        virtual ~TestScreen()
        {
        }

    private:
        void onBackBtnClicked(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("MainScreen");
            EngineHandler::executeCommand(command);
        }

        void toTestPrimitiveScreen(Widget * sender)
        {
        }

        void toTestFaderScreen(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestFaderScreen");
            EngineHandler::executeCommand(command);
         }

        void toTestSoundScreen(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestSoundScreen");
            EngineHandler::executeCommand(command);
        }

        void toTestWidgetsScreen(Widget * sender)
        {
        }

        void toTestScrollScreen(Widget * sender)
        {
        }

        void toTestFontScreen(Widget * sender)
        {
        }

        void toAtlasScreen(Widget * sender)
        {
        }

        void toBattlefieldScreen(Widget * sender)
        {
        }
    };
    
    class TestSoundScreen : public Screen
    {
    public:
        TestSoundScreen(const std::string & id = String::kEmpty)
            : Screen(id)
        {
            Button * btn = new Button("backBtn");
            btn->setText("Exit");
            btn->setFont("system_15_fnt");
            btn->setColour("red");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setRect(0, 0, 256, 64);
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestSoundScreen::onBackBtnClick);
            attach(btn);
            
            btn = new Button("playMusicBtn");
            btn->setText("Music On");
            btn->setFont("system_15_fnt");
            btn->setColour("red");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setRect(256, 0, 256, 64);
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestSoundScreen::onPlayMusicBtnClick);
            attach(btn);
            
            btn = new Button("stopMusicBtn");
            btn->setText("Music Off");
            btn->setFont("system_15_fnt");
            btn->setColour("red");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setRect(256, 64, 256, 64);
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestSoundScreen::onStopMusicBtnClick);
            attach(btn);

            btn = new Button("playSoundBtn");
            btn->setText("Play Sound");
            btn->setFont("system_15_fnt");
            btn->setColour("red");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setRect(512, 0, 256, 64);
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestSoundScreen::onPlaySoundBtnClick);
            attach(btn);

            btn = new Button("playDoubleSoundBtn");
            btn->setText("Play Double Sound");
            btn->setFont("system_15_fnt");
            btn->setColour("red");
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setRect(512, 64, 256, 64);
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestSoundScreen::onPlayDoubleSoundBtnClick);
            attach(btn);
        }

        virtual ~TestSoundScreen()
        {
        }
    private:
        void onBackBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestScreen");
            EngineHandler::executeCommand(command);
        }

        void onPlayMusicBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::PlayMusic, "main_menu_mus");
            EngineHandler::executeCommand(command);
        }

        void onStopMusicBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::StopMusic);
            EngineHandler::executeCommand(command);
        }

        void onPlaySoundBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::PlaySound, "kick_snd");
            command.setIParam(0);
            command.setIParam2(-1);
            EngineHandler::executeCommand(command);
        }

        void onPlayDoubleSoundBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::PlaySound, "kick_snd");
            command.setIParam(1);
            command.setIParam2(-1);
            EngineHandler::executeCommand(command);
         }
    };

    class TestFaderScreen : public Screen
    {
    private:
        int m_fadeSpeed;
        Fader * m_fader;
        Label * m_fadeSpeedLbl;

    public:
        TestFaderScreen(const std::string & id = String::kEmpty)
            : Screen(id)
            , m_fadeSpeed(100)
            , m_fader(nullptr)
            , m_fadeSpeedLbl(nullptr)
        {
            const int screenWidth = EngineHandler::getScreenWidth();
            const int screenHeight = EngineHandler::getScreenHeight();

            Primitive * primitive = new Primitive();
            primitive->setColour("white");
            const Rect rect(0, 0, screenWidth, screenHeight);
            primitive->createRect(rect, true);
            attach(primitive);

            Button * btn = new Button("backBtn");
            btn->setText("Exit");
            btn->setFont("system_15_fnt");
            btn->setColour("red");
            btn->setRect(0, 0, 256, 64);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setOrder(2);
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestFaderScreen::onBackBtnClick);
            attach(btn);

            m_fader = new Fader("fader");
            m_fader->setRect(0, 0, screenWidth, screenHeight);
            m_fader->setFadeSpeed(m_fadeSpeed);
            m_fader->setSprite("dark_img_spr");
            attach(m_fader);

            btn = new Button("fadeInBtn");
            btn->setText("Fade In");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 70, 256, 64);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestFaderScreen::onFadeInBtnClick);
            attach(btn);
            
            btn = new Button("fadeOutBtn");
            btn->setText("Fade Out");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 140, 256, 64);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestFaderScreen::onFadeOutBtnClick);
            attach(btn);

            btn = new Button("fadeSpeedUpBtn");
            btn->setText("+");
            btn->setFont("system_15_fnt");
            btn->setRect(50, 210, 64, 64);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestFaderScreen::onFadeSpeedUpBtnClick);
            attach(btn);

            btn = new Button("fadeSpeedDownBtn");
            btn->setText("-");
            btn->setFont("system_15_fnt");
            btn->setRect(150, 210, 64, 64);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestFaderScreen::onFadeSpeedDownBtnClick);
            attach(btn);

            Label * lbl = new Label();
            lbl->setRect(50, 280, 100, 64);
            lbl->setText("Fade speed:");
            lbl->setFont("system_15_fnt");
            lbl->setTextAlignment("RIGHT|MIDDLE");
            lbl->setColour("red");
            attach(lbl);

            m_fadeSpeedLbl = new Label("fadeSpeedLbl");
            m_fadeSpeedLbl->setRect(164, 280, 256, 64);
            m_fadeSpeedLbl->setText(std::to_string(m_fadeSpeed));
            m_fadeSpeedLbl->setFont("system_15_fnt");
            m_fadeSpeedLbl->setTextAlignment("LEFT|MIDDLE");
            m_fadeSpeedLbl->setColour("blue");
            attach(m_fadeSpeedLbl);

        }

        virtual ~TestFaderScreen()
        {
        }

        void onBackBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestScreen");
            EngineHandler::executeCommand(command);
        }

        void onFadeInBtnClick(Widget * sender)
        {
            if (m_fader)
            {
                m_fader->fadeIn();
            }
         }

        void onFadeOutBtnClick(Widget * sender)
        {
            if (m_fader)
            {
                m_fader->fadeOut();
            }
        }

        void onFadeSpeedUpBtnClick(Widget * sender)
        {
            if (m_fader)
            {
                int speed = m_fader->getFadeSpeed();
                m_fader->setFadeSpeed(speed + 1);
                if (m_fadeSpeedLbl)
                {
                    speed = m_fader->getFadeSpeed();
                    m_fadeSpeedLbl->setText(std::to_string(speed));
                }
            }
        }

        void onFadeSpeedDownBtnClick(Widget * sender)
        {
            if (m_fader)
            {
                int speed = m_fader->getFadeSpeed();
                m_fader->setFadeSpeed(speed - 1);
                if (m_fadeSpeedLbl)
                {
                    speed = m_fader->getFadeSpeed();
                    m_fadeSpeedLbl->setText(std::to_string(speed));
                }
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
                Button * btn = new Button("testBtn");
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
                Button * btn = new Button("newGameBtn");
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
                Button * btn = new Button("loadGameBtn");
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
                Button * btn = new Button("optionsBtn");
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
                Button * btn = new Button("mapEditorBtn");
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
                Button * btn = new Button("exitBtn");
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
        }

    private:
        void onTestBtnClicked(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestScreen");
            EngineHandler::executeCommand(command);
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
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("OptionsScreen");
            EngineHandler::executeCommand(command);
        }

        void onMapEditorBtnClicked(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("MapEditorScreen");
            EngineHandler::executeCommand(command);
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
            stren::Logger("green") << "Red Revolt Game creating...";
            init();

            EngineCommand command(EngineCommand::Type::SwitchScreen, "StartScreen");
            switchScreen(command);
            stren::Logger("green") << "Red Revolt Game created.";
        }

        virtual ~RedRevoltGame()
        {
        }

        virtual Screen * createScreen(const EngineCommand & command) override
        {
            const std::string & id = command.getParam();
            stren::Logger("red") << id;
            if ("LoadingScreen" == id)
            {
                const std::string & nextId = command.getParam2();
                return new LoadingScreen(id, nextId);
            }
            else if ("MainScreen" == id)
            {
                return new MainScreen(id);
            }
            else if ("StartScreen" == id)
            {
                return new StartScreen(id);
            }
            else if ("TestScreen" == id)
            {
                return new TestScreen(id);
            }
            else if ("OptionsScreen" == id)
            {
                return new OptionsScreen(id);
            }
            else if ("MapEditorScreen" == id)
            {
                return new MapEditorScreen(id);
            }
            else if ("TestSoundScreen" == id)
            {
                return new TestSoundScreen(id);
            }
            else if ("TestFaderScreen" == id)
            {
                return new TestFaderScreen(id);
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
