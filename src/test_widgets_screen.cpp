#include "test_widgets_screen.h"

#include "system_tools.h"
#include "test_dialog.h"

namespace redrevolt
{
TestWidgetsScreen::TestWidgetsScreen(const std::string & id)
    : stren::Screen(id)
    , m_resizeValue(10)
    , m_testDlg(nullptr)
    , m_exitLbl(nullptr)
    , m_multilineLbl(nullptr)
    , m_pb1(nullptr)
    , m_pb2(nullptr)
    , m_scrollCnt(nullptr)
    , m_widgetCnt(nullptr)
{
    SystemTools * systemTools = new SystemTools("systemTools");
    attach(systemTools);

    stren::Button * backBtn = new stren::Button("backBtn");
    backBtn->setText("Exit");
    backBtn->setFont("system_15_fnt");
    backBtn->setColour("red");
    backBtn->setRect(0, 0, 256, 64);
    backBtn->setTextAlignment("CENTER|MIDDLE");
    backBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    backBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onBackBtnClick);
    attach(backBtn);

    stren::Button * lockBtn = new stren::Button("lockBtn");
    lockBtn->setText("View Label");
    lockBtn->setFont("system_15_fnt");
    lockBtn->setRect(0, 64, 256, 64);
    lockBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    lockBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onLockBtnClick);
    attach(lockBtn);

    stren::Button * windBtn = new stren::Button("windBtn");
    windBtn->setText("Wind Progressbar");
    windBtn->setFont("system_15_fnt");
    windBtn->setColour("yellow");
    windBtn->setRect(0, 128, 256, 64);
    windBtn->setTextAlignment("CENTER|MIDDLE");
    windBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    windBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onWindBtnClick);
    attach(windBtn);

    stren::Button * moveCntBtn = new stren::Button("moveCnt");
    moveCntBtn->setText("Move Container");
    moveCntBtn->setFont("system_15_fnt");
    moveCntBtn->setRect(0, 192, 256, 64);
    moveCntBtn->setTextAlignment("CENTER|MIDDLE");
    moveCntBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    moveCntBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onMoveCntBtnClick);
    moveCntBtn->setColour("white");
    attach(moveCntBtn);
    
    stren::Button * resizeBtn = new stren::Button();
    resizeBtn->setText("Increase Label");
    resizeBtn->setFont("system_15_fnt");
    resizeBtn->setRect(0, 256, 256, 64);
    resizeBtn->setTextAlignment("CENTER|MIDDLE");
    resizeBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    resizeBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onResizeBtnUpClick);
    resizeBtn->setColour("white");
    attach(resizeBtn);

    resizeBtn = new stren::Button();
    resizeBtn->setText("Decrease Label");
    resizeBtn->setFont("system_15_fnt");
    resizeBtn->setRect(0, 320, 256, 64);
    resizeBtn->setTextAlignment("CENTER|MIDDLE");
    resizeBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    resizeBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onResizeBtnDownClick);
    resizeBtn->setColour("white");
    attach(resizeBtn);

    stren::Image * img = new stren::Image();
    img->setRect(0, 0, 100, 100);
    img->setSprite("round_btn_spr");
    img->setAlignment("RIGHT|TOP", 0, 0);
    img->setAngle(0);
    img->setFlip(true, true);
    attach(img);

    m_multilineLbl = new stren::Label("multilineLbl");
    m_multilineLbl->setRect(0, 0, 300, 20);
    m_multilineLbl->setAlignment("CENTER|TOP", 0, 50);
    m_multilineLbl->setText("Very long text for this label that should be rendered on several lines");
    m_multilineLbl->setWrap(true);
    m_multilineLbl->setFont("system_15_fnt");
    m_multilineLbl->setColour("white");
    attach(m_multilineLbl);

    m_exitLbl = new stren::Label("exitLbl");
    m_exitLbl->setRect(0, 0, 100, 100);
    m_exitLbl->setAlignment("RIGHT|TOP", 0, 100);
    m_exitLbl->setText("exit_lbl");
    m_exitLbl->setFont("system_24_fnt");
    m_exitLbl->setColour("green");
    attach(m_exitLbl);

    m_pb1 = new stren::ProgressBar("pb1");
    m_pb1->setRect(656, 620, 100, 20);
    m_pb1->setSprite("progressbar_spr");
    m_pb1->setCurrentValue(0);
    m_pb1->setMaxValue(100);
    m_pb1->setFillSpeed(100);
    m_pb1->setVertical(false);
    attach(m_pb1);

    m_pb2 = new stren::ProgressBar("pb2");
    m_pb2->setRect(626, 620, 20, 100);
    m_pb2->setSprite("progressbar_spr");
    m_pb2->setCurrentValue(100);
    m_pb2->setMaxValue(100);
    m_pb2->setFillSpeed(100);
    m_pb2->setVertical(true);
    attach(m_pb2);

    stren::TextEdit * textEdit = new stren::TextEdit("textEdit");
    textEdit->setRect(400, 228, 300, 100);
    textEdit->setText("Click to enter the text");
    textEdit->setColour("blue");
    textEdit->setFont("system_24_fnt");
    textEdit->addCallback("TextEdited", this, &TestWidgetsScreen::onTextEdited);
    attach(textEdit);

    m_widgetCnt = new stren::Container("widgetCnt");
    m_widgetCnt->setRect(500, 328, 0, 0);
    attach(m_widgetCnt);

    stren::Label * cntLbl = new stren::Label("cntLbl");
    cntLbl->setRect(500, 328, 100, 100);
    cntLbl->setText("Label in Container");
    cntLbl->setColour("white");
    cntLbl->setFont("system_24_fnt");
    cntLbl->setOrder(999);
    m_widgetCnt->attach(cntLbl);

    stren::Button * cntBtn = new stren::Button("cntBtn");
    cntBtn->setText("Button in Container");
    cntBtn->setFont("system_15_fnt");
    cntBtn->setRect(600, 428, 256, 64);
    cntBtn->setTextAlignment("CENTER|MIDDLE");
    cntBtn->setSprites("up_btn_spr", "down_btn_spr", "over_btn_spr");
    cntBtn->setColour("white");
    cntBtn->addCallback("MouseUp_Left", this, &TestWidgetsScreen::onBtnInCntClick); 
    m_widgetCnt->attach(cntBtn);

    m_scrollCnt = new stren::ScrollContainer("scrollCnt");
    m_scrollCnt->setAlignment("RIGHT|TOP", -160, 60);
    m_scrollCnt->setRect(0, 0, 100, 100);
    m_scrollCnt->setScrollSpeed(500);
    m_scrollCnt->setContentRect(0, 0, 100, 200);
    attach(m_scrollCnt);

    stren::Image * img1 = new stren::Image();
    img1->setRect(0, 0, 100, 100);
    img1->setSprite("round_btn_spr");
    m_scrollCnt->attach(img1);

    stren::Image * img2 = new stren::Image();
    img2->setRect(0, 100, 100, 100);
    img2->setSprite("round_btn_spr");
    m_scrollCnt->attach(img2);

    stren::Image * upImg = new stren::Image();
    upImg->setRect(0, 0, 100, 20);
    upImg->setAlignment("RIGHT|TOP", -160, 20);
    upImg->setSprite("up_btn_spr");
    attach(upImg);

    stren::Area * scrollUpArea = new stren::Area("scrollUpArea");
    scrollUpArea->setRect(0, 0, 100, 20);
    scrollUpArea->setAlignment("RIGHT|TOP", -160, 20);
    scrollUpArea->addCallback("MouseOver", this, &TestWidgetsScreen::scrollUpOn);
    scrollUpArea->addCallback("MouseLeft", this, &TestWidgetsScreen::scrollUpOff);
    attach(scrollUpArea);

    stren::Image * downImg = new stren::Image();
    downImg->setRect(0, 0, 100, 20);
    downImg->setAlignment("RIGHT|TOP", -160, 180);
    downImg->setSprite("up_btn_spr");
    attach(downImg);

    stren::Area * scrollDownArea = new stren::Area("scrollDownArea");
    scrollDownArea->setRect(0, 0, 100, 20);
    scrollDownArea->setAlignment("RIGHT|TOP", -160, 180);
    scrollDownArea->addCallback("MouseOver", this, &TestWidgetsScreen::scrollDownOn);
    scrollDownArea->addCallback("MouseLeft", this, &TestWidgetsScreen::scrollDownOff);
    attach(scrollDownArea);

    m_testDlg= new TestDialog();
    attach(m_testDlg);
}

