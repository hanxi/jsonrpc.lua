-- example for lsocket: a http server, using the rshttpd lib
-- this is extremely simple, just echoes back the request headers and
-- request details
--
-- Gunnar Zötl <gz@tset.de>, 2013-03
-- Released under MIT/X11 license. See file LICENSE for details.

local conf = require "conf"
local util = require "util"
local httpd = require "rshttpd"
local staticfile = require "staticfile"
local apis = require "apis"
local mime = require "mime"
local json = require "dkjson"
local unpack = unpack or table.unpack

local server = httpd.new('0.0.0.0', conf.port, 1000, print)

print("start http server in ", conf.port)

local function tablify(tbl)
	local res = '<table style="border: 1px solid grey">'
	local k, v
	for k, v in pairs(tbl) do
		res = res .. '<tr><th align="right" valign="top" style="border: 1px solid grey">' .. k .. "</th><td>"
		if type(v) == "table" then
			res = res .. tablify(v)
		else
			res = res .. tostring(v)
		end
		res = res .. "</td></tr>"
	end
	res = res .. "</table>"
	return res
end

local function jsonrpchandle(data, apis)
    local res = ""
    if data and data.method then
        local v = '1.0'
        if data.method:find('.', 1, true) then
            v = '2.0'
        end
        if not data.jsonrpc then data.jsonrpc = v end
        local method = util.explode(data.method, '.')
        if apis[method[1]] and (v == '1.0' or apis[method[1]][method[2]]) then
            res = json.encode({
                jsonrpc = data.jsonrpc,
                result = (v == '1.0' and apis[method[1]] or apis[method[1]][method[2]])(unpack(data.params)),
                error = null,
            })
        else
            res = json.encode({jsonrpc = data.jsonrpc,result = null,error = "method not exists!"})
        end
    else
        res = json.encode({jsonrpc = v,result = null,error = "Agreement Error!"})
    end
    return res
end

server:addhandler("post", function(rq, header, data)
	local res = jsonrpchandle(json.decode(data), apis)
	return "200", res, { ["Content-Type"] = "text/javascript" }
end)

server:addhandler("get", function(rq, header)
	local res = ""
    local hdr = {}
	if rq.path == "/status" then
		res = "<html><body><h2>Status</h2>" .. tablify(server:status()) .. "</body></html>"
	else
        local filename = rq.path:sub(2)
        local suffix = filename:gsub("^.*%.([^.]+)$", "%1")
        if mime[suffix] then
            hdr["Content-Type"] = mime[suffix]
        else
            hdr["Content-Type"] = "application/octet-stream"
        end
        local content = staticfile[rq.path]
        if not content then
            content = staticfile["index.html"]
            hdr["Content-Type"] = "text/html"
        end
        res = content
	end
	return "200", res, hdr 
end)

local doomsday = false

repeat
	server:step(0.1)
until doomsday
