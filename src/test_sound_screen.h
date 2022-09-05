#ifndef TEST_SOUND_SCREEN_H
#define TEST_SOUND_SCREEN_H

#include "stren.h"

namespace redrevolt
{
class TestSoundScreen : public stren::Screen
{
public:
    TestSoundScreen(const std::string & id = stren::String::kEmpty);

    virtual ~TestSoundScreen();
private:
    void onBackBtnClick(stren::Widget * sender);

    void onPlayMusicBtnClick(stren::Widget * sender);

    void onStopMusicBtnClick(stren::Widget * sender);

    void onPlaySoundBtnClick(stren::Widget * sender);

    void onPlayDoubleSoundBtnClick(stren::Widget * sender);
};
} // redrevolt
#endif // TEST_SOUND_SCREEN_H
