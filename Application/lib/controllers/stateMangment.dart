import 'package:apdl/classes/order.dart';
import 'package:flutter/cupertino.dart';
import '../classes/state.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import '../classes/user.dart';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'dart:io';

import '../classes/products.dart';

class Auth_model extends ChangeNotifier {
  var databasesPath;
  Database? db;
  bool isloading = false;
  String url = "http://localhost:8000/api/";
  int index = -1;
  Map<String, String> headers = {
    "Accept": "application/json",
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
    'Content-Type': 'application/json'
  };
  List<Map<String, String>> reviews = [];
  List<Product> products = [];
  List<Order> userOrders = [];
  List<Order> userShippments = [];
  int oIndex = -1;
  User? admin;
  PublishSubject<bool> login = PublishSubject();
  List<Product> userProducts = [];
  void initalize() async {
    databasesPath = await getDatabasesPath();
    db = await openDatabase('user.db');
    if (db!.isOpen) {
      await db!.execute('''CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT,
    token Text,
    email Text
)''').onError((error, stackTrace) async {
        List<Map<dynamic, dynamic>> temp =
            await db!.rawQuery('select * from users order by id desc');

        for (int i = 0; i < temp.length; i++) {
          admin = User(
              id: temp[i]["user_id"],
              email: temp[i]["email"],
              token: temp[i]["token"]);
          headers["Authorization"] = "Bearer " + temp[i]["token"];
        }
        if (admin != null) {
          login.add(true);
        }
      });
    }
  }

  Future<void> getUserProducts() async {
    isloading = true;
    userProducts.clear();
    notifyListeners();
    http.Response res =
        await http.get(Uri.parse(url + "userProducts"), headers: headers);
    Map<String, dynamic> data = jsonDecode(res.body);
    if (res.statusCode == 200 && data.containsKey("data")) {
      for (int i = 0; i < data["data"].length; i++) {
        bool isFound = false;
        for (int j = 0; j < userProducts.length; j++) {
          if (userProducts[j].id == data["data"][i]["id"].toString()) {
            isFound = true;
          }
        }
        if (!isFound) {
          userProducts.add(Product(
              id: data["data"][i]["id"].toString(),
              count: data["data"][i]["count"],
              image: data["data"][i]["image"],
              name: data["data"][i]["title"],
              price: data["data"][i]["price"].toDouble(),
              description: data["data"][i]["description"]));
        }
      }
    }
    isloading = false;
    notifyListeners();
  }

  Future<void> getProductReviews() async {
    isloading = true;
    reviews.clear();
    notifyListeners();
    http.Response res = await http.get(
        Uri.parse(url + "reviews/" + products[index].id),
        headers: headers);
    Map<String, dynamic> data = jsonDecode(res.body);
    if (res.statusCode == 200 && data.containsKey("data")) {
      for (int i = 0; i < data["data"].length; i++) {
        reviews.add({"comment": data["data"][i]["comment"]});
      }
    }
    isloading = false;
    notifyListeners();
  }

  Future<void> getUserOrders() async {
    isloading = true;
    userOrders.clear();
    notifyListeners();
    http.Response res =
        await http.get(Uri.parse(url + "orders"), headers: headers);

    Map<String, dynamic> data = jsonDecode(res.body);
    if (res.statusCode == 200 && data.containsKey("data")) {
      for (int i = 0; i < data["data"].length; i++) {
        bool isFound = false;
        for (int j = 0; j < userOrders.length; j++) {
          if (userOrders[j].id == data["data"][i]["id"].toString()) {
            isFound = true;
          }
        }
        if (!isFound) {
          userOrders.add(Order(
              productId: data["data"][i]["product_id"].toString(),
              id: data["data"][i]["id"].toString(),
              productName: data["data"][i]["product_name"],
              total: double.parse(data["data"][i]["total"].toString()),
              number: data["data"][i]["number"],
              status: data["data"][i]["status"],
              feedback: data["data"][i]["feedback"] == null
                  ? ""
                  : data["data"][i]["feedback"]));
        }
      }
    }
    isloading = false;

    notifyListeners();
  }

