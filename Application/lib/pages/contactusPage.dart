import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../controllers/stateMangment.dart';

class contact_us extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<Auth_model>(
        builder: (BuildContext context, Auth_model model, Widget? child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        drawer: Drawer(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.yellowAccent[600],
              ),
              ListTile(
                  title: Text("homepage"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  }),
              ListTile(
                  title: Text("products"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'edit');
                  }),
              ListTile(
                  title: Text("orders"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'orders');
                  }),
              ListTile(
                  title: Text("shippment"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'shippments');
                  }),
              ListTile(
                title: Text("Log out"),
                trailing: Icon(Icons.exit_to_app),
                onTap: model.logout,
              )
            ],
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 150.0,
                backgroundImage: AssetImage("assets/adnan.png"),
              ),
              FlatButton(
                  onPressed: () async {
                    String mail = "sms:+963994357358";
                    if (await canLaunch(mail)) {
                      launch(mail);
                    } else {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("something wrong went on"),
                            actions: [
                              FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("ok"))
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text("+963994357358")),
              FlatButton(
                  onPressed: () async {
                    String mail = "mailto:bestadnan8@gmail.com";
                    if (await canLaunch(mail)) {
                      launch(mail);
                    } else {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("something wrong went on"),
                            actions: [
                              FlatButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("ok"))
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text("bestadnan8@gmail.com"))
            ],
          ),
        )),
      );
    });
  }
}
