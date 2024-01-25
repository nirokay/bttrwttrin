import std/[unittest, json]
import bttrwttrin
import bttrwttrin/[typedefs, conversions]

let rawDummyData: string = readFile("./tests/dummy_data.json")

var
    rawJsonDummyData: JsonNode
    dummyData: WeatherRequest

test "Parsing raw json to JsonNode":
    rawJsonDummyData = rawDummyData.parseJson()

test "Parsing JsonNode to JsonWeather and then WeatherRequest":
    dummyData = rawJsonDummyData.parseWeather()


test "Getting values":
    check dummyData.current.temperature.metric == -7
    check dummyData.current.temperature.imperial == 19

    check dummyData.current.description == "Freezing fog"
