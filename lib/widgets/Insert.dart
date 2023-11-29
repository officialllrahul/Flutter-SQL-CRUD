import 'package:flutter/material.dart';

import 'db_helper.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var contactController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insert Data insqlite"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(25),
                    child: Text(
                        "Regestration Form",
                        style:TextStyle(fontWeight: FontWeight.bold,fontSize: 23) ),
                  ),
                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Name",
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(15),
              child: TextField(
                controller: contactController,
                decoration: InputDecoration(
                  hintText: "Contact",
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(15),
              child: ElevatedButton(
                    onPressed: () async{
                     await DatabaseHelper.instance.insertRecord({
                       DatabaseHelper.columnName:nameController.text,
                       DatabaseHelper.columnEmail:emailController.text,
                       DatabaseHelper.columnContact:contactController.text
                     });

                     Navigator.of(context).pop();
                },
                child: Text("Submit"),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
