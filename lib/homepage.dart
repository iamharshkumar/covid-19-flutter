import 'dart:convert';

import 'package:covid19/data.dart';
import 'package:covid19/pages/countryPage.dart';
import 'package:covid19/pages/india.dart';
import 'package:covid19/panels/infopanel.dart';
import 'package:covid19/panels/mosteffectedcountries.dart';
import 'package:covid19/panels/worldwidepanel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:covid19/bloc/theme.dart';


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Map worldData;
  List countryData;

  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  fetchCountryData() async {
    http.Response response =
    await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  Future fetchData() async {
    fetchWorldWideData();
    fetchCountryData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Theme
                .of(context)
                .brightness == Brightness.light
                ? Icons.lightbulb_outline
                : Icons.highlight),
            onPressed: () {
              Theme.of(context).brightness == Brightness.light ? _themeChanger.setTheme(
                  ThemeData.dark()) : _themeChanger.setTheme(ThemeData.light());
            },
          )
        ],
        title: Text("COVID-19 TRACKER"),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  height: 100,
                  color: Colors.orange[100],
                  child: Text(
                    DataSource.quote,
                    style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Worldwide',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => IndiaPage()));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
//                      margin: EdgeInsets.only(left: 140),
                              decoration: BoxDecoration(
                                  color: primaryBlack,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                'India states',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CountryPage()));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: primaryBlack,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                'Regional',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                worldData == null
                    ? Container()
                    : PieChart(
                  dataMap: {
                    'Confirmed': worldData['cases'].toDouble(),
                    'Active': worldData['active'].toDouble(),
                    'Recovered': worldData['recovered'].toDouble(),
                    'Deaths': worldData['deaths'].toDouble(),
                  },
                  colorList: [
                    Colors.deepOrangeAccent,
                    Colors.blue,
                    Colors.green,
                    Colors.red,
                  ],
                ),
                worldData == null
                    ? Center(child: CircularProgressIndicator())
                    : WorldwidePanel(worldData: worldData),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
                  child: Text(
                    'Most affected Countries',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                countryData == null
                    ? Container()
                    : MostAffectedPanel(
                  countryData: countryData,
                ),
                SizedBox(
                  height: 30,
                ),
                InfoPanel(),
                SizedBox(
                  height: 50,
                ),
                Center(
                    child: Text(
                      "WE ARE TOGETHER IN THE FIGHT",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                SizedBox(
                  height: 50,
                ),
              ],
            )),
      ),
    );
  }
}
