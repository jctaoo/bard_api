import 'package:bard_api/bard_api.dart';

void main() async {
  final bard = ChatBot(
      sessionId:
          "WQhElIHjwbSSlw5Pq01apE4jxEn3dTW3uQo-_yijH3DbR2DMDFvvQTie6qd8UGPUoMU2-w.");
  final result = await bard.ask("Hello?");
  print(result);
}
