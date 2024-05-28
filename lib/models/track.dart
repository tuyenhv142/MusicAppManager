class Track {
  // String id;
  String title;
  String source;
  String singerId;
  String image;
  String dateEnter;

  Track({
    // required this.id,
    required this.title,
    required this.source,
    required this.singerId,
    required this.image,
    required this.dateEnter,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      // id: json['id'] ?? '',
      title: json['title'] ?? '',
      source: json['source'] ?? '',
      singerId: json['singerId'] ?? '',
      image: json['image'] ?? '',
      dateEnter: json['dateEnter'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'title': title,
      'source': source,
      'singerId': singerId,
      'image': image,
      'dateEnter': dateEnter,
    };
  }
}
