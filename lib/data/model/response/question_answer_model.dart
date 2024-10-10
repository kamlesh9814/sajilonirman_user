class QuestionAnswerListModel {
  int? id;
  String? addedBy;
  String? message;
  String? productName;
  String? userEmail;
  String? replyMessage;

  QuestionAnswerListModel(
      {this.id,
      this.addedBy,
      this.message,
      this.productName,
      this.userEmail,
      this.replyMessage});

  QuestionAnswerListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addedBy = json['added_by'];
    productName = json['product_name'];
    userEmail = json['user_email'];
    replyMessage = json['reply_message'];
    message = json['message'];
  }
}
