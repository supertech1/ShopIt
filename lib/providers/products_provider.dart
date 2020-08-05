import 'package:flutter/material.dart';
import './../models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Products_Provider with ChangeNotifier {
  final String authToken;
  final String userId;

  Products_Provider(this.authToken, this._items, this.userId);

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchProduct([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : "";
    final myUrl =
        'https://shop-a37c7.firebaseio.com/products.json?auth=$authToken$filterString';
    try {
      final res = await http.get(myUrl);
      final extractedData = jsonDecode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final favoriteResponse = await http.get(
          "https://shop-a37c7.firebaseio.com/userFavorites/$userId.json?auth=$authToken");
      final favoriteData = jsonDecode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            description: prodData['description'],
            price: prodData['price'],
            title: prodData['title'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product p) async {
    final myUrl =
        "https://shop-a37c7.firebaseio.com/products.json?auth=$authToken";
    try {
      var res = await http.post(
        myUrl,
        body: json.encode({
          'title': p.title,
          'description': p.description,
          'imageUrl': p.imageUrl,
          'price': p.price,
          'creatorId': userId
        }),
      );
      final newProduct = Product(
          title: p.title,
          description: p.description,
          imageUrl: p.imageUrl,
          price: p.price,
          id: jsonDecode(res.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }

    return Future.value();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final myUrl =
        "https://shop-a37c7.firebaseio.com/products/$id.json?auth=$authToken";

    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      await http.patch(myUrl,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final myUrl =
        "https://shop-a37c7.firebaseio.com/products/$id.json?auth=$authToken";

    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[prodIndex];
    if (prodIndex >= 0) {
      _items.removeAt(prodIndex);
      notifyListeners();
    }
    http.delete(myUrl).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException(
            "Could not delete item"); //NB by default, delete doesn't return error, so in other to catch it, we will need to throw it ourselve as done here by implementing the excption interface
      }
      existingProduct = null;
    }).catchError((_) {
      _items.insert(prodIndex, existingProduct);
      notifyListeners();
    });
  }
}
