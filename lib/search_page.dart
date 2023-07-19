import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  var uuid = Uuid();
  String session = '11223';
  List<dynamic> places = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onChange();
    });
  }

  onChange(){
    if(session == null){
        setState(() {
          session = uuid.v4();
        });
    }

    getSuggession(_controller.text);
  }

  void getSuggession(String value) async{
      String APIKEY = 'AIzaSyCAhfkgm8BTlgBeUUYmtaw3SQPHNd-MQA4';
      String baseURI = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String URI = '$baseURI?input=$value&key=$APIKEY&sessiontoken=$session';

      var response = await http.get(Uri.parse(URI));
      print(response.body.toString());
      if(response.statusCode==200){
          setState(() {
            places = jsonDecode(response.body.toString())['predictions'];
          });
      }
      else{
        throw Exception('Failed to load data');
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Search any place'
            ),
          ),
          Expanded(child: ListView.builder(
            itemCount: places.length,
              itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    _controller.text = places[index]['description'];
                    setState(() {

                    });
                  },
                  child: ListTile(
                    title: Text(places[index]['description']),
                  ),
                );
              }
            )
          )
        ],
      ),
    );
  }
}
