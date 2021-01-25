local STRING_KEY_TEMPLATE = "[\"%s\"]"
local NUMBER_KEY_TEMPLATE = "[%s]"
local VALUE_LINE_TEMPLATE = "%s%s%s = %s\n"
local TABLE_TEMPLATE = "{\n%s%s},"

local function excellarstring(s)
    s = string.format( "%q",s )
    -- to replace
    s = string.gsub( s,"\\\n","\\n" )
    s = string.gsub( s,"\r","\\r" )
    s = string.gsub( s,string.char(26),"\"..string.char(26)..\"" )
    return s
end

function table.spairs(t, order)
    -- t = { "a" = 8, "b" = 10, "c" = 11 }
    -- order = function(t,a,b) return t[b] < t[a] end

    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local __spairs = table.spairs

local __get_tbl_template = function(str, level)
    return string.format(TABLE_TEMPLATE, str, string.rep('\t', level))
end

local function to_txt(str, tbl, level)
    for k, v in __spairs(tbl) do
        local k_type = type(k)
        local v_type = type(v)
        local k_value;
        local s_value;

        if ("string" == k_type) then
            k_value = string.format(STRING_KEY_TEMPLATE, k)
        elseif ("number" == k_type) then
            k_value = string.format(NUMBER_KEY_TEMPLATE, k)
        else
            k_value = tostring(k)
        end

        if ("string" == v_type) then
            s_value = string.format("%s,", excellarstring(v))
        elseif ("table" == v_type) then
            if (not next(v)) then
                s_value = "{},"
            else
                s_value = __get_tbl_template(to_txt("", v, level + 1), level)
            end
        elseif ("function" == v_type) then
            s_value = "FUNC,"
        elseif ("number" == v_type) then
            s_value = string.format("%s,", v)
        else
            s_value =  string.format("%s,", tostring(v))
        end

        str = string.format(VALUE_LINE_TEMPLATE, str, string.rep("\t", level), k_value, s_value)
    end

    return str
end

-- Saves a string to file
local function write_file(filename, value)
    if (value) then
        local file = io.open(filename,"w+")
        file:write(value)
        file:close()
    end
end

function table.totxt(tbl, filepath)
    local ret = "return {\n"
    
    ret = to_txt(ret, tbl, 1)

    ret = ret .. "}"

    if (filepath) then
        write_file(filepath, ret)
    end

    return ret
end

function table.concat(t1, t2)
    for i = 1, #t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

-- This function returns a deep copy of a given table. 
-- The function below also copies the metatable to the new table if there is one, so the behaviour of the copied table is the same as the original. 
-- But the 2 tables share the same metatable, you can avoid this by changing this 'getmetatable(object)' to '_copy( getmetatable(object) )'. 

function table.deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end