class AdminChatViewModel {
  int? id;
  int? userId;
  dynamic sellerId;
  int? adminId;
  int? adminSendToCustomer;
  dynamic deliveryManId;
  String? message;
  String? newMessage;
  dynamic attachment;
  int? sentByCustomer;
  int? sentBySeller;
  dynamic sentByAdmin;
  dynamic sentByDeliveryMan;
  int? seenByCustomer;
  int? seenBySeller;
  dynamic seenByAdmin;
  dynamic type;
  dynamic seenByDeliveryMan;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? softDeletes;
  dynamic shopId;

  AdminChatViewModel({
    this.id,
    this.userId,
    this.sellerId,
    this.adminId,
    this.adminSendToCustomer,
    this.deliveryManId,
    this.message,
    this.newMessage,
    this.attachment,
    this.sentByCustomer,
    this.sentBySeller,
    this.sentByAdmin,
    this.sentByDeliveryMan,
    this.seenByCustomer,
    this.seenBySeller,
    this.seenByAdmin,
    this.type,
    this.seenByDeliveryMan,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.softDeletes,
    this.shopId,
  });

  AdminChatViewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    sellerId = json['seller_id'];
    adminId = json['admin_id'];
    message = json['message'];
    newMessage = json['new_message'];
    attachment = json['attachment'];
    sentByCustomer = json['sent_by_customer'];
    sentBySeller = json['sent_by_seller'];
    sentByAdmin = json['sent_by_admin'];
    seenByCustomer = json['seen_by_customer'];
    seenBySeller = json['seen_by_seller'];
    seenByAdmin = json['seen_by_aadmin'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
