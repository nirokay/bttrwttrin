import std/[options]

type
    JsonSeqValue* = seq[tuple[value: string]] ## Weird thing that wttr.in does

    JsonCurrentLocation* = object
        ## Raw json data that comes from wttr.in
        FeelsLikeC*, FeelsLikeF*, cloudcover*, humidity*,
            localObsDateTime*, observation_time*, precipInches*, precipMM*,
            pressure*, pressureInches*, temp_C*, temp_F*, uvIndex*, visibility*,
            visibilityMiles*, weatherCode*, winddir16Point*,
            winddirDegree*, windspeedKmph*, windspeedMiles*: Option[string]

        weatherIconUrl*, weatherDesc*: JsonSeqValue


    JsonNearestArea* = object
        ## Nearest area
        areaName*: Option[JsonSeqValue]
        latitude*, longitude*, population*: Option[string]
        country*, region*, weatherUrl*: JsonSeqValue


    JsonWttrInRequest* = seq[tuple[query, `type`: string]] ## Request meta-data


    JsonAstronomy* = object
        ## Stuff about moon and sun
        moon_illumination*, moon_phase*, moonrise*, moonset*, sunrise*, sunset*: string

    JsonHourlyForecast* = object
        ## Hourly forecast
        weatherDesc*, weatherIconUrl*: JsonSeqValue
        DewPointC*, DewPointF*, FeelsLikeC*, FeelsLikeF*, HeatIndexC*, HeatIndexF*, WindChillC*,
            WindChillF*, WindGustKmph*, WindGustMiles*, chanceoffog*, chanceoffrost*,
            chanceofhightemp*, chanceofovercast*, chanceofrain*, chanceofremdry*,
            chanceofsnow*, chanceofsunshine*, chanceofthunder*, chanceofwindy*, cloudcover*,
            humidity*, precipInches*, precipMM*, pressure*, pressureInches*, tempC*, tempF*, time*,
            uvIndex*, visibility*, visibilityMiles*, weatherCode*, winddir16Point*,
            winddirDegree*, windspeedKmph*, windspeedMiles*: Option[string]

    JsonWeatherForecast* = object
        ## Weather object for a single day
        astronomy*: seq[JsonAstronomy]
        avgtempC*, avgtempF*, date*, maxtempC*, maxtempF*,
            mintempC*, mintempF*, sunHour*, totalSnow_cm*, uvIndex*: Option[string]
        hourly*: seq[JsonHourlyForecast]

    JsonWeather* = object
        ## Full set of data received from wttr.in
        current_condition*: seq[JsonCurrentLocation]
        nearest_area*: seq[JsonNearestArea]
        request*: JsonWttrInRequest
        weather*: seq[JsonWeatherForecast]

