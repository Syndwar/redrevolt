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
            const int screenWidth = Engine::getScreenWidth();
            const int screenHeight = Engine::getScreenHeight();
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
                sprintf(str, "%d", Engine::getFPS());
                m_fpsLabel->setText(str);
            }
            if (m_mousePosLabel)
            {
                const Point & pos = Engine::getMousePos();
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

    class WidgetTreeBranch : public Container
    {
    public:
        static const int lineHeight = 32;
    private:
        bool m_isExpanded;
        bool m_hasChildren;
        int m_level;
        Widget * m_widget;
        Button * m_expandBtn;
        Button * m_nameBtn;
        Widget * m_parent;
    public:
        WidgetTreeBranch(Widget * parent, Widget * widget, const bool hasChildren, const int level)
            : Container(String::kEmpty)
            , m_parent(parent)
            , m_isExpanded(false)
            , m_hasChildren(hasChildren)
            , m_level(level)
            , m_widget(widget)
            , m_expandBtn(nullptr)
            , m_nameBtn(nullptr)
        {
            if (!widget) return;

            const std::string & widgetId = widget->getId();
            const bool isOpened = widget->isOpened();

            m_expandBtn = new Button();
            m_expandBtn->setText(m_hasChildren ? (m_isExpanded ? "-" : "+") : " ");
            m_expandBtn->setRect(0, 0, 32, lineHeight);
            m_expandBtn->setFont("system_15_fnt");
            m_expandBtn->setTextAlignment("CENTER|MIDDLE");
            if (m_hasChildren)
            {
                m_expandBtn->addCallback("MouseUp_Left", this, &WidgetTreeBranch::onExpandBranchClick);
            }
            attach(m_expandBtn);

            m_nameBtn = new Button();
            m_nameBtn->setRect(32, 0, 200, lineHeight);
            m_nameBtn->setFont("system_15_fnt");
            m_nameBtn->setTextAlignment("LEFT|MIDDLE");
            m_nameBtn->addCallback("MouseUp_Left", this, &WidgetTreeBranch::onEnableWidgetClick);
            m_nameBtn->setColour(isOpened ? "white" : "grey");
            m_nameBtn->setText("" != widgetId ? widgetId : "[empty]");
            attach(m_nameBtn);

            instantView(false);
        }

        virtual ~WidgetTreeBranch()
        {
        }

        bool isExpanded() const { return m_isExpanded; }

        bool hasChildren() const { return m_hasChildren; }
        
        int getLevel() const { return m_level; }

        void expand()
        {
            if (m_hasChildren)
            {
                m_isExpanded = !m_isExpanded;
                m_expandBtn->setText(m_isExpanded ? "-" : "+");
            }
        }

        void onExpandBranchClick(Widget * sender);

        void onEnableWidgetClick(Widget * sender)
        {
            m_widget->instantView(!m_widget->isOpened());
            m_nameBtn->setColour(m_widget->isOpened() ? "white" : "grey");
        }
    };

    class WidgetsTree : public ScrollContainer
    {
    private:
        int m_level;
        std::vector<WidgetTreeBranch *> m_branches;

    public:
        WidgetsTree(const std::string & id)
            : ScrollContainer(id)
            , m_level(0)
        {
            addCallback("WidgetOpened", this, &WidgetsTree::onOpening);

            const int screenWidth = Engine::getScreenWidth();
            const int screenHeight = Engine::getScreenHeight();
            setRect(0, 0, screenWidth, screenHeight);

            instantView(false);
        }

        virtual ~WidgetsTree()
        {
            m_branches.clear();
        }

        void onOpening(Widget * sender)
        {
            reset();
            update();
        }

        void reset()
        {
            m_branches.clear();
            m_level = 0;
            clean();
            Screen * screen = Engine::getCurrentScreen(); 
            createBranch(screen);
        }

        void createBranch(Widget * parent)
        {
            if (!parent) return;

            Container * parentCnt = dynamic_cast<Container *>(parent);
            if (!parentCnt) return;

            std::list<Widget *> attached = parentCnt->debugGetAttached();
            for (Widget * w : attached)
            {
                const std::string & id = w->getId();
                if ("systemTools" != id)
                {
                    Container * cnt = dynamic_cast<Container *>(w);
                    bool hasChildren(false);
                    if (cnt)
                    {
                        std::list<Widget *> children = cnt->debugGetAttached();
                        hasChildren = !children.empty();
                    }
                    WidgetTreeBranch * branch = new WidgetTreeBranch(this, w, hasChildren, m_level);
                    attach(branch);

                    m_branches.push_back(branch);

                    if (hasChildren)
                    {
                        m_level += 1;
                        createBranch(cnt);
                        m_level -= 1;
                    }
                }
            }
        }

        void update()
        {
            int visibleBranchCounter(0);
            int lockLevel(0);

            for (WidgetTreeBranch * branch : m_branches)
            {
                if (!branch) continue;
                // close all branches
                branch->instantView(false);
                const int branchLevel = branch->getLevel();
                const bool isVisible = branchLevel <= lockLevel;
                if (isVisible)
                {
                    lockLevel = branchLevel;
                }
                const bool isExpandedContainer = branch->hasChildren() && branch->isExpanded();
                if (isExpandedContainer)
                {
                    lockLevel = branchLevel + 1;
                }
                if (isVisible)
                {
                    const int newPosX = branchLevel * 32;
                    const int newPosY = WidgetTreeBranch::lineHeight * visibleBranchCounter;
                    branch->instantView(true);
                    branch->moveTo(newPosX, newPosY);
                    visibleBranchCounter += 1;
                }
            }
            const int screenWidth = Engine::getScreenWidth();
            setContentRect(0, 0, screenWidth, WidgetTreeBranch::lineHeight * visibleBranchCounter);
        }
    };

    void WidgetTreeBranch::onExpandBranchClick(Widget * sender)
    {
        expand();
        if (m_parent)
        {
            WidgetsTree * tree = dynamic_cast<WidgetsTree *>(m_parent);
            if (tree)
            {
                tree->update();
            }
        }
    }
 
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
            m_console = nullptr;
            m_widgetsTree = nullptr;
            m_debugPanel = nullptr;
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
            Screen * screen = Engine::getCurrentScreen();
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
            const int screenWidth = Engine::getScreenWidth();
            const int screenHeight = Engine::getScreenHeight();

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
            Engine::executeCommand(command);
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
            Engine::executeCommand(command);
        }
    };
    
    class OptionsScreen : public Screen
    {
    private:
        struct Resolution
        {
            int width;
            int height;
        };
        Button * m_vsyncBtn;
        Button * m_borderlessBtn;
        Button * m_fullscreenBtn;
        bool m_isVSync;
        bool m_isBorderless;
        bool m_isFullscreen;
        int m_resIndex;
        std::vector<Button *> m_resButtons;
        std::vector<Resolution> m_resolutions = {
            {800, 600},
            {1024, 768},
            {1280, 720},
            {1360, 768},
            {1600, 1900},
            {1920, 1080}
        };
    public:
        OptionsScreen(const std::string & id = String::kEmpty)
            : Screen(id)
            , m_vsyncBtn(nullptr)
            , m_borderlessBtn(nullptr)
            , m_fullscreenBtn(nullptr)
            , m_isVSync(false)
            , m_isBorderless(false)
            , m_isFullscreen(false)
            , m_resIndex(0)
        {
            //     local saved_config = UserSave:getConfig()
            // 
            //     self.is_vsync = UserSave:isVSync()
            //     self.is_borderless = UserSave:isBorderless()
            //     self.is_fullscreen = UserSave:isFullscreen()
            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);

            Button * btn = new Button("backBtn");
            btn->setText("Main Screen");
            btn->setFont("system_15_fnt");
            btn->setColour("red");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|TOP", -64, 64);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &OptionsScreen::onBackBtnClick);
            attach(btn);

            btn = new Button("applyBtn");
            btn->setText("Apply");
            btn->setFont("system_15_fnt");
            btn->setColour("white");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|BOTTOM", -64, -64);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &OptionsScreen::onApplyBtnClick);
            attach(btn);

            m_vsyncBtn = new Button("vsyncBtn");
            m_vsyncBtn->setText(m_isVSync ? "VSync On" : "VSync Off");
            m_vsyncBtn->setColour(m_isVSync ? "green" : "red");
            m_vsyncBtn->setFont("system_15_fnt");
            m_vsyncBtn->setRect(0, 0, 256, 64);
            m_vsyncBtn->setAlignment("LEFT|TOP", 64, 64);
            m_vsyncBtn->setTextAlignment("CENTER|MIDDLE");
            m_vsyncBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            m_vsyncBtn->addCallback("MouseUp_Left", this, &OptionsScreen::onVSyncBtnClick);
            attach(m_vsyncBtn);

            m_borderlessBtn = new Button("borderlessBtn");
            m_borderlessBtn->setText(m_isBorderless ? "Window Border On" : "Window Border Off");
            m_borderlessBtn->setColour(m_isBorderless ? "green" : "red");
            m_borderlessBtn->setFont("system_15_fnt");
            m_borderlessBtn->setRect(0, 0, 256, 64);
            m_borderlessBtn->setAlignment("LEFT|TOP", 64, 128);
            m_borderlessBtn->setTextAlignment("CENTER|MIDDLE");
            m_borderlessBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            m_borderlessBtn->addCallback("MouseUp_Left", this, &OptionsScreen::onBorderlessBtnClick);
            attach(m_borderlessBtn);

            m_fullscreenBtn = new Button("m_fullscreenBtn");
            m_fullscreenBtn->setText(m_isFullscreen ? "Fullscreen On" : "Fullscreen Off");
            m_fullscreenBtn->setColour(m_isFullscreen ? "green" : "red");
            m_fullscreenBtn->setFont("system_15_fnt");
            m_fullscreenBtn->setRect(0, 0, 256, 64);
            m_fullscreenBtn->setAlignment("LEFT|TOP", 64, 196);
            m_fullscreenBtn->setTextAlignment("CENTER|MIDDLE");
            m_fullscreenBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            m_fullscreenBtn->addCallback("MouseUp_Left", this, &OptionsScreen::onFullscreenBtnClick);
            attach(m_fullscreenBtn);

            const int screenWidth = Engine::getScreenWidth();
            const int screenHeight = Engine::getScreenHeight();

            size_t i(0);
            for (const Resolution & res : m_resolutions)
            {
                const std::string resStr = std::to_string(res.width) + "x" + std::to_string(res.height);
                const bool isSelected = screenWidth == res.width && screenHeight == res.height;
                Button * btn = new Button();
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

        virtual ~OptionsScreen()
        {
        }

        void onBackBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("MainScreen");
            Engine::executeCommand(command);
        }

        void onApplyBtnClick(Widget * sender)
        {
            if (m_resIndex < m_resolutions.size())
            {
                Resolution & res = m_resolutions[m_resIndex];
                EngineCommand command(EngineCommand::Type::UpdateConfig, "resolution");
                command.setIParam(res.width);
                command.setIParam2(res.height);
                Engine::executeCommand(command);
            }
            {
                EngineCommand command(EngineCommand::Type::UpdateConfig, "vsync");
                command.setBParam(m_isVSync);
                Engine::executeCommand(command);
            }
            {
                EngineCommand command(EngineCommand::Type::UpdateConfig, "fullscreen");
                command.setBParam(m_isFullscreen);
                Engine::executeCommand(command);
            }
            {
                EngineCommand command(EngineCommand::Type::UpdateConfig, "borderless");
                command.setBParam(m_isBorderless);
                Engine::executeCommand(command);
            }
            {
                EngineCommand command(EngineCommand::Type::Save);
                Engine::executeCommand(command);
            }
            {
                EngineCommand command(EngineCommand::Type::Restart);
                Engine::executeCommand(command);
            }
        }

        void onVSyncBtnClick(Widget * sender)
        {
            m_isVSync = !m_isVSync;
            if (m_isVSync)
            {
                m_vsyncBtn->setText(m_isVSync ? "VSync On" : "VSync Off");
                m_vsyncBtn->setColour(m_isVSync ? "green" : "red");
            }
        }

        void onBorderlessBtnClick(Widget * sender)
        {
            m_isBorderless = !m_isBorderless;
            if (m_borderlessBtn)
            {
                m_borderlessBtn->setText(m_isBorderless ? "Window Border On" : "Window Border Off");
                m_borderlessBtn->setColour(m_isBorderless ? "green" : "red");
            }
        }

        void onFullscreenBtnClick(Widget * sender)
        {
            m_isFullscreen = !m_isFullscreen;
            if (m_fullscreenBtn)
            {
                m_fullscreenBtn->setText(m_isFullscreen ? "Fullscreen On" : "Fullscreen Off");
                m_fullscreenBtn->setColour(m_isFullscreen ? "green" : "red");
            }
        }
        
        void onResolutionBtnClick(Widget * sender)
        {
            size_t i(0);
            for (Button * btn : m_resButtons)
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

    };

    class MapEditorScreen : public Screen
    {
    public:
        MapEditorScreen(const std::string & id = String::kEmpty)
            : Screen(id)
        {
            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);
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
            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);

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
            btn->addCallback("MouseUp_Left", this, &TestScreen::toTestAtlasScreen);
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
            Engine::executeCommand(command);
        }

        void toTestPrimitiveScreen(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestPrimitivesScreen");
            Engine::executeCommand(command);
        }

        void toTestFaderScreen(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestFaderScreen");
            Engine::executeCommand(command);
         }

        void toTestSoundScreen(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestSoundScreen");
            Engine::executeCommand(command);
        }

        void toTestWidgetsScreen(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestWidgetsScreen");
            Engine::executeCommand(command);
         }

        void toTestScrollScreen(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestScrollScreen");
            Engine::executeCommand(command);
         }

        void toTestFontScreen(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestFontScreen");
            Engine::executeCommand(command);
        }

        void toTestAtlasScreen(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestAtlasScreen");
            Engine::executeCommand(command);
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
            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);

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
            Engine::executeCommand(command);
        }

        void onPlayMusicBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::PlayMusic, "main_menu_mus");
            Engine::executeCommand(command);
        }

        void onStopMusicBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::StopMusic);
            Engine::executeCommand(command);
        }

        void onPlaySoundBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::PlaySound, "kick_snd");
            command.setIParam(0);
            command.setIParam2(-1);
            Engine::executeCommand(command);
        }

        void onPlayDoubleSoundBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::PlaySound, "kick_snd");
            command.setIParam(1);
            command.setIParam2(-1);
            Engine::executeCommand(command);
         }
    };

    class TestDialog : public Dialog
    {
    public:
        TestDialog(const std::string & id = String::kEmpty)
            : Dialog(id)
        {
            Transform openTransform;
            openTransform.add(0, 100, 1000);
            openTransform.add(100, 255, 1000);
            attachTransform("WidgetOpening", openTransform);

            Transform closeTransform;
            closeTransform.add(255, 0, 3000);
            attachTransform("WidgetClosing", closeTransform);

            setRect(0, 0, 400, 400);
            setAlignment("CENTER|MIDDLE", 0, 0);

            Image * backImg = new Image();
            backImg->setRect(0, 0, 400, 400);
            backImg->setSprite("up_btn_spr");
            attach(backImg);

            Label * lbl = new Label();
            lbl->setRect(100, 180, 200, 40);
            lbl->setText("Hello");
            lbl->setFont("system_24_fnt");
            lbl->setColour("green");
            lbl->setTextAlignment("CENTER|MIDDLE");
            attach(lbl);
        }

        virtual ~TestDialog()
        {
        }
    };

    class TestPrimitivesScreen : public Screen
    {
    public:
        TestPrimitivesScreen(const std::string & id = String::kEmpty)
            : Screen(id)
        {
            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);

            Button * btn = new Button("backBtn");
            btn->setText("Exit");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setAlignment("RIGHT|TOP", 0, 0);
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestPrimitivesScreen::onBackBtnClick);
            btn->setColour("red");
            attach(btn);

            Primitive * primitive = new Primitive();
            primitive->setColour("white");
            primitive->createCircle(630, 130, 100);
            attach(primitive);

            primitive = new Primitive();
            primitive->setColour("green");
            primitive->createLines({{0, 0}, {1024, 768}});
            attach(primitive);

            primitive = new Primitive();
            primitive->setColour("red");
            primitive->createLines({{0, 0}, {200, 500}, {1024, 768}});
            attach(primitive);

            primitive = new Primitive();
            primitive->setColour("yellow");
            primitive->createPoint({630, 130});
            attach(primitive);

            primitive = new Primitive();
            primitive->setColour("red");
            primitive->createRect({470, 70, 60, 80}, false);
            attach(primitive);

            primitive = new Primitive();
            primitive->setColour("green");
            primitive->createRect({400, 70, 60, 60}, true);
            attach(primitive);

            primitive = new Primitive();
            primitive->setColour("green");
            primitive->createPoints({{500, 101}, {500, 102}, {500, 103}});
            attach(primitive);

            primitive = new Primitive();
            primitive->setColour("red");
            primitive->createRects({{120, 700, 40, 40}, {100, 650, 80, 80}}, true);
            attach(primitive);
        }

        virtual ~TestPrimitivesScreen()
        {
        }

        void onBackBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestScreen");
            Engine::executeCommand(command);
        }
    };

    class TestAtlasScreen : public Screen
    {
    public:
        TestAtlasScreen(const std::string & id = String::kEmpty)
            : Screen(id)
        {

            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);

            lua::Table spritesTbl("Sprites");
            const size_t spritesCount = spritesTbl.getSize();
            for (size_t i = 1; i <= spritesCount; ++i)
            {
                lua::Table spriteTbl(spritesTbl.get(i));
                const std::string id = spriteTbl.get("id").getString();
                const std::string textureId = spriteTbl.get("texture").getString();
                if ("atlas_1_tex" == textureId)
                {
                    Image * img = new Image();
                    lua::Table rectTbl(spriteTbl.get("rect"));
                    const int x = rectTbl.get(1).getInt();
                    const int y = rectTbl.get(2).getInt();
                    const int w = rectTbl.get(3).getInt();
                    const int h = rectTbl.get(4).getInt();
                    img->setSprite(id);
                    img->setRect(x, y, w, h);
                    attach(img);
                }
           }

            Button * btn = new Button("backBtn");
            btn->setText("Exit");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|BOTTOM", -64, -64);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestAtlasScreen::onBackBtnClick);
            attach(btn);
        }

        virtual ~TestAtlasScreen()
        {
        }

        void onBackBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestScreen");
            Engine::executeCommand(command);
         }
    };

    class TestFontScreen : public Screen
    {
    private:
        size_t m_index;
        Image * m_fontImg;
    public:
        TestFontScreen(const std::string & id = String::kEmpty)
            : Screen(id)
            , m_index(0)
            , m_fontImg(nullptr)
        {
            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);

            m_fontImg = new Image("fontImg");
            attach(m_fontImg);

            Button * btn = new Button("backBtn");
            btn->setText("Exit");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|BOTTOM", 0, 0);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->setColour("red");
            btn->addCallback("MouseUp_Left", this, &TestFontScreen::onBackBtnClick);
            attach(btn);

            btn = new Button("changeFontBtn");
            btn->setText("Show Next Font");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 256, 64);
            btn->setAlignment("RIGHT|BOTTOM", 0, -70);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestFontScreen::onChangeFontBtnClick);
            attach(btn);
        }

        virtual ~TestFontScreen()
        {
        }

        void onBackBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestScreen");
            Engine::executeCommand(command);
        }
        
        void onChangeFontBtnClick(Widget * sender)
        {
            if (!m_fontImg) return;

            lua::Table fontsTbl("Fonts");
            lua::Table spritesTbl("Sprites");
            m_index += 1;
            if (m_index > fontsTbl.getSize())
            {
                m_index = 1;
            }
            lua::Table fontTbl(fontsTbl.get(m_index));
            const std::string fontId = fontTbl.get("id").getString();
            log(fontId.c_str());
            const size_t spritesCount = spritesTbl.getSize();
            for (size_t i = 1; i <= spritesCount; ++i)
            {
                lua::Table spriteTbl(spritesTbl.get(i));
                const std::string textureId = spriteTbl.get("texture").getString();
                if (textureId == fontId)
                {
                    const std::string id = spriteTbl.get("id").getString();
                    m_fontImg->setSprite(id);
                    int width(0);
                    int height(0);
                    Engine::debugGetTextureSize(fontId, width, height);
                    m_fontImg->setRect(0, 0, width, height);
                    break;
                }
            }

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

    class TestScrollScreen : public Screen
    {
    private:
        int m_fieldWidth;
        int m_fieldHeight;
        int m_tileWidth;
        int m_tileHeight;
        std::string m_tileSpr;
        ScrollContainer * m_scrollCnt;
    public:
        TestScrollScreen(const std::string & id = String::kEmpty)
            : Screen(id)
            , m_fieldWidth(80)
            , m_fieldHeight(50)
            , m_tileWidth(128)
            , m_tileHeight(64)
            , m_tileSpr("test_tile_spr")
            , m_scrollCnt(nullptr)
        {
            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);

            const int screenWidth = Engine::getScreenWidth();
            const int screenHeight = Engine::getScreenHeight();

            m_scrollCnt = new ScrollContainer("scrollCnt");
            m_scrollCnt->setRect(0, 0, screenWidth, screenHeight);
            m_scrollCnt->setScrollSpeed(1000);
            attach(m_scrollCnt);

            Area * leftArea = new Area("scrollLeftArea");
            leftArea->setRect(0, 0, 20, 700);
            leftArea->setAlignment("LEFT|MIDDLE", 0, 0);
            leftArea->addCallback("MouseOver", this, &TestScrollScreen::scrollLeftOn);
            leftArea->addCallback("MouseLeft", this, &TestScrollScreen::scrollLeftOff);
            attach(leftArea);
            
            Area * upArea = new Area("scrollUpArea");
            upArea->setRect(0, 0, 1000, 20);
            upArea->setAlignment("CENTER|TOP", 0, 0);
            upArea->addCallback("MouseOver", this, &TestScrollScreen::scrollUpOn);
            upArea->addCallback("MouseLeft", this, &TestScrollScreen::scrollUpOff);
            attach(upArea);
            
            Area * downArea = new Area("scrollDownArea");
            downArea->setRect(0, 0, 1000, 20);
            downArea->setAlignment("CENTER|BOTTOM", 0, 0);
            downArea->addCallback("MouseOver", this, &TestScrollScreen::scrollDownOn);
            downArea->addCallback("MouseLeft", this, &TestScrollScreen::scrollDownOff);
            attach(downArea);
            
            Area * rightArea = new Area("scrollRightArea");
            rightArea->setRect(0, 0, 20, 700);
            rightArea->setAlignment("RIGHT|MIDDLE", 0, 0);
            rightArea->addCallback("MouseOver", this, &TestScrollScreen::scrollRightOn);
            rightArea->addCallback("MouseLeft", this, &TestScrollScreen::scrollRightOff);
            attach(rightArea);

            Button * btn = new Button("backBtn");
            btn->setText("Exit");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 64, 64);
            btn->setAlignment("RIGHT|BOTTOM", 0, 0);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScrollScreen::onBackBtnClick);
            btn->setColour("red");
            attach(btn);

            btn = new Button("jumpBtn");
            btn->setText("Jump");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 64, 64);
            btn->setAlignment("RIGHT|BOTTOM", 0, -64);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScrollScreen::onJumpBtnClick);
            btn->setColour("red");
            attach(btn);

            btn = new Button("scrollBtn");
            btn->setText("Scroll");
            btn->setFont("system_15_fnt");
            btn->setRect(0, 0, 64, 64);
            btn->setAlignment("RIGHT|BOTTOM", 0, -128);
            btn->setTextAlignment("CENTER|MIDDLE");
            btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            btn->addCallback("MouseUp_Left", this, &TestScrollScreen::onScrollBtnClick);
            btn->setColour("red");
            attach(btn);

            addScrollContent();
        }

        virtual ~TestScrollScreen()
        {
        }

        void scrollTo(const int direction, const bool value)
        {
            if (m_scrollCnt)
            {
                m_scrollCnt->scrollTo(direction, value);
            }
        }

        void scrollUpOn()
        {
            scrollTo(ScrollContainer::Up, true);
        }

        void scrollUpOff()
        {
            scrollTo(ScrollContainer::Up, false);
        }

        void scrollLeftOn()
        {
            scrollTo(ScrollContainer::Left, true);
        }

        void scrollLeftOff()
        {
            scrollTo(ScrollContainer::Left, false);
        }

        void scrollRightOn()
        {
            scrollTo(ScrollContainer::Right, true);
        }

        void scrollRightOff()
        {
            scrollTo(ScrollContainer::Right, false);
        }

        void scrollDownOn()
        {
            scrollTo(ScrollContainer::Down, true);
        }

        void scrollDownOff()
        {
            scrollTo(ScrollContainer::Down, false);
        }

        void onBackBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("TestScreen");
            Engine::executeCommand(command);
        }

        void onJumpBtnClick(Widget * sender)
        {
            if (m_scrollCnt)
            {
                m_scrollCnt->jumpTo(1024, 768);
            }
        }

        void onScrollBtnClick(Widget * sender)
        {
            if (m_scrollCnt)
            {
                if (!m_scrollCnt->isScrolling())
                {
                    m_scrollCnt->scrollTo(0, 0);
                }
            }
        }

        void addScrollContent()
        {
            if (m_scrollCnt)
            {
                int contentWidth(0);
                int contentHeight(0);
                for (int i = 0; i < m_fieldWidth; ++i)
                {
                    for (int j = 0; j < m_fieldHeight; ++j)
                    {
                        const bool isOdd = 1 == (j & 1);
                        const int offsetX = isOdd ? (m_tileWidth * 0.5) : 0;
                        const int x = m_tileWidth * (m_fieldWidth - 1 - i) + offsetX;
                        const int y = m_tileHeight * 0.5 * j;

                        Image * img = new Image();
                        img->setRect(x, y, m_tileWidth, m_tileHeight);
                        img->setSprite(m_tileSpr);
                        m_scrollCnt->attach(img);

                        if (x + m_tileWidth > contentWidth)
                        {
                            contentWidth = x + m_tileWidth;
                        }
                        if (y + m_tileHeight > contentHeight)
                        {
                            contentHeight = y + m_tileHeight;
                        }
                    }
                }
                m_scrollCnt->setContentRect(0, 0, contentWidth, contentHeight);
            }
        }
    };

    class TestWidgetsScreen : public Screen
    {
    private:

        int m_resizeValue;
        Dialog * m_testDlg;
        Label * m_exitLbl;
        Label * m_multilineLbl;
        ProgressBar * m_pb1;
        ProgressBar * m_pb2;
        ScrollContainer * m_scrollCnt;
        Container * m_widgetCnt;
    public:
        TestWidgetsScreen(const std::string & id = String::kEmpty)
            : Screen(id)
            , m_resizeValue(10)
            , m_testDlg(nullptr)
            , m_exitLbl(nullptr)
            , m_multilineLbl(nullptr)
            , m_pb1(nullptr)
            , m_pb2(nullptr)
            , m_scrollCnt(nullptr)
            , m_widgetCnt(nullptr)
        {
            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);

            Button * backBtn = new Button("backBtn");
            backBtn->setText("Exit");
            backBtn->setFont("system_15_fnt");
            backBtn->setColour("red");
            backBtn->setRect(0, 0, 256, 64);
            backBtn->setTextAlignment("CENTER|MIDDLE");
            backBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            backBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onBackBtnClick);
            attach(backBtn);

            Button * lockBtn = new Button("lockBtn");
            lockBtn->setText("View Label");
            lockBtn->setFont("system_15_fnt");
            lockBtn->setRect(0, 64, 256, 64);
            lockBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            lockBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onLockBtnClick);
            attach(lockBtn);

            Button * windBtn = new Button("windBtn");
            windBtn->setText("Wind Progressbar");
            windBtn->setFont("system_15_fnt");
            windBtn->setColour("yellow");
            windBtn->setRect(0, 128, 256, 64);
            windBtn->setTextAlignment("CENTER|MIDDLE");
            windBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            windBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onWindBtnClick);
            attach(windBtn);

            Button * moveCntBtn = new Button("moveCnt");
            moveCntBtn->setText("Move Container");
            moveCntBtn->setFont("system_15_fnt");
            moveCntBtn->setRect(0, 192, 256, 64);
            moveCntBtn->setTextAlignment("CENTER|MIDDLE");
            moveCntBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            moveCntBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onMoveCntBtnClick);
            moveCntBtn->setColour("white");
            attach(moveCntBtn);
            
            Button * resizeBtn = new Button();
            resizeBtn->setText("Increase Label");
            resizeBtn->setFont("system_15_fnt");
            resizeBtn->setRect(0, 256, 256, 64);
            resizeBtn->setTextAlignment("CENTER|MIDDLE");
            resizeBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            resizeBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onResizeBtnUpClick);
            resizeBtn->setColour("white");
            attach(resizeBtn);

            resizeBtn = new Button();
            resizeBtn->setText("Decrease Label");
            resizeBtn->setFont("system_15_fnt");
            resizeBtn->setRect(0, 320, 256, 64);
            resizeBtn->setTextAlignment("CENTER|MIDDLE");
            resizeBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            resizeBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onResizeBtnDownClick);
            resizeBtn->setColour("white");
            attach(resizeBtn);

            Image * img = new Image();
            img->setRect(0, 0, 100, 100);
            img->setSprite("round_btn_spr");
            img->setAlignment("RIGHT|TOP", 0, 0);
            img->setAngle(0);
            img->setFlip(true, true);
            attach(img);

            m_multilineLbl = new Label("multilineLbl");
            m_multilineLbl->setRect(0, 0, 300, 20);
            m_multilineLbl->setAlignment("CENTER|TOP", 0, 50);
            m_multilineLbl->setText("Very long text for this label that should be rendered on several lines");
            m_multilineLbl->setWrap(true);
            m_multilineLbl->setFont("system_15_fnt");
            m_multilineLbl->setColour("white");
            attach(m_multilineLbl);

            m_exitLbl = new Label("exitLbl");
            m_exitLbl->setRect(0, 0, 100, 100);
            m_exitLbl->setAlignment("RIGHT|TOP", 0, 100);
            m_exitLbl->setText("exit_lbl");
            m_exitLbl->setFont("system_24_fnt");
            m_exitLbl->setColour("green");
            attach(m_exitLbl);

            m_pb1 = new ProgressBar("pb1");
            m_pb1->setRect(656, 620, 100, 20);
            m_pb1->setSprite("progressbar_spr");
            m_pb1->setCurrentValue(0);
            m_pb1->setMaxValue(100);
            m_pb1->setFillSpeed(100);
            m_pb1->setVertical(false);
            attach(m_pb1);

            m_pb2 = new ProgressBar("pb2");
            m_pb2->setRect(626, 620, 20, 100);
            m_pb2->setSprite("progressbar_spr");
            m_pb2->setCurrentValue(100);
            m_pb2->setMaxValue(100);
            m_pb2->setFillSpeed(100);
            m_pb2->setVertical(true);
            attach(m_pb2);

            TextEdit * textEdit = new TextEdit("textEdit");
            textEdit->setRect(400, 228, 300, 100);
            textEdit->setText("Click to enter the text");
            textEdit->setColour("blue");
            textEdit->setFont("system_24_fnt");
            textEdit->addCallback("TextEdited", this, &TestWidgetsScreen::onTextEdited);
            attach(textEdit);

            m_widgetCnt = new Container("widgetCnt");
            m_widgetCnt->setRect(500, 328, 0, 0);
            attach(m_widgetCnt);

            Label * cntLbl = new Label("cntLbl");
            cntLbl->setRect(500, 328, 100, 100);
            cntLbl->setText("Label in Container");
            cntLbl->setColour("white");
            cntLbl->setFont("system_24_fnt");
            cntLbl->setOrder(999);
            m_widgetCnt->attach(cntLbl);

            Button * cntBtn = new Button("cntBtn");
            cntBtn->setText("Button in Container");
            cntBtn->setFont("system_15_fnt");
            cntBtn->setRect(600, 428, 256, 64);
            cntBtn->setTextAlignment("CENTER|MIDDLE");
            cntBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
            cntBtn->setColour("white");
            cntBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onBtnInCntClick); 
            m_widgetCnt->attach(cntBtn);

            m_scrollCnt = new ScrollContainer("scrollCnt");
            m_scrollCnt->setAlignment("RIGHT|TOP", -160, 60);
            m_scrollCnt->setRect(0, 0, 100, 100);
            m_scrollCnt->setScrollSpeed(500);
            m_scrollCnt->setContentRect(0, 0, 100, 200);
            attach(m_scrollCnt);

            Image * img1 = new Image();
            img1->setRect(0, 0, 100, 100);
            img1->setSprite("round_btn_spr");
            m_scrollCnt->attach(img1);

            Image * img2 = new Image();
            img2->setRect(0, 100, 100, 100);
            img2->setSprite("round_btn_spr");
            m_scrollCnt->attach(img2);

            Image * upImg = new Image();
            upImg->setRect(0, 0, 100, 20);
            upImg->setAlignment("RIGHT|TOP", -160, 20);
            upImg->setSprite("up_btn_spr");
            attach(upImg);

            Area * scrollUpArea = new Area("scrollUpArea");
            scrollUpArea->setRect(0, 0, 100, 20);
            scrollUpArea->setAlignment("RIGHT|TOP", -160, 20);
            scrollUpArea->addCallback("MouseOver", this, &TestWidgetsScreen::scrollUpOn);
            scrollUpArea->addCallback("MouseLeft", this, &TestWidgetsScreen::scrollUpOff);
            attach(scrollUpArea);

            Image * downImg = new Image();
            downImg->setRect(0, 0, 100, 20);
            downImg->setAlignment("RIGHT|TOP", -160, 180);
            downImg->setSprite("up_btn_spr");
            attach(downImg);

            Area * scrollDownArea = new Area("scrollDownArea");
            scrollDownArea->setRect(0, 0, 100, 20);
            scrollDownArea->setAlignment("RIGHT|TOP", -160, 180);
            scrollDownArea->addCallback("MouseOver", this, &TestWidgetsScreen::scrollDownOn);
            scrollDownArea->addCallback("MouseLeft", this, &TestWidgetsScreen::scrollDownOff);
            attach(scrollDownArea);

            m_testDlg= new TestDialog();
            attach(m_testDlg);
        }

        virtual ~TestWidgetsScreen()
        {
        }

        void onBackBtnClick(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("MainScreen");
            Engine::executeCommand(command);
        }

        void onLockBtnClick(Widget * sender)
        {
            if (m_exitLbl)
            {
                m_exitLbl->view(!m_exitLbl->isOpened());
            }
        }

        void onWindBtnClick(Widget * sender)
        {
            if (m_pb1)
            {
                const int value = m_pb1->getCurrentValue();
                if (0 == value || 100 == value)
                {
                    m_pb1->windTo(0 == value ? 100 : 0);
                }
            }

            if (m_pb2)
            {
                const int value = m_pb2->getCurrentValue();
                if (0 == value || 100 == value)
                {
                    m_pb2->windTo(0 == value ? 100 : 0);
                }
            }
        }
        
        void onMoveCntBtnClick(Widget * sender)
        {
            if (m_widgetCnt)
            {
                m_widgetCnt->moveTo(600, 328);
            }
        }

        void onResizeBtnUpClick(Widget * sender)
        {
            if (m_multilineLbl)
            {
                Rect rect = m_multilineLbl->getRect();
                rect.setWidth(rect.getWidth() + m_resizeValue);
                m_multilineLbl->setRect(rect);
            }

        }
        
        void onResizeBtnDownClick(Widget * sender)
        {
            if (m_multilineLbl)
            {
                Rect rect = m_multilineLbl->getRect();
                rect.setWidth(rect.getWidth() - m_resizeValue);
                m_multilineLbl->setRect(rect);
            }

        }

        void onBtnInCntClick(Widget * sender)
        {
            if (m_testDlg)
            {
                m_testDlg->view(!m_testDlg->isOpened());
            }
        }

        void scrollUpOn(Widget * sender)
        {
            if (m_scrollCnt)
            {
                m_scrollCnt->scrollTo(ScrollContainer::Up, true);
            }
        }

        void scrollUpOff(Widget * sender)
        {
            if (m_scrollCnt)
            {
                m_scrollCnt->scrollTo(ScrollContainer::Up, false);
            }
        }

        void scrollDownOn(Widget * sender)
        {
            if (m_scrollCnt)
            {
                m_scrollCnt->scrollTo(ScrollContainer::Down, true);
            }
        }

        void scrollDownOff(Widget * sender)
        {
            if (m_scrollCnt)
            {
                m_scrollCnt->scrollTo(ScrollContainer::Down, false);
            }
        }

        void onTextEdited(Widget * sender)
        {
            // local self = params[1]
            // local edit = params[2]
            // log(edit:getText())
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
            SystemTools * systemTools = new SystemTools("systemTools");
            attach(systemTools);

            const int screenWidth = Engine::getScreenWidth();
            const int screenHeight = Engine::getScreenHeight();

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
            Engine::executeCommand(command);
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
            Engine::executeCommand(command);
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
            Engine::executeCommand(command);
        }

        void onMapEditorBtnClicked(Widget * sender)
        {
            EngineCommand command(EngineCommand::Type::SwitchScreen, "LoadingScreen");
            command.setParam2("MapEditorScreen");
            Engine::executeCommand(command);
        }

        void onExitBtnClicked(Widget * sender)
        {
            Engine::shutdown();
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
            else if ("TestWidgetsScreen" == id)
            {
                return new TestWidgetsScreen(id);
            }
            else if ("TestScrollScreen" == id)
            {
                return new TestScrollScreen(id);
            }
            else if ("TestPrimitivesScreen" == id)
            {
                return new TestPrimitivesScreen(id);
            }
            else if ("TestFontScreen" == id)
            {
                return new TestFontScreen(id);
            }
            else if ("TestAtlasScreen" == id)
            {
                return new TestAtlasScreen(id);
            }
            else if ("OptionsScreen" == id)
            {
                return new OptionsScreen(id);
            }

            return nullptr;
        }

        virtual void restart() override
        {
            stren::Logger("green") << "Red Revolt Game restarting...";
            init();

            EngineCommand command(EngineCommand::Type::SwitchScreen, "StartScreen");
            switchScreen(command);
            stren::Logger("green") << "Red Revolt Game restarted.";
         }

        void init()
        {
            Engine::deserialize();
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

