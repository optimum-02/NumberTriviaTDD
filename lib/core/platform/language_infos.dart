import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart';

import 'package:number_trivia/api_key.dart';

import '../errors/exceptions.dart';

abstract class Translation {
  Future<String> translate(
      {required String text,
      required sourceLanguageCode,
      required String targetLanguageCode});
}

class GoogleTranslationImp extends Translation {
  final Client http;
  GoogleTranslationImp({
    required this.http,
  });
  @override
  Future<String> translate(
      {required String text,
      required sourceLanguageCode,
      required String targetLanguageCode}) async {
    if (targetLanguageCode != sourceLanguageCode) {
      try {
        final urlStr =
            'https://translation.googleapis.com/language/translate/v2?target=$targetLanguageCode&source=en&key=$translationApiKey&q=$text';
        final url = Uri.parse(urlStr);

        final response = await http.post(url);
        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          final translation = body["data"]["translations"] as List;
          final last = translation.first;
          return HtmlUnescape().convert(last["translatedText"]);
        } else {
          throw TranslationFailedException();
        }
      } on Exception {
        throw TranslationFailedException();
      }
    }
    return text;
  }
}
