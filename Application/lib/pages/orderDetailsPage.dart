import 'package:apdl/classes/order.dart';
import 'package:apdl/controllers/stateMangment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatelessWidget {
  TextEditingController _feedbackController = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  final Order currentOrder;
  OrderDetailsPage(this.currentOrder);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double targetBottomHeight = height > 500 ? 100 : height * 0.2;
    return Consumer<Auth_model>(builder: (context, model, child) {
      return GestureDetector(
          onTap: () {
            return FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(),
              bottomSheet: currentOrder.status == "pending"
                  ? SizedBox()
                  : currentOrder.feedback != ""
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Container(
                            width: width,
                            height: targetBottomHeight,
                            color: Colors.blue[600],
                            child: FlatButton(
                                onPressed: () {
                                  _form.currentState!.validate();
                                  model
                                      .postReview(
                                          _feedbackController.text.trim())
                                      .then((_) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text(
                                  "submit",
                                  textScaleFactor: 2.0,
                                )),
                          )),
              body: LayoutBuilder(builder: (context, constraints) {
                return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                        child: Container(
                            height: height,
                            child: ListView(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("#" + currentOrder.id),
                                  Text(currentOrder.status,
                                      style: TextStyle(
                                          color: currentOrder.status ==
                                                  "pending"
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(currentOrder.productName,
                                                      textScaleFactor: 1.5),
                                                  Text(
                                                    "x" +
                                                        currentOrder.number
                                                            .toString(),
                                                    textScaleFactor: 1.5,
                                                  ),
                                                ],
                                              ),
                                              const Divider(
                                                thickness: 2.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Total",
                                                      textScaleFactor: 1.5),
                                                  Text(
                                                    "\$" +
                                                        currentOrder.total
                                                            .toString(),
                                                    textScaleFactor: 1.5,
                                                  )
                                                ],
                                              )
                                            ],
                                          )))),
                              currentOrder.status != "pending"
                                  ? const Text("Review")
                                  : SizedBox(),
                              currentOrder.status != "pending"
                                  ? const Divider(
                                      thickness: 2.0,
                                    )
                                  : SizedBox(),
                              currentOrder.status != "pending"
                                  ? currentOrder.feedback == ""
                                      ? Form(
                                          key: _form,
                                          child: TextFormField(
                                              decoration: InputDecoration(
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  labelText: "feedback",
                                                  hintText: "feedback",
                                                  alignLabelWithHint: true,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15.0)))),
                                              controller: _feedbackController,
                                              maxLines: 10,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "enter vaild feedback";
                                                }
                                              }))
                                      : Text(currentOrder.feedback)
                                  : SizedBox(),
                            ]))));
              })));
    });
  }
}
