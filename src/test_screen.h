#ifndef TEST_SCREEN_H
#define TEST_SCREEN_H

#include "stren.h"

namespace redrevolt
{
    class TestScreen : public stren::Screen
    {
    public:
        TestScreen(const std::string & id = stren::String::kEmpty);

        virtual ~TestScreen();

    private:
        void onBackBtnClicked(stren::Widget * sender);

        void toTestPrimitiveScreen(stren::Widget * sender);

        void toTestFaderScreen(stren::Widget * sender);

        void toTestSoundScreen(stren::Widget * sender);

        void toTestWidgetsScreen(stren::Widget * sender);

        void toTestScrollScreen(stren::Widget * sender);

        void toTestFontScreen(stren::Widget * sender);

        void toTestAtlasScreen(stren::Widget * sender);

        void toTestBattlefieldScreen(stren::Widget * sender);
    };
} // redrevolt
#endif // TEST_SCREEN_H
