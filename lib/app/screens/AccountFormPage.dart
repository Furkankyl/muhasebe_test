import 'dart:convert';

import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:muhasebetest/app/helper/CustomToast.dart';
import 'package:muhasebetest/app/model/AccountType.dart';
import 'package:muhasebetest/app/services/DBService.dart';
import 'package:muhasebetest/app/widgets/CustomButton.dart';
import 'package:muhasebetest/locator.dart';

class AccountFormPage extends StatefulWidget {
  @override
  _AccountFormPageState createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  final _formKey = GlobalKey<FormState>();
  var firmaAdiController = TextEditingController();
  FocusNode firmaAdiNode = FocusNode();
  var yetkiliAdiController = TextEditingController();
  FocusNode yetkiliAdiNode = FocusNode();
  var yetkiliSoyadiController = TextEditingController();
  FocusNode yetkiliSoyadiNode = FocusNode();

  var firmaTelefonController = TextEditingController();
  FocusNode firmaTelefonNode = FocusNode();
  var telefonCepController = TextEditingController();
  FocusNode telefonCepNode = FocusNode();
  var mailController = TextEditingController();
  FocusNode mailNode = FocusNode();

  var firmaVergiDairesiController = TextEditingController();
  FocusNode firmaVergiDairesiNode = FocusNode();
  var vergiTcNumarasiController = TextEditingController();
  FocusNode vergiTcNumarasiNode = FocusNode();

  var firmaAdresController = TextEditingController();
  FocusNode firmaAdresNode = FocusNode();

  List<AccountType> countryList;
  int selectedCountry;

  List<AccountType> disctrictList;
  int selectedDistrict;

  List<AccountType> zoneList;
  int selectedZone;

  List<AccountType> quarterList;
  int selectedQuarter;

  bool isBusy = false;

  @override
  void initState() {
    fetchCountry();
    super.initState();
  }

  fetchCountry() async {
    String url = "https://kitap.ddawebdizayn.com/api/v1/get/countries";

    Response response = await get(url);
    var jsonData = "${response.body}";
    var parsedJson = json.decode(jsonData);
    print('${response.body}');

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        countryList = [];
        await parsedJson['data'].forEach((json) {
          countryList.add(AccountType.fromJson(json));
        });
        selectedCountry = countryList.singleWhere((at) => at.id == 215).id ??
            countryList[0].id;
        setState(() {});
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
  }

  fetchZone() async {
    String url =
        "https://kitap.ddawebdizayn.com/api/v1/get/zone/$selectedCountry";

    Response response = await get(url);
    var jsonData = "${response.body}";
    var parsedJson = json.decode(jsonData);
    print('${response.body}');

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        zoneList = [];
        await parsedJson['data'].forEach((json) {
          zoneList.add(AccountType.fromJson(json));
        });
        selectedZone = zoneList[0].id;
        setState(() {});
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
  }

  fetchDisctrict() async {
    String url =
        "https://kitap.ddawebdizayn.com/api/v1/get/district/$selectedZone";

    Response response = await get(url);
    var jsonData = "${response.body}";
    var parsedJson = json.decode(jsonData);
    print('${response.body}');

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        disctrictList = [];
        await parsedJson['data'].forEach((json) {
          disctrictList.add(AccountType.fromJson(json));
        });
        selectedDistrict = disctrictList[0].id;
        setState(() {});
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
  }

