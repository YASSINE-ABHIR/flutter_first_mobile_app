import 'package:flutter/material.dart';
import './weather.dart';
class WeatherForm extends StatefulWidget {
  const WeatherForm({super.key});


  @override
  _WeatherFormState createState() => _WeatherFormState();
}
class _WeatherFormState extends State<WeatherForm> {
  late String city = '';
  TextEditingController cityEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(city), backgroundColor: const Color(0xFF006064)),
      body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Tape a City..'),
                  controller: cityEditingController,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (String str){
                    setState((){
                      city=str;
                    });
                    },
                  onSubmitted: (String str){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Weather(city)));
                    cityEditingController.text="";
                    },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor:Colors.cyan[50],
                    backgroundColor: Colors.cyan[900]
                  ),
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context)=>Weather(city)));
                    cityEditingController.text="";
                  },
                  child: const Text('Get Weather'),
                ),
              )
            ],
        ),
    );
  }
}