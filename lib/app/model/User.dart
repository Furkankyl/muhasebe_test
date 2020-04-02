


class User {



  int id;
  String userName;
  String idNumber;
  bool status;



  User({this.id, this.userName, this.idNumber,this.status});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['displayName'];
    idNumber = json['idNumber'];
    status = json['status']==1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['displayName'] = this.userName;
    data['idNumber'] = this.idNumber;
    data['status'] = this.status?1:0;
    return data;
  }

  @override
  String toString() {
    return 'User{displayName: $userName}';
  }


}