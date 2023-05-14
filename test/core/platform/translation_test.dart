import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/core/platform/language_infos.dart';

class MockHttpClient extends Mock implements Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late GoogleTranslationImp googleTranslationImp;
  // late Future<Response> request;

  setUp(() {
    mockHttpClient = MockHttpClient();
    googleTranslationImp = GoogleTranslationImp(http: mockHttpClient);
    // request = mockHttpClient.post(any());
  });

  registerFallbackValue(FakeUri());

  test(
      'should make http post request to google traduction api and return a string when the status code equal to 200',
      () async {
    // Arrange
    when(() => mockHttpClient.post(any())).thenAnswer((_) async => Response("""{
    "data": {
        "translations": [
            {
                "translatedText": "texte"
            }
        ]
    }
}""", 200));
    // Act
    final result = await googleTranslationImp.translate(
        text: "text", sourceLanguageCode: "en", targetLanguageCode: "fr");
    // Assert
    verify(() => mockHttpClient.post(any())).called(1);
    expect(result, "texte");
  });
  test(
      'should make http post request to google traduction api and throw translationf failed exception a string when the status code different to 200',
      () async {
    // Arrange
    when(() => mockHttpClient.post(any()))
        .thenAnswer((_) async => Response("texte", 404));
    // Act
    final result = googleTranslationImp.translate(
        text: "text", sourceLanguageCode: "en", targetLanguageCode: "fr");
    // Assert
    verify(() => mockHttpClient.post(any())).called(1);
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
