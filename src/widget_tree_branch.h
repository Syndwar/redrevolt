#ifndef WIDGET_TREE_BRANCH_H
#define WIDGET_TREE_BRANCH_H

#include "stren.h"

namespace redrevolt
{
class WidgetTreeBranch : public stren::Container
{
public:
    static const int lineHeight;
private:
    bool m_isExpanded;
    bool m_hasChildren;
    int m_level;
    stren::Widget * m_widget;
    stren::Button * m_expandBtn;
    stren::Button * m_nameBtn;
    stren::Widget * m_parent;
public:
    WidgetTreeBranch(stren::Widget * parent, stren::Widget * widget, const bool hasChildren, const int level);

    virtual ~WidgetTreeBranch();

    bool isExpanded() const { return m_isExpanded; }

    bool hasChildren() const { return m_hasChildren; }
    
    int getLevel() const { return m_level; }

    void expand();

    void onExpandBranchClick(stren::Widget * sender);

    void onEnableWidgetClick(stren::Widget * sender);
};
} // redrevolt
#endif // WIDGET_TREE_BRANCH_H
