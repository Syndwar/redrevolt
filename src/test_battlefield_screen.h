#ifndef TEST_BATTLEFIELD_SCREEN_H
#define TEST_BATTLEFIELD_SCREEN_H

#include "stren.h"

namespace redrevolt
{
class TestBattlefieldScreen : public stren::Screen
{
public:
    TestBattlefieldScreen(const std::string & id = stren::String::kEmpty);

    virtual ~TestBattlefieldScreen();

    void onBackBtnClick(stren::Widget * sender);
};
} // redrevolt
#endif // TEST_BATTLEFIELD_SCREEN_H
