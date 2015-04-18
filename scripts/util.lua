local sformat = string.format
local sgmatch = string.gmatch
local tinsert = table.insert

local util = {}

function util.explode(str,sep)
    local array = {}
    local reg = sformat("([^%s]+)",sep)
    for mem in sgmatch(str,reg) do
        tinsert(array, mem)
    end
    return array
end

return util

