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
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  iconTheme: const IconThemeData(size: 24, weight: 500, color: Colors.black),
);
final darkTheme = ThemeData(
  primaryColor: Colors.blue.shade800,
  brightness: Brightness.dark,
  // primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.grey.shade900,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  iconTheme: IconThemeData(size: 24, weight: 500, color: Colors.grey.shade100),
);
