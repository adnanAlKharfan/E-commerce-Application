import 'dart:async';

import 'package:apdl/classes/products.dart';

import 'package:flutter/material.dart';
import 'productDetailsPage.dart';
import 'package:provider/provider.dart';

import '../controllers/stateMangment.dart';

class homepage extends StatefulWidget {
  final logout;
  final Auth_model model;
  homepage(this.logout, this.model);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _homepage();
  }
}

class _homepage extends State<homepage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(Duration(seconds: 2), () {
      widget.model.getall();
    });
  }

  Widget retriver() {
    Widget childs = Center(
      child: Text("no data found"),
    );

    List<Product> products = widget.model.product_list;
    if (products.length > 0 && !widget.model.isloading) {
      childs = ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                widget.model.index = index;
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return details();
                })).then((_) {
                  widget.model.index = -1;
                });
              },
              child: Hero(
                  tag: products[index].id,
                  child: Card(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            image: products[index].updatedImage != null
                                ? FileImage(products[index].updatedImage!)
                                : NetworkImage(products[index].image)
                                    as ImageProvider,
                            placeholder: AssetImage("assets/image.jpg"),
                            height: MediaQuery.of(context).size.height / 5,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  products[index].name,
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context)
                                              .size
                                              .aspectRatio *
                                          60,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'osbold'),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Text(
                                      "\$" + products[index].price.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .aspectRatio *
                                              60),
                                    ))
                              ]),
                        ),
                      ],
                    ),
                  ))));
        },
      );
    } else if (widget.model.isloading) {
      childs = Center(
          child: CircularProgressIndicator(
        strokeWidth: 10.0,
      ));
    }
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: childs,
      onRefresh: () async {
        return widget.model.getall();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<Auth_model>(
        builder: (BuildContext context, Auth_model model, Widget? child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.yellowAccent[600],
              ),
              ListTile(
                title: Text("products edit"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'edit');
                },
              ),
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
                  title: Text("contact us"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'contact');
                  }),
              ListTile(
                title: Text("Log out"),
                trailing: Icon(Icons.exit_to_app),
                onTap: () => widget.logout(),
              )
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text("App Products"),
        ),
        body: retriver(),
      );
    });
  }
}
