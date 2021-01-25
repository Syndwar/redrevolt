if (0 == #arg) then return end

local Data = dofile(arg[1])
local files = Data.files
local textureSize = Data.textureSize
local atlasIndex = Data.index
local folder = Data.folder

local magick = "\"c:\\Program Files\\ImageMagick-7.0.8-Q16\\magick.exe\" %s"
local output = "_result/atlas_%s.png"
local spritesOutput = "_result/sprites.lua"
local texturesOutput = "_result/textures.lua"

local function createAtlas(index)
    local param = "convert -size %dx%d xc:transparent %s"
    local command = magick:format(param:format(textureSize[1], textureSize[2], output:format(index)))
    os.execute(command)
end

-- Saves a string to file
local function write_file(filename, value)
    if (value) then
        local file = io.open(filename, "a")
        file:write(value)
        file:close()
    end
end

local function saveSpritesData(tbl)
    local str = ""
    local line = "    {id = \"%s\", texture = \"%s\", rect = {%d, %d, %d, %d}},\n"
    for _, data in ipairs(tbl) do
        local sprite = data.id:gsub(".png", "_spr"):gsub(".jpg", "_spr")
        local texture = data.texture:gsub(".png", "_tex"):gsub(".jpg", "_tex"):gsub("_result/", "")
        local newLine = line:format(sprite, texture, data.rect[1], data.rect[2], data.rect[3], data.rect[4])
        str = str .. newLine
    end

    write_file(spritesOutput, str)
end

local function saveTexturesData(tbl)
    local str = ""
    local line = "{id = \"%s\",  file = \"%s\", alphaBlending = true},\n"
    local cache = {}
    for _, data in ipairs(tbl) do
        local filename = data.texture
        if (not cache[filename]) then
            cache[filename] = true
            local textureId = data.texture:gsub(".png", "_tex"):gsub(".jpg", "_tex"):gsub("_result/", "")
            local newLine = line:format(textureId, filename)
            str = str .. newLine
        end
    end
    write_file(texturesOutput, str)
end

function main()
    print("Started")

    local f = io.open(spritesOutput, "r")
    if (f) then
        f:close()
    else
        os.execute("mkdir _result")
    end
    
    local resourceTbl = {}

    createAtlas(atlasIndex)

    local x = 0 -- placement position x
    local y = 0 -- placement position y
    local height = 0 -- current row height
    local imageWidth = 0 -- current image width
    local imageHeight = 0 -- current image height
    for _, data in ipairs(files) do
        -- 0 works as a command to start from the new line
        if (0 == data) then
            x = 0
            y = y + height
        -- table holds information about below sprites width and height
        elseif ("table" == type(data)) then
            imageWidth = data[1]
            imageHeight = data[2]
        -- string value holds information about image file name
        elseif ("string" == type(data)) then
            print(data)
            -- if image is too big to fit vertically than we start a new line
            if (x + imageWidth > textureSize[1]) then
                x = 0
                y = y + height
            end
            -- if image is too big to fit horizontally than we start a new atlas
            if (y + imageHeight > textureSize[2]) then
                atlasIndex = atlasIndex + 1
                createAtlas(atlasIndex)
                x = 0
                y = 0
                height = 0
            end
            
            -- place image on to the existing atlas
            param = "convert -composite -geometry +%d+%d %s %s %s"
            local target = output:format(atlasIndex)
            local filename = folder .. "/" .. data
            command = magick:format(param:format(x, y, target, filename, target))
            os.execute(command)
            table.insert(resourceTbl, {id = data, texture = target, rect = {x, y, imageWidth, imageHeight}})
            x = x + imageWidth
            -- if image height is higher than previous images heights than remember this value
            if (height < imageHeight) then
                height = imageHeight
            end

        end
    end

    print("Save Res File")

    saveSpritesData(resourceTbl)
    saveTexturesData(resourceTbl)

    print("Done")
end

main()