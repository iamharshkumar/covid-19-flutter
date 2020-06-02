import 'package:covid19/pages/districtSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IndiaPage extends StatefulWidget {
  @override
  _IndiaPageState createState() => _IndiaPageState();
}

class _IndiaPageState extends State<IndiaPage> {
  List countryData;
  List indiaData;
  var districtData = [];

  fetchCountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  fetchIndiaData() async {
    http.Response response = await http
        .get('https://api.covid19india.org/v2/state_district_wise.json');
    setState(() {
      indiaData = json.decode(response.body);
    });

    for (var i = 0; i < indiaData.length; i++) {
      for (var j = 0; j < indiaData[i]['districtData'].length; j++) {
        districtData.add(indiaData[i]['districtData'][j]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchIndiaData();
    fetchCountryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: DistrictSearch(districtData));
            },
          )
        ],
        title: Text("India State"),
      ),
      body: indiaData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    indiaData[index]['state'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: indiaData[index]['districtData'].length,
                        itemBuilder: (context, i) {
                          return Card(
                            child: Container(
                              height: 130,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          indiaData[index]['districtData'][i]
                                              ['district'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            "CONFIRMED:" +
                                                indiaData[index]['districtData']
                                                        [i]['confirmed']
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                          Text(
                                            "ACTIVE:" +
                                                indiaData[index]['districtData']
                                                        [i]['active']
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          Text(
                                            "RECOVERED:" +
                                                indiaData[index]['districtData']
                                                        [i]['recovered']
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                          Text(
                                            "DEATHS:" +
                                                indiaData[index]['districtData']
                                                        [i]['deceased']
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                );
              },
              itemCount: indiaData.length,
            ),
    );
  }
}
