import 'package:provider/provider.dart';
import '../controllers/stateMangment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/state.dart';

class auth_page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _auth_page();
  }
}

class _auth_page extends State<auth_page> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final _email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  final credit_card_number = TextEditingController();
  final credit_card_pass = TextEditingController();
  bool accept_term = false;

  switch_between_login_and_signup state =
      switch_between_login_and_signup.Signin;
  @override
  build(BuildContext context) {
    // TODO: implement build
    return Consumer<Auth_model>(
      builder: (context, model, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
              onTap: () {
                return FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/photo.jpg"),
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.dstATop),
                          fit: BoxFit.cover)),
                  padding: EdgeInsets.all(10.0),
                  child: Form(
                      key: key,
                      child: Center(
                          child: SingleChildScrollView(
                              child: Column(
                        children: [
                          state == switch_between_login_and_signup.Signin
                              ? Center()
                              : TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: name,
                                  decoration: InputDecoration(
                                      labelText: "name",
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 25.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)))),
                                  onSaved: (value) {
                                    name.text = value!.trim();
                                  },
                                  validator: (value) {
                                    value = value!.trim();
                                    if (value.isEmpty ||
                                        !RegExp(r"^[a-zA-Z ]{2,30}$")
                                            .hasMatch(value)) {
                                      return "enter valid name";
                                    }
                                  },
                                ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _email,
                            decoration: InputDecoration(
                                labelText: "email",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.5),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 25.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                            validator: (value) {
                              value = value!.trim();
                              if (value.isEmpty ||
                                  !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                                      .hasMatch(value)) {
                                return "you must put vaild email";
                              }
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: password,
                            decoration: InputDecoration(
                                labelText: "password",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.5),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 25.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)))),
                            validator: (value) {
                              value = value!.trim();
                              if (value.isEmpty ||
                                  !RegExp(r"^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{6,})")
                                      .hasMatch(value)) {
                                return "you must enter valid password";
                              }
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          state == switch_between_login_and_signup.Signin
                              ? Center()
                              : TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: credit_card_number,
                                  decoration: InputDecoration(
                                      labelText: "credit card number",
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 25.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)))),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r"(^5[1-5][0-9]{14}$|^2(?:2(?:2[1-9]|[3-9][0-9])|[3-6][0-9][0-9]|7(?:[01][0-9]|20))[0-9]{12}$)|(^3[47][0-9]{13}$)|(^4[0-9]{12}(?:[0-9]{3})?$)|(^65[4-9][0-9]{13}|64[4-9][0-9]{13}|6011[0-9]{12}|(622(?:12[6-9]|1[3-9][0-9]|[2-8][0-9][0-9]|9[01][0-9]|92[0-5])[0-9]{10})$)|(^(?:2131|1800|35[0-9]{3})[0-9]{11}$)|(^3(?:0[0-5]|[68][0-9])[0-9]{11}$)|(^(5018|5081|5044|5020|5038|603845|6304|6759|676[1-3]|6799|6220|504834|504817|504645)[0-9]{8,15}$)")
                                            .hasMatch(value)) {
                                      return "please enter a valid credit card number";
                                    }
                                  },
                                ),
                          SizedBox(
                            height: 10.0,
                          ),
                          state == switch_between_login_and_signup.Signin
                              ? Center()
                              : TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: credit_card_pass,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      labelText: "credit card password",
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.5),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(width: 25.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)))),
                                  validator: (value) {
                                    value = value!.trim();
                                    if (value.isEmpty ||
                                        !RegExp(r"([0-9]{3,4})")
                                            .hasMatch(value)) {
                                      return "you must enter a valid credit card password ";
                                    }
                                  },
                                ),
                          state == switch_between_login_and_signup.Signin
                              ? Center()
                              : SwitchListTile(
                                  title: Text("accept our term"),
                                  value: accept_term,
                                  onChanged: (value) {
                                    setState(() {
                                      accept_term = value;
                                    });
                                  }),
                          model.isloading
                              ? CircularProgressIndicator()
                              : RaisedButton(
                                  color: Colors.lightBlue.shade300,
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  onPressed: () {
                                    if (key.currentState!.validate()) {
                                      key.currentState!.save();
                                      if (state ==
                                          switch_between_login_and_signup
                                              .Signin) {
                                        if (_email == null) print("fuck");

                                        model
                                            .signin_sigup(
                                                email: _email.text,
                                                password: password.text,
                                                type: state)
                                            .then((value) {
                                          if (!value["error"]) {
                                            Navigator.pushReplacementNamed(
                                                context, "/");
                                          }
                                          return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Center(
                                                    child:
                                                        Text(value["message"]),
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                          "ok",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ))
                                                  ],
                                                );
                                              });
                                        });
                                      } else if (accept_term) {
                                        model
                                            .signin_sigup(
                                                email: _email.text,
                                                password: password.text,
                                                type: state,
                                                name: name.text,
                                                credit_card_number:
                                                    credit_card_number.text,
                                                credit_card_pass:
                                                    credit_card_pass.text)
                                            .then((value) {
                                          if (!value["error"]) {
                                            Navigator.pushReplacementNamed(
                                                context, "/");
                                          }
                                          return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Center(
                                                    child:
                                                        Text(value["message"]),
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                          "ok",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ))
                                                  ],
                                                );
                                              });
                                        });
                                      }
                                    }
                                  },
                                  child: Text(state ==
                                          switch_between_login_and_signup.Signin
                                      ? "sign in"
                                      : "sign up")),
                          FlatButton(
                              shape: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              onPressed: () {
                                setState(() {
                                  if (state ==
                                      switch_between_login_and_signup.Signin) {
                                    state =
                                        switch_between_login_and_signup.Signup;
                                  } else {
                                    state =
                                        switch_between_login_and_signup.Signin;
                                  }
                                });
                              },
                              child: Text(
                                state == switch_between_login_and_signup.Signin
                                    ? "switch to sign up"
                                    : "switch to sign in",
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      )))))),
        );
      },
    );
  }
}
