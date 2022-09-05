#include "test_dialog.h"

namespace redrevolt
{
TestDialog::TestDialog(const std::string & id)
    : stren::Dialog(id)
{
    stren::Transform openTransform;
    openTransform.add(0, 100, 1000);
    openTransform.add(100, 255, 1000);
    attachTransform("WidgetOpening", openTransform);

    stren::Transform closeTransform;
    closeTransform.add(255, 0, 3000);
    attachTransform("WidgetClosing", closeTransform);

    setRect(0, 0, 400, 400);
    setAlignment("CENTER|MIDDLE", 0, 0);

    stren::Image * backImg = new stren::Image();
    backImg->setRect(0, 0, 400, 400);
    backImg->setSprite("up_btn_spr");
    attach(backImg);

    stren::Label * lbl = new stren::Label();
    lbl->setRect(100, 180, 200, 40);
    lbl->setText("Hello");
    lbl->setFont("system_24_fnt");
    lbl->setColour("green");
    lbl->setTextAlignment("CENTER|MIDDLE");
    attach(lbl);
}

TestDialog::~TestDialog()
{
}
} // redrevolt
