#include "redrevolt_game.h"

int main(int argc, char * args[])
{
    stren::Stren engine; // create first
    redrevolt::RedRevoltGame * game = new redrevolt::RedRevoltGame();
    engine.setGame(game);
    engine.run();
    if (game)
    {
        delete game;
        game = nullptr;
    }
    return 0;
}

