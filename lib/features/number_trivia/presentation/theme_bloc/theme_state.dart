part of 'theme_bloc.dart';

@immutable
class ThemeState extends Equatable {
  final ThemeData theme;

  const ThemeState(this.theme);

  @override
  List<Object?> get props => [theme];
}

final lightTheme = ThemeData(
  primaryColor: Colors.blue,
  brightness: Brightness.light,
  // primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      textStyle: const TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(12),
      textStyle: const TextStyle(
          color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  iconTheme: const IconThemeData(size: 24, weight: 500, color: Colors.black),
);
final darkTheme = ThemeData(
  primaryColor: Colors.blue.shade900,
  brightness: Brightness.dark,

  // primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.grey.shade900,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue.shade900,
      textStyle: const TextStyle(
          color: Colors.white60, fontSize: 15, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(12),
      textStyle: TextStyle(
          color: Colors.blue.shade900,
          fontSize: 15,
          fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  iconTheme: const IconThemeData(size: 24, weight: 500, color: Colors.white70),
);
