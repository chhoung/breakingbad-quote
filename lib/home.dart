import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var quote;
  Future<String> getQuote() async {
    var url = 'https://breaking-bad-quotes.herokuapp.com/v1/quotes';
    //var quote = "";

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      //     quote = jsonResponse[0]['quote'];

      quote = jsonResponse[0]['quote'] + '  \n- ' + jsonResponse[0]['author'];
      print(quote);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return quote;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: FutureBuilder(
          future: getQuote(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Text(snapshot.data);
            } else {
              return Text('Loading quote..');
            }
          },
        ),
      ),
    );
  }
}
