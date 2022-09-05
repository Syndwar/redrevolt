#include "test_primitives_screen.h"

#include "system_tools.h"

namespace redrevolt
{
TestPrimitivesScreen::TestPrimitivesScreen(const std::string & id)
    : stren::Screen(id)
{
    SystemTools * systemTools = new SystemTools("systemTools");
    attach(systemTools);

    stren::Button * btn = new stren::Button("backBtn");
    btn->setText("Exit");
    btn->setFont("system_15_fnt");
    btn->setRect(0, 0, 256, 64);
    btn->setTextAlignment("CENTER|MIDDLE");
    btn->setAlignment("RIGHT|TOP", 0, 0);
    btn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    btn->addCallback("MouseUp_Left", this, &TestPrimitivesScreen::onBackBtnClick);
    btn->setColour("red");
    attach(btn);

    stren::Primitive * primitive = new stren::Primitive();
    primitive->setColour("white");
    primitive->createCircle(630, 130, 100);
    attach(primitive);

    primitive = new stren::Primitive();
    primitive->setColour("green");
    primitive->createLines({{0, 0}, {1024, 768}});
    attach(primitive);

    primitive = new stren::Primitive();
    primitive->setColour("red");
    primitive->createLines({{0, 0}, {200, 500}, {1024, 768}});
    attach(primitive);

    primitive = new stren::Primitive();
    primitive->setColour("yellow");
    primitive->createPoint({630, 130});
    attach(primitive);

    primitive = new stren::Primitive();
    primitive->setColour("red");
    primitive->createRect({470, 70, 60, 80}, false);
    attach(primitive);

    primitive = new stren::Primitive();
    primitive->setColour("green");
    primitive->createRect({400, 70, 60, 60}, true);
    attach(primitive);

    primitive = new stren::Primitive();
    primitive->setColour("green");
    primitive->createPoints({{500, 101}, {500, 102}, {500, 103}});
    attach(primitive);

    primitive = new stren::Primitive();
    primitive->setColour("red");
    primitive->createRects({{120, 700, 40, 40}, {100, 650, 80, 80}}, true);
    attach(primitive);
}

TestPrimitivesScreen::~TestPrimitivesScreen()
{
}

void TestPrimitivesScreen::onBackBtnClick(Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("TestScreen");
    command.execute();
}
} // redrevolt
