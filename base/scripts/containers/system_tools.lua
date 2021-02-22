require("containers/debug_panel")
require('containers/console_panel')
require('containers/widget_tree')

class "SystemTools" (Container)

function SystemTools:init()
    self:setOrder(1000)
    
    self:addCallback("KeyDown_Grave", self.viewConsole, self)
    self:addCallback("KeyDown_F1",    self.viewSystemInfo, self)
    self:addCallback("KeyDown_F2",    self.viewDebugView, self)
    self:addCallback("KeyDown_F3",    self.viewWidgetsTree, self)
end

function SystemTools:reset()
    if (self.widgets_tree) then
        self.widgets_tree:instantView(false)
    end
end

function SystemTools:viewConsole()
    if (not self.console) then
        self.console = ConsolePanel()
        self:attach(self.console)
    end
    if (self.console) then
        self.console:view(not self.console:isOpened())
    end
end

function SystemTools:viewSystemInfo()
    if (not self.debug_panel) then
        self.debug_panel = DebugPanel()
        self:attach(self.debug_panel)
    end
    if (self.debug_panel) then
        self.debug_panel:view(not self.debug_panel:isOpened())
    end
end

function SystemTools:viewDebugView()
    local current_screen = UserSave:getCurrentScreen()
    if (current_screen) then
        current_screen:switchDebugView()
    end
end

function SystemTools:viewWidgetsTree()
    if (not self.widgets_tree) then
        self.widgets_tree = WidgetTree()
        self:attach(self.widgets_tree)
    end
    if (self.widgets_tree) then
        self.widgets_tree:view(not self.widgets_tree:isOpened())
    end
end

function SystemTools:log(...)
    if (not self.console) then
        self.console = ConsolePanel()
        self:attach(self.console)
    end
    if (self.console) then
        self.console:log(...)
    end
end