class AccountType {
  String name;
  int id;

  AccountType(this.name, this.id);

  AccountType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  String toString() {
    return 'AccountType{name: $name, id: $id}';
  }


}
