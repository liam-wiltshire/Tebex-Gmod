Msg( "// API Client 0.1            //\n" )

TebexApiClient = {}
TebexApiClient.__index = TebexApiClient

function TebexApiClient:init(baseUrl, secret, timeout)
    local apiclient = {}

    setmetatable(apiclient,TebexApiClient)

    apiclient.baseUrl = baseUrl
    apiclient.secret = secret;

    if (timeout == nil) then
        timeout = 5000
    end

    apiclient.timeout = timeout

    return apiclient

end

function TebexApiClient:get(endpoint, success, failure)
    HTTP(
        {
            failed = function (msg)
                Tebex.err("There was a problem sending this request. Please try again")
            end,
            success = function (code, body)
                print ("handle response", code)
                tBody = util.JSONToTable(body)
                if (code == 200 or code == 204) then
                    print ("call success")
                    success(tBody)
                    return
                end
                print ("call fail")
                failure(tBody)
            end,
            method = "GET",
            url = self.baseUrl .. endpoint,
            headers = {
                ['X-Buycraft-Secret'] = apiclient.secret
            }
        }
    )
end