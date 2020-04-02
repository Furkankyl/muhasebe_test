import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:muhasebetest/app/helper/Constant.dart';
import 'package:muhasebetest/app/helper/CustomSharedPref.dart';
import 'package:muhasebetest/app/helper/CustomToast.dart';
import 'package:muhasebetest/app/model/FileModel.dart';
import 'package:muhasebetest/app/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBService {
  @override
  Future<User> signInUserIdAndPassword(String userId, String password) async {
    User user;
    String url = Constant.loginUrl;

    Map<String, String> map = Map();
    map['username'] = userId;
    map['password'] = password;
    map['token'] = "token";

    Response response = await post(url, body: map);
    var jsonData = "${response.body}";
    print('${response.body}');
    var parsedJson = json.decode(jsonData);

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        user = User.fromJson(parsedJson['data']);
        saveUser(user);
      } else {
        CustomToast.showCard(
            title: 'Hata',
            body: parsedJson['error'],
            trailing: Icon(
              Icons.error,
              color: Colors.red,
            ));
      }
    }

    return user;
  }

  @override
  Future<bool> createUser(
      String idNumber, String password, String phoneNumber) async {
    String url = Constant.signUpUrl;

    Map<String, String> map = Map();
    map['email'] = idNumber;
    map['password'] = password;
    map['telephone'] = phoneNumber;

    Response response = await post(url, body: map);
    var jsonData = "${response.body}";
    var parsedJson = json.decode(jsonData);
    print('${response.body}');

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        return true;
      } else {
        CustomToast.showCard(
            title: 'Hata',
            body: parsedJson['error'],
            trailing: Icon(
              Icons.error,
              color: Colors.red,
            ));
        return false;
      }
    }

    return false;
  }

  Future<User> getCurrentUser() async {
    SharedPref sp = SharedPref(await SharedPreferences.getInstance());
    User user = sp.getUser();

    return Future.value(user.id == 0 ? null : user);
  }

  saveUser(User user) async {
    SharedPref sp = SharedPref(await SharedPreferences.getInstance());
    sp.setUser(user);
  }

  Map<DateTime, List<FileModel>> data = Map();

  Future<Map<DateTime, List<FileModel>>> getFiles(
      DateTime date, int day) async {
    String url = Constant.getFiles + "${(await getCurrentUser()).id}";

    Map<String, String> map = Map();
    map['date'] = DateFormat("yyyy-MM").format(date);
    map['months'] = day.toString();

    Response response = await post(url, body: map);
    var jsonData = "${response.body}";
    var parsedJson = json.decode(jsonData);

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        data.clear();
        parsedJson['days'].keys.forEach((key) {
          List<FileModel> tmpFileList = [];
          parsedJson['days'][key].forEach((fileJson) {
            tmpFileList.add(FileModel.fromJson(fileJson));
          });
          data.addAll({DateFormat("yyyy-MM").parse(key): tmpFileList});
        });
        for (int i = 0; i < day; i++) {}
        return data;
      } else {
        CustomToast.showCard(
            title: 'Hata',
            body: parsedJson['error'],
            trailing: Icon(
              Icons.error,
              color: Colors.red,
            ));
      }
    }

    return null;
  }

  Future<bool> fileUpdate(FileModel file) async {
    print(file.id);
    String url = Constant.updateFile + "${file.id}";

    Map<String, String> map = Map();
    map['name'] = file.name;
    map['url'] = file.url;
    map['date'] = DateFormat("yyyy-MM-dd").format(file.date);
    map['editingDate'] = DateFormat("yyyy-MM-dd").format(file.editingDate);

    Response response = await post(url, body: map);
    var jsonData = "${response.body}";
    var parsedJson = json.decode(jsonData);
    print('${response.body}');

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        return true;
      } else {
        CustomToast.showCard(
            title: 'Hata',
            body: parsedJson['error'],
            trailing: Icon(
              Icons.error,
              color: Colors.red,
            ));
        return false;
      }
    }

    return false;
  }

  Future<int> fileInsert(FileModel file) async {
    print("${(await getCurrentUser()).id}");
    String url = Constant.addFile + "${(await getCurrentUser()).id}";

    Map<String, String> map = Map();
    map['name'] = file.name;
    map['url'] = file.url;
    map['date'] = DateFormat("yyyy-MM-dd").format(file.date);
    map['editingDate'] = DateFormat("yyyy-MM-dd").format(file.editingDate);

    Response response = await post(url, body: map);
    var jsonData = "${response.body}";
    var parsedJson = json.decode(jsonData);
    print('${response.body}');

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        return parsedJson['data']['id'];
      } else {
        CustomToast.showCard(
            title: 'Hata',
            body: parsedJson['error'],
            trailing: Icon(
              Icons.error,
              color: Colors.red,
            ));
        return null;
      }
    }

    return null;
  }

  Future<bool> fileRemove(int fileId) async {
    String url = Constant.deleteFile + "$fileId";

    Response response = await get(url);
    var jsonData = "${response.body}";
    var parsedJson = json.decode(jsonData);
    print('${response.body}');

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        return true;
      } else {
        CustomToast.showCard(
            title: 'Hata',
            body: parsedJson['error'],
            trailing: Icon(
              Icons.error,
              color: Colors.red,
            ));
        return false;
      }
    }

    return false;
  }

  sendApplicationForm(
      {String username,
      String companyName,
      String companyPersonName,
      String companyPersonLastName,
      String telephone,
      String cellPhone,
      String email,
      String companyTaxOffice,
      String taxNumber,
      String countryId,
      String disctrictId,
      String zoneId,
      String quarterId,
      String companyAddress}) async {
    String url = Constant.accountFormUrl + "${(await getCurrentUser()).id}";

    Map<String, String> map = Map();
    map['company_name'] = companyName;
    map['company_person_name'] = companyPersonName;
    map['company_person_lastname'] = companyPersonLastName;

    map['telephone'] = telephone;
    map['cellphone'] = cellPhone;
    map['email'] = email;

    map['company_tax_office'] = companyTaxOffice;
    map['tax_number'] = taxNumber;
    map['country_id'] = countryId;
    map['district_id'] = disctrictId;
    map['zone_id'] = zoneId;
    map['quarter_id'] = quarterId;
    map['company_address'] = companyAddress;

    Response response = await post(url, body: map);
    var jsonData = "${response.body}";
    var parsedJson = json.decode(jsonData);
    print('${response.body}');

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        return true;
      } else {
        CustomToast.showCard(
            title: 'Hata',
            body: parsedJson['error'],
            trailing: Icon(
              Icons.error,
              color: Colors.red,
            ));
        return false;
      }
    }

    return false;
  }

  changePassword(String text) async {
    String url = Constant.accountFormUrl + "${(await getCurrentUser()).id}";

    Map<String, String> map = Map();

    map['password'] = text;

    Response response = await post(url, body: map);
    var jsonData = "${response.body}";
    var parsedJson = json.decode(jsonData);
    print('${response.body}');

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        return true;
      } else {
        CustomToast.showCard(
            title: 'Hata',
            body: parsedJson['error'],
            trailing: Icon(
              Icons.error,
              color: Colors.red,
            ));
        return false;
      }
    }

    return false;
  }
}
