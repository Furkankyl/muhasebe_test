import 'package:muhasebetest/app/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPref {
  SharedPreferences sp;


  static String spUserId = "user_id";
  static String spStatus = "status";
  static String spUserIdNumber = "user_image";
  static String spUserName = "user_name";
  static String spIsAuth = "is_auth";
  static String spAccountType = "account_type";
  static String spToken = "token";
  static String spShopId = "shop_id";


  SharedPref(this.sp);


  setUser(User user) {
    setId(user.id);
    setName(user.userName);
    setIdNumber(user.idNumber);

    setStatus(user.status);
    setAuthState(true);
  }

  User getUser() {
    User user = User();
    user.id = getId();
    user.userName = getName();
    user.idNumber = getDisplayNumber();
    user.status = getStatus();

    return user.id == 0 ? null : user;
  }

  bool getStatus() {
    return sp.getBool(spStatus) ?? false;
  }

  setStatus(bool value) {
    sp.setBool(spStatus, value);
  }

  setId(int id) {
    sp.setInt(spUserId, id);
  }

  int getId() {
    return sp.getInt(spUserId) ?? 0;
  }

  setName(name) {
    sp.setString(spUserName, name);
  }

  String getName() {
    return sp.getString(spUserName) ?? "";
  }

  setIdNumber(idNumber) {
    sp.setString(spUserIdNumber, idNumber);
  }

  String getDisplayNumber() {
    return sp.getString(spUserIdNumber) ?? "default image";
  }

  setAuthState(authState) {
    sp.setBool(spIsAuth, authState);
  }

  isAuth() {
    return sp.getBool(spIsAuth) ?? false;
  }


  signIn({name, idNumber, id,status}) {
    setName(name);
    setIdNumber(idNumber);
    setId(id);
    setStatus(status);
  }

  signOut() {
    sp.remove(spUserName);
    sp.remove(spUserIdNumber);
    sp.remove(spUserId);
    sp.setBool(spIsAuth, false);
  }


}