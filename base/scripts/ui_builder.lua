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
    local lbl = nil
    if (data) then
        lbl = Label(data.id or "")
        __tuneWidget(lbl, data)

        lbl:setText(data.text or "")
        lbl:setFont(data.font or "")

        if (data.text_align) then
            lbl:setTextAlignment(data.text_align)
        end
        if (data.colour) then
            lbl:setColour(data.colour)
        end
    end
    return lbl
end

local function __createImage(data)
    local img = nil
    if (data) then
        img = Image(data.id or "")
        __tuneWidget(img, data)

        if (data.sprite) then
            img:setSprite(data.sprite or "")
        end
    end
    return img
end

local function __createButton(data)
    local btn = nil
    if (data) then
        btn = Button(data.id or "")
        __tuneWidget(btn, data)

        btn:setText(data.text or "")
        btn:setFont(data.font or "")

        if (data.text_align) then
            btn:setTextAlignment(data.text_align)
        end
        if (data.sprites) then
            btn:setSprites(unpack(data.sprites))
        end
        if (data.callback) then
            btn:addCallback(unpack(data.callback))
        end
        if (data.colour) then
            btn:setColour(data.colour)
        end
    end
    return btn
end

UIBuilder._build_tools = {
    ["Button"] = __createButton,
    ["Image"] = __createImage,
    ["Label"] = __createLabel,
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

