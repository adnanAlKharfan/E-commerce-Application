import 'dart:async';

import 'package:apdl/pages/addToOrderPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../classes/products.dart';
import '../controllers/stateMangment.dart';

class details extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _details();
  }
}

class _details extends State<details> {
  Auth_model? m;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Timer(Duration(seconds: 2), () {
      m!.getProductReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    double padding = 10.0;
    // TODO: implement build
    return Consumer<Auth_model>(
      builder: (BuildContext context, Auth_model model, Widget? child) {
        m = model;
        final List<Product> prod = model.product_list;
        final Product k = prod[model.index];
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        double targetBottomHeight = height > 500 ? 100 : height * 0.2;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          bottomSheet: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                width: width,
                height: targetBottomHeight,
                color: Colors.blue[600],
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return ConfirmPage(k);
                      }));
                    },
                    child: Text(
                      "order now",
                      textScaleFactor: 2.0,
                    )),
              )),
          body: CustomScrollView(slivers: [
            SliverAppBar(
              expandedHeight: height * 0.4,
              pinned: true,
              leading: SizedBox(),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(k.name),
                background: Hero(
                  tag: k.id,
                  child: FadeInImage(
                      image: k.updatedImage != null
                          ? FileImage(k.updatedImage!)
                          : NetworkImage(k.image) as ImageProvider,
                      placeholder: AssetImage("assets/photo.jpg"),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Text(
                "\$" + k.price.toString(),
                textScaleFactor: 3.0,
                overflow: TextOverflow.visible,
                strutStyle: StrutStyle(
                  fontWeight: FontWeight.w100,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Text("Description:")),
              Divider(
                thickness: 2.0,
              ),
              Padding(
                  padding: EdgeInsets.all(padding), child: Text(k.description)),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Text("Reviews:")),
              Divider(
                thickness: 2.0,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: model.isloading
                      ? CircularProgressIndicator()
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          itemBuilder: (context, index) {
                            return Text(
                              model.reviews[index]["comment"]!,
                              style: TextStyle(color: Colors.grey),
                            );
                          },
                          separatorBuilder: (context, index) {
                            if (index != model.reviews.length - 1) {
                              return Divider(
                                thickness: 2,
                              );
                            }
                            return SizedBox();
                          },
                          itemCount: model.reviews.length))
            ])),
          ]),
        );
      },
    );
  }
}
