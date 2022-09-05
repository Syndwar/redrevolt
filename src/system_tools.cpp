#include "system_tools.h"

#include "debug_panel.h"
#include "console.h"
#include "widgets_tree.h"
namespace redrevolt
{
SystemTools::SystemTools(const std::string & id)
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

SystemTools::~SystemTools()
{
    m_console = nullptr;
    m_widgetsTree = nullptr;
    m_debugPanel = nullptr;
}

void SystemTools::viewConsole(stren::Widget * sender)
{
    if (m_console)
    {
        m_console->view(!m_console->isOpened());
    }
}

void SystemTools::viewSystemInfo(stren::Widget * sender)
{
    if (m_debugPanel)
    {
        m_debugPanel->view(!m_debugPanel->isOpened());
    }
}

void SystemTools::viewDebugView(stren::Widget * sender)
{
    stren::Screen * screen = stren::Engine::getCurrentScreen();
    if  (screen)
    {
        screen->setDebugView(!screen->isDebugView());
    }
}

void SystemTools::viewWidgetsTree(stren::Widget * sender)
{
    if (m_widgetsTree)
    {
        m_widgetsTree->view(!m_widgetsTree->isOpened());
    }
}

void SystemTools::log(const char * msg)
{
    if (m_console)
    {
        m_console->log(msg);
    }
}

void SystemTools::reset()
{
    if (m_widgetsTree)
    {
        m_widgetsTree->instantClose();
    }
}
} // redrevolt
