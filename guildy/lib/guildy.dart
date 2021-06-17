/// Support for doing something awesome.
///
/// More dartdocs go here.
library guildy;

import 'package:nyxx/nyxx.dart'
    show
        Activity,
        ClientOptions,
        DiscordColor,
        GatewayIntents,
        GuildMessage,
        Member,
        Message,
        Nyxx,
        PresenceBuilder,
        ReadyEvent;
import 'package:nyxx_commander/commander.dart' show Commander;
import 'package:nyxx_interactions/interactions.dart'
    show Interactions, SlashCommandBuilder;

// Import command files
// normalCommands
import 'package:guildy/normalCommands/commands.dart';

// slashCommands
import 'package:guildy/slashCommands/commands.dart';

DiscordColor? getColorForUserFromMessage(Message message) {
  if (message is GuildMessage) {
    // return message.guild.getFromCache()?.selfMember?.highestRole.color;
    return message.member.highestRole.color;
  }
  // Return standard color
  return DiscordColor.fromInt(0x68C2AF);
}

DiscordColor? getColorForUserFromMember(Member member) {
  // return member.guild.getFromCache()?.selfMember?.highestRole.color;
  return member.highestRole.color;
}

// BOT
void main() {
  // Global vars
  const String prefix = '--';

  // Bot instance
  final bot = Nyxx(
      'NzA3NTA4MjEwMzUyNzgzNDMw.XrJ0Xg.ZLPdNp4tcPnCtRLtV7L3Eu0lrSY',
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

  Commander(bot, prefix: prefix)
    ..registerCommand('ping', pingCommand)
    ..registerCommand('pik', pikCommand)
    ..registerCommand('uptime', pingCommand)
    ..registerCommand('urban', pingCommand)
    ..registerCommand('simprate', pingCommand);

  Interactions(bot)
    ..registerSlashCommand(SlashCommandBuilder("ping", "Se Guildy's ping", [])
      ..registerHandler(pingSlashCommand))
    ..syncOnReady();

  bot.onMessageReceived.listen((event) async {
    // Check if message was sent by the bot OR if the message does not start with the prefix
    if (event.message.author.bot || !event.message.content.startsWith(prefix)) {
      return;
    }
  });
}
