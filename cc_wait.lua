if ngx.var.white_ip == '1' then
return
end

local redis = require "resty.redis"

local ip = ngx.var.remote_addr
local red = redis:new()


red:set_timeout(1000) -- 1 sec

local ok, err = red:connect("47.52.69.219", 6379)
if not ok then
   ngx.say("failed to connect: ", err)
   return
end
local ck = ngx.var.cookie_ccinfo

local key = ngx.var.http_host.."|"..ngx.var.remote_addr
local res, err = red:get(key)

if res == ngx.null then
  if ck == nil then
    ngx.exec('/wait.html')
  else
    red:set(key,1)
    red:expire(key, 86400)
  end
else
   local count = tonumber(res) 
   count = count + 1 
   local res, err =  red:set(key,count)
   red:expire(key, 86400)	
end


local ok, err = red:set_keepalive(10000, 100)
if not ok then
   ngx.say("failed to set keepalive: ", err)
   return
end
