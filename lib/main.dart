import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:digicard/cardDetailt.dart';
import 'package:digicard/dbHelper.dart';
import 'package:digicard/firebaseCardService.dart';
import 'package:digicard/loadingScreen.dart';
import 'package:digicard/locator.dart';

import 'package:digicard/moreInfo.dart';
import 'package:digicard/splashScreen.dart';
import 'package:digicard/view_model/cardViewModel.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    setupLocator();
    runApp(MyApp());
  });
  // setupLocator();
  // CustomImageCache();

  // runApp(
  //   // _devicePreview(
  //   //   enabled: !kReleaseMode,
  //   //   builder: (context) => MyApp(),
  //   // ),
  //   MyApp(),
  // );
}

class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    // Set your image cache size
    imageCache.maximumSize = 10;
    return imageCache;
  }
}

// Widget _devicePreview({bool enabled, WidgetBuilder builder}) {
//   return MaterialApp(
//     // <~ for DevicePreview (1)
//     home: Scaffold(
//       body: DevicePreview(
//         enabled: enabled,
//         builder: builder,
//       ),
//     ),
//   );
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CardViewModel()),
      ],
      child: MaterialApp(
        title: 'Digi Card',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,

          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MySpalshScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = locator<DBHelper>();
  final _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    database();
  }

  database() async {
    await dbHelper.opendatabase();
    // await dbHelper.getCard();
    // await dbHelper.countCard();
    // await dbHelper.deleteAllRecord();
  }

  File _image;

  // TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

  final picker = ImagePicker();
  String base64Image;
  String text = "";
  List<String> email = <String>[];
  List<String> phone = <String>[];
  String add = "";
  String website = '';
  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  bool isPhone(String em) {
    String p = r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  bool isPhoneNumber(String em) {
    String p = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  bool isPhoneNumber2(String em) {
    String p =
        r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  bool isInternationalPhone(String em) {
    String p = r'^\+[1-9]{1}[0-9]{3,14}$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  bool isWebsite(String em) {
    String p =
        r'(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  @override
  Widget build(BuildContext context) {
    final cardModel = Provider.of<CardViewModel>(context);
    final CardServer _cardServer = new CardServer();

    // cardModel.getLength();
    converIntoBase64() async {
      // setState(() {
      //   List<int> imageBytes = _image.readAsBytesSync();
      //   base64Image = base64Encode(imageBytes);
      //   // print(base64Image);
      //   _bytesImage = Base64Decoder().convert(base64Image);
      // });

      _cardServer.insertImage(_image).then((value) async {
        cardModel.changeLoadingState();
        if (value != null) {
          await dbHelper.opendatabase();
          dbHelper
              .insertCard(
            value,
            address: "address",
            company: "company",
            email2: email.length != 2 ? null : email[1],
            name: "name",
            note: "note",
            website: website,
            phone: phone.length != 1 ? null : phone[0],
            phone2: phone.length != 2 ? null : phone[1],
            email: email.length != 1 ? null : email[0],
          )
              .then((value) {
            cardModel.getLength();
            //TODO : navigate the screen
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => CardDetail(),
            //   ),
            // );
          });
        }
      });
    }

    Future getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        cardModel.changeLoadingState();
        setState(() {
          _image = File(pickedFile.path);
          // print(_image);
        });

        TextRecognizer textRecognizer =
            FirebaseVision.instance.textRecognizer();
        FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_image);
        VisionText visionText = await textRecognizer.processImage(visionImage);
        email.clear();
        add = "";
        website = "";
        phone.clear();
        for (TextBlock block in visionText.blocks) {
          for (TextLine line in block.lines) {
            for (TextElement word in line.elements) {
              // if (word.text.contains("email") ||
              //     word.text.contains("Email") ||
              //     word.text.contains("E-mail") ||
              //     word.text.contains("e-mail") ||
              //     word.text.contains("EMAIL") ||
              //     word.text.contains("E-MAIL")) {
              //   setState(() {
              //     email.add(word.text
              //         .substring(word.text.indexOf(":") + 1, word.text.length)
              //         .trim());
              //     print(email);
              //   });
              // } else {
              if (isEmail(word.text)) {
                setState(() {
                  email.add(word.text);
                });
              }
              // }
              // if (word.text.contains("tel") ||
              //     word.text.contains("tel:") ||
              //     word.text.contains("phone") ||
              //     word.text.contains("mobile") ||
              //     word.text.contains("PHONE") ||
              //     word.text.contains("TEL") ||
              //     word.text.contains("TEL:")) {
              //   setState(() {
              //     phone.add(word.text
              //         .substring(word.text.indexOf(":") + 1, word.text.length)
              //         .trim());
              //   });
              // } else {
              if (isPhone(word.text) ||
                  isInternationalPhone(word.text) ||
                  isPhoneNumber(word.text) ||
                  isPhoneNumber2(word.text)) {
                setState(() {
                  phone.add(word.text);
                });
              }
              // }

              if (isWebsite(word.text)) {
                setState(() {
                  website = word.text;
                });
              }
              setState(() {
                text = text + word.text + ' ';
              });
            }
            text = text + '\n';
          }
        }
        textRecognizer.close();
        // print(text);

        // print(website);
        // print(phone);
        // print(email);
      }
      converIntoBase64();
    }

    return SafeArea(
      child: cardModel.isShowLoadingIndicator
          ? LoadingScreen()
          : Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: CustomAppBar(
                textEditionController: _textEditingController,
              ),
              body: !cardModel.isSearch
                  ? Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          future: dbHelper.getCard(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData)
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            if (snapshot.data.length == 0) {
                              return Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 70,
                                        backgroundColor: Colors.blue[300],
                                        child: Icon(
                                          FontAwesomeIcons.creditCard,
                                          size: 50,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "No cards added yet",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Wrap(
                                        children: [
                                          Text(
                                              "Open the camera and start adding business"),
                                        ],
                                      ),
                                      Text("cards to your library!"),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CardDetail(
                                              cardDataIndex:
                                                  snapshot.data[index],
                                            ),
                                          ),
                                        ).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.black,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              right: 10, left: 10),
                                          height: 110,
                                          // child: ListTile(
                                          //   title: Text(
                                          //     "VISA",
                                          //     style: TextStyle(color: Colors.blue[300]),
                                          //   ),
                                          //   trailing: Container(
                                          //     width: 120,
                                          //     height: double.infinity,
                                          //     child: Image.network(
                                          //       "https://www.yesbank.in/squareimages/YES_Prosperity_Platinum_Debit_card%20_Banner_image_YBL%20Prosperity_Debit%20%20Platinum%20NFC%20(Dec%202016)%20CS4_website.png",
                                          //       fit: BoxFit.fill,
                                          //       // height: 100,
                                          //       // width: 200,
                                          //     ),
                                          //   ),
                                          //   subtitle: Padding(
                                          //     padding: const EdgeInsets.only(top: 50),
                                          //     child: Text("7/26/20"),
                                          //   ),
                                          // ),
                                          child: Row(
                                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    snapshot.data[index]['name']
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.blue[300],
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   height: 40,
                                                  // ),
                                                  Text(
                                                    snapshot.data[index]
                                                        ['company'],
                                                  ),
                                                ],
                                              ),
                                              CachedNetworkImage(
                                                // placeholder: (context, url) =>
                                                //     Container(
                                                //   child: Card(
                                                //     child: FlutterLogo(),
                                                //     elevation: 10,
                                                //   ),
                                                // ),
                                                height: 80,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                fit: BoxFit.fill,
                                                imageUrl: snapshot.data[index]
                                                    ['image'],
                                              ),
                                              // Image.network(
                                              //   snapshot.data[index]['image'],
                                              //   fit: BoxFit.fill,
                                              //   width: MediaQuery.of(context)
                                              //           .size
                                              //           .width /
                                              //       2.5,
                                              //   height: 80,
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          future:
                              dbHelper.searchCard(_textEditingController.text),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData)
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            if (snapshot.data.length == 0) {
                              return Center(
                                child: Text(
                                  "No cards found",
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }
                            return Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 12),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CardDetail(
                                              cardDataIndex:
                                                  snapshot.data[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 10,
                                        shadowColor: Colors.black,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              right: 10, left: 10),
                                          height: 110,
                                          child: Row(
                                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    snapshot.data[index]['name']
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.blue[300],
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   height: 40,
                                                  // ),
                                                  Text(
                                                    snapshot.data[index]
                                                        ['company'],
                                                  ),
                                                ],
                                              ),
                                              CachedNetworkImage(
                                                // placeholder: (context, url) =>
                                                //     Container(
                                                //   height: 80,
                                                //   width: MediaQuery.of(context)
                                                //           .size
                                                //           .width /
                                                //       3,
                                                //   child: Card(
                                                //     child: FlutterLogo(),
                                                //   ),
                                                // ),
                                                height: 80,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                fit: BoxFit.fill,
                                                imageUrl: snapshot.data[index]
                                                    ['image'],
                                              ),
                                              // Image.network(
                                              //   snapshot.data[index]['image'],
                                              //   fit: BoxFit.fill,
                                              //   width: MediaQuery.of(context)
                                              //           .size
                                              //           .width /
                                              //       2.5,
                                              //   height: 80,
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) {
                  //       String id = DateTime.now().toIso8601String();
                  //       print("id => $id");
                  //       return CameraApp(id: id);
                  //     },
                  //   ),
                  // );
                  getImage();
                },
                tooltip: 'Pick Image',
                child: Icon(
                  Icons.camera_alt,
                ),
              ),
            ),
    );
  }
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final textEditionController;

  const CustomAppBar({Key key, this.textEditionController}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(58);
}

