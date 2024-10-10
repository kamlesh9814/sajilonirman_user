import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';

class HomeCategoryProduct {
  int? id;
  String? name;
  String? slug;
  String? icon;
  int? parentId;
  int? position;
  String? createdAt;
  String? updatedAt;
  List<Product>? products;
  List<dynamic>? translations;
  String? banner1;
  String? banner2;

  HomeCategoryProduct(
      {this.id,
        this.name,
        this.slug,
        this.icon,
        this.parentId,
        this.position,
        this.createdAt,
        this.updatedAt,
        this.products,
        this.translations,
        this.banner1,
        this.banner2,
        });

  HomeCategoryProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    icon = json['icon'];
    parentId = json['parent_id'];
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    banner1 = json['banner1'];
    banner2 = json["banner2"];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) { products!.add(Product.fromJson(v)); });
    }

    if (json['translations'] != null) {
      translations = [];
      translations = List<dynamic>.from(translations!.map((x) => x));
    }

  }

}
