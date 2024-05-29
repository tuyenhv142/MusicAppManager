class Banner1 {
  // String id;
  String title;
  String img;

  Banner1({
    // required this.id,
    required this.title,
    required this.img,
  });

  factory Banner1.fromJson(Map<String, dynamic> json) {
    return Banner1(
      // id: json['id'] ?? '',
      title: json['title'] ?? '',
      img: json['img'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'title': title,
      'img': img,
    };
  }
}
