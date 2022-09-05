#ifndef DEBUG_PANEL_H
#define DEBUG_PANEL_H 

#include "stren.h"

namespace redrevolt
{
class DebugPanel : public stren::Dialog
{
private:
    stren::Label * m_fpsLabel;
    stren::Label * m_mousePosLabel;
    stren::Timer * m_timer;
public:
    DebugPanel(const std::string & id);

    virtual ~DebugPanel();

    void onTimerElapsed(stren::Widget * sender);
};
} // redrevolt
#endif
