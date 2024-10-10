class StoreFollowModel{

  String? text;
  String? message;
  int? value;
  int? status;
  int? followers;

  StoreFollowModel({
    this.text,
    this.message,
    this.value,
    this.status,
    this.followers,
  });

  StoreFollowModel.fromJson(Map<String,dynamic> json){
    text = json['text'];
    message = json['message'];
    value = json['value'];
    status = json['status'];
    followers = json['followers'];
  }
}