import std/[strutils, options, json]
import typedefs, typedefsjson

proc perc(number: string): float =
    ## Gets a float from an string int-percentage
    result = parseFloat("0." & number)
proc perc(number: Option[string]): float =
    ## Gets a float from an string int-percentage
    result = number.get().perc()


proc metImp[T](metric, imperial: T): UnitData[T] =
    ## Shortcut to generate `UnitData[T]`
    result = (metric: metric, imperial: imperial)

proc metImpI(metric, imperial: string): UnitData[int] =
    ## Shortcut to generate `UnitData[int]`
    result = metImp(metric.parseInt(), imperial.parseInt())
proc metImpI(metric, imperial: Option[string]): UnitData[int] =
    ## Shortcut to generate `UnitData[int]`
    result = metImpI(get metric, get imperial)

proc metImpF(metric, imperial: string): UnitData[float] =
    ## Shortcut to generate `UnitData[float]`
    result = metImp[float](metric.parseFloat(), imperial.parseFloat())
proc metImpF(metric, imperial: Option[string]): UnitData[float] =
    ## Shortcut to generate `UnitData[float]`
    result = metImpF(get metric, get imperial)


proc parsePercentageF(number: string): float =
    ## Parses a string float to a float
    result = number.parseFloat()
proc parsePercentageI(number: string): float =
    ## Parses a string int to a float
    result = number.parseInt().toFloat() / 100

proc parsePercentageF(number: Option[string]): float {.used.} =
    ## Parses a string float to a float
    result = number.get().parsePercentageF()
proc parsePercentageI(number: Option[string]): float {.used.} =
    ## Parses a string int to a float
    result = number.get().parsePercentageI()


proc getWind*(deg, p16, speedM, speedI: Option[string]): Wind =
    ## Gets the wind object from wind input
    result = Wind(
        direction: (degrees: deg.get().parseInt(), direction16Point: get p16),
        speed: metImpI(speedM, speedI)
    )

proc jsonToCurrent*(json: JsonCurrentLocation): CurrentWeather =
    ## Gets the current weather from json
    result = CurrentWeather(
        temperature: metImpI(json.temp_C, json.temp_F),
        feelsLike: metImpI(json.temp_C, json.temp_F),
        humidity: perc(json.humidity),
        cloudcover: parseInt(get json.cloudcover),
        observation: (utc: get json.observation_time, local: get json.localObsDateTime),
        precipitation: metImpF(json.precipMM, json.precipInches),
        pressure: metImpI(json.pressure, json.pressureInches),
        uvIndex: parseInt(get json.uvIndex),
        visibility: metImpI(json.visibility, json.visibilityMiles),
        weatherCode: parseInt(get json.weatherCode),
        description: json.weatherDesc[0].value,
        wind: getWind(json.winddirDegree, json.winddir16Point, json.windspeedKmph, json.windspeedMiles)
    )


proc jsonToNearestArea*(json: JsonNearestArea): Option[NearestArea] =
    ## Gets the nearest area from json
    result = some NearestArea(
        name: json.areaName.get()[0].value,
        country: json.country[0].value,
        region: json.region[0].value,
        population: parseInt(get json.population),
        location: (
            latitude: parseFloat(get json.latitude),
            longitude: parseFloat(get json.longitude)
        ),
        weatherUrl: json.weatherUrl[0].value
    )

proc jsonToNearestArea*(json: seq[JsonNearestArea]): Option[NearestArea] =
    ## Gets the nearest area from json
    if json.len() == 0:
        return none NearestArea

    let area: JsonNearestArea = json[0]
    result = area.jsonToNearestArea()


proc getAstronomy*(json: seq[JsonAstronomy]): Astronomy =
    ## Gets the astronomy from json
    let json: JsonAstronomy = json[0]

proc getHourly*(json: JsonHourlyForecast): WeatherHourlyForecast =
    ## Gets the hourly forecast from json
    result = WeatherHourlyForecast(
        dewPoint: metImpI(json.DewPointC, json.DewPointF),
        feelsLike: metImpI(json.FeelsLikeC, json.FeelsLikeF),
        heatIndex: metImpI(json.HeatIndexC, json.HeatIndexF),
        windChill: metImpI(json.WindChillC, json.WindChillF),
        windGust: metImpI(json.WindGustKmph, json.WindGustMiles),
        chanceOf: ChanceOf(
            frost: json.chanceoffrost.parsePercentageI(),
            fog: json.chanceoffog.parsePercentageI(),
            highTemp: json.chanceofhightemp.parsePercentageI(),
            overcast: json.chanceofovercast.parsePercentageI(),
            rain: json.chanceofrain.parsePercentageI(),
            remdry: json.chanceofremdry.parsePercentageI(),
            snow: json.chanceoffog.parsePercentageI(),
            sunshine: json.chanceofsunshine.parsePercentageI(),
            thunder: json.chanceofthunder.parsePercentageI(),
            windy: json.chanceofwindy.parsePercentageI()
        ),
        humidity: json.humidity.get().parseFloat(),
        precipitation: metImpI(json.precipMM, json.precipInches),
        pressure: metImpI(json.pressure, json.pressureInches),
        time: json.time.get(),
        uvIndex: json.uvIndex.get().parseInt(),
        visibility: metImpI(json.visibility, json.visibilityMiles),
        weatherCode: json.weatherCode.get().parseInt(),
        wind: getWind(json.winddirDegree, json.winddir16Point, json.windspeedKmph, json.windspeedMiles),
        description: json.weatherDesc[0].value,
        weatherIconUrl: json.weatherIconUrl[0].value
    )

proc getHourly*(json: seq[JsonHourlyForecast]): seq[WeatherHourlyForecast] =
    ## Gets the hourly forecasts from json
    for forecast in json:
        result.add forecast.getHourly()

proc getForecast*(json: JsonWeatherForecast): WeatherForecast =
    ## Gets the weather forecast from json
    result = WeatherForecast(
        astronomy: json.astronomy.getAstronomy(),
        averageTemperature: metImpI(json.avgtempC, json.avgtempF),
        date: get json.date,
        maxTemperature: metImpI(json.maxtempC, json.maxtempF),
        minTemperature: metImpI(json.mintempC, json.mintempF),
        sunHours: json.sunHour.get().parseFloat(),
        totalSnow: json.totalSnow_cm.get().parseInt(),
        uvIndex: json.uvIndex.get().parseInt(),
        hourly: json.hourly.getHourly()
    )

proc getForecasts*(json: seq[JsonWeatherForecast]): seq[WeatherForecast] =
    ## Gets the weather forecasts from json
    for forecast in json:
        result.add forecast.getForecast()


proc jsonToObject*(json: JsonWeather): WeatherRequest =
    ## Converts the `JsonWeather` object to a `WeatherRequest` object
    result = WeatherRequest(
        current: json.current_condition[0].jsonToCurrent(),
        nearestArea: json.nearest_area.jsonToNearestArea(),
        forecasts: json.weather.getForecasts()
    )


proc parseWeather*(json: JsonNode): WeatherRequest =
    ## Parses raw json and returns a `WeatherRequest` object
    let jsonWeather: JsonWeather = json.to(JsonWeather)
    result = jsonWeather.jsonToObject()

proc parseWeather*(json: string): WeatherRequest =
    ## Parses a raw json string and returns a `WeatherRequest` object
    result = json.parseJson().parseWeather()

#[
    NearestAreaWeather* = object
        name*: string ## Area name
        country*: string ## Country name
        region*: string ## Region name
        population*: int ## Area population
        location*: LocationLatLong ## Location of area
        weatherUrl*: string ## Weather URL
]#
