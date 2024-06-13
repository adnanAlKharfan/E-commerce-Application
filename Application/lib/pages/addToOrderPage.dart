import 'package:apdl/classes/products.dart';
import 'package:apdl/controllers/stateMangment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmPage extends StatefulWidget {
  final Product currentProduct;

  ConfirmPage(this.currentProduct);
  @override
  _ConfirmPage createState() => _ConfirmPage();
}

class _ConfirmPage extends State<ConfirmPage> {
  int howMany = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth_model>(builder: (context, model, child) {
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
                    model
                        .postOrder(
                            number: howMany,
                            total: (widget.currentProduct.price * howMany))
                        .then((value) {
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text(
                    "confirm",
                    textScaleFactor: 2.0,
                  )),
            )),
        body: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("test", textScaleFactor: 1.5),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (howMany > 1) {
                                  howMany--;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.exposure_minus_1_rounded,
                              color: Colors.red,
                            )),
                        Text(
                          "x" + howMany.toString(),
                          textScaleFactor: 1.5,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                howMany++;
                              });
                            },
                            icon: Icon(Icons.exposure_plus_1_rounded,
                                color: Colors.green))
                      ],
                    )
                  ],
                ),
                Divider(
                  thickness: 2.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total", textScaleFactor: 1.5),
                    Text(
                      "\$" + (widget.currentProduct.price * howMany).toString(),
                      textScaleFactor: 1.5,
                    )
                  ],
                )
              ],
            )),
      );
    });
  }
}
