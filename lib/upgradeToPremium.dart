import 'package:flutter/material.dart';

class UpgradeToPremium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpdagradeToPremiumDetail(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Text(
                "Upgrade to Premium",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 34,
              ),
              Text("Get unlimited card scans today!"),
              SizedBox(
                height: MediaQuery.of(context).size.height / 11,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("50 CARDS"),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Text(
                          "₹169.00",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blue,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "ONE-OFF",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("50 CARDS"),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        Text(
                          "₹549.00",
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blue,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "ONE-OFF",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
              Center(
                child: Text("Payments are one-off and last a lifetime!"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Center(
                child: Text("RESTORE PURCHASES"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 15,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        // child: Container(
        //   // height: 100,
        //   // width: MediaQuery.of(context).size.width,
        //   color: Colors.grey,
        //   child: Center(),
        // ),
        child: Container(
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Have a question!"),
                Text("Contact support@shirajsayad13@gmail.com"),
              ],
            ),
          ),
          height: 100,
        ),
      ),
    );
  }
}

class UpdagradeToPremiumDetail extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 10,
          top: MediaQuery.of(context).padding.top,
          child: IconButton(
            icon: Icon(
              Icons.close,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
