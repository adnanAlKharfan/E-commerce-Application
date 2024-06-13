import 'dart:async';

import 'package:apdl/controllers/stateMangment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'shippmentDetailsPage.dart';

class ShippmentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShippmentPage();
  }
}

class _ShippmentPage extends State<ShippmentPage> {
  Auth_model? m;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Timer(Duration(seconds: 2), () {
      m!.getUserShipments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth_model>(builder: (context, model, child) {
      m = model;
      return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.yellow,
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
                  title: Text("contact us"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'contact');
                  }),
              ListTile(
                title: Text("Log out"),
                trailing: Icon(Icons.exit_to_app),
                onTap: model.logout,
              )
            ],
          ),
        ),
        body: model.isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : model.userShippments.length == 0
                ? Center(
                    child: Text("no order been made yet"),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      if (index != model.userShippments.length - 1) {
                        return Divider(
                          thickness: 2.0,
                        );
                      }
                      return SizedBox();
                    },
                    itemCount: model.userShippments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          model.oIndex = index;
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ShippmentDetailsPage(
                                model.userShippments[index]);
                          })).then((_) {
                            model.oIndex = -1;
                          });
                        },
                        leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("#" + model.userShippments[index].id),
                              Text(
                                "status:" + model.userShippments[index].status,
                                style: TextStyle(
                                    color: model.userShippments[index].status ==
                                            "pending"
                                        ? Colors.grey
                                        : model.userShippments[index].status ==
                                                "accept"
                                            ? Colors.green
                                            : Colors.red),
                              )
                            ]),
                        trailing: Text("total:\$" +
                            model.userShippments[index].total.toString()),
                      );
                    }),
      );
    });
  }
}
