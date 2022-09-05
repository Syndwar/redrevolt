#ifndef TEST_ATLAS_SCREEN_H
#define TEST_ATLAS_SCREEN_H

#include "stren.h"

namespace redrevolt
{
    class TestAtlasScreen : public stren::Screen
    {
    public:
        TestAtlasScreen(const std::string & id = stren::String::kEmpty);

        virtual ~TestAtlasScreen();

        void onBackBtnClick(stren::Widget * sender);
    };

} // redrevolt
#endif
