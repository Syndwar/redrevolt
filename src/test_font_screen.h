#ifndef TEST_FONT_SCREEN_H
#define TEST_FONT_SCREEN_H

#include "stren.h"

namespace redrevolt
{
class TestFontScreen : public stren::Screen
{
private:
    size_t m_index;
    stren::Image * m_fontImg;
public:
    TestFontScreen(const std::string & id = stren::String::kEmpty);

    virtual ~TestFontScreen();

    void onBackBtnClick(stren::Widget * sender);
    
    void onChangeFontBtnClick(stren::Widget * sender);

    void log(const char * msg);
};
} // redrevolt
#endif // TEST_FONT_SCREEN_H
