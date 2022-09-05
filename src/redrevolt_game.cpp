#include "redrevolt_game.h"
#include "screens.h"

namespace redrevolt
{
    RedRevoltGame::RedRevoltGame()
        : stren::Game()
    {
        stren::Logger("green") << "Red Revolt Game creating...";
        init();
        stren::Logger("green") << "Red Revolt Game created.";
    }

    void RedRevoltGame::start()
    {
        stren::SwitchScreenCommand command;
        command.setScreen("StartScreen");
        command.execute();
    }

    RedRevoltGame::~RedRevoltGame()
    {
    }

    stren::Screen * RedRevoltGame::createScreen(const stren::SwitchScreenCommand * command)
    {
        const std::string & id = command->getScreen();
        stren::Logger("red") << id;
        if ("LoadingScreen" == id)
        {
            const std::string & nextId = command->getNextScreen();
            return new LoadingScreen(id, nextId);
        }
        else if ("MainScreen" == id)
        {
            return new MainScreen(id);
        }
        else if ("StartScreen" == id)
        {
            return new StartScreen(id);
        }
        else if ("TestScreen" == id)
        {
            return new TestScreen(id);
        }
        else if ("OptionsScreen" == id)
        {
            return new OptionsScreen(id);
        }
        else if ("MapEditorScreen" == id)
        {
            return new MapEditorScreen(id);
        }
        else if ("TestSoundScreen" == id)
        {
            return new TestSoundScreen(id);
        }
        else if ("TestFaderScreen" == id)
        {
            return new TestFaderScreen(id);
        }
        else if ("TestWidgetsScreen" == id)
        {
            return new TestWidgetsScreen(id);
        }
        else if ("TestScrollScreen" == id)
        {
            return new TestScrollScreen(id);
        }
        else if ("TestPrimitivesScreen" == id)
        {
            return new TestPrimitivesScreen(id);
        }
        else if ("TestFontScreen" == id)
        {
            return new TestFontScreen(id);
        }
        else if ("TestAtlasScreen" == id)
        {
            return new TestAtlasScreen(id);
        }
        else if ("TestBattlefieldScreen" == id)
        {
            return new TestBattlefieldScreen(id);
        }

        return nullptr;
    }

    void RedRevoltGame::restart()
    {
        stren::Logger("green") << "Red Revolt Game restarting...";
        init();

        stren::SwitchScreenCommand command;
        command.setScreen("StartScreen");
        command.execute();
        stren::Logger("green") << "Red Revolt Game restarted.";
    }

    void RedRevoltGame::init()
    {
        stren::Engine::deserialize();
    }
} // redrevolt