  fetchQuarter() async {
    String url =
        "https://kitap.ddawebdizayn.com/api/v1/get/quarter/$selectedDistrict";

    Response response = await get(url);
    var jsonData = "${response.body}";
    var parsedJson = json.decode(jsonData);
    print('${response.body}');

    if (response.statusCode == 200) {
      if (parsedJson['result']) {
        quarterList = [];
        await parsedJson['data'].forEach((json) {
          quarterList.add(AccountType.fromJson(json));
        });
        selectedQuarter = quarterList[0].id;
        setState(() {});
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(145, 104, 222, 1),
        title: Text('Hesap detayı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          primary: false,
          children: <Widget>[

            form(),
            SizedBox(
              height: 16,
            ),
            CustomButton(
              child: isBusy ? CircularProgressIndicator() : Text('Kaydet'),
              onPressed: !isValid
                  ? null
                  : sendForm,
            ),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
  sendForm
        () async {
      setState(() {
        isBusy = true;
      });
      try{
        DBService auth = locator<DBService>();
        bool result = await auth.sendApplicationForm(
          companyName: firmaAdiController.text,
          companyPersonName: yetkiliAdiController.text,
          companyPersonLastName: yetkiliSoyadiController.text,
          telephone: firmaTelefonController.text,
          cellPhone: telefonCepController.text,
          email: mailController.text,
          companyTaxOffice: firmaVergiDairesiController.text,
          taxNumber: vergiTcNumarasiController.text,
          countryId: selectedCountry.toString(),
          disctrictId: selectedDistrict.toString(),
          zoneId: selectedZone.toString(),
          quarterId: selectedQuarter.toString(),
          companyAddress: firmaAdresController.text,
        );
        if(result){
          CustomToast.showCard(title: "Form başarıyla kaydedildi",body: "Profilini tamamladığın için teşekkürler");
        }
      }catch(e){
        print(e);
      }finally{
        setState(() {
          isBusy = false;
        });
        validate();
      }



  }

  bool isValid = false;

  validate() {
    setState(() {
      isValid = !isBusy &&
          _formKey.currentState.validate() &&
          selectedCountry != null &&
          selectedZone != null &&
          selectedDistrict != null &&
          selectedQuarter != null;
    });
  }

  form()=>Form(
    key: _formKey,
    onChanged: (){
      validate();
    },
    child: Column(
      children: <Widget>[
        TextFormField(
          controller: firmaAdiController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          maxLength: 32,          autofocus: false,

          focusNode: firmaAdiNode,
          maxLengthEnforced: true,
          onFieldSubmitted: (term) {
            FocusScope.of(context).requestFocus(yetkiliAdiNode);
          },
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return "boş bırakılamaz.";
            } else if (value.length < 6) {
              return "Firma adı en az 6 haneli olmalıdır!";
            } else
              return null;
          },
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            errorStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white),
            labelText: "Firma adı",
            hintText: "DDA Bilişim",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: yetkiliAdiController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          maxLength: 32,          autofocus: false,

          focusNode: yetkiliAdiNode,
          maxLengthEnforced: true,
          onFieldSubmitted: (term) {
            FocusScope.of(context).requestFocus(yetkiliSoyadiNode);
          },
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return "boş bırakılamaz.";
            } else if (value.length <= 3) {
              return "Yetkili adı en az 3 haneli olmalıdır!";
            } else
              return null;
          },
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            errorStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white),
            labelText: "Yetkili adı",
            hintText: "John",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: yetkiliSoyadiController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          maxLength: 32,          autofocus: false,

          focusNode: yetkiliSoyadiNode,
          maxLengthEnforced: true,
          onFieldSubmitted: (term) {
            FocusScope.of(context).requestFocus(firmaTelefonNode);
          },
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return "boş bırakılamaz.";
            } else if (value.length <= 2) {
              return "Yetkili soyadı en az 2 haneli olmalıdır!";
            } else
              return null;
          },
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            errorStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white),
            labelText: "Yetkili Soyadı",
            hintText: "Doe",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: firmaTelefonController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          focusNode: firmaTelefonNode,
          maxLengthEnforced: true,          autofocus: false,

