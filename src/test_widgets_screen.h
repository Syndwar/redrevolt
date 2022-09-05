#ifndef TEST_WIDGETS_SCREEN_H
#define TEST_WIDGETS_SCREEN_H

#include "stren.h"

namespace redrevolt
{
    class TestWidgetsScreen : public stren::Screen
    {
    private:

        int m_resizeValue;
        stren::Dialog * m_testDlg;
        stren::Label * m_exitLbl;
        stren::Label * m_multilineLbl;
        stren::ProgressBar * m_pb1;
        stren::ProgressBar * m_pb2;
        stren::ScrollContainer * m_scrollCnt;
        stren::Container * m_widgetCnt;
    public:
        TestWidgetsScreen(const std::string & id = stren::String::kEmpty);

        virtual ~TestWidgetsScreen();

        void onBackBtnClick(stren::Widget * sender);

        void onLockBtnClick(stren::Widget * sender);

        void onWindBtnClick(stren::Widget * sender);
        
        void onMoveCntBtnClick(stren::Widget * sender);

        void onResizeBtnUpClick(stren::Widget * sender);
        
        void onResizeBtnDownClick(stren::Widget * sender);

        void onBtnInCntClick(stren::Widget * sender);

        void scrollUpOn(stren::Widget * sender);

        void scrollUpOff(stren::Widget * sender);

        void scrollDownOn(stren::Widget * sender);

        void scrollDownOff(stren::Widget * sender);

        void onTextEdited(stren::Widget * sender);

    };
} // redrevolt
#endif // TEST_WIDGETS_SCREEN_H
