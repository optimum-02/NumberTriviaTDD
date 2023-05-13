import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/platform/language_infos.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late GoogleTranslationImp googleTranslationImp;

  setUp(() {
    mockHttpClient = MockHttpClient();
    googleTranslationImp = GoogleTranslationImp(http: mockHttpClient);
  });
  final request = mockHttpClient.post(
    Uri.parse(any()),
  );

  test(
      'should make http post request to google traduction api and return a string when the status code equal to 200',
      () async {
    // Arrange
    when(() => request).thenAnswer((_) async => Response("texte", 200));
    // Act
    final result = await googleTranslationImp.translate(
        text: "text", sourceLanguageCode: "en", targetLanguageCode: "fr");
    // Assert
    verify(() => request).called(1);
    expect(result, "texte");
  });
  test(
      'should make http post request to google traduction api and throw translationf failed exception a string when the status code different to 200',
      () async {
    // Arrange
    when(() => request).thenAnswer((_) async => Response("texte", 404));
    // Act
    final result = googleTranslationImp.translate(
        text: "text", sourceLanguageCode: "en", targetLanguageCode: "fr");
    // Assert
    verify(() => request).called(1);
    await expectLater(result, throwsA(isA<TranslationFailedException>()));
  });
  test(
      'should return the text provided to translate and make no http call when source and target language are equal',
      () async {
    // Arrange

    // Act
    final result = await googleTranslationImp.translate(
        text: "text", sourceLanguageCode: "en", targetLanguageCode: "en");
    // Assert
    verifyZeroInteractions(mockHttpClient);
    expect(result, "text");
  });
}
