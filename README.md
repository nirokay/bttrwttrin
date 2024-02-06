# bttrwttrin

**Better wttr.in** is a library, that lets you easily request weather for any
city using the [wttr.in](https://wttr.in/) API.

## Usage

For type reference see [typedefs file](./src/bttrwttrin/typedefs.nim) or the
[documentation](https://nirokay.github.io/nim-docs/bttrwttrin/bttrwttrin.html).

### Requesting `WeatherRequest` object

```nim
import bttrwttrin

let weather: WeatherRequest = getWeather("Berlin")
```

### Daily forecasts

```nim
import std/[options]
import bttrwttrin

let weather: WeatherRequest = getWeather("Berlin")

let today: WeatherForecast = get weather.getToday()
# This is equivalent to `weather.forecasts[0]`,
# but safer (no chance of `IndexDefect`), however
# it is your responsibility to handle `None` values!

let
    tomorrow: Option[WeatherForecast] = weather.getTomorrow()
    overmorrow: Option[WeatherForecast] = weather.getOvermorrow()
```

### Current weather

```nim
import bttrwttrin

let
    weather: WeatherRequest = getWeather("Berlin")
    current: CurrentWeather = weather.current

# Temperature (has two fields for metric (°C) and imperial (°F))
let temperature: UnitData[int] = current.temperature

echo $temperature.metric & "°C"
echo $temperature.imperial & "°F"
```

## Installation

### Nimble

`nimble install bttrwttrin` (not yet included in package manager)

### Building from source

`git clone https://github.com/nirokay/bttrwttrin && cd bttrwttrin && nimble install`
