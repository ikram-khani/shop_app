import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
//   Product(
//     id: 'p1',
//     title: 'Red Shirt',
//     description: 'A red shirt - it is pretty red!',
//     price: 29.99,
//     imageUrl:
//         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//   ),
//   Product(
//     id: 'p2',
//     title: 'Trousers',
//     description: 'A nice pair of trousers.',
//     price: 59.99,
//     imageUrl:
//         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//   ),
//   Product(
//     id: 'p3',
//     title: 'Yellow Scarf',
//     description: 'Warm and cozy - exactly what you need for the winter.',
//     price: 19.99,
//     imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//   ),
//   Product(
//     id: 'p4',
//     title: 'A Pan',
//     description: 'Prepare any meal you want.',
//     price: 49.99,
//     imageUrl:
//         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//   ),
  ];

  String authToken;
  String userId;
  Products(this.authToken, this.userId, this._items);
  // var _showFavoritesOnly = false;
  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : false;
    var url = Uri.parse(
        'https://shop-app-59eb0-default-rtdb.firebaseio.com/Products.json?auth=$authToken&$filterString');

    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>?;
      final List<Product> loadedProducts = [];

      if (extractData == null) {
        return;
      }
      url = Uri.parse(
          'https://shop-app-59eb0-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      print(favoriteData);

      extractData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: favoriteData == null
                ? false
                : favoriteData[prodId] ??
                    false, //?? means if prodId is null so then false
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-app-59eb0-default-rtdb.firebaseio.com/Products.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      // _items.insert(0, newProduct);//at the beginning of the list
      _items.add(
        newProduct,
      );
      notifyListeners();
    } catch (error) {
      print(error);

      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shop-app-59eb0-default-rtdb.firebaseio.com/Products/$id.json?auth=$authToken');

      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          },
        ),
      );
      _items[prodIndex] = newProduct;
    } else {
      print('.....');
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-app-59eb0-default-rtdb.firebaseio.com/Products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere(
      (element) => element.id == id,
    );
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _items.insert(
        existingProductIndex,
        existingProduct,
      );
      notifyListeners();
      throw const HttpException('Could not delete the product.');
    }
    existingProduct = null;
  }
}
