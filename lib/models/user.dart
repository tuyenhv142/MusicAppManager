class User1 {
  String idUser;
  String fullname;
  String email;
  String img;
  String dateEnter;
  List<String> favoriteArtistId;
  List<String> favoritePlaylistId;
  List<String> favoriteTrackId;

  User1({
    required this.idUser,
    required this.fullname,
    required this.email,
    required this.img,
    required this.dateEnter,
    required this.favoriteArtistId,
    required this.favoritePlaylistId,
    required this.favoriteTrackId,
  });

  factory User1.fromJson(Map<String, dynamic> json) {
    return User1(
      idUser: json['idUser'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      img: json['img'] ?? '',
      dateEnter: json['dateEnter'] ?? '',
      favoriteArtistId: List<String>.from(json['favoriteArtistId'] ?? []),
      favoritePlaylistId: List<String>.from(json['favoritePlaylistId'] ?? []),
      favoriteTrackId: List<String>.from(json['favoriteTrackId'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUser': idUser,
      'fullname': fullname,
      'email': email,
      'img': img,
      'dateEnter': dateEnter,
      'favoriteArtistId': favoriteArtistId,
      'favoritePlaylistId': favoritePlaylistId,
      'favoriteTrackId': favoriteTrackId,
    };
  }
}
