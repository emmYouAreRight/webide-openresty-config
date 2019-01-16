local host=ngx.var.host
local key = string.match(host,"(%w+)%.")
ngx.log(ngx.ERR, "host:", host, " keys ", key ,"\n")
local res = ngx.location.capture(
  "/redis", { args = { key = key } }
)

local default_server="http://127.0.0.1:3000"

print("key: ", key)
if res.status ~= 200 then
  ngx.log(ngx.ERR, "redis server returned bad status: ",res.status)
  ngx.exit(res.status)
end

if not res.body then
  ngx.log(ngx.ERR, "redis returned empty body")
  ngx.exit(500)
end

local parser = require "redis.parser"
local server, typ = parser.parse_reply(res.body)
if typ ~= parser.BULK_REPLY or not server then
  ngx.log(ngx.ERR, "bad redis response: ", res.body)
  server=default_server
  ngx.exit(500)
end

print("server: ", server)

ngx.var.target = server
