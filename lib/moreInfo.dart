import 'package:digicard/settings.dart';
import 'package:digicard/upgradeToPremium.dart';
import 'package:digicard/webViewScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MoreInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: MediaQuery.of(context).padding.top - 10),
                children: [
                  InkWell(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.black,
                      elevation: 10,
                      color: Colors.white,
                      child: Container(
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Container(
                                  child: Icon(
                                    FontAwesomeIcons.solidFileExcel,
                                    color: Colors.white,
                                  ),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                    color: Colors.blue[300],
                                  ),
                                  // width: double.infinity,
                                ),
                                // color: Colors.blue[300],
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Export"),
                              ),
                              flex: 7,
                            ),
                            Expanded(
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      color: Colors.white,
                      child: Container(
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Icon(
                                  FontAwesomeIcons.shareAlt,
                                  color: Colors.white,
                                ),
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                  ),
                                  color: Colors.blue[300],
                                ),
                                // width: double.infinity,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Love it? Share it!"),
                              ),
                              flex: 7,
                            ),
                            Expanded(child: Icon(Icons.arrow_forward_ios)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      //webview
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WebViewScreen(),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      color: Colors.white,
                      child: Container(
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Icon(
                                  FontAwesomeIcons.appStore,
                                  color: Colors.white,
                                ),
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                  ),
                                  color: Colors.blue[300],
                                ),
                                // width: double.infinity,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Checkout our contacts app!",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              flex: 7,
                            ),
                            Expanded(child: Icon(Icons.arrow_forward_ios)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (_) => UpgradeToPremium(),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      color: Colors.white,
                      child: Container(
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Icon(
                                  FontAwesomeIcons.infinity,
                                  color: Colors.white,
                                ),
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                  ),
                                  color: Colors.blue[300],
                                ),
                                // width: double.infinity,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Upgrade to Premium"),
                              ),
                              flex: 7,
                            ),
                            Expanded(
                              child: Icon(Icons.arrow_forward_ios),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      child: Container(
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                  ),
                                  color: Colors.blue[300],
                                ),
                                // width: double.infinity,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text("Settings"),
                              ),
                              flex: 7,
                            ),
                            Expanded(
                              child: Icon(Icons.arrow_forward_ios),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    // color: Colors.black26,
                    // width: MediaQuery.of(context).size.width,
                    // padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text("Have a question?"),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Contact : shirajsayed13@gmail.com"),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
