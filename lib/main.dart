import 'package:flutter/material.dart';
import 'package:sqlite_crud_flutter/widgets/dashboard.dart';

void main() {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "dashboard",
    routes: {
      'dashboard' : (context) => DashBoard(),
    },
  ));

}
