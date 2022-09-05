#ifndef SYSTEM_TOOLS_H
#define SYSTEM_TOOLS_H 

#include "stren.h"

namespace redrevolt
{
class DebugPanel;
class Console;
class WidgetsTree;

class SystemTools : public stren::Container
{
private:
    Console * m_console;
    WidgetsTree * m_widgetsTree;
    DebugPanel * m_debugPanel;

public:
    SystemTools(const std::string & id = stren::String::kEmpty);

    virtual ~SystemTools();

    void viewConsole(stren::Widget * sender);

    void viewSystemInfo(stren::Widget * sender);

    void viewDebugView(stren::Widget * sender);

    void viewWidgetsTree(stren::Widget * sender);

    void log(const char * msg);

    void reset();
};
} // redrevolt
#endif SYSTEM_TOOLS_H 
