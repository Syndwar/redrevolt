#ifndef TEST_FADER_SCREEN_H
#define TEST_FADER_SCREEN_H

#include "stren.h"

namespace redrevolt
{
class TestFaderScreen : public stren::Screen
    {
    private:
        int m_fadeSpeed;
        stren::Fader * m_fader;
        stren::Label * m_fadeSpeedLbl;

    public:
        TestFaderScreen(const std::string & id = stren::String::kEmpty);

        virtual ~TestFaderScreen();

        void onBackBtnClick(stren::Widget * sender);

        void onFadeInBtnClick(stren::Widget * sender);

        void onFadeOutBtnClick(stren::Widget * sender);

        void onFadeSpeedUpBtnClick(stren::Widget * sender);

        void onFadeSpeedDownBtnClick(stren::Widget * sender);
    };
} // redrevolt
#endif // TEST_FADER_SCREEN_H

