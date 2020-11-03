import 'package:breakingbad_quotes/quote.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum characters {
  walterwhite,
  jessepinkman,
  sualgoodman,
}

String getGifs(String charac) {
  switch (charac) {
    case 'Walter White':
      return "gifs/walterwhite.gif";
      break;
    case 'Jesse Pinkman':
      return "gifs/jessepinkman.gif";
      break;
    case 'Saul Goodman':
      return "gifs/saulgoodman.gif";
      break;
    case 'Mike Ehrmantraut':
      return "gifs/mike.gif";
      break;
    case 'Hank Schrader':
      return 'gifs/hank.gif';
      break;
    case 'Skyler White':
      return 'gifs/skyler.gif';
      break;
    case 'Gustavo Fring':
      return 'gifs/gus.gif';
      break;
    default:
      return "gifs/jessepinkman2.gif";
  }
}

class _HomeScreenState extends State<HomeScreen> {
  var quote;
  Future<QuoteClass> getQuote() async {
    QuoteClass quoteClass;
    var url = 'https://breaking-bad-quotes.herokuapp.com/v1/quotes';

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      quote = jsonResponse[0]['quote'] + '  \n- ' + jsonResponse[0]['author'];
      quoteClass = QuoteClass(quote, jsonResponse[0]['author']);
      print(quote);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return quoteClass;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: FutureBuilder<QuoteClass>(
            future: getQuote(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image(
                        image: AssetImage(getGifs(snapshot.data.author)),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        snapshot.data.quote,
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 15.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: () {
                                print('Sharing..');
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    'gifs/brea.png',
                                    color: null,
                                    scale: 10,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'More..',
                                    style: TextStyle(color: Colors.white70),
                                  )
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                print('Sharing..');
                                final RenderBox box =
                                    context.findRenderObject();
                                Share.share(snapshot.data.quote,
                                    subject: 'Breaking Bad Quote',
                                    sharePositionOrigin:
                                        box.localToGlobal(Offset.zero) &
                                            box.size);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share_outlined,
                                    color: Colors.blueAccent,
                                  ),
                                  Text(
                                    'Share',
                                    style: TextStyle(color: Colors.white70),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ]);
              } else {
                return Text('Loading quote..');
              }
            }),
      ),
    );
  }
}
