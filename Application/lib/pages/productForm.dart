import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../controllers/stateMangment.dart';
import '../classes/products.dart';

class add extends StatefulWidget {
  final ind;
  add({this.ind});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _add();
  }
}

class _add extends State<add> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  ImagePicker pick = ImagePicker();
  var data;
  File? imagefile;

  Future<dynamic> showforimage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height > 500
                  ? 150.0
                  : MediaQuery.of(context).size.height * 0.4,
              child: Column(
                children: [
                  OutlineButton(
                    child: Text("take an image"),
                    onPressed: () async {
                      ImagePicker()
                          .getImage(source: ImageSource.camera)
                          .then((value) {
                        print(value);
                        setState(() {
                          if (value != null) imagefile = File(value.path);
                          Navigator.pop(context);
                        });
                      });
                    },
                  ),
                  OutlineButton(
                    child: Text("pick an image"),
                    onPressed: () async {
                      data = ImagePicker()
                          .getImage(source: ImageSource.gallery)
                          .then((value) {
                        setState(() {
                          if (value != null) imagefile = File(value.path);
                          Navigator.pop(context);
                        });
                      }).onError((error, stackTrace) {
                        print(error.toString());
                      });
                    },
                  )
                ],
              ));
        });
  }

  final _titlecontroller = TextEditingController();
  final _descriptioncontroller = TextEditingController();
  final _pricecontroller = TextEditingController();
  final _count = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double devicewidth = MediaQuery.of(context).size.width;
    double devicetarget = devicewidth > 550.0 ? 500.0 : devicewidth * 0.95;
    double paddintarget = devicewidth - devicetarget;

    // TODO: implement build
    return Consumer<Auth_model>(builder: (context, model, child) {
      Product? currentProduct;
      Image? currentImage;

      if (widget.ind != null) {
        final prol = model.product_list;
        currentProduct = prol[model.index];
        currentImage = currentProduct.updatedImage == null
            ? Image.network(currentProduct.image)
            : Image.file(currentProduct.updatedImage!);
        if (_titlecontroller.text == "" &&
            _descriptioncontroller.text == "" &&
            _pricecontroller.text == "" &&
            _count.text == "") {
          _titlecontroller.text = currentProduct.name;
          _descriptioncontroller.text = currentProduct.description;
          _pricecontroller.text = currentProduct.price.toString();
          _count.text = currentProduct.count.toString();
        }
      }
      bool isWithoutPic = (currentImage == null && imagefile == null);
      Widget body = GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
              margin: EdgeInsets.all(10.0),
              child: Form(
                  key: key,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: paddintarget / 2),
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'title'),
                        controller: _titlecontroller,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'[a-zA-Z]').hasMatch(value)) {
                            return "title is required";
                          }
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: 'how many product you have'),
                        controller: _count,
                        validator: (value) {
                          value = value!.trim();
                          if (value.isEmpty ||
                              !RegExp(r'[1-9]([0-9])*').hasMatch(value)) {
                            return "you must enter valid number";
                          }
                        },
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                              labelText: "description",
                              border: InputBorder.none),
                          controller: _descriptioncontroller,
                          maxLines: 10,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "enter vaild description";
                            }
                          }),
                      TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(labelText: "product price"),
                        controller: _pricecontroller,
                        validator: (value) {
                          value = value!.trim();
                          if (value.isEmpty ||
                              !RegExp(r'[1-9]([0-9])*.[0-9]([0-9])*')
                                  .hasMatch(value)) {
                            return "enter vaild price for example:3.00";
                          }
                        },
                      ),
                      OutlineButton(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 3.0),
                          color: Colors.orange,
                          onPressed: () {
                            showforimage(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.orange,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                "pick a pic",
                                style: TextStyle(color: Colors.orange),
                              )
                            ],
                          )),
                      isWithoutPic
                          ? Center(
                              child: Text(
                                "please insert a pic",
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : imagefile == null
                              ? currentImage!
                              : Image.file(
                                  imagefile!,
                                ),
                      model.isloading
                          ? CircularProgressIndicator()
                          : RaisedButton(
                              onPressed: () async {
                                if (key.currentState!.validate()) {
                                  _pricecontroller.text
                                      .trim()
                                      .replaceAll(",", ".");
                                  if (imagefile != null &&
                                      currentProduct == null) {
                                    model
                                        .add(
                                            image: imagefile!,
                                            name: _titlecontroller.text.trim(),
                                            description:
                                                _descriptioncontroller.text,
                                            price: double.parse(
                                                _pricecontroller.text.trim()),
                                            count:
                                                int.parse(_count.text.trim()))
                                        .then((value) {
                                      if (value) {
                                        Navigator.pushReplacementNamed(
                                            context, '/');
                                      }
                                    });
                                  } else if (imagefile != null &&
                                      currentProduct != null) {
                                    model
                                        .updateproduct(
                                            imagef: imagefile,
                                            name: _titlecontroller.text.trim(),
                                            description:
                                                _descriptioncontroller.text,
                                            price: double.parse(
                                                _pricecontroller.text.trim()),
                                            count:
                                                int.parse(_count.text.trim()))
                                        .then((value) {
                                      if (value) Navigator.pop(context);
                                    });
                                  } else {
                                    model
                                        .updateproduct(
                                            image: currentProduct!.image,
                                            name: _titlecontroller.text.trim(),
                                            description:
                                                _descriptioncontroller.text,
                                            price: double.parse(
                                                _pricecontroller.text.trim()),
                                            count:
                                                int.parse(_count.text.trim()))
                                        .then((value) {
                                      if (value) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  }
                                }
                              },
                              child: Text(
                                  currentProduct == null ? "save" : "update"),
                            )
                    ],
                  ))));
      if (currentProduct != null) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                title: Text(currentProduct == null ? "" : currentProduct.name)),
            body: body);
      } else {
        return body;
      }
    });
  }
}
