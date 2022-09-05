#include "widgets_tree.h"

#include "widget_tree_branch.h"

namespace redrevolt
{
WidgetsTree::WidgetsTree(const std::string & id)
    : stren::ScrollContainer(id)
    , m_level(0)
{
    addCallback("WidgetOpened", this, &WidgetsTree::onOpening);

    const int screenWidth = stren::Engine::getScreenWidth();
    const int screenHeight = stren::Engine::getScreenHeight();
    setRect(0, 0, screenWidth, screenHeight);

    instantView(false);
}

WidgetsTree::~WidgetsTree()
{
    m_branches.clear();
}

void WidgetsTree::onOpening(Widget * sender)
{
    reset();
    update();
}

void WidgetsTree::reset()
{
    m_branches.clear();
    m_level = 0;
    clean();
    stren::Screen * screen = stren::Engine::getCurrentScreen(); 
    createBranch(screen);
}

void WidgetsTree::createBranch(Widget * parent)
{
    if (!parent) return;

    stren::Container * parentCnt = dynamic_cast<stren::Container *>(parent);
    if (!parentCnt) return;

    std::list<Widget *> attached = parentCnt->debugGetAttached();
    for (Widget * w : attached)
    {
        const std::string & id = w->getId();
        if ("systemTools" != id)
        {
            stren::Container * cnt = dynamic_cast<stren::Container *>(w);
            bool hasChildren(false);
            if (cnt)
            {
                std::list<Widget *> children = cnt->debugGetAttached();
                hasChildren = !children.empty();
            }
            WidgetTreeBranch * branch = new WidgetTreeBranch(this, w, hasChildren, m_level);
            attach(branch);

            m_branches.push_back(branch);

            if (hasChildren)
            {
                m_level += 1;
                createBranch(cnt);
                m_level -= 1;
            }
        }
    }
}

void WidgetsTree::update()
{
    int visibleBranchCounter(0);
    int lockLevel(0);

    for (WidgetTreeBranch * branch : m_branches)
    {
        if (!branch) continue;
        // close all branches
        branch->instantView(false);
        const int branchLevel = branch->getLevel();
        const bool isVisible = branchLevel <= lockLevel;
        if (isVisible)
        {
            lockLevel = branchLevel;
        }
        const bool isExpandedContainer = branch->hasChildren() && branch->isExpanded();
        if (isExpandedContainer)
        {
            lockLevel = branchLevel + 1;
        }
        if (isVisible)
        {
            const int newPosX = branchLevel * 32;
            const int newPosY = WidgetTreeBranch::lineHeight * visibleBranchCounter;
            branch->instantView(true);
            branch->moveTo(newPosX, newPosY);
            visibleBranchCounter += 1;
        }
    }
    const int screenWidth = stren::Engine::getScreenWidth();
    setContentRect(0, 0, screenWidth, WidgetTreeBranch::lineHeight * visibleBranchCounter);
}
} // redrevolt
