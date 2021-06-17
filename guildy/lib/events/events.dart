import 'package:nyxx/nyxx.dart';
import 'package:guildy/main.dart';

void main() {
  bot.onMessageReceived.listen((event) async {
    // Check if message was sent by the bot OR if the message does not start with the prefix
    if (event.message.author.bot || !event.message.content.startsWith(prefix)) {
      return;
    }
  });

  bot.onReady.listen((ReadyEvent e) {
    print('Guildy er oppe!');
  });
}
