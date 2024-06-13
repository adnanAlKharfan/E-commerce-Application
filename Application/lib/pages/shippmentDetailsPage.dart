import 'package:apdl/classes/order.dart';
import 'package:apdl/controllers/stateMangment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippmentDetailsPage extends StatelessWidget {
  final Order currentOrder;
  ShippmentDetailsPage(this.currentOrder);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double targetBottomHeight = height > 500 ? 200 : height * 0.4;
    return Consumer<Auth_model>(builder: (context, model, child) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(),
          bottomSheet: currentOrder.status != "pending"
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                      width: width,
                      height: targetBottomHeight,
                      color: Colors.blue[600],
                      child: Column(children: [
                        Container(
                            width: width,
                            height: targetBottomHeight / 2,
                            color: Colors.greenAccent[400],
                            child: FlatButton(
                                onPressed: () {
                                  model.putOrder(status: "accept").then((_) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text(
                                  "Accept",
                                  textScaleFactor: 2.0,
                                ))),
                        Container(
                            width: width,
                            height: targetBottomHeight / 2,
                            color: Colors.red[600],
                            child: FlatButton(
                                onPressed: () {
                                  model.putOrder(status: "decline").then((_) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text(
                                  "Decline",
                                  textScaleFactor: 2.0,
                                ))),
                      ]))),
          body: LayoutBuilder(builder: (context, constraints) {
            return Padding(
                padding: EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("#" + currentOrder.id),
                            Text(currentOrder.status,
                                style: TextStyle(
                                    color: currentOrder.status == "pending"
                                        ? Colors.grey
                                        : currentOrder.status == "accept"
                                            ? Colors.green
                                            : Colors.red))
                          ],
                        ),
                        Container(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight / 2,
                            ),
                            child: Center(
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(currentOrder.productName,
                                                textScaleFactor: 1.5),
                                            Text(
                                              currentOrder.number.toString(),
                                              textScaleFactor: 1.5,
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          thickness: 2.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Total",
                                                textScaleFactor: 1.5),
                                            Text(
                                              "\$" +
                                                  currentOrder.total.toString(),
                                              textScaleFactor: 1.5,
                                            )
                                          ],
                                        )
                                      ],
                                    )))),
                        currentOrder.feedback == ""
                            ? SizedBox()
                            : const Text("Review", textScaleFactor: 1.5),
                        currentOrder.feedback == ""
                            ? SizedBox()
                            : const Divider(
                                thickness: 2.0,
                              ),
                        currentOrder.feedback == ""
                            ? SizedBox()
                            : Text(currentOrder.feedback)
                      ],
                    ),
                  ),
                ));
          }));
    });
  }
}
