class "WidgetTreeBranch" (Container)

WidgetTreeBranch.line_height = 32

function WidgetTreeBranch:init(id, widget, has_children, level)
    self._widget = widget
    self._is_expanded = false
    self._has_children = has_children
    self._level = level

    local id = widget:getId()
    local is_opened = widget:isOpened()
    local line_height = WidgetTreeBranch.line_height

    self._expand_btn = Button()
    self._expand_btn:setText(has_children and (self._is_expanded and "-" or "+") or " ")
    self._expand_btn:setRect(0, 0, 32, line_height)
    self._expand_btn:setFont("system_15_fnt")
    self._expand_btn:setTextAlignment("CENTER|MIDDLE")
    if (has_children) then
        self._expand_btn:addCallback("MouseUp_Left", self.onExpandBranchClicked, self)
    end
    self:attach(self._expand_btn)

    self._name_btn = Button()
    self._name_btn:setRect(32, 0, 200, line_height)
    self._name_btn:setFont("system_15_fnt")
    self._name_btn:setTextAlignment("LEFT|MIDDLE")
    self._name_btn:addCallback("MouseUp_Left", self.onEnableWidgetClicked, self)
    self._name_btn:setColour(is_opened and "white" or "grey")
    self._name_btn:setText("" ~= id and id or "[noname]")
    self:attach(self._name_btn)

    self:instantView(false)
end

function WidgetTreeBranch:expand()
    if (self._has_children) then
        self._is_expanded = not self._is_expanded
        self._expand_btn:setText(self._is_expanded and "-" or "+")
    end
end

function WidgetTreeBranch:isExpanded()
    return self._is_expanded
end

function WidgetTreeBranch:hasChildren()
    return self._has_children
end

function WidgetTreeBranch:getLevel()
    return self._level
end

function WidgetTreeBranch:onExpandBranchClicked()
    local system_tools = SystemToolsPanel
    local widgets_tree = system_tools and system_tools.widgets_tree
    if (widgets_tree) then
        self:expand()
        widgets_tree:update()
    end
end

function WidgetTreeBranch:onEnableWidgetClicked()
    self._widget:instantView(not self._widget:isOpened())
    self._name_btn:setColour(self._widget:isOpened() and "white" or "grey")
end