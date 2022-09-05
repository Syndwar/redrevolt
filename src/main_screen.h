#ifndef MAIN_SCREEN_H
#define MAIN_SCREEN_H

#include "stren.h"

namespace redrevolt
{
    class MainScreen : public stren::Screen
    {
    public:
        MainScreen(const std::string & id = stren::String::kEmpty);

        virtual ~MainScreen();

    private:
        void onTestBtnClicked(stren::Widget * sender);

        void onNewGameBtnClicked(stren::Widget * sender);

        void onLoadGameBtnClicked(stren::Widget * sender);

        void onOptionsBtnClicked(stren::Widget * sender);

        void onMapEditorBtnClicked(stren::Widget * sender);

        void onExitBtnClicked(stren::Widget * sender);
        
        void log(const char * msg);
    };
} // redrevolt
#endif MAIN_SCREEN_H
