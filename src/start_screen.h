#ifndef START_SCREEN_H
#define START_SCREEN_H

#include "stren.h"

namespace redrevolt
{
class StartScreen : public stren::Screen
{
public:
    StartScreen(const std::string & id = stren::String::kEmpty);

    virtual ~StartScreen();

    void goToNextScreen(stren::Widget * sender);
};
} // redrevolt
#endif // START_SCREEN_H
