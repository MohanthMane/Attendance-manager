import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  var subjects;
  var percentage;
  var present, absent, total;

  Info(this.subjects) {
    this.present = 0;
    this.absent = 0;
    for (var s in subjects) {
      this.present += s['present'];
      this.absent += s['absent'];
    }

    this.total = this.present + this.absent;

    this.percentage = (this.total != 0)
        ? ((this.present * 100 / this.total))
        : 0;
    
    this.percentage = double.parse(this.percentage.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendace report'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Align(
                child: Text(
                  '$percentage%',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 75),
                ),
                alignment: Alignment.topCenter,
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                child: Text(
                  'You have attended ${this.present} from a total of ${this.total} classes',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.left,
                ),
                alignment: Alignment.topLeft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
