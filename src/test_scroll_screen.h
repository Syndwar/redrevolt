#ifndef TEST_SCROLL_SCREEN_H
#define TEST_SCROLL_SCREEN_H

#include "stren.h"

namespace redrevolt
{
class TestScrollScreen : public stren::Screen
{
private:
    int m_fieldWidth;
    int m_fieldHeight;
    int m_tileWidth;
    int m_tileHeight;
    std::string m_tileSpr;
    stren::ScrollContainer * m_scrollCnt;
public:
    TestScrollScreen(const std::string & id = stren::String::kEmpty);

    virtual ~TestScrollScreen();

    void scrollTo(const int direction, const bool value);

    void scrollUpOn();

    void scrollUpOff();

    void scrollLeftOn();

    void scrollLeftOff();

    void scrollRightOn();

    void scrollRightOff();

    void scrollDownOn();

    void scrollDownOff();

    void onBackBtnClick(stren::Widget * sender);

    void onJumpBtnClick(stren::Widget * sender);

    void onScrollBtnClick(stren::Widget * sender);

    void addScrollContent();
};
} // redrevolt
#endif