class _CustomAppBarState extends State<CustomAppBar> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final focusNode = new FocusNode();
    final cardModel = Provider.of<CardViewModel>(context);
    cardModel.getLength();
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      prefixIcon: IconButton(
                        icon: focusNode.hasFocus
                            ? Icon(
                                Icons.arrow_back,
                                // color: Colors.white,
                              )
                            : Icon(
                                Icons.search,
                                // color: Colors.white,
                              ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              return widget.textEditionController.clear();
                            },
                          );
                          // clear conten
                        },
                      ),
                      fillColor:
                          cardModel.cardNo == 0 ? Colors.grey : Colors.white,
                      contentPadding: EdgeInsets.only(
                        left: 15,
                        bottom: 11,
                        top: 11,
                        right: 15,
                      ),
                      hintText: "Search",
                      // hintStyle: TextStyle(color: Colors.white),
                    ),
                    focusNode: focusNode,
                    onTap: () {
                      if (count == 0) {
                        FocusScope.of(context).requestFocus(focusNode);
                        setState(() {
                          count = 1;
                        });
                      }
                    },
                    enableInteractiveSelection: false,
                    enabled: cardModel.cardNo == 0 ? false : true,
                    onChanged: (value) {
                      cardModel.hasNodeFocus();
                      cardModel.searchShowList(value);
                    },
                    controller: widget.textEditionController,
                  ),
                ),
              ),
              // SizedBox(
              //   width: 10,
              // ),

              Expanded(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (_) => MoreInfo(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.more_vert,
                    size: 33,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // @override
  // Size get preferredSize => ;
}
