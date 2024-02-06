import std/[httpclient, tables, options]
import typedefs, conversions

const
    urlStart: string = "https://wttr.in/"
    urlArgs: string = "?format=j1"

type
    Unit* = enum
        ## Used for passing arguments to procs like `getTemperatureFluctuation()`
        Metric, Imperial

var client: HttpClient = newHttpClient()
proc url(city: string): string = urlStart & city & urlArgs


# -----------------------------------------------------------------------------
# Weather request procs:
# -----------------------------------------------------------------------------

proc getWeather*(city: string): WeatherRequest =
    ## Gets `WeatherRequest` object for a specified city
    result = client.getContent(city.url()).parseWeather()

proc getWeather*(cities: seq[string]): OrderedTable[string, WeatherRequest] =
    ## Gets `WeatherRequest`s for each city and puts them in an `OrderedTable`
    ##
    ## `"city": WeatherRequest`
    for city in cities:
        result[city] = city.getWeather()


# -----------------------------------------------------------------------------
# Daily forecast procs:
# -----------------------------------------------------------------------------

proc getDay(weather: WeatherRequest, day: int): Option[WeatherForecast] =
    ## Helper proc to get a specific index of `forecasts`
    if weather.forecasts.len() - 1 < day:
        result = none WeatherForecast
    else:
        result = some weather.forecasts[day]

proc getToday*(weather: WeatherRequest): Option[WeatherForecast] =
    ## Gets optional `WeatherForecast` for today
    result = weather.getDay(0)

proc getTomorrow*(weather: WeatherRequest): Option[WeatherForecast] =
    ## Gets optional `WeatherForecast` for tomorrow
    result = weather.getDay(1)

proc getOvermorrow*(weather: WeatherRequest): Option[WeatherForecast] =
    ## Gets optional `WeatherForecast` for overmorrow (day after tomorrow)
    result = weather.getDay(2)

proc getDayAfterTomorrow*(weather: WeatherRequest): Option[WeatherForecast] =
    ## Gets optional `WeatherForecast` for overmorrow (day after tomorrow)
    ##
    ## This is an alias to `WeatherRequest.getOvermorrow()`
    result = weather.getOvermorrow()

proc getTemperatureFluctuation*(weather: WeatherForecast, unit: Unit = Metric): int =
    ## Gets the temperature fluctuation for a `WeatherForecast`
    case unit:
    of Metric:
        result = weather.maxTemperature.metric - weather.minTemperature.metric
    of Imperial:
        result = weather.maxTemperature.imperial - weather.minTemperature.imperial
