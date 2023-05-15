# Bard

Reverse engineering of Google's Bard chatbot API for dart inspired from [Bard](https://github.com/acheong08/Bard).

Installation

```shell
dart pub install bard_api
# or
flutter pub install bard_api
```

## Authentication

1. Go to [Bard Site](https://bard.google.com/)
2. Open the devtools.
3. Copy the cookie value of `__Secure-1PSID`.

## Usage

```dart
import 'package:bard_api/bard_api.dart';

void main() async {
  final bard = ChatBot(sessionId: "...");
  final result = await bard.ask("Hello?");
  print(result);
}
```
