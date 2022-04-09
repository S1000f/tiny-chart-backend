using HTTP
using Sockets
using JSON3
using URIs
using Redis

import HTTP.Request
import HTTP.Response
import HTTP.Router
import HTTP.@register
import HTTP.serve

function ping()
  while true
    res = HTTP.request("GET", "https://api.coingecko.com/api/v3/ping")
    println(res.status)
    json = String(res.body)
    j = JSON3.read(json, Dict{String, String})
    println(j)
    sleep(3)
  end
end

function getPriceRanged(q::Dict{String, String})
  while true
    res2 = HTTP.request("GET", "https://api.coingecko.com/api/v3/coins/bitcoin/market_chart/range?" * URI(query=q).query)
    json2 = String(res2.body)
    j2 = JSON3.read(json2, Dict)
    println(j2)
    sleep(5)
  end
end

q = Dict(
  "vs_currency" => "usd",
  "from" => "1648339200",
  "to" => "1648356367"
)

@async ping()
@async getPriceRanged(q)

function main(req::Request)
  return Response(200, "<h1>Hello world!</h1>")
end

const HANDLER_ROUTER = Router()
@register(HANDLER_ROUTER, "GET", "/", main)

serve(HANDLER_ROUTER, Sockets.localhost, 8081)