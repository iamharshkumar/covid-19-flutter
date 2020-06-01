import 'package:covid19/data.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQs"),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(DataSource.questionAnswers[index]['question'], style: TextStyle(fontWeight: FontWeight.bold),),
          children: <Widget>[
            Text(DataSource.questionAnswers[index]['answer'])
          ],
        );
      },
      itemCount: DataSource.questionAnswers.length,),
    );
  }
}
