import 'dart:async';

// import 'package:booksharing/UI/views/shared_pref.dart';

import 'package:digicard/dbHelper.dart';
import 'package:digicard/locator.dart';
import 'package:digicard/main.dart';
import 'package:flutter/material.dart';

class MySpalshScreen extends StatefulWidget {
  @override
  _MySpalshScreenState createState() => _MySpalshScreenState();
}

class _MySpalshScreenState extends State<MySpalshScreen>
    with WidgetsBindingObserver {
//ProgressDialog pr;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    // SPHelper.logout();
    database();
    _updateConnectionStatus();
  }

  database() async {
    final dbHelper = locator<DBHelper>();
    await dbHelper.opendatabase();
    // await dbHelper.getSample();
    // await dbHelper.insertSample();

    // await dbHelper.deleteAllRecord();
    // await dbHelper.getSample();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  Future<void> _updateConnectionStatus() async {
    // print(_connectionStatus);

    Timer(Duration(seconds: 3), () {
      // print(SPHelper.getString("enrollmentNo"));
      // print(box.get("studentName"));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MyHomePage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  child: FlutterLogo(
                    size: 100,
                  ),
                  // borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
