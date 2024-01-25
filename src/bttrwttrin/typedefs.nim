import std/[options]

type
    UnitData*[T] = tuple[metric, imperial: T] ## Tuple that holds both metric and imperial data formats in the `metric` and `imperial` fields, respectively

    AstronomyEvent* = object of RootObj ## Object astronomy
        rising*: string ## Time of rising
        setting*: string ## Time of setting
    AstronomySun* = object of AstronomyEvent ## Sun astronomy
    AstronomyMoon* = object of AstronomyEvent ## Moon astronomy
        illumination*: int ## Moon illumination
        phase*: string ## Moon phase

    Astronomy* = object
        sun*: AstronomySun
        moon*: AstronomyMoon

    Wind* = object
        direction*: tuple[degrees: int, direction16Point: string] ## Wind direction in degrees and 16-point (SSE, SSW, NWW, ...)
        speed*: UnitData[int] ## Speed in km/h and mi/h

    LocationLatLong* = tuple[latitude, longitude: float] ## Latitude and Longitude

    CurrentWeather* = object
        ## Current weather for a location
        temperature*: UnitData[int] ## Temperature in °C and °F
        feelsLike*: UnitData[int] ## Feels-like in metric and imperial
        humidity*: float ## Percentage of humidity
        cloudcover*: int ## Cloud cover
        observation*: tuple[utc, local: string] ## Observation time
        precipitation*: UnitData[float] ## Millimeters/Inches of precipitation
        pressure*: UnitData[int] ## Atmospheric pressure (Millibars and "inches of mercury")
        uvIndex*: int ## UV index
        visibility*: UnitData[int] ## Visibility in kilometers and miles
        weatherCode*: int ## Weather code
        description*: string ## Weather description (sunny, foggy, ...)
        wind*: Wind ## Wind data


    NearestArea* = object
        ## Nearest area
        name*: string ## Area name
        country*: string ## Country name
        region*: string ## Region name
        population*: int ## Area population
        location*: LocationLatLong ## Location of area
        weatherUrl*: string ## Weather URL

    ChanceOf* = object
        ## Chances of weather happening
        frost*, fog*, highTemp*, overcast*, rain*, remdry*,
            snow*, sunshine*, thunder*, windy*: float

    WeatherHourlyForecast* = object
        ## Hourly weather forecast
        dewPoint*: UnitData[int] ## Dew point in °C and °F
        feelsLike*: UnitData[int] ## Feels-like in °C and °F
        heatIndex*: UnitData[int] ## Heat index in °C and °F
        windChill*: UnitData[int] ## Wind chill in °C and °F
        windGust*: UnitData[int] ## Wind gust in °C and °F
        chanceOf*: ChanceOf ## Chances of weather happening
        humidity*: float ## Humidity
        precipitation*: UnitData[int] ## Precipitation in °C and °F
        pressure*: UnitData[int] ## Pressure in millibars and "inches of mercury"
        temperature*: UnitData[int] ## Temperature in °C and °F
        time*: string ## Time in HHMM (24h format)
        uvIndex*: int ## UV index
        visibility*: UnitData[int] ## Visibility in kilometers and miles
        weatherCode*: int ## Weather code
        wind*: Wind ## Wind data
        description*: string ## Weather description
        weatherIconUrl*: string ## Weather icon URL


    WeatherForecast* = object
        ## Weather forecast for the day
        astronomy*: Astronomy ## Astronomy of sun and moon
        averageTemperature*: UnitData[int] ## Average temperature in °C and °F
        date*: string ## Forecast date
        maxTemperature*: UnitData[int] ## Maximal temperature in °C and °F
        minTemperature*: UnitData[int] ## Minimal temperature in °C and °F
        sunHours*: float ## Hours of sun-shine
        totalSnow*: int ## Total snow in centimeters
        uvIndex*: int ## UV index
        hourly*: seq[WeatherHourlyForecast] ## Hourly forecast

    WeatherRequest* = object
        current*: CurrentWeather ## Current weather situation
        nearestArea*: Option[NearestArea] ## Nearest area
        forecasts*: seq[WeatherForecast] ## Daily weather forecast
