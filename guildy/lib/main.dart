/// Support for doing something awesome.
///
/// More dartdocs go here.
library guildy;

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart' show Commander;
import 'package:nyxx_interactions/interactions.dart'
    show Interactions, SlashCommandBuilder;

// Import command files
// normalCommands
import 'package:guildy/normalCommands/commands.dart';

// slashCommands
import 'package:guildy/slashCommands/commands.dart';

// Other
import 'package:guildy/utils/utils.dart';

// BOT
late Nyxx bot;
void main() {
  // Global vars
  const String prefix = '--';

  // Bot instance
  bot = Nyxx('NzA3NTA4MjEwMzUyNzgzNDMw.XrJ0Xg.ZLPdNp4tcPnCtRLtV7L3Eu0lrSY',
      GatewayIntents.all,
      options: ClientOptions(
          initialPresence: PresenceBuilder.of(
              game: Activity.of('@Guildy | ${prefix}Hjælp'))));

  bot.onReady.listen((ReadyEvent e) {
    print('Guildy er oppe!');
  });

/*
 |-------------------|
 | STANDARD COMMANDS |
 |-------------------|
*/

  Commander(bot, prefix: prefix, beforeCommandHandler: commandBefore)
    ..registerCommand('test', testCommand)
    ..registerCommand('ping', pingCommand)
    ..registerCommand('pik', pikCommand)
    ..registerCommand('uptime', pingCommand)
    ..registerCommand('urban', urbanCommand)
    ..registerCommand('simprate', simprateCommand);

  Interactions(bot)
    ..registerSlashCommand(SlashCommandBuilder('ping', "Se Guildy's ping", [],
        guild: 699919841078935603.toSnowflake())
      ..registerHandler(pingSlashCommand))
    ..syncOnReady();
}
