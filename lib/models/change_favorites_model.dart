class ChangeFavoritesModel {
  bool? status;
  String? message;

  ChangeFavoritesModel.fromJso(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
