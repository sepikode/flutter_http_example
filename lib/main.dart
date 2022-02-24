import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(child: ListView_JSON()),
    ));
  }
}

class ParseJSON {
  int? id;
  String? name;
  String? email;

  ParseJSON({this.id, this.name, this.email});

  factory ParseJSON.fromJson(Map<String, dynamic> json) {
    return ParseJSON(id: json['id'], name: json['name'], email: json['email']);
  }
}

class ListView_JSON extends StatefulWidget {
  CustomListTileView createState() => CustomListTileView();
}

class CustomListTileView extends State<ListView_JSON> {
  final String apiURL = 'https://jsonplaceholder.typicode.com/users';

  Future<List<ParseJSON>> fetchJSON() async {
    var jsonResponse = await http.get(Uri.parse(apiURL));

    if (jsonResponse.statusCode == 200) {
      final jsonItems =
          json.decode(jsonResponse.body).cast<Map<String, dynamic>>();

      List<ParseJSON> tempList = jsonItems.map<ParseJSON>((json) {
        return ParseJSON.fromJson(json);
      }).toList();

      return tempList;
    } else {
      throw Exception('Failed To Load Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON ListTile ListView in Flutter'),
      ),
      body: FutureBuilder<List<ParseJSON>>(
        future: fetchJSON(),
        builder: (context, data) {
          if (data.hasError) {
            return Center(child: Text("${data.error}"));
          } else if (data.hasData) {
            var items = data.data as List<ParseJSON>;
            return ListView.builder(
                itemCount: items == null ? 0 : items.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                    title: Text(
                      items[index].name.toString(),
                    ),
                    onTap: () {
                      print(
                        items[index].name.toString(),
                      );
                    },
                    subtitle: Text(
                      items[index].email.toString(),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(items[index].name.toString()[0],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21.0,
                          )),
                    ),
                  ));
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}