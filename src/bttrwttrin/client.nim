import std/[httpclient, json]

const
    url*: string = "https://wttr.in/" ## wttr.in url
    arg*: string = "?format=j1" ## Args for format

var client: HttpClient = newHttpClient() ## Local client to fetch stuff

proc getRawWeatherData*(location: string): string =
    ## Returns the raw data received from the API
    result = client.getContent(url & location & arg)

proc getRawWeatherJson*(location: string): JsonNode =
    ## Returns the raw json data received from the API
    result = location.getRawWeatherData().parseJson()
