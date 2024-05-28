part of 'app_pages.dart';

abstract class Routes{
  Routes._();
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const TRACK = _Paths.TRACK;
  static const ARTIST = _Paths.ARTIST;
  static const PLAYLIST = _Paths.PLAYLIST;
  static const BANNER = _Paths.BANNER;
  static const USER = _Paths.USER;
}

abstract class _Paths{
  _Paths._();
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const TRACK = '/track';
  static const ARTIST = '/artist';
  static const PLAYLIST = '/playlist';
  static const BANNER = '/banner';
  static const USER = '/user';
}