  Future<void> getUserShipments() async {
    isloading = true;
    userShippments.clear();
    notifyListeners();
    http.Response res =
        await http.get(Uri.parse(url + "shippment"), headers: headers);
    Map<String, dynamic> data = jsonDecode(res.body);

    if (res.statusCode == 200 &&
        data.containsKey("data") &&
        data["data"].length > 0) {
      for (int i = 0; i < data["data"][0].length; i++) {
        bool isFound = false;
        for (int j = 0; j < userShippments.length; j++) {
          if (userShippments[j].id == data["data"][0][i]["id"].toString()) {
            isFound = true;
          }
        }
        if (!isFound) {
          userShippments.add(Order(
              productId: data["data"][0][i]["product_id"].toString(),
              id: data["data"][0][i]["id"].toString(),
              productName: data["data"][0][i]["product_name"],
              total: double.parse(data["data"][0][i]["total"].toString()),
              number: data["data"][0][i]["number"],
              status: data["data"][0][i]["status"],
              feedback: data["data"][0][i]["feedback"] == null
                  ? ""
                  : data["data"][0][i]["feedback"]));
        }
      }
    }
    isloading = false;
    notifyListeners();
  }

  Future<void> postOrder({required int number, required double total}) async {
    isloading = true;

    notifyListeners();

    http.Response res =
        await http.post(Uri.parse(url + "orders/" + products[index].id),
            headers: headers,
            body: jsonEncode({
              "total": total.toString(),
              "number": number,
              "product_name": products[index].name
            }));

    Map<String, dynamic> data = jsonDecode(res.body);
    if (res.statusCode == 200 && data.containsKey("data")) {
      getUserOrders();
    }
    isloading = false;

    notifyListeners();
  }

  Future<void> postReview(String comment) async {
    isloading = true;

    notifyListeners();
    http.Response res = await http.post(
        Uri.parse(url +
            "reviews/" +
            userOrders[oIndex].productId +
            "/" +
            userOrders[oIndex].id),
        headers: headers,
        body: jsonEncode({"comment": comment}));

    Map<String, dynamic> data = jsonDecode(res.body);
    if (res.statusCode == 200 && data.containsKey("data")) {
      userOrders[oIndex].feedback = comment;
    }
    isloading = false;

    notifyListeners();
  }

  Future<void> putOrder({required String status}) async {
    isloading = true;

    notifyListeners();
    http.Response res =
        await http.put(Uri.parse(url + "orders/" + userShippments[oIndex].id),
            headers: headers,
            body: jsonEncode({
              "status": status,
            }));

    Map<String, dynamic> data = jsonDecode(res.body);
    if (res.statusCode == 200 && data.containsKey("data")) {
      userShippments[oIndex].status = status;
    }
    isloading = false;

    notifyListeners();
  }

  Future<Map> signin_sigup(
      {String? name,
      required String email,
      required String password,
      required switch_between_login_and_signup type,
      String? credit_card_number,
      String? credit_card_pass}) async {
    isloading = true;
    notifyListeners();

    http.Response res;
    if (type == switch_between_login_and_signup.Signin) {
      res = await http.post(Uri.parse(url + "sign_in"),
          headers: headers,
          body: json.encode({
            'email': email,
            'password': password,
          }));
    } else {
      res = await http.post(Uri.parse(url + "sign_up"),
          headers: headers,
          body: json.encode({
            'email': email,
            'password': password,
            'name': name,
            'credit_card_number': credit_card_number,
            'credit_card_pass': credit_card_pass,
          }));
    }

    Map resbody = json.decode(res.body);
    bool haserror = false;
    String message = "succesfully signed in";
    if (resbody.containsKey("errors")) {
      haserror = true;
      message = resbody["errors"].toString();
    } else if (resbody.containsKey("msg")) {
      haserror = true;
      message = resbody["msg"];
    } else {
      headers["Authorization"] = "Bearer " + resbody["token"];
      admin = User(
          id: resbody["data"]["id"].toString(),
          email: resbody["data"]["email"],
          token: resbody["token"]);
      await db!.insert('users',
          {'user_id': admin!.id, 'token': admin!.token, 'email': admin!.email});
      login.add(true);
    }
    isloading = false;
    notifyListeners();
    return {"error": haserror, "message": message};
  }

  void logout() async {
    http.Response res =
        await http.post(Uri.parse(url + "sign_out"), headers: headers);
    if (res.statusCode == 200 && json.decode(res.body).containsKey("msg")) {
      login.add(false);
      headers["Authorization"] = "";
      await db!.delete('users', where: 'user_id=?', whereArgs: [admin!.id]);
      admin = null;
    }
  }

