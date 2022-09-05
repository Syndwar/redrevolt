#ifndef REDREVOLT_GAME_H
#define REDREVOLT_GAME_H
#include "stren.h"

namespace redrevolt
{
    class RedRevoltGame : public stren::Game
    {
    public:
        RedRevoltGame();

        virtual void start() override;

        virtual ~RedRevoltGame();

        virtual stren::Screen * createScreen(const stren::SwitchScreenCommand * command) override;

        virtual void restart() override;

        void init();
    };
} // redrevolt

#endif REDREVOLT_GAME_H
