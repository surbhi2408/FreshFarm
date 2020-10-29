import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'dart:convert';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'knorr soup',
    //   description: 'A warm soup of knorr soup for snack and flavor of mix vegitable flavor',
    //   price: 49.99,
    //   imageUrl:
    //   'https://rukminim1.flixcart.com/image/352/352/j3rm8i80/soup/r/y/m/61-soup-mix-veg-vegetable-knorr-original-imaeusugqktrpm9e.jpeg?q=70',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'lays',
    //   description: 'with a magic masala taste',
    //   price: 19.99,
    //   imageUrl:
    //   'https://images-na.ssl-images-amazon.com/images/I/81X7W2BrGaL._SX425_.jpg',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Kurkure',
    //   description: 'with a masala munch flavor',
    //   price: 19.99,
    //   imageUrl:
    //   'https://i5.walmartimages.ca/images/Enlarge/118/863/6000200118863.jpg',
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'Oreo',
    //   description: 'Twist,lick,dunk eat',
    //   price: 17.99,
    //   imageUrl:
    //   'https://images-na.ssl-images-amazon.com/images/I/41XPnuR-uJL.jpg',
    // ),
    // Product(
    //   id: 'p9',
    //   title: 'Almond hair oil',
    //   description: 'for silky hair and smooth hair',
    //   price: 159.99,
    //   imageUrl:
    //   'https://i5.walmartimages.ca/images/Enlarge/787/562/6000199787562.jpg',
    // ),
    // Product(
    //   id: 'p10',
    //   title: 'Dairy Milk',
    //   description: 'Chocolaty',
    //   price: 20.00,
    //   imageUrl:
    //   'https://igashop.com.au/wp-content/uploads/2020/05/cadbury-dairy-milk-chocolate-180g.jpg',
    // ),
    // Product(
    //   id: 'p11',
    //   title: 'Basmati Rice',
    //   description: 'Polished basmati rice,product name India gate weighing 10kilogram',
    //   price: 539.99,
    //   imageUrl:
    //   'https://4.imimg.com/data4/BM/KX/MY-15922529/india-gate-basmati-rice-premium-500x500.jpg',
    // ),
  ];

  var _showFavoritesOnly = false;

  List<Product> get items {
    // if(_showFavoritesOnly){
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems{
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly(){
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll(){
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async{
    const url = 'https://shopapp-e1a4e.firebaseio.com/products.json';
    try{
      final response = await http.get(url);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null){
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    }
    catch(error){
      throw (error);
    }
  }

  // using async always return future
  Future<void> addProduct(Product product) async{
    // _items.add(value);

    // converting in json and sending post request to live server
    const url = 'https://shopapp-e1a4e.firebaseio.com/products.json';
    try {
      final response = await http.post(url, body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
      );
      //print(json.decode(response.body));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct); // at the start of the list
      notifyListeners();
      // }).catchError((error){
      //   print(error);
      //   throw error;
      // });
    }catch (error){
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if(prodIndex >= 0){
      final url = 'https://shopapp-e1a4e.firebaseio.com/products/$id.json';
      await http.patch(
          url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          })
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
    else{
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async{
    final url = 'https://shopapp-e1a4e.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    //_items.removeWhere((prod) => prod.id == id);

      //print(response.statusCode);
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if(response.statusCode >= 400){
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product!');
    }
    existingProduct = null;

  }
}