  Future<bool> add({
    required File image,
    required String name,
    required double price,
    required String description,
    required int count,
  }) async {
    isloading = true;
    notifyListeners();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url + "products"),
    );
    Map<String, String> header = {
      "Content-type": "multipart/form-data",
      "Accept": "application/json",
      "Authorization": "Bearer " + admin!.token
    };
    request.files.add(
      http.MultipartFile(
        'image',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: DateTime.now().toString() + name,
      ),
    );
    request.fields.addAll({
      "title": name,
      "price": price.toString(),
      "description": description,
      "count": count.toString(),
    });
    request.headers.addAll(header);

    var res = await request.send();

    final respStr = await res.stream.bytesToString();

    Map<String, dynamic> data = jsonDecode(respStr);
    if (data.containsKey("data")) {
      Product temp = Product(
          id: data["data"]["id"].toString(),
          count: int.parse(data["data"]["count"]),
          image: data["data"]["image"],
          name: data["data"]["title"],
          description: data["data"]["description"],
          price: double.parse(data["data"]["price"]));
      products.add(temp);
      userProducts.add(temp);
      isloading = false;
      notifyListeners();
      return true;
    }
    isloading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateproduct(
      {File? imagef,
      required String name,
      required double price,
      required String description,
      required int count,
      String? image}) async {
    isloading = true;
    notifyListeners();
    var request = http.MultipartRequest(
      'POSt',
      Uri.parse(url + "products/" + products[index].id),
    );
    Map<String, String> header = {
      "Content-type": "multipart/form-data",
      "Accept": "application/json",
      "Authorization": "Bearer " + admin!.token
    };

    var data = {
      "title": name,
      "price": price.toString(),
      "description": description,
      "count": count.toString(),
      '_method': 'PUT'
    };
    if (imagef != null) {
      request.files.add(
        http.MultipartFile(
          'image',
          imagef.readAsBytes().asStream(),
          imagef.lengthSync(),
          filename: DateTime.now().toString() + name,
        ),
      );
    }

    request.headers.addAll(header);

    request.fields.addAll(data);
    var res = await request.send();

    final respStr = await res.stream.bytesToString();

    if (jsonDecode(respStr).containsKey("data")) {
      userProducts[index] = Product(
          updatedImage: products[index].updatedImage == null
              ? null
              : products[index].updatedImage,
          id: userProducts[index].id,
          name: name,
          description: description,
          image: jsonDecode(respStr)["data"]["image"],
          count: count,
          price: price);
      products.every((element) {
        if (userProducts[index].id == element.id) {
          element = userProducts[index];
          return false;
        }
        return true;
      });
      isloading = false;
      notifyListeners();
      return true;
    }
    isloading = false;
    notifyListeners();
    return false;
  }

  Future<Map<String, String>> delete() async {
    isloading = true;
    notifyListeners();
    http.Response res = await http.delete(
        Uri.parse(url + "products/" + products[index].id),
        headers: headers);
    products.every((element) {
      if (userProducts[index].id == element.id) {
        products.remove(element);
        return false;
      }
      return true;
    });
    userProducts.removeAt(index);
    isloading = false;
    notifyListeners();
    return {"msg": jsonDecode(res.body)["msg"]};
  }

  List<Product> get product_list {
    return List.from(products);
  }

  Future<void> getall() async {
    isloading = true;
    products.clear();
    notifyListeners();

    http.Response res =
        await http.get(Uri.parse(url + "products"), headers: headers);
    var data = jsonDecode(res.body);
    if (data.containsKey("data")) {
      for (int i = 0; i < data["data"].length; i++) {
        bool isFound = false;
        for (int j = 0; j < products.length; j++) {
          if (products[j].id == data["data"][i]["id"].toString()) {
            isFound = true;
          }
        }
        if (!isFound) {
          products.add(Product(
              id: data["data"][i]["id"].toString(),
              count: data["data"][i]["count"],
              image: data["data"][i]["image"],
              name: data["data"][i]["title"],
              price: data["data"][i]["price"].toDouble(),
              description: data["data"][i]["description"]));
        }
      }
    }
    isloading = false;
    notifyListeners();
  }
}
