import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfos {
  Future<bool> checkConnection();
}

class NetworkInfosImpl implements NetworkInfos {
  final InternetConnectionChecker dataConnectionChecker;

  NetworkInfosImpl(this.dataConnectionChecker);

  @override
  Future<bool> checkConnection() => dataConnectionChecker.hasConnection;
}
