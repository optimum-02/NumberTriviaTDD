import 'package:flutter/material.dart';

import 'features/number_trivia/presentation/number_trivia/pages/number_trivia_page.dart';
import 'injection_dependency.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        primarySwatch: Colors.green,
        // useMaterial3: true,
      ),
      home: const NumbertriviaPage(),
    );
  }
}
