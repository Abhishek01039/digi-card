import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:digicard/dbHelper.dart';
import 'package:digicard/firebaseCardService.dart';
import 'package:digicard/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:digicard/shared/utility.dart';
import 'package:digicard/view_model/cardViewModel.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// import 'package:http/http.dart';
class CardDetail extends StatefulWidget {
  final Map cardDataIndex;

  const CardDetail({Key key, this.cardDataIndex}) : super(key: key);
  @override
  _CardDetailState createState() => _CardDetailState();
}

class _CardDetailState extends State<CardDetail> {
  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.cardDataIndex['name']);

    companyController =
        TextEditingController(text: widget.cardDataIndex['company']);
    // jobController = TextEditingController(text: widget.cardDataIndex['name']);
    addController =
        TextEditingController(text: widget.cardDataIndex['address']);
    phoneController =
        TextEditingController(text: widget.cardDataIndex['phone']);
    phoneController2 =
        TextEditingController(text: widget.cardDataIndex['phone2']);
    emailController =
        TextEditingController(text: widget.cardDataIndex['email']);
    emailController2 =
        TextEditingController(text: widget.cardDataIndex['email2']);
    websiteController =
        TextEditingController(text: widget.cardDataIndex['website']);
    noteController = TextEditingController(text: widget.cardDataIndex['note']);
  }

  TextEditingController nameController;
  TextEditingController companyController;
  // TextEditingController jobController;
  TextEditingController addController;
  TextEditingController phoneController;
  TextEditingController phoneController2;
  TextEditingController emailController;
  TextEditingController emailController2;
  TextEditingController websiteController;

  TextEditingController noteController;

  // Future<void> _shareImageFromUrl() async {
  //   try {
  //     var request = await HttpClient().getUrl(
  //       Uri.parse(
  //           'https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'),
  //     );
  //     var response = await request.close();
  //     Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  //     await Share.file('Digi Card', 'amlog.jpg', bytes, 'image/jpg',
  //         text: "This is my text to share with other applications.");
  //     //     .then((value) {
  //     //   Share.text('my text title',
  //     //       'This is my text to share with other applications.', 'text/plain');
  //     // });
  //     // await _shareText();
  //   } catch (e) {
  //     print('error: $e');
  //   }
  // }

  final picker = ImagePicker();
  File _secondImage;
  final dbHelper = locator<DBHelper>();
  final CardServer _cardServer = new CardServer();

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Future<void> _shareText() async {
  //   try {
  //     Share.text('my text title',
  //         'This is my text to share with other applications.', 'text/plain');
  //   } catch (e) {
  //     print('error: $e');
  //   }
  // }
  String imageData;
  Future<void> _createFile(BuildContext contxt) async {
    cirularAlertDialog(context);
    final pdf = pw.Document();
    // var document = PdfDocument();
    //Add page and draw text to the page.
    // document.pages.add().graphics.drawImage(
    //       // 'Hello World!'
    //       PdfBitmap(_secondImage), Rect.fromLTWH(0, 0, 100, 100),
    //       // brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    //       // bounds: Rect.fromLTWH(0, 0, 500, 30)
    //     );
    var url = widget.cardDataIndex['image']; // <-- 1
    var response = await get(url);
    // Directory directory = await getApplicationDocumentsDirectory();
    final Directory directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String path2 = directory.path + "/image";
    String path3 = directory.path + "/image/hello.jpg";

    await Directory(path2).create(recursive: true);
    // await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = new File(path3);
    file2.writeAsBytesSync(response.bodyBytes);

    setState(() {
      imageData = path3;
    });
    final image = PdfImage.file(
      pdf.document,
      bytes: File(imageData).readAsBytesSync(),
    );
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pw.Image(image, height: 200, width: 400, fit: pw.BoxFit.fill),
                pw.SizedBox(height: 20),
                widget.cardDataIndex['name'] != ""
                    ? pw.Text("Full name :  ${widget.cardDataIndex['name']}")
                    : pw.Text("Full name :  -"),
                // pw.Text("Full Name : ${widget.cardDataIndex['name']}"),
                pw.SizedBox(height: 20),
                widget.cardDataIndex['company'] != ""
                    ? pw.Text("Company :  ${widget.cardDataIndex['company']}")
                    : pw.Text("Company :  -"),
                // pw.Text("compnay : ${widget.cardDataIndex['company']}"),
                pw.SizedBox(height: 20),
                widget.cardDataIndex['email'] != ""
                    ? pw.Text("Email :  ${widget.cardDataIndex['email']}")
                    : pw.Text("Email :  -"),
                pw.SizedBox(height: 20),
                widget.cardDataIndex['email2'] != ""
                    ? pw.Text(
                        "Second Email :  ${widget.cardDataIndex['email2']}")
                    : pw.Text("Second Email :  -"),
                // pw.Text("second email : ${widget.cardDataIndex['email2']}"),
                pw.SizedBox(height: 20),

                widget.cardDataIndex['phone'] != ""
                    ? pw.Text("Phone :  ${widget.cardDataIndex['phone']}")
                    : pw.Text("Phone :  -"),
                // pw.Text("phone : ${widget.cardDataIndex['phone']}"),
                pw.SizedBox(height: 20),
                widget.cardDataIndex['phone2'] != ""
                    ? pw.Text(
                        "Second Phone :  ${widget.cardDataIndex['phone2']}")
                    : pw.Text("Second Phone :  -"),
                // pw.Text("second phone : ${widget.cardDataIndex['phone2']}"),
                pw.SizedBox(height: 20),
                widget.cardDataIndex['website'] != ""
                    ? pw.Text("website :  ${widget.cardDataIndex['website']}")
                    : pw.Text("Website :  -"),
                // pw.Text("webiste : ${widget.cardDataIndex['website']}"),
                pw.SizedBox(height: 20),
                widget.cardDataIndex['note'] != ""
                    ? pw.Text("Note :  ${widget.cardDataIndex['note']}")
                    : pw.Text("Note :  -"),
                // pw.Text("note : ${widget.cardDataIndex['note']}"),
              ],
            ), // Center)
          );
        },
      ),
    );
    //Get external storage directory

    //Get directory path
    // String path = directory.path;
    // final file = File("example.pdf");
    File file = File('$path2/Share.pdf');
    await file.writeAsBytes(pdf.save());

    //Save the document
    // var bytes = document.save();
    // Dispose the document
    // print(bytes);

    //Create an empty file to write PDF data

    //Write PDF data
    // await file.writeAsBytes(bytes, flush: true);
    // try {

