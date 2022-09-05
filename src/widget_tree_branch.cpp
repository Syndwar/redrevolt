#include "widget_tree_branch.h"

#include "widgets_tree.h"

namespace redrevolt
{
const int WidgetTreeBranch::lineHeight = 32;

WidgetTreeBranch::WidgetTreeBranch(Widget * parent, Widget * widget, const bool hasChildren, const int level)
    : stren::Container(stren::String::kEmpty)
    , m_parent(parent)
    , m_isExpanded(false)
    , m_hasChildren(hasChildren)
    , m_level(level)
    , m_widget(widget)
    , m_expandBtn(nullptr)
    , m_nameBtn(nullptr)
{
    if (!widget) return;

    const std::string & widgetId = widget->getId();
    const bool isOpened = widget->isOpened();

    m_expandBtn = new stren::Button();
    m_expandBtn->setText(m_hasChildren ? (m_isExpanded ? "-" : "+") : " ");
    m_expandBtn->setRect(0, 0, 32, lineHeight);
    m_expandBtn->setFont("system_15_fnt");
    m_expandBtn->setTextAlignment("CENTER|MIDDLE");
    if (m_hasChildren)
    {
        m_expandBtn->addCallback("MouseUp_Left", this, &WidgetTreeBranch::onExpandBranchClick);
    }
    attach(m_expandBtn);

    m_nameBtn = new stren::Button();
    m_nameBtn->setRect(32, 0, 200, lineHeight);
    m_nameBtn->setFont("system_15_fnt");
    m_nameBtn->setTextAlignment("LEFT|MIDDLE");
    m_nameBtn->addCallback("MouseUp_Left", this, &WidgetTreeBranch::onEnableWidgetClick);
    m_nameBtn->setColour(isOpened ? "white" : "grey");
    m_nameBtn->setText("" != widgetId ? widgetId : "[empty]");
    attach(m_nameBtn);

    instantView(false);
}

WidgetTreeBranch::~WidgetTreeBranch()
{
}

void WidgetTreeBranch::expand()
{
    if (m_hasChildren)
    {
        m_isExpanded = !m_isExpanded;
        m_expandBtn->setText(m_isExpanded ? "-" : "+");
    }
}

void WidgetTreeBranch::onEnableWidgetClick(Widget * sender)
{
    m_widget->instantView(!m_widget->isOpened());
    m_nameBtn->setColour(m_widget->isOpened() ? "white" : "grey");
}

void WidgetTreeBranch::onExpandBranchClick(Widget * sender)
{
    expand();
    if (m_parent)
    {
        WidgetsTree * tree = dynamic_cast<WidgetsTree *>(m_parent);
        if (tree)
        {
            tree->update();
        }
    }
}
} // redrevolt

