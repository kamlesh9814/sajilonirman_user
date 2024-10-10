class AdminProductDetailsModel {
  List<AdminProduct>? _products;
  AdminProductDetailsModel({List<AdminProduct>? products}) {
    _products = products;
  }

  List<AdminProduct>? get products => _products;
  AdminProductDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      _products = [];
      json['data'].forEach((v) {
        _products!.add(AdminProduct.fromJson(v));
      });
    }
  }
}

class AdminProduct {
  int? _id;
  String? _addedBy;
  int? _userId;
  String? _name;
  String? _slug;
  String? _productType;
  int? _minimumOrderQuantity;
  String? _thumbnail;
  int? _unitPrice;
  int? _discount;
  String? _discount_type;
  int? _current_stock;
  int? _reviewCount;

  AdminProduct(
      {int? id,
      String? addedBy,
      int? userId,
      String? name,
      String? slug,
      String? productType,
      int? minimumOrderQuantity,
      String? thumbnail,
      int? unitPrice,
      int? discount,
      String? discountType,
      int? currentStock,
      int? reviewCount}) {
    _id = id;
    _addedBy = addedBy;
    _userId = userId;
    _name = name;
    _slug = slug;
    _productType = productType;
    _minimumOrderQuantity = minimumOrderQuantity;
    _thumbnail = thumbnail;
    _unitPrice = unitPrice;
    _discount = discount;
    _discount_type = discountType;
    _current_stock = currentStock;
    _reviewCount = reviewCount;
  }

  int? get id => _id;
  String? get addedBy => _addedBy;
  int? get userId => _userId;
  String? get name => _name;
  String? get slug => _slug;
  String? get productType => _productType;
  int? get minimumOrderQuantity => _minimumOrderQuantity;
  String? get thumbnail => _thumbnail;
  int? get unitPrice => _unitPrice;
  int? get discount => _discount;
  String? get discountType => _discount_type;
  int? get currentStock => _current_stock;
  int? get reviewCount => _reviewCount;

  AdminProduct.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addedBy = json['added_by'];
    _userId = json['user_id'];
    _name = json['name'];
    _slug = json['slug'];
    _productType = json['product_type'];
    _minimumOrderQuantity = json['minimum_order_qty'];
    _thumbnail = json['thumbnail'];

    // Fixing the unit_price conversion
    _unitPrice = json['unit_price'] is double
        ? (json['unit_price'] as double).toInt()
        : json['unit_price'];

    _discount = json['discount'];
    _discount_type = json['discount_type'];
    _current_stock = json['current_stock'];
    _reviewCount = json['reviews_count'];
  }
}