          onFieldSubmitted: (term) {
            FocusScope.of(context).requestFocus(telefonCepNode);
          },
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return "boş bırakılamaz.";
            } else if (value.length != 10) {
              return "Telefon numarası 10 haneli olmalıdır!";
            } else
              return null;
          },
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            errorStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white),
            labelText: "Firma telefon numarası",
            hintText: "5555555555",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: telefonCepController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          maxLength: 10,          autofocus: false,

          focusNode: telefonCepNode,
          maxLengthEnforced: true,
          onFieldSubmitted: (term) {
            FocusScope.of(context).requestFocus(mailNode);
          },
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return "boş bırakılamaz.";
            } else if (value.length != 10) {
              return "Telefon numarası 10 haneli olmalıdır!";
            } else
              return null;
          },
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            errorStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white),
            labelText: "Cep telefon numarası",
            hintText: "5555555555",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: mailController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          focusNode: mailNode,          autofocus: false,

          maxLengthEnforced: true,
          onFieldSubmitted: (term) {
            FocusScope.of(context).requestFocus(firmaVergiDairesiNode);
          },
          autovalidate: true,
          validator: (value) {
            bool emailValid =
            RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value);
            if (value.isEmpty) {
              return " boş bırakılamaz.";
            } else if (!emailValid) {
              return "geçersiz mail adresi!";
            } else
              return null;
          },
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            errorStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white),
            labelText: "Firma mail adresi",
            hintText: "example@gmail.com",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: firmaVergiDairesiController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          autofocus: false,
          maxLength: 32,
          focusNode: firmaVergiDairesiNode,
          maxLengthEnforced: true,
          onFieldSubmitted: (term) {
            FocusScope.of(context).requestFocus(vergiTcNumarasiNode);
          },
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return "boş bırakılamaz.";
            } else if (value.length <= 3) {
              return "Firma vergi dairesi en az 3 haneli olmalıdır";
            } else
              return null;
          },
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            errorStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white),
            labelText: "Firma vergi dairesi",
            hintText: "Samsun vergi dairesi",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: vergiTcNumarasiController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          maxLength: 11,          autofocus: false,

          focusNode: vergiTcNumarasiNode,
          onFieldSubmitted: (_){
            FocusScope.of(context).unfocus();
          },
          maxLengthEnforced: true,
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return "boş bırakılamaz.";
            } else if (value.length != 11) {
              return "Vergi/TC numarası 11 haneli olmalıdır";
            } else
              return null;
          },
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            errorStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white),
            labelText: "Vergi/TC numarası",
            hintText: "33333333333",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Card(
          child: countryList == null
              ? CircularProgressIndicator()
              : DropDownFormField(
            titleText: 'Ülke seç',
            hintText: 'Lütfen birini seç',
            required: true,
            value: countryList != null
                ? countryList
                .singleWhere((accountType) =>
            accountType.id == selectedCountry)
                .id
                : null,
            onChanged: (value) {
              setState(() {
                selectedCountry = value;
              });
              fetchZone();      validate();

            },
            dataSource: countryList != null
                ? countryList.map((accountType) {
              return {
                "name": accountType.name,
                "id": accountType.id
              };
            }).toList()
                : [],
            textField: 'name',
            valueField: 'id',
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Card(
          child: zoneList == null
              ? SizedBox()
              : DropDownFormField(
            titleText: 'Şehir seç',
            hintText: 'Lütfen birini seç',
            required: true,
            value: zoneList != null
                ? zoneList
                .singleWhere((accountType) =>
            accountType.id == selectedZone)
                .id
                : null,
            onChanged: (value) {
              setState(() {
                selectedZone = value;
              });
              fetchDisctrict();      validate();

            },
            dataSource: zoneList != null
                ? zoneList.map((accountType) {
              return {
                "name": accountType.name,
                "id": accountType.id
              };
            }).toList()
                : [],
            textField: 'name',
            valueField: 'id',
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Card(
          child: disctrictList == null
              ? SizedBox()
              : DropDownFormField(
            titleText: 'İlçe seç',
            hintText: 'Lütfen birini seç',
            required: true,
            value: disctrictList != null
                ? disctrictList
                .singleWhere((accountType) =>
            accountType.id == selectedDistrict)
                .id
                : null,
            onChanged: (value) {
              print(value);

              setState(() {
                selectedDistrict = value;
              });
              fetchQuarter();      validate();

            },
            dataSource: disctrictList != null
                ? disctrictList.map((accountType) {
              return {
                "name": accountType.name,
                "id": accountType.id
              };
            }).toList()
                : [],
            textField: 'name',
            valueField: 'id',
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Card(
          child: quarterList == null
              ? SizedBox()
              : DropDownFormField(
            titleText: 'Mahalle seç',
            hintText: 'Lütfen birini seç',
            required: true,
            value: quarterList != null
                ? quarterList
                .singleWhere((accountType) =>
            accountType.id == selectedQuarter)
                .id
                : null,
            onChanged: (value) {
              setState(() {
                selectedQuarter = value;
              });      validate();

              FocusScope.of(context).requestFocus(firmaAdresNode);
            },
            dataSource: quarterList != null
                ? quarterList.map((accountType) {
              return {
                "name": accountType.name,
                "id": accountType.id
              };
            }).toList()
                : [],
            textField: 'name',
            valueField: 'id',
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextFormField(
          controller: firmaAdresController,
          textInputAction: TextInputAction.send,
          keyboardType: TextInputType.multiline,
          maxLength: 255,
          maxLengthEnforced: true,
          focusNode: firmaAdresNode,
          onFieldSubmitted: (term) {
            if(isValid)
            sendForm();
          },
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return "boş bırakılamaz.";
            } else if (value.length < 10) {
              return "Firma adresi en az 10 haneli olmalıdır!";
            } else
              return null;
          },
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red, width: 2)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white, width: 2)),
            errorStyle: TextStyle(color: Colors.white),
            counterStyle: TextStyle(color: Colors.white),
            labelText: "Firma adresi",
            hintText: "",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
