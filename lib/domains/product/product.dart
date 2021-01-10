import 'package:json_annotation/json_annotation.dart';
import 'package:pomangam/domains/_bases/entity_auditing.dart';
import 'package:pomangam/domains/product/info/product_info.dart';
import 'package:pomangam/domains/product/product_type.dart';
import 'package:pomangam/domains/product/review/product_reply.dart';
import 'package:pomangam/domains/product/sub/category/product_sub_category.dart';

part 'product.g.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class Product extends EntityAuditing {

  int idxStore;
  int salePrice;
  ProductInfo productInfo;
  String productCategoryTitle;
  int cntLike;
  int cntReply;
  int sequence;

  // images
  String productImageMainPath;
  List<String> productImageSubPaths;

  // like
  bool isLike;

  // reply
  List<ProductReply> replies;

  // product sub category
  List<ProductSubCategory> productSubCategories = List();

  ProductType productType;

  bool isTempActive;

  Product({
    int idx, DateTime registerDate, DateTime modifyDate,
    this.idxStore, this.salePrice, this.productInfo,
    this.productCategoryTitle, this.cntLike, this.cntReply, this.sequence,
    this.productImageMainPath, this.productImageSubPaths, this.isLike, this.replies,
    this.productSubCategories, this.productType, this.isTempActive
  }): super(idx: idx, registerDate: registerDate, modifyDate: modifyDate);

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
  static List<Product> fromJsonList(List<dynamic> jsonList) {
    List<Product> entities = [];
    jsonList.forEach((map) => entities.add(Product.fromJson(map)));
    return entities;
  }

  @override
  String toString() {
    return 'Product{idxStore: $idxStore, salePrice: $salePrice, productInfo: $productInfo, productCategoryTitle: $productCategoryTitle, cntLike: $cntLike, cntReply: $cntReply, sequence: $sequence, productImageMainPath: $productImageMainPath, productImageSubPaths: $productImageSubPaths, isLike: $isLike, replies: $replies, productSubCategories: $productSubCategories, productType: $productType, isTempActive: $isTempActive}';
  }
}