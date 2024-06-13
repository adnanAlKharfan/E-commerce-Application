import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'productForm.dart';
import '../controllers/stateMangment.dart';
import 'package:provider/provider.dart';

class edit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _edit();
  }
}

class _edit extends State<edit> {
  bool isCalled = false;

  Widget retrive(Auth_model model) {
    if (!isCalled) {
      model.index = -1;
      isCalled = true;
      Timer(Duration(seconds: 2), () {
        model.getUserProducts();
      });
    }
    Widget child = Center(child: Text("no item yet"));
    if (model.userProducts.length > 0 && !model.isloading) {
      child = ListView.builder(
          itemCount: model.userProducts.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(model.userProducts[index].name),
                onDismissed: (direction) {
                  try {
                    model.index = index;
                    model.delete();
                  } catch (e) {
                    print(e);
                  }
                },
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  child: Container(
                      padding: EdgeInsets.only(right: 100.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Remove",
                            textAlign: TextAlign
                                .center /*TextAlign.values(TextAlign.center,TextAlign.end)*/,
                            style:
                                TextStyle(fontSize: 26.0, color: Colors.white),
                          ))),
                ),
                child: Column(children: [
                  ListTile(
                    leading: CircleAvatar(
                        backgroundImage: model
                                    .userProducts[index].updatedImage !=
                                null
                            ? FileImage(model.userProducts[index].updatedImage!)
                            : NetworkImage(model.userProducts[index].image)
                                as ImageProvider),
                    title: Text(model.userProducts[index].name),
                    subtitle:
                        Text("\$" + model.userProducts[index].price.toString()),
                    trailing: IconButton(
                        onPressed: () {
                          //  model.select(index);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            model.index = index;
                            return add(
                              ind: model.index,
                            );
                          }));
                        },
                        icon: Icon(Icons.edit)),
                  ),
                  Divider(),
                ]));
          });
    } else if (model.isloading) {
      child = Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
        child: child,
        onRefresh: () async {
          return model.getUserProducts();
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<Auth_model>(
        builder: (BuildContext context, Auth_model model, Widget? child) {
      return retrive(model);
    });
  }
}
