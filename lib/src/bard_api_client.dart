import 'dart:convert';
import 'dart:io';
import 'dart:math';

class ChatBot {
  int _reqId = Random().nextInt(pow(10, 4).toInt());
  String _conversationId = "";
  String _responseId = "";
  String _choiceId = "";
  String? _SNLM0e;

  final HttpClient _client = HttpClient();
  Map<String, String> get _headers => {
        "Host": "bard.google.com",
        "X-Same-Domain": "1",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36",
        "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
        "Origin": "https://bard.google.com",
        "Referer": "https://bard.google.com/",
      };
  List<Cookie> get _cookies => [
        Cookie(
          "__Secure-1PSID",
          _sessionId,
        )
      ];
  final String _sessionId;

  ChatBot({required String sessionId}) : _sessionId = sessionId;

  Future<void> _initialize() async {
    _SNLM0e = await _getSNLM0e();
  }

  Future<HttpClientRequest> _makeGetRequest(String url) async {
    HttpClientRequest request = await _client.getUrl(Uri.parse(url));
    for (var header in _headers.entries) {
      request.headers.add(header.key, header.value);
    }
    request.cookies.addAll(_cookies);
    return request;
  }

  Future<HttpClientRequest> _makePostRequest(Uri uri) async {
    HttpClientRequest request = await _client.postUrl(uri);
    for (var header in _headers.entries) {
      request.headers.add(header.key, header.value);
    }
    request.cookies.addAll(_cookies);
    return request;
  }

  Future<String> _getSNLM0e() async {
    HttpClientRequest request =
        await _makeGetRequest("https://bard.google.com/");
    final response = await request.close().timeout(Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception("Could not get Google Bard");
    }

    // ignore: non_constant_identifier_names
    final SNlM0eRegExp = RegExp(r'SNlM0e\":\"(.*?)\"');
    final body = await response.transform(utf8.decoder).join();
    final match = SNlM0eRegExp.firstMatch(body);
    // ignore: non_constant_identifier_names
    final SNlM0e = match?.group(1) ?? '';

    return SNlM0e;
  }

  Future<Map<String, dynamic>> ask(String question) async {
    if (_SNLM0e == null) {
      await _initialize();
    }

    final urlParams = {
      "bl": "boq_assistant-bard-web-server_20230419.00_p1",
      "_reqid": _reqId.toString(),
      "rt": "c",
    };

    final messageStruct = [
      [question],
      null,
      [_conversationId, _responseId, _choiceId]
    ];
    final data = {
      "f.req": json.encode([null, json.encode(messageStruct)]),
      "at": _SNLM0e,
    };

    Uri uri = Uri.https(
      "bard.google.com",
      "/_/BardChatUi/data/assistant.lamda.BardFrontendService/StreamGenerate",
      urlParams,
    );
    HttpClientRequest request = await _makePostRequest(uri);
    request.write(Uri(queryParameters: data).query);
    HttpClientResponse response =
        await request.close().timeout(Duration(seconds: 120));
    final body = await response.transform(utf8.decoder).join();

    final chatData = json.decode(body.split("\n")[3])[0][2];
    if (chatData == null) {
      throw "Google Bard encountered an error: $body.";
    }
    final jsonChatData = json.decode(chatData);
    final results = {
      "content": jsonChatData[4][0][1][0],
      "conversation_id": jsonChatData[1][0],
      "response_id": jsonChatData[1][1],
      "factualityQueries": jsonChatData[3],
      "textQuery": jsonChatData[2] != null ? jsonChatData[2][0] : "",
      "choices":
          jsonChatData[4].map((i) => {"id": i[0], "content": i[1]}).toList(),
    };
    _conversationId = results["conversation_id"];
    _responseId = results["response_id"];
    _choiceId = results["choices"][0]["id"];
    _reqId += 100000;

    return results;
  }
}
