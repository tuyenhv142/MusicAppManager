class Artist {
  String id;
  String name;
  String img;
  String dateEnter;

  Artist({
    required this.id,
    required this.name,
    required this.img,
    required this.dateEnter,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      img: json['img'] ?? '',
      dateEnter: json['dateEnter'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'dateEnter': dateEnter,
    };
  }
}
