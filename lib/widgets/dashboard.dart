import 'package:flutter/material.dart';
import 'package:sqlite_crud_flutter/widgets/viewpage.dart';
import 'Insert.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Sqlite") ,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertPage(),));
                },
                child: const Text("Insert")),

            ElevatedButton(
                onPressed: () async{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewPage(),));
                },
                child: const Text("ViewPage Update and Delete")),

          ],
        ),
      ),

    );
  }
}
