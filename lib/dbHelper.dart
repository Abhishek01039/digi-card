import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:core';

// import 'package:flutter/material.dart';

class DBHelper {
  Database database;
  // DBHelper() {
  //   opendatabase();
  // }
  opendatabase() async {
// Delete the database
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "card.db");
    // await deleteDatabase(path);

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
        'CREATE TABLE tbl_test (id INTEGER PRIMARY KEY, image TEXT,image2 TEXT, name TEXT, company TEXT,address TEXT,phone TEXT,phone2 TEXT,email TEXT,email2 TEXT, website TEXT,note TEXT)',
      );
    });
  }

// open the database
  Future<int> insertCard(
    String image, {
    String name,
    String company,
    String address,
    String phone,
    String phone2,
    String email,
    String email2,
    String website,
    String note,
  }) async {
    // Insert some records in a transaction
    int id2;
    await database.transaction((txn) async {
      // int id1 = await txn.rawInsert(
      //     'INSERT INTO tbl_test(Card, code, format) VALUES($Card, $code, $format)');
      // print('inserted1: $id1');
      id2 = await txn.rawInsert(
          'INSERT INTO tbl_test(image, image2, name, company, address, phone, phone2, email, email2, website, note) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            image,
            "",
            name,
            company,
            address,
            phone ?? "",
            phone2 ?? "",
            email ?? "",
            email2 ?? "",
            website,
            note
          ]);
      // print('inserted2: $id2');
    });
    return id2;
    // assert(count == 1);
    // return null;
  }

  getDataById(int id) async {
    List<Map> list =
        await database.rawQuery('SELECT * FROM tbl_test where id=?', [id]);
    // List<Map> expectedList = [
    //   {'Card': 'updated name', 'id': 1, 'code': "9876", 'format': '456.789'},
    //   {
    //     'Card': 'another name',
    //     'id': 2,
    //     'code': '12345678',
    //     'format': '3.1416'
    //   }
    // ];
    // print(list);
    // print(list[0]['id']);
    return list;
  }

  Future<int> updateCard(
    String name,
    String company,
    String address,
    String phone,
    String phone2,
    String email,
    String email2,
    String website,
    String note,
    int id,
  ) async {
    // Update some record
    int count = await database.rawUpdate(
        'UPDATE tbl_test SET name=?, company=?, address=?, phone=?, phone2=?, email=?, email2=?, website=?, note=? where id=?',
        [
          name,
          company,
          address,
          phone,
          phone2,
          email,
          email2,
          website,
          note,
          id
        ]);
    // print('updated: $count');
    return count;
  }

  Future<int> updateImage(String image, int id) async {
    int count = await database
        .rawUpdate('UPDATE tbl_test SET image2 = ? where id = ?', [image, id]);
    // print('updated: $count');
    return count;
  }

  Future<List<Map>> getCard() async {
    // Get the records
    List<Map> list = await database.rawQuery('SELECT * FROM tbl_test');
    // List<Map> expectedList = [
    //   {'Card': 'updated name', 'id': 1, 'code': "9876", 'format': '456.789'},
    //   {
    //     'Card': 'another name',
    //     'id': 2,
    //     'code': '12345678',
    //     'format': '3.1416'
    //   }
    // ];
    // print(list);
    // print(list[0]['id']);
    return list;
    // print(expectedList);
  }

// Count the records
  countCard() async {
    var count = Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM tbl_test'));
    // print(count);
    return count;
  }

// Delete a record
  Future<int> deleteCard(int id) async {
    var count =
        await database.rawDelete('DELETE FROM tbl_test WHERE id = ?', [id]);
    // print(count);
    // assert(count == 1);
    return count;
  }

  Future<int> deleteAllRecord() async {
    var count = await database.delete('tbl_test');
    // print(count);
    // assert(count == 1);
    return count;
  }

  Future<List<Map>> searchCard(String query) async {
    List<Map> list = await database.rawQuery(
        "SELECT * FROM tbl_test WHERE name LIKE '%$query%' OR company LIKE '%$query%' OR address LIKE '%$query%' OR phone LIKE '%$query%' OR phone2 LIKE '%$query%' OR email LIKE '%$query%' OR email2 LIKE '%$query%' OR website LIKE '%$query%' OR note LIKE '%$query%'");
    return list;
  }

  closeCard() async {
    await database.close();
  }
// Close the database

}
