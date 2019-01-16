ngx.say("hello, world123")
local arg = ngx.req.get_uri_args()
ngx.say(arg["docker"])
for k,v in pairs(arg) do
  ngx.say("[GET ] key:", k, " v:", v)
end

ngx.say(ngx.var.host)
