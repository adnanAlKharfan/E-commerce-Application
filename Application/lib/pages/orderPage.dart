import 'dart:async';

import 'package:apdl/controllers/stateMangment.dart';
import 'package:apdl/pages/orderDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPage createState() => _OrderPage();
}

class _OrderPage extends State<OrderPage> {
  Auth_model? m;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Timer(Duration(seconds: 2), () {
      m!.getUserOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth_model>(builder: (context, model, child) {
      m = model;
      return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          backgroundColor: Colors.yellowAccent[600],
          child: Column(
            children: [
              AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.yellow),
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
                  title: Text("shippment"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'shippments');
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
            : model.userOrders.length == 0
                ? Center(
                    child: Text("no order been made yet"),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) {
                      if (index != model.userOrders.length - 1) {
                        return Divider();
                      }
                      return SizedBox();
                    },
                    itemCount: model.userOrders.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          model.oIndex = index;
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return OrderDetailsPage(model.userOrders[index]);
                          })).then((_) {
                            model.oIndex = -1;
                          });
                        },
                        leading: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("#" + model.userOrders[index].id),
                              Text(
                                "status:" + model.userOrders[index].status,
                                style: TextStyle(
                                    color: model.userOrders[index].status ==
                                            "pending"
                                        ? Colors.grey
                                        : model.userOrders[index].status ==
                                                "accept"
                                            ? Colors.green
                                            : Colors.red),
                              )
                            ]),
                        trailing: Icon(Icons.arrow_forward_ios),
                      );
                    }),
      );
    });
  }
}
