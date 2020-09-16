import 'package:flutter/material.dart';


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: Card(
                      child: Text("You are Authorized",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 50.0
                      ),
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
