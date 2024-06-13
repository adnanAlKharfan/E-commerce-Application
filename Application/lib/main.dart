import 'package:apdl/pages/orderPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './pages/sign_in_sign_up_page.dart';
import 'controllers/stateMangment.dart';
import 'pages/homePage.dart';
import './pages/add_and_edit_products.dart';
import 'pages/contactusPage.dart';
import 'pages/shippmentPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _myapp();
  }
}

class _myapp extends State<MyApp> {
  Auth_model model = Auth_model();
  bool _login = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (model.login == null) {
      _login = false;
    } else {
      model.login.listen((value) {
        setState(() {
          if (value == null) {
            _login = false;
          } else {
            _login = value;
          }
        });
      });
    }

    model.initalize();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
        create: (context) => model,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (BuildContext context) {
              return _login ? homepage(model.logout, model) : auth_page();
            },
            'contact': (BuildContext context) {
              return _login ? contact_us() : auth_page();
            },
            'edit': (BuildContext context) {
              return _login ? add_and_edit(model.logout) : auth_page();
            },
            'orders': (BuildContext context) {
              return _login ? OrderPage() : auth_page();
            },
            'shippments': (BuildContext context) {
              return _login ? ShippmentPage() : auth_page();
            }
          },
          onUnknownRoute: (settings) {
            MaterialPageRoute(builder: (context) {
              return _login ? homepage(model.logout, model) : auth_page();
            });
          },
        ));
  }
}
