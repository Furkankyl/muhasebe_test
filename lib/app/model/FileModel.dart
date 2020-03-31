import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class FileModel {
  int id;
  String name;
  String url;
  DateTime date;
  DateTime editingDate;

  FileModel({this.id, @required this.name,@required this.url,@required this.date, @required this.editingDate});


  FileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    date = DateTime.now();
    editingDate = DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.toString(),
      "name": name,
      "url": url,
      "date": DateFormat("yyyy-MM-dd HH:mm").format(date),
      "editingDate": DateFormat("yyyy-MM-dd HH:mm").format(editingDate),
    };
  }

  @override
  String toString() {
    return 'FileModel{id: $id, name: $name, url: $url, date: $date, editingDate: $editingDate}';
  }


}
