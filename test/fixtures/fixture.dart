import 'dart:io';

Future<String> reader(String name) async {
  return await File('test/fixtures/$name').readAsString();
}
