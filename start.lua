__root = "./"
local path,ret = arg[0]:gsub("^([^/]*/).*$","%1")
if ret~=0 then
    __root = path
end
package.path = package.path .. ";" .. __root .. "lsocket/?.lua;" .. __root .. "scripts/?.lua;" .. __root .. "?.lua"
package.cpath = package.cpath .. ";" .. __root .. "lsocket/?.so"

require "httpserver"

