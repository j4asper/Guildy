/// Support for doing something awesome.
///
/// More dartdocs go here.
library guildy;

import 'dart:io' as io;
import 'package:yaml/yaml.dart';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:nyxx_interactions/interactions.dart';

// Import command files
// normalCommands
import 'package:guildy/normalCommands/commands.dart';
import 'package:guildy/normalCommands/owner.dart';

// slashCommands
import 'package:guildy/slashCommands/commands.dart';

// Other
import 'package:guildy/utils/utils.dart';
import 'package:guildy/events/events.dart';

// BOT
late Nyxx bot;

// Global vars
const String prefix = '--';

void main() {
  // Get token from conf.yaml
  var file = io.File('conf.yaml');
  var yamlString = file.readAsStringSync();
  Map yaml = loadYaml(yamlString);

  // Bot instance
  bot = Nyxx(yaml['token'], GatewayIntents.all,
      options: ClientOptions(
          initialPresence: PresenceBuilder.of(
              game: Activity.of('@Guildy | ${prefix}Hjælp'))));

  // Make sure events.dart is registered
  events();

  Commander(bot, prefix: prefix, beforeCommandHandler: commandBefore)
    // OWNER COMMANDS
    ..registerCommand('sql', sqlCommand)
    ..registerCommand('test', testCommand)
    //..registerSubCommand('test', testCommand)
    //..registerCommand('test', testCommand)
    ..registerCommand('ping', pingCommand)
    ..registerCommand('pik', pikCommand)
    ..registerCommand('uptime', uptimeCommand)
    ..registerCommand('urban', urbanCommand)
    ..registerCommand('simprate', simprateCommand)
    //
    ..registerCommand('fortrolighedspolitik', privacyCommand)
    ..registerCommand('privacy', privacyCommand)
    //
    ..registerCommand('avatar', avatarCommand)
    ..registerCommand('pb', avatarCommand)
    ..registerCommand('av', avatarCommand)
    ..registerCommand('profilbillede', avatarCommand)
    //
    ..registerCommand('stats', statsCommand)
    ..registerCommand('feedback', feedbackCommand)
    ..registerCommand('coinflip', coinflipCommand)
    ..registerCommand('tos', tosCommand)
    ..registerCommand('report', reportCommand)
    ..registerCommand('iq', iqCommand)
    ..registerCommand('match', matchCommand)
    ..registerCommand('supportserver', supportServerCommand)
    ..registerCommand('invite', inviteCommand);

  Interactions(bot)
    ..registerSlashCommand(SlashCommandBuilder('ping', "Se Guildy's ping", [],
        guild: 699919841078935603.toSnowflake())
      ..registerHandler(pingSlashCommand))
    ..syncOnReady();
}
