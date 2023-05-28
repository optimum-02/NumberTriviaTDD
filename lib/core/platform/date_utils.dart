import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../api_key.dart';
import '../errors/exceptions.dart';

// Future<void> main() async {
//   String phrase =
//       "January 24th is the day in 1742 that Charles VII Albert becomes Holy Roman Emperor.";
//   final du = GptDateUtils(httpClient: Client());

//   try {
//     final res = await du.getDateFromSentence(phrase);

//     final dte = DateFormat("EEE dd MMM yyyy").format(res);
//     // print(dte);
//     // print(res.millisecondsSinceEpoch);
//     // print(DateTime.fromMillisecondsSinceEpoch(res.millisecondsSinceEpoch));
//   } on Exception catch (e) {
//     print(e);
//   }
// }

abstract class IAUtils {
  Future<DateTime> getDateFromSentence(String sentence);
}

class GptDateUtils implements IAUtils {
  final Client httpClient;
  GptDateUtils({
    required this.httpClient,
  });

  @override
  Future<DateTime> getDateFromSentence(String sentence) async {
    try {
      final prompt = """Voici la phrase suivante : ```$sentence```
      Extrait la date de cette phrase au format dd/mm/yyyy en tenant compte de l'ère
      Renvoie le resultat dans le champ "dateFormat" au format json """;
      final res = await httpClient.post(
        Uri.parse("https://api.openai.com/v1/completions"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openApiKey'
        },
        body: jsonEncode(
            {"model": "text-davinci-003", "prompt": prompt, "temperature": 0}),
      );

      print(res.body);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)["choices"] as List;

        final dateJson = jsonDecode(data.first['text']);
        final dateString = dateJson["dateFormat"];
        final dateParts = dateString.split("/");
        final finalDate = DateTime(
          int.parse(dateParts[2]),
          int.parse(dateParts[1]),
          int.parse(dateParts[0]),
        );
        return finalDate;
      } else {
        throw DateFromSentenceByGptException();
      }
    } on Exception catch (e) {
      print(e);
      throw DateFromSentenceByGptException();
    }
  }
}
