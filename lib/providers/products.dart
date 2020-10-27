import 'package:flutter/material.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p5',
      title: 'knorr soup',
      description: 'A warm soup of knorr soup for snack and flavor of mix vegitable flavor',
      price: 49.99,
      imageUrl:
      'https://rukminim1.flixcart.com/image/352/352/j3rm8i80/soup/r/y/m/61-soup-mix-veg-vegetable-knorr-original-imaeusugqktrpm9e.jpeg?q=70',
    ),
    Product(
      id: 'p6',
      title: 'lays',
      description: 'with a magic masala taste',
      price: 19.99,
      imageUrl:
      'https://images-na.ssl-images-amazon.com/images/I/81X7W2BrGaL._SX425_.jpg',
    ),
    Product(
      id: 'p7',
      title: 'Kurkure',
      description: 'with a masala munch flavor',
      price: 19.99,
      imageUrl:
      'https://i5.walmartimages.ca/images/Enlarge/118/863/6000200118863.jpg',
    ),
    Product(
      id: 'p8',
      title: 'Oreo',
      description: 'Twist,lick,dunk eat',
      price: 17.99,
      imageUrl:
      'https://images-na.ssl-images-amazon.com/images/I/41XPnuR-uJL.jpg',
    ),
    Product(
      id: 'p9',
      title: 'Almond hair oil',
      description: 'for silky hair and smooth hair',
      price: 159.99,
      imageUrl:
      'https://i5.walmartimages.ca/images/Enlarge/787/562/6000199787562.jpg',
    ),
    Product(
      id: 'p10',
      title: 'Dairy Milk',
      description: 'Chocolaty',
      price: 20.00,
      imageUrl:
      'https://igashop.com.au/wp-content/uploads/2020/05/cadbury-dairy-milk-chocolate-180g.jpg',
    ),
    Product(
      id: 'p11',
      title: 'Basmati Rice',
      description: 'Polished basmati rice,product name India gate weighing 10kilogram',
      price: 539.99,
      imageUrl:
      'https://4.imimg.com/data4/BM/KX/MY-15922529/india-gate-basmati-rice-premium-500x500.jpg',
    ),
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

  void addProduct(Product product) {
    // _items.add(value);
    final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    //_items.insert(0, newProduct); // at the start of the list
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct){
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if(prodIndex >= 0){
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
    else{
      print('...');
    }
  }

  void deleteProduct(String id){
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