TestWidgetsScreen::~TestWidgetsScreen()
{
}

void TestWidgetsScreen::onBackBtnClick(Widget * sender)
{
    stren::SwitchScreenCommand command;
    command.setScreen("LoadingScreen");
    command.setNextScreen("MainScreen");
    command.execute();
 }

void TestWidgetsScreen::onLockBtnClick(Widget * sender)
{
    if (m_exitLbl)
    {
        m_exitLbl->view(!m_exitLbl->isOpened());
    }
}

void TestWidgetsScreen::onWindBtnClick(Widget * sender)
{
    if (m_pb1)
    {
        const int value = m_pb1->getCurrentValue();
        if (0 == value || 100 == value)
        {
            m_pb1->windTo(0 == value ? 100 : 0);
        }
    }

    if (m_pb2)
    {
        const int value = m_pb2->getCurrentValue();
        if (0 == value || 100 == value)
        {
            m_pb2->windTo(0 == value ? 100 : 0);
        }
    }
}

void TestWidgetsScreen::onMoveCntBtnClick(Widget * sender)
{
    if (m_widgetCnt)
    {
        m_widgetCnt->moveTo(600, 328);
    }
}

void TestWidgetsScreen::onResizeBtnUpClick(Widget * sender)
{
    if (m_multilineLbl)
    {
        stren::Rect rect = m_multilineLbl->getRect();
        rect.setWidth(rect.getWidth() + m_resizeValue);
        m_multilineLbl->setRect(rect);
    }

}

