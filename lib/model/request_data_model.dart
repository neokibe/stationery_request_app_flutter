class RequestDataModel {
  String? stationery;
  String? quantity;

// receiving data
  RequestDataModel({this.stationery, this.quantity,});

  factory RequestDataModel.fromMap(map) {
    return RequestDataModel(
      quantity: map['quantity'],
      stationery: map['stationery'],
    );
  }

// sending data
  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'stationery': stationery,
    };
  }

  static RequestDataModel? fromJson(data) {}
}