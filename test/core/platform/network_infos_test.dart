import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/platform/network_infos.dart';

class MockDataConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late MockDataConnectionChecker mockDataConnectionChecker;
  late NetworkInfos networkInfos;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfos = NetworkInfosImpl(mockDataConnectionChecker);
  });

  test('should forward call to DataConnectionChecker.hasConnection', () async {
    // Arrange
    final hasConnection = Future.value(true);
    when(
      () => mockDataConnectionChecker.hasConnection,
    ).thenAnswer((_) => hasConnection);
    // Act
    final result = networkInfos.checkConnection();
    // Assert
    expect(result,
        hasConnection); // testing the basic dart reference equality of hasConnection; not values equality
    verify(
      () => mockDataConnectionChecker.hasConnection,
    ).called(1);
    verifyNoMoreInteractions(mockDataConnectionChecker);
  });
}
