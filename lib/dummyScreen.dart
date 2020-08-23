import 'package:flutter/material.dart';

class HomeScreenDummy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              color: Colors.amber,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.black,
                      height: 100,
                    ),
                    Container(
                      color: Colors.black87,
                      height: 100,
                    ),
                    Container(
                      color: Colors.yellow,
                      height: 100,
                    ),
                    Container(
                      color: Colors.deepOrangeAccent,
                      height: 100,
                    ),
                    Container(
                      color: Colors.indigo,
                      height: 100,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
