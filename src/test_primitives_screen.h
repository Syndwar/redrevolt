#ifndef TEST_PRIMITIVES_SCREEN
#define TEST_PRIMITIVES_SCREEN

#include "stren.h"

namespace redrevolt
{
class TestPrimitivesScreen : public stren::Screen
{
public:
    TestPrimitivesScreen(const std::string & id = stren::String::kEmpty);

    virtual ~TestPrimitivesScreen();

    void onBackBtnClick(stren::Widget * sender);
};
} // redrevolt
#endif // TEST_PRIMITIVES_SCREEN
