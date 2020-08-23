import 'package:digicard/dbHelper.dart';
import 'package:digicard/locator.dart';
import 'package:digicard/model/cardModel.dart';
import 'package:flutter/cupertino.dart';

class CardViewModel extends ChangeNotifier {
  List<CardModel> searchCardData = <CardModel>[];
  bool isSearch = false;
  bool isShowDeleteIcon = true;
  bool isShowFABIcon = true;
  bool isShowLoadingIndicator = false;
  List data = [];
  final dbHelper = locator<DBHelper>();
  String imageUrl;
  int cardNo = 0;
  CardViewModel() {
    getData();
  }

  updateImageUrl(String value, int id) async {
    await dbHelper.opendatabase();
    dbHelper.updateImage(value, id).then((va) {
      if (va == 1) {
        imageUrl = value;
      }
      notifyListeners();
    });
  }

  getData() async {
    await dbHelper.opendatabase();
    data = await dbHelper.getCard();
    notifyListeners();
  }

  List<CardModel> cardData = [
    CardModel(
      add: "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA",
      email: "abhishekghaskata1999@gmail.com",
      phone: "8530172127",
      fullName: "VISA card",
    ),
    CardModel(
      add: "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA",
      phone: "9726703638",
      fullName: "hello card",
    ),
    CardModel(
      add: "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA",
      email: "abhishekghaskata1999@gmail.com",
      phone: "9004879919",
      fullName: "ICICI card",
    ),
    CardModel(
      add: "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA",
      email: "abhishekghaskata1999@gmail.com",
      phone: "9879324099",
      fullName: "IDBI card",
    ),
    CardModel(
      add: "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA",
      email: "abhishekghaskata1999@gmail.com",
      phone: "9537901039",
      fullName: "VISA card",
    ),
    CardModel(
      add: "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA",
      email: "abhishekghaskata1999@gmail.com",
      phone: "8160119895",
      fullName: "VISA card",
    ),
  ];

  deleteData(String phone) {
    cardData.removeWhere(
      (element) => element.phone == phone,
    );
    notifyListeners();
  }

  hasNodeFocus() {
    isSearch = true;
    notifyListeners();
  }

  searchShowList(String value) {
    if (value == "") {
      isSearch = false;
    } else {
      searchCardData.clear();
      for (var i in cardData) {
        if (i.phone.contains(value)) {
          searchCardData.add(i);
        }
      }
      print(searchCardData);
    }
    notifyListeners();
  }

  chagneState() {
    isShowDeleteIcon = false;
    isShowFABIcon = false;
    notifyListeners();
  }

  getLength() async {
    await dbHelper.opendatabase();
    cardNo = await dbHelper.countCard();
    notifyListeners();
  }

  changeLoadingState() {
    isShowLoadingIndicator = !isShowLoadingIndicator;
    notifyListeners();
  }

  changeReset() {
    isShowDeleteIcon = true;
    isShowFABIcon = true;
    notifyListeners();
  }
}
