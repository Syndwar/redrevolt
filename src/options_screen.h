#ifndef OPTIONS_SCREEN_H
#define OPTIONS_SCREEN_H

#include "stren.h"

namespace redrevolt
{
    class OptionsScreen : public stren::Screen
    {
    private:
        stren::Button * m_vsyncBtn;
        stren::Button * m_borderlessBtn;
        stren::Button * m_fullscreenBtn;
        bool m_isVSync;
        bool m_isBorderless;
        bool m_isFullscreen;
        int m_resIndex;
        std::vector<stren::Button *> m_resButtons;
   public:
        OptionsScreen(const std::string & id = stren::String::kEmpty);

        virtual ~OptionsScreen();

        void onBackBtnClick(stren::Widget * sender);

        void onApplyBtnClick(stren::Widget * sender);

        void onVSyncBtnClick(stren::Widget * sender);

        void onBorderlessBtnClick(stren::Widget * sender);

        void onFullscreenBtnClick(stren::Widget * sender);
        
        void onResolutionBtnClick(stren::Widget * sender);
    };
} // redrevolt
#endif