// File testFile = new File("${dir.path}/flutter/test.txt");
// if (!await testFile.exists()) {
    // await testFile.create(recursive: true);
    // testFile.writeAsStringSync("test for share documents file");
    Navigator.of(context, rootNavigator: true).pop();
    ShareExtend.share("$path2/Share.pdf", "text/pdf").whenComplete(() {
      //TODO: Delete the directory when complete sharing
      // final dir = Directory(path2);
      // dir.deleteSync(recursive: true);
      // print("deleted");
    });

    // final ByteData bytes = await rootBundle.load('$path2/Share.pdf');
    // await Share.file(
    //     'addresses', 'digicard.pdf', bytes.buffer.asUint8List(), 'text/pdf');
    // final dir = Directory('$path/Share.pdf');
    // dir.deleteSync(recursive: true);
    // } catch (e) {
    // print('error: $e');
    // }
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final CardViewModel _cardViewModel = Provider.of(context);
    getSecondImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _secondImage = File(pickedFile.path);
        });
        _cardServer.insertImage(_secondImage).then((value) async {
          if (value != null) {
            _cardViewModel.updateImageUrl(value, widget.cardDataIndex['id']);
          }
        });
      }
    }

    // final dbHelper = locator<DBHelper>();
    // dbHelper.getDataById(widget.cardDataIndex['id']);
    final imgList = [
      widget.cardDataIndex['image'],
      widget.cardDataIndex['image2'] == null ||
              widget.cardDataIndex['image2'] == ""
          ? _cardViewModel.imageUrl == null
              ? "https://static.addtoany.com/images/icon-200-3.png"
              : _cardViewModel.imageUrl
          : widget.cardDataIndex['image2'],
    ];
    // nameController.text = widget.cardDataIndex['name'];
    // companyController.text = widget.cardDataIndex['company'];
    // // jobController.text = widget.cardDataIndex.job;
    // addController.text = widget.cardDataIndex['address'];

    // phoneController.text = widget.cardDataIndex['phone'];
    // emailController.text = widget.cardDataIndex['email'];
    // websiteController.text = widget.cardDataIndex['website'];
    // noteController.text = widget.cardDataIndex['note'];
    final cardModel = Provider.of<CardViewModel>(context);
    final List<Widget> imageSliders = imgList
        .map(
          (item) => GestureDetector(
            onTap: () {
              if (item == "https://static.addtoany.com/images/icon-200-3.png") {
                getSecondImage();
              }
            },
            child: Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: item,
                        fit: BoxFit.fill,
                        width: 1000.0,
                      ),
                      // Positioned(
                      //   bottom: 0.0,
                      //   left: 0.0,
                      //   right: 0.0,
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       gradient: LinearGradient(
                      //         colors: [
                      //           Color.fromARGB(200, 0, 0, 0),
                      //           Color.fromARGB(0, 0, 0, 0)
                      //         ],
                      //         begin: Alignment.bottomCenter,
                      //         end: Alignment.topCenter,
                      //       ),
                      //     ),
                      //     padding: EdgeInsets.symmetric(
                      //         vertical: 10.0, horizontal: 20.0),
                      //     // child: Text(
                      //     //   'No. ${imgList.indexOf(item)} image',
                      //     //   style: TextStyle(
                      //     //     color: Colors.white,
                      //     //     fontSize: 20.0,
                      //     //     fontWeight: FontWeight.bold,
                      //     //   ),
                      //     // ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();

    showDiscardChanagesDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Discard changes?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Any changes you\'ve made to this card will be lost'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Discard'),
                onPressed: () {
                  // Navigator.of(context).pop();

                  cardModel.changeReset();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: CustomAppBarCardDetail(
        nameController: nameController,
        companyController: companyController,
        addController: addController,
        phoneController: phoneController,
        emailController: emailController,
        websiteController: websiteController,
        noteController: noteController,
        emailController2: emailController2,
        phoneController2: phoneController2,
        id: widget.cardDataIndex['id'],
        cardDataIndex: widget.cardDataIndex,
      ),
      body: WillPopScope(
        onWillPop: () async {
          // return true;
          if (!cardModel.isShowFABIcon) {
            showDiscardChanagesDialog();
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // SizedBox(
                //   height: 20,
                // ),
                Column(
                  children: [
                    Container(
                      // padding: EdgeInsets.all(5),
                      height: 200,
                      child: CarouselSlider(
                        items: imageSliders,
                        options: CarouselOptions(
                            height: 400,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            // autoPlay: true,
                            // autoPlayInterval: Duration(seconds: 3),
                            // autoPlayAnimationDuration: Duration(milliseconds: 800),
                            // autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            // onPageChanged: callbackFunction,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgList.map((url) {
                        int index = imgList.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _current == index ? Colors.blue : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: widget.cardDataIndex['phone'] != ""
                              ? IconButton(
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.blue[300],
                                  ),
                                  onPressed: () {
                                    _makePhoneCall(
                                        'tel:${widget.cardDataIndex['phone']}');
                                  },
                                )
                              : Icon(
                                  Icons.phone,
                                  color: Colors.grey,
                                ),
                        ),
                        Expanded(
                          child: widget.cardDataIndex['phone'] != ""
                              ? IconButton(
                                  icon: Icon(
                                    Icons.message,
                                    color: Colors.blue[300],
                                  ),
                                  onPressed: () {
                                    _makePhoneCall(
                                        'sms:${widget.cardDataIndex['phone']}');
                                  },
                                )
                              : Icon(
                                  Icons.message,
                                  color: Colors.grey,
                                ),
                        ),
                        Expanded(
                          child: widget.cardDataIndex['email'] != ""
                              ? IconButton(
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.blue[300],
                                  ),
                                  onPressed: () {
                                    _makePhoneCall(
                                        'sms:${widget.cardDataIndex['email']}');
                                  },
                                )
                              : Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                        ),
                        Expanded(
                          child: widget.cardDataIndex['address'] != ""
                              ? IconButton(
                                  icon: Icon(
                                    Icons.location_on,
                                    color: Colors.blue[300],
                                  ),
                                  onPressed: () {
                                    MapsLauncher.launchQuery(
                                      widget.cardDataIndex['address'],
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Full Name"),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: CardDetailTextField(
                        textEditingController: nameController,
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Company"),
                      ),
                    ),
                    Expanded(
                      child: CardDetailTextField(
                        textEditingController: companyController,
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.5,
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Padding(
                //         padding: const EdgeInsets.only(left: 10),
                //         child: Text("Job title"),
                //       ),
                //     ),
                //     // Expanded(
                //     //   child: CardDetailTextField(
                //     //     textEditingController: jobController,
                //     //   ),
                //     //   flex: 3,
                //     // ),
                //   ],
                // ),
                // Divider(
                //   thickness: 1.5,
                // ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Address"),
                      ),
                    ),
                    Expanded(
                      child: CardDetailTextField(
                        textEditingController: addController,
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.5,
                  // indent: 3,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Phone"),
                      ),
                    ),
                    Expanded(
                      child: CardDetailTextField(
                        textEditingController: phoneController,
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Email"),
                      ),
                    ),
                    Expanded(
                      child: CardDetailTextField(
                        textEditingController: emailController,
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Website"),
                      ),
                    ),
                    Expanded(
                      child: CardDetailTextField(
                        textEditingController: websiteController,
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Note"),
                      ),
                    ),
                    Expanded(
                      child: CardDetailTextField(
                        textEditingController: noteController,
                      ),
                      flex: 3,
                    ),
                  ],
                ),
                Divider(
                  thickness: 1.5,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Consumer<CardViewModel>(
        builder: (context, cardModel, _) {
          return cardModel.isShowFABIcon
              ? FloatingActionButton(
                  onPressed: () {
                    // _shareImageFromUrl();
                    _createFile(context);
                  },
                  child: Icon(Icons.share),
                )
              : Container();
        },
      ),
    );
  }
}

class CustomAppBarCardDetail extends StatelessWidget
    implements PreferredSizeWidget {
  // final CardModel cardDataIndex;

  final TextEditingController nameController;

  final TextEditingController companyController;

  final TextEditingController jobController;

  final TextEditingController addController;
  final TextEditingController phoneController2;
  final TextEditingController phoneController;
  final TextEditingController emailController2;
  final TextEditingController emailController;

  final TextEditingController websiteController;

  final TextEditingController noteController;
  final int id;
  final Map cardDataIndex;
  const CustomAppBarCardDetail({
    Key key,
    this.cardDataIndex,
    this.nameController,
    this.companyController,
    this.jobController,
    this.addController,
    this.phoneController2,
    this.phoneController,
    this.emailController2,
    this.emailController,
    this.websiteController,
    this.noteController,
    @required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbHelper = DBHelper();
    // final cardModel = Provider.of<CardViewModel>(context);
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text('Delete Card ?'),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete this card ?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () async {
                  // Navigator.of(context).pop();
                  // cardModel.deleteData(cardDataIndex['id']);
                  await dbHelper.opendatabase();
                  dbHelper
                      .deleteCard(cardDataIndex['id'])
                      .then((value) => null);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    showDiscardChanagesDialog() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text('Discard changes?'),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Any changes you\'ve made to this card will be lost'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Consumer<CardViewModel>(
                builder: (context, cardModel, _) {
                  return FlatButton(
                    child: Text('Discard'),
                    onPressed: () {
                      cardModel.changeReset();
                      // Navigator.of(context).pop();
                      // cardModel.deleteData(cardDataIndex.phone);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Consumer<CardViewModel>(
                  builder: (context, cardView, _) {
                    return IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        // Navigator.pop(context);
                        if (!cardView.isShowFABIcon) {
                          showDiscardChanagesDialog();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          nameController.text != null || nameController.text != ""
              ? Expanded(
                  flex: 4,
                  child: Text(
                    nameController.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                )
              : Container(),
          Consumer<CardViewModel>(
            builder: (context, cardModel, _) {
              return cardModel.isShowDeleteIcon
                  ? Expanded(
                      flex: 2,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.blue[300],
                        ),
                        onPressed: () {
                          _showMyDialog();
                        },
                      ),
                    )
                  : FlatButton(
                      onPressed: () async {
                        await dbHelper.opendatabase();
                        dbHelper
                            .updateCard(
                          nameController.text,
                          companyController.text,
                          addController.text,
                          phoneController.text,
                          phoneController2.text,
                          emailController.text,
                          emailController2.text,
                          websiteController.text,
                          noteController.text,
                          id,
                        )
                            .then((value) {
                          if (value == 1) {
                            cardModel.changeReset();
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: Text("SAVE"),
                    );
            },
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class CardDetailTextField extends StatefulWidget {
  final TextEditingController textEditingController;

  const CardDetailTextField({Key key, @required this.textEditingController})
      : super(key: key);

  @override
  _CardDetailTextFieldState createState() => _CardDetailTextFieldState();
}

class _CardDetailTextFieldState extends State<CardDetailTextField> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // final viewModel = locator<CardViewModel>();
    return Consumer<CardViewModel>(
      builder: (context, cardView, _) {
        return TextField(
          controller: widget.textEditingController,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          onChanged: (value) {
            // if (count == 0) {
            cardView.chagneState();
            // setState(() {
            // count = 1;
            // });
            // }
          },
        );
      },
    );
  }
}
