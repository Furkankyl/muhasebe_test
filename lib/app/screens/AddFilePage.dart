import 'package:flutter/material.dart';

class AddFilePage extends StatefulWidget {
  @override
  _AddFilePageState createState() => _AddFilePageState();
}

class _AddFilePageState extends State<AddFilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          heroTag: "fab", onPressed: () {}, label: Text('Ekle')),
      appBar: AppBar(
        title: Text("Dosya ekle"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                  child: ListTile(
                title: Text('Dosya:'),
              )),
              Container(
                width: 250,
                child: Card(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                              height: 100,
                              child: Icon(
                                Icons.forward,
                                size: 48,
                              )),
                          Text('Dosya seçilmedi')
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            title: Text("Seçilen ay"),
            subtitle: Text('2020 Mart ayı'),
            trailing: IconButton(
              icon: Icon(
               Icons.calendar_today,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Dosya adı",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white,width: 2),
                )
              ),

            ),
          )
        ],
      ),
    );
  }
}
