class ExpenseInfo {
  String _id;
  String _title;
  String _description;
  int _quantity;
  int _price;
  int _date;
  String _imageUrl;

  ExpenseInfo(
      {String id,
        String title,
        String description,
        int quantity,
        int price,
        int date,
      String imageUrl}) {
    this._id = id;
    this._title = title;
    this._description = description;
    this._quantity = quantity;
    this._price = price;
    this._date = date;
    this._imageUrl = imageUrl;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get title => _title;
  set title(String title) => _title = title;
  String get description => _description;
  set description(String description) => _description = description;
  int get quantity => _quantity;
  set quantity(int quantity) => _quantity = quantity;
  int get price => _price;
  set price(int price) => _price = price;
  int get date => _date;
  set date(int date) => _date = date;
  String get imageUrl => _imageUrl;
  set imageUrl(String imageUrl) => _imageUrl = imageUrl;

  ExpenseInfo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    _quantity = json['quantity'];
    _price = json['price'];
    _date = json['date'];
    _imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['description'] = this._description;
    data['quantity'] = this._quantity;
    data['price'] = this._price;
    data['date'] = this._date;
    data['imageUrl'] = this._imageUrl;
    return data;
  }
}
