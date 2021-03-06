

import Foundation

// let's keep a sample on hand for testing purposes
// so we don't have to keep hitting the server while developing the interface
// global; to use, Edit Scheme > Run > Arguments, check the TESTING checkbox
let samplejson = """
{
   "cod":"200",
   "message":0,
   "cnt":40,
   "list":[
      {
         "dt":1581735600,
         "main":{
            "temp":283.43,
            "feels_like":281.74,
            "temp_min":280.89,
            "temp_max":283.43,
            "pressure":1019,
            "sea_level":1019,
            "grnd_level":911,
            "humidity":76,
            "temp_kf":2.54
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01n"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":1.17,
            "deg":342
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-15 03:00:00"
      },
      {
         "dt":1581746400,
         "main":{
            "temp":282.78,
            "feels_like":280.47,
            "temp_min":280.87,
            "temp_max":282.78,
            "pressure":1021,
            "sea_level":1021,
            "grnd_level":912,
            "humidity":72,
            "temp_kf":1.91
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01n"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":1.64,
            "deg":356
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-15 06:00:00"
      },
      {
         "dt":1581757200,
         "main":{
            "temp":281.45,
            "feels_like":278.9,
            "temp_min":280.18,
            "temp_max":281.45,
            "pressure":1021,
            "sea_level":1021,
            "grnd_level":912,
            "humidity":66,
            "temp_kf":1.27
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01n"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":1.33,
            "deg":353
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-15 09:00:00"
      },
      {
         "dt":1581768000,
         "main":{
            "temp":279.95,
            "feels_like":276.99,
            "temp_min":279.31,
            "temp_max":279.95,
            "pressure":1021,
            "sea_level":1021,
            "grnd_level":912,
            "humidity":57,
            "temp_kf":0.64
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01n"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":1.17,
            "deg":346
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-15 12:00:00"
      },
      {
         "dt":1581778800,
         "main":{
            "temp":278.98,
            "feels_like":275.81,
            "temp_min":278.98,
            "temp_max":278.98,
            "pressure":1022,
            "sea_level":1022,
            "grnd_level":912,
            "humidity":51,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":2
         },
         "wind":{
            "speed":1.03,
            "deg":349
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-15 15:00:00"
      },
      {
         "dt":1581789600,
         "main":{
            "temp":287.97,
            "feels_like":284.25,
            "temp_min":287.97,
            "temp_max":287.97,
            "pressure":1023,
            "sea_level":1023,
            "grnd_level":914,
            "humidity":31,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":1
         },
         "wind":{
            "speed":2.06,
            "deg":178
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-15 18:00:00"
      },
      {
         "dt":1581800400,
         "main":{
            "temp":288.95,
            "feels_like":285.08,
            "temp_min":288.95,
            "temp_max":288.95,
            "pressure":1021,
            "sea_level":1021,
            "grnd_level":912,
            "humidity":41,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":3.28,
            "deg":194
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-15 21:00:00"
      },
      {
         "dt":1581811200,
         "main":{
            "temp":287.11,
            "feels_like":283.98,
            "temp_min":287.11,
            "temp_max":287.11,
            "pressure":1020,
            "sea_level":1020,
            "grnd_level":912,
            "humidity":53,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":2.73,
            "deg":206
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-16 00:00:00"
      },
      {
         "dt":1581822000,
         "main":{
            "temp":281.75,
            "feels_like":279.71,
            "temp_min":281.75,
            "temp_max":281.75,
            "pressure":1021,
            "sea_level":1021,
            "grnd_level":912,
            "humidity":71,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01n"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":0.93,
            "deg":24
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-16 03:00:00"
      },
      {
         "dt":1581832800,
         "main":{
            "temp":281.93,
            "feels_like":278.93,
            "temp_min":281.93,
            "temp_max":281.93,
            "pressure":1022,
            "sea_level":1022,
            "grnd_level":913,
            "humidity":50,
            "temp_kf":0
         },
         "weather":[
            {
               "id":802,
               "main":"Clouds",
               "description":"scattered clouds",
               "icon":"03n"
            }
         ],
         "clouds":{
            "all":34
         },
         "wind":{
            "speed":1.24,
            "deg":13
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-16 06:00:00"
      },
      {
         "dt":1581843600,
         "main":{
            "temp":281.54,
            "feels_like":278.06,
            "temp_min":281.54,
            "temp_max":281.54,
            "pressure":1022,
            "sea_level":1022,
            "grnd_level":913,
            "humidity":44,
            "temp_kf":0
         },
         "weather":[
            {
               "id":802,
               "main":"Clouds",
               "description":"scattered clouds",
               "icon":"03n"
            }
         ],
         "clouds":{
            "all":35
         },
         "wind":{
            "speed":1.54,
            "deg":358
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-16 09:00:00"
      },
      {
         "dt":1581854400,
         "main":{
            "temp":281.12,
            "feels_like":277.64,
            "temp_min":281.12,
            "temp_max":281.12,
            "pressure":1020,
            "sea_level":1020,
            "grnd_level":911,
            "humidity":49,
            "temp_kf":0
         },
         "weather":[
            {
               "id":802,
               "main":"Clouds",
               "description":"scattered clouds",
               "icon":"03n"
            }
         ],
         "clouds":{
            "all":25
         },
         "wind":{
            "speed":1.73,
            "deg":342
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-16 12:00:00"
      },
      {
         "dt":1581865200,
         "main":{
            "temp":281.3,
            "feels_like":278.21,
            "temp_min":281.3,
            "temp_max":281.3,
            "pressure":1020,
            "sea_level":1020,
            "grnd_level":911,
            "humidity":56,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":1.55,
            "deg":348
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-16 15:00:00"
      },
      {
         "dt":1581876000,
         "main":{
            "temp":289.25,
            "feels_like":286.31,
            "temp_min":289.25,
            "temp_max":289.25,
            "pressure":1020,
            "sea_level":1020,
            "grnd_level":912,
            "humidity":38,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":1.76,
            "deg":189
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-16 18:00:00"
      },
      {
         "dt":1581886800,
         "main":{
            "temp":291.32,
            "feels_like":287.87,
            "temp_min":291.32,
            "temp_max":291.32,
            "pressure":1018,
            "sea_level":1018,
            "grnd_level":910,
            "humidity":37,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":2.85,
            "deg":194
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-16 21:00:00"
      },
      {
         "dt":1581897600,
         "main":{
            "temp":290.14,
            "feels_like":288.14,
            "temp_min":290.14,
            "temp_max":290.14,
            "pressure":1016,
            "sea_level":1016,
            "grnd_level":909,
            "humidity":40,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":0.78,
            "deg":201
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-17 00:00:00"
      },
      {
         "dt":1581908400,
         "main":{
            "temp":284.09,
            "feels_like":280.75,
            "temp_min":284.09,
            "temp_max":284.09,
            "pressure":1016,
            "sea_level":1016,
            "grnd_level":909,
            "humidity":52,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01n"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":2.25,
            "deg":350
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-17 03:00:00"
      },
      {
         "dt":1581919200,
         "main":{
            "temp":282.58,
            "feels_like":278.92,
            "temp_min":282.58,
            "temp_max":282.58,
            "pressure":1017,
            "sea_level":1017,
            "grnd_level":909,
            "humidity":57,
            "temp_kf":0
         },
         "weather":[
            {
               "id":801,
               "main":"Clouds",
               "description":"few clouds",
               "icon":"02n"
            }
         ],
         "clouds":{
            "all":20
         },
         "wind":{
            "speed":2.69,
            "deg":355
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-17 06:00:00"
      },
      {
         "dt":1581930000,
         "main":{
            "temp":281.61,
            "feels_like":277.58,
            "temp_min":281.61,
            "temp_max":281.61,
            "pressure":1017,
            "sea_level":1017,
            "grnd_level":908,
            "humidity":62,
            "temp_kf":0
         },
         "weather":[
            {
               "id":801,
               "main":"Clouds",
               "description":"few clouds",
               "icon":"02n"
            }
         ],
         "clouds":{
            "all":21
         },
         "wind":{
            "speed":3.28,
            "deg":350
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-17 09:00:00"
      },
      {
         "dt":1581940800,
         "main":{
            "temp":281.58,
            "feels_like":277.19,
            "temp_min":281.58,
            "temp_max":281.58,
            "pressure":1016,
            "sea_level":1016,
            "grnd_level":907,
            "humidity":59,
            "temp_kf":0
         },
         "weather":[
            {
               "id":802,
               "main":"Clouds",
               "description":"scattered clouds",
               "icon":"03n"
            }
         ],
         "clouds":{
            "all":45
         },
         "wind":{
            "speed":3.62,
            "deg":353
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-17 12:00:00"
      },
      {
         "dt":1581951600,
         "main":{
            "temp":281.4,
            "feels_like":277.07,
            "temp_min":281.4,
            "temp_max":281.4,
            "pressure":1016,
            "sea_level":1016,
            "grnd_level":907,
            "humidity":61,
            "temp_kf":0
         },
         "weather":[
            {
               "id":804,
               "main":"Clouds",
               "description":"overcast clouds",
               "icon":"04d"
            }
         ],
         "clouds":{
            "all":91
         },
         "wind":{
            "speed":3.6,
            "deg":354
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-17 15:00:00"
      },
      {
         "dt":1581962400,
         "main":{
            "temp":290.2,
            "feels_like":287.2,
            "temp_min":290.2,
            "temp_max":290.2,
            "pressure":1017,
            "sea_level":1017,
            "grnd_level":908,
            "humidity":36,
            "temp_kf":0
         },
         "weather":[
            {
               "id":802,
               "main":"Clouds",
               "description":"scattered clouds",
               "icon":"03d"
            }
         ],
         "clouds":{
            "all":45
         },
         "wind":{
            "speed":1.86,
            "deg":100
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-17 18:00:00"
      },
      {
         "dt":1581973200,
         "main":{
            "temp":292,
            "feels_like":288.16,
            "temp_min":292,
            "temp_max":292,
            "pressure":1014,
            "sea_level":1014,
            "grnd_level":907,
            "humidity":31,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":2.95,
            "deg":92
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-17 21:00:00"
      },
      {
         "dt":1581984000,
         "main":{
            "temp":290.8,
            "feels_like":286.88,
            "temp_min":290.8,
            "temp_max":290.8,
            "pressure":1014,
            "sea_level":1014,
            "grnd_level":907,
            "humidity":30,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":8
         },
         "wind":{
            "speed":2.74,
            "deg":85
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-18 00:00:00"
      },
      {
         "dt":1581994800,
         "main":{
            "temp":284.51,
            "feels_like":279.64,
            "temp_min":284.51,
            "temp_max":284.51,
            "pressure":1015,
            "sea_level":1015,
            "grnd_level":907,
            "humidity":35,
            "temp_kf":0
         },
         "weather":[
            {
               "id":802,
               "main":"Clouds",
               "description":"scattered clouds",
               "icon":"03n"
            }
         ],
         "clouds":{
            "all":32
         },
         "wind":{
            "speed":3.46,
            "deg":9
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-18 03:00:00"
      },
      {
         "dt":1582005600,
         "main":{
            "temp":283.36,
            "feels_like":277.31,
            "temp_min":283.36,
            "temp_max":283.36,
            "pressure":1016,
            "sea_level":1016,
            "grnd_level":909,
            "humidity":22,
            "temp_kf":0
         },
         "weather":[
            {
               "id":801,
               "main":"Clouds",
               "description":"few clouds",
               "icon":"02n"
            }
         ],
         "clouds":{
            "all":16
         },
         "wind":{
            "speed":4.22,
            "deg":5
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-18 06:00:00"
      },
      {
         "dt":1582016400,
         "main":{
            "temp":283.3,
            "feels_like":277.37,
            "temp_min":283.3,
            "temp_max":283.3,
            "pressure":1015,
            "sea_level":1015,
            "grnd_level":908,
            "humidity":20,
            "temp_kf":0
         },
         "weather":[
            {
               "id":802,
               "main":"Clouds",
               "description":"scattered clouds",
               "icon":"03n"
            }
         ],
         "clouds":{
            "all":45
         },
         "wind":{
            "speed":3.92,
            "deg":6
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-18 09:00:00"
      },
      {
         "dt":1582027200,
         "main":{
            "temp":282.44,
            "feels_like":276.21,
            "temp_min":282.44,
            "temp_max":282.44,
            "pressure":1015,
            "sea_level":1015,
            "grnd_level":907,
            "humidity":20,
            "temp_kf":0
         },
         "weather":[
            {
               "id":803,
               "main":"Clouds",
               "description":"broken clouds",
               "icon":"04n"
            }
         ],
         "clouds":{
            "all":52
         },
         "wind":{
            "speed":4.29,
            "deg":9
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-18 12:00:00"
      },
      {
         "dt":1582038000,
         "main":{
            "temp":281.94,
            "feels_like":275.71,
            "temp_min":281.94,
            "temp_max":281.94,
            "pressure":1016,
            "sea_level":1016,
            "grnd_level":908,
            "humidity":21,
            "temp_kf":0
         },
         "weather":[
            {
               "id":801,
               "main":"Clouds",
               "description":"few clouds",
               "icon":"02d"
            }
         ],
         "clouds":{
            "all":15
         },
         "wind":{
            "speed":4.3,
            "deg":8
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-18 15:00:00"
      },
      {
         "dt":1582048800,
         "main":{
            "temp":290.23,
            "feels_like":285.61,
            "temp_min":290.23,
            "temp_max":290.23,
            "pressure":1017,
            "sea_level":1017,
            "grnd_level":909,
            "humidity":15,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":7
         },
         "wind":{
            "speed":2.26,
            "deg":76
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-18 18:00:00"
      },
      {
         "dt":1582059600,
         "main":{
            "temp":292.29,
            "feels_like":287.85,
            "temp_min":292.29,
            "temp_max":292.29,
            "pressure":1015,
            "sea_level":1015,
            "grnd_level":907,
            "humidity":15,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":2.19,
            "deg":152
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-18 21:00:00"
      },
      {
         "dt":1582070400,
         "main":{
            "temp":290.55,
            "feels_like":286.06,
            "temp_min":290.55,
            "temp_max":290.55,
            "pressure":1014,
            "sea_level":1014,
            "grnd_level":907,
            "humidity":20,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":2.57,
            "deg":175
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-19 00:00:00"
      },
      {
         "dt":1582081200,
         "main":{
            "temp":283.54,
            "feels_like":279.03,
            "temp_min":283.54,
            "temp_max":283.54,
            "pressure":1016,
            "sea_level":1016,
            "grnd_level":908,
            "humidity":32,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01n"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":2.63,
            "deg":4
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-19 03:00:00"
      },
      {
         "dt":1582092000,
         "main":{
            "temp":283.27,
            "feels_like":277.75,
            "temp_min":283.27,
            "temp_max":283.27,
            "pressure":1017,
            "sea_level":1017,
            "grnd_level":909,
            "humidity":23,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01n"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":3.51,
            "deg":353
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-19 06:00:00"
      },
      {
         "dt":1582102800,
         "main":{
            "temp":282.74,
            "feels_like":276.96,
            "temp_min":282.74,
            "temp_max":282.74,
            "pressure":1016,
            "sea_level":1016,
            "grnd_level":909,
            "humidity":24,
            "temp_kf":0
         },
         "weather":[
            {
               "id":802,
               "main":"Clouds",
               "description":"scattered clouds",
               "icon":"03n"
            }
         ],
         "clouds":{
            "all":36
         },
         "wind":{
            "speed":3.89,
            "deg":360
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-19 09:00:00"
      },
      {
         "dt":1582113600,
         "main":{
            "temp":282.01,
            "feels_like":276.11,
            "temp_min":282.01,
            "temp_max":282.01,
            "pressure":1016,
            "sea_level":1016,
            "grnd_level":908,
            "humidity":24,
            "temp_kf":0
         },
         "weather":[
            {
               "id":802,
               "main":"Clouds",
               "description":"scattered clouds",
               "icon":"03n"
            }
         ],
         "clouds":{
            "all":25
         },
         "wind":{
            "speed":4,
            "deg":4
         },
         "sys":{
            "pod":"n"
         },
         "dt_txt":"2020-02-19 12:00:00"
      },
      {
         "dt":1582124400,
         "main":{
            "temp":281.81,
            "feels_like":275.65,
            "temp_min":281.81,
            "temp_max":281.81,
            "pressure":1017,
            "sea_level":1017,
            "grnd_level":909,
            "humidity":24,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":4.35,
            "deg":11
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-19 15:00:00"
      },
      {
         "dt":1582135200,
         "main":{
            "temp":289.15,
            "feels_like":282.88,
            "temp_min":289.15,
            "temp_max":289.15,
            "pressure":1018,
            "sea_level":1018,
            "grnd_level":911,
            "humidity":15,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":4.52,
            "deg":56
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-19 18:00:00"
      },
      {
         "dt":1582146000,
         "main":{
            "temp":290.58,
            "feels_like":284.04,
            "temp_min":290.58,
            "temp_max":290.58,
            "pressure":1017,
            "sea_level":1017,
            "grnd_level":910,
            "humidity":14,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":4.94,
            "deg":63
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-19 21:00:00"
      },
      {
         "dt":1582156800,
         "main":{
            "temp":289.27,
            "feels_like":283.37,
            "temp_min":289.27,
            "temp_max":289.27,
            "pressure":1017,
            "sea_level":1017,
            "grnd_level":910,
            "humidity":17,
            "temp_kf":0
         },
         "weather":[
            {
               "id":800,
               "main":"Clear",
               "description":"clear sky",
               "icon":"01d"
            }
         ],
         "clouds":{
            "all":0
         },
         "wind":{
            "speed":4.18,
            "deg":67
         },
         "sys":{
            "pod":"d"
         },
         "dt_txt":"2020-02-20 00:00:00"
      }
   ],
   "city":{
      "id":5378880,
      "name":"Ojai",
      "coord":{
         "lat":34.4481,
         "lon":-119.2429
      },
      "country":"US",
      "population":7461,
      "timezone":-28800,
      "sunrise":1581691428,
      "sunset":1581730725
   }
}
"""
