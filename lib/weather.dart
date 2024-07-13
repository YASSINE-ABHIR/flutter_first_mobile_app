
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Weather extends StatefulWidget {
  final String city;
  const Weather(this.city, {super.key});

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  var weatherData = {};

  void getData(String url) {
    http.get(
      Uri.parse(url),
      headers: {'accept': 'application/json'},
    ).then((resp) {
      setState(() {
        weatherData = json.decode(resp.body);
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    super.initState();
    String url = 'http://api.weatherapi.com/v1/forecast.json?key=0ab3f4f08a68449daf3224333240107&q=${widget.city}&days=6&aqi=no&alerts=no';
    print(url);
    getData(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city),
        backgroundColor: Colors.orange,
      ),
      body: weatherData.isEmpty
          ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: weatherData['forecast']['forecastday'].length,
        itemBuilder: (context, index) {
          var weather = weatherData['forecast']['forecastday'][index];
          var date = DateTime.fromMillisecondsSinceEpoch(weather['date_epoch'] * 1000);
          var formattedDate = DateFormat('E dd/MM/yyyy').format(date);
          var formattedTime = DateFormat('HH:mm').format(date);
          var weatherMain = weather['day']['condition']['text'].toString();
          var weatherState = '';
          if(weatherMain.toLowerCase().contains('rain')) {
            weatherState = 'Rainy';
          } else if(weatherMain.toLowerCase().contains('sun')) {
            weatherState = 'Sunny';
          } else if(weatherMain.toLowerCase().contains('snow')) {
            weatherState = 'Snowy';
          } else if (weatherMain.toLowerCase().contains('cloud')) {
            weatherState = 'Cloudy';
          } else {
            weatherState = 'default';
          }

                return Card(
            color: Colors.deepOrangeAccent,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/$weatherState.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$formattedTime | $weatherMain',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${weather['day']['avgtemp_c'].round()} °C',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
