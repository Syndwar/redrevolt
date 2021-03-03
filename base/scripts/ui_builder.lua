UIBuilder = {}

local function __tuneWidget(widget, data)
    if (widget and data) then
        if (data.rect) then
            widget:setRect(unpack(data.rect))
        end
        if (data.alignment) then
            widget:setAlignment(unpack(data.alignment))
        end
    end
end

local function __createLabel(data)
    local widget = nil
    if (data) then
        widget = Label(data.id or "")
        __tuneWidget(widget, data)

        widget:setText(data.text or "")
        widget:setFont(data.font or "")

        if (data.text_align) then
            widget:setTextAlignment(data.text_align)
        end
        if (data.colour) then
            widget:setColour(data.colour)
        end
    end
    return widget
end

local function __createImage(data)
    local widget = nil
    if (data) then
        widget = Image(data.id or "")
        __tuneWidget(widget, data)

        if (data.sprite) then
            widget:setSprite(data.sprite)
        end
        if (data.angle) then
            widget:setAngle(data.angle)
        end
        if (data.center) then
            widget:setCenter(unpack(data.center))
        end
    end
    return widget
end

local function __createButton(data)
    local widget = nil
    if (data) then
        widget = Button(data.id or "")
        __tuneWidget(widget, data)

        widget:setText(data.text or "")
        widget:setFont(data.font or "")

        if (data.text_align) then
            widget:setTextAlignment(data.text_align)
        end
        if (data.sprites) then
            widget:setSprites(unpack(data.sprites))
        end
        if (data.callback) then
            widget:addCallback(unpack(data.callback))
        end
        if (data.colour) then
            widget:setColour(data.colour)
        end
    end
    return widget
end

local function __createTextEdit(data)
    local widget = nil
    if (data) then
        widget = TextEdit(data.id or "")
        __tuneWidget(widget, data)

        widget:setText(data.text or "")
        widget:setFont(data.font or "")

        if (data.text_align) then
            widget:setTextAlignment(data.text_align)
        end
        if (data.colour) then
            widget:setColour(data.colour)
        end
    end
    return widget
end

local function __createScrollContainer(data)
    local widget = nil
    if (data) then
        widget = ScrollContainer(data.id or "")
        widget:setScrollSpeed(data.scroll_speed or 1)
        __tuneWidget(widget, data)
    end
    return widget
end

local function __createArea(data)
    local widget = nil
    if (data) then
        widget = Area(data.id or "")
        __tuneWidget(widget, data)
        if (data.callbacks) then
            for _, callback in ipairs(data.callbacks) do
                widget:addCallback(unpack(callback))
            end
        end
    end
    return widget
end

UIBuilder._build_tools = {
    ["Button"] = __createButton,
    ["Image"] = __createImage,
    ["Label"] = __createLabel,
    ["TextEdit"] = __createTextEdit,
    ["ScrollContainer"] = __createScrollContainer,
    ["Area"] = __createArea,
}

function UIBuilder.create(cnt, desc)
    for _, data in ipairs(desc) do
        local tool = UIBuilder._build_tools[data.widget]
        if (tool) then
            local widget = tool(data)
            if (widget) then
                if (data.ui) then
                    cnt:setUI(data.ui, widget)
                end
                cnt:attach(widget)
            end
        end
    end
end

