require("containers/widget_tree_branch")

class "WidgetTree" (ScrollContainer)

function WidgetTree:init()
    self._branches = {}
    self._level = 0

    self:addCallback("WidgetOpened", self.onOpening, self)

    local screen_width = Engine.getScreenWidth()
    local screen_height = Engine.getScreenHeight()
    self:setRect(0, 0, screen_width, screen_height)

    self:instantView(false)
end

function WidgetTree:onOpening()
    self:reset()
    self:update()
end

function WidgetTree:reset()
    self._level = 0
    self._branches = {}

    self:detachAll()
    local current_screen = UserSave:getCurrentScreen()
    self:createBranch(current_screen)
end

function WidgetTree:update()
    local visible_branches_counter = 0

    local lock_level = 0

    for i, branch in ipairs(self._branches) do
        -- close all branches
        branch:instantView(false)

        local branch_level = branch:getLevel()

        local is_visible = branch_level <= lock_level
        if (is_visible) then
            lock_level = branch_level
        end

        local is_expanded_container = branch:hasChildren() and branch:isExpanded()
        if (is_expanded_container) then
            lock_level = branch_level + 1
        end

        if (is_visible) then
            local new_pos_x = branch_level * 32
            local new_pos_y = WidgetTreeBranch.line_height * visible_branches_counter
            branch:instantView(true)
            branch:moveTo(new_pos_x, new_pos_y)
            visible_branches_counter = visible_branches_counter + 1
        end
    end
    local screen_width = Engine.getScreenWidth()
    self:setContentRect(0, 0, screen_width, WidgetTreeBranch.line_height * visible_branches_counter)
end

function WidgetTree:createBranch(parent)
    local raw_widgets = parent:getAttached()
    for _, raw in ipairs(raw_widgets) do
        local widget = cast(raw, Widget)
        if ("systemTools" ~= widget:getId()) then
            local cnt = cast(raw, Container)
            local children = cnt:getAttached()
            local has_children = 0 ~= #children
            local branch = WidgetTreeBranch("", widget, has_children, self._level)
            self:attach(branch)
            
            table.insert(self._branches, branch)
            
            if (has_children) then
                self._level = self._level + 1
                self:createBranch(widget)
                self._level = self._level - 1
            end
        end
    end
end