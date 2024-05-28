import 'package:flutter_web_dashboard/views/pages/login/login.dart';
import 'package:flutter_web_dashboard/views/pages/banners/banners.dart';
import 'package:flutter_web_dashboard/views/pages/artist/artists.dart';
import 'package:flutter_web_dashboard/views/pages/overview/overview.dart';
import 'package:flutter_web_dashboard/views/pages/playlist/playlists.dart';
import 'package:flutter_web_dashboard/views/pages/tracks/tracks.dart';
import 'package:flutter_web_dashboard/views/pages/users/users.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: non_constant_identifier_names
  static String INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: _Paths.ARTIST,
      page: () => const ArtistsPage(),
    ),
    GetPage(
      name: _Paths.BANNER,
      page: () => const BannersPage(),
    ),
    GetPage(
      name: _Paths.PLAYLIST,
      page: () => const PlaylistsPage(),
    ),
    GetPage(
      name: _Paths.TRACK,
      page: () => const TracksPage(),
    ),
    GetPage(
      name: _Paths.USER,
      page: () => const UsersPage(),
    ),
  ];
}
