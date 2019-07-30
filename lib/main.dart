import 'package:flutter/material.dart';
import 'package:s11_login_validacion/src/pages/home_page.dart';
import 'package:s11_login_validacion/src/pages/login_page.dart';
import 'package:s11_login_validacion/src/pages/producto_page.dart';

import 'bloc/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.deepPurple),
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: "home",
        routes: {
          "login": (BuildContext context) => LoginPage(),
          "home": (BuildContext context) => HomePage(),
          "producto": (BuildContext context) => ProductoPage()
        },
      ),
    );
  }
}
