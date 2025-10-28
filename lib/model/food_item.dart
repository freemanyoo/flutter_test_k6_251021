class FoodItem {
  final String? mainTitle;
  final String? title;
  final String? image;

  FoodItem({this.mainTitle, this.title, this.image});

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      mainTitle: json['RCP_NM'],
      title: json['RCP_PARTS_DTLS'],
      image: json['ATT_FILE_NO_MK'],
    );
  }
}