void TestWidgetsScreen::onResizeBtnDownClick(Widget * sender)
{
    if (m_multilineLbl)
    {
        stren::Rect rect = m_multilineLbl->getRect();
        rect.setWidth(rect.getWidth() - m_resizeValue);
        m_multilineLbl->setRect(rect);
    }

}

void TestWidgetsScreen::onBtnInCntClick(Widget * sender)
{
    if (m_testDlg)
    {
        m_testDlg->view(!m_testDlg->isOpened());
    }
}

void TestWidgetsScreen::scrollUpOn(Widget * sender)
{
    if (m_scrollCnt)
    {
        m_scrollCnt->scrollTo(stren::ScrollContainer::Up, true);
    }
}

void TestWidgetsScreen::scrollUpOff(Widget * sender)
{
    if (m_scrollCnt)
    {
        m_scrollCnt->scrollTo(stren::ScrollContainer::Up, false);
    }
}

void TestWidgetsScreen::scrollDownOn(Widget * sender)
{
    if (m_scrollCnt)
    {
        m_scrollCnt->scrollTo(stren::ScrollContainer::Down, true);
    }
}

void TestWidgetsScreen::scrollDownOff(Widget * sender)
{
    if (m_scrollCnt)
    {
        m_scrollCnt->scrollTo(stren::ScrollContainer::Down, false);
    }
}

void TestWidgetsScreen::onTextEdited(Widget * sender)
{
    // local self = params[1]
    // local edit = params[2]
    // log(edit:getText())
}
} // redrevolt
