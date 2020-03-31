


class User {



  int id;
  String userName;
  String idNumber;


  User({this.id, this.userName, this.idNumber});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['displayName'];
    idNumber = json['idNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['displayName'] = this.userName;
    data['idNumber'] = this.idNumber;
    return data;
  }

  @override
  String toString() {
    return 'User{displayName: $userName}';
  }


}