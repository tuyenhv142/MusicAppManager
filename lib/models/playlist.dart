class Playlist {
  String id;
  String name;
  String img;
  String content;
  String dateEnter;
  List<String> tracks;

  Playlist({
    required this.id,
    required this.name,
    required this.img,
    required this.content,
    required this.dateEnter,
    required this.tracks,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      img: json['img'] ?? '',
      content: json['content'] ?? '',
      dateEnter: json['dateEnter'] ?? '',
      tracks: List<String>.from(json['tracks'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'content': content,
      'dateEnter': dateEnter,
      'tracks': tracks,
    };
  }
}
