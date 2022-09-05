#ifndef LOADING_SCREEN_H
#define LOADING_SCREEN_H
#include "stren.h"

namespace redrevolt
{
    class LoadingScreen : public stren::Screen
    {
    private:
        std::string m_nextScreenId;
    public:
        LoadingScreen(const std::string & id = stren::String::kEmpty, const std::string & nextId = stren::String::kEmpty);

        virtual ~LoadingScreen();

        void onTimerElapsed(stren::Widget * sender);
    };
 
} // redrevolt
#endif LOADING_SCREEN_H
