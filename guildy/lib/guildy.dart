/// Support for doing something awesome.
///
/// More dartdocs go here.
library guildy;

import 'dart:math';
import 'dart:convert';
import 'package:nyxx/nyxx.dart';
import 'package:http/http.dart' as http;
//import 'package:nyxx_commander/commander.dart';
//import 'package:nyxx_interactions/interactions.dart';

DiscordColor? getColorForUserFromMessage(Message message) {
  if (message is GuildMessage) {
    // return message.guild.getFromCache()?.selfMember?.highestRole.color;
    return message.member.highestRole.color;
  }
  // Return standard color
  return DiscordColor.fromInt(0x68C2AF);
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

  bot.onMessageReceived.listen((event) async {
    // Check if message was sent by the bot OR if the message does not start with the prefix
    if (event.message.author.bot || !event.message.content.startsWith(prefix)) {
      return;
    }
    var content = event.message.content.toLowerCase();
    var channel = event.message.channel;
    var author = event.message.author;

    // PING KOMMANDO
    if (content.trim() == '${prefix}ping') {
      var latency = bot.shardManager.gatewayLatency.inMilliseconds;
      String? desc;
      if (latency == 0) {
        desc = 'Bottens ping er ikke tilgængelig lige nu.';
      } else {
        desc = '🏓 ``$latency`` ms';
      }
      final embed = EmbedBuilder()
        ..addAuthor((author) {
          author.name = 'Ping';
        })
        ..description = desc
        ..color = getColorForUserFromMessage(event.message);

      await channel.getFromCache()!.sendMessage(MessageBuilder.embed(embed));
    }

    // PIK KOMMANDO
    if (content.startsWith('${prefix}pik') ||
        content.startsWith('${prefix}penis') ||
        content.startsWith('${prefix}tissemand')) {
      var random = Random();
      var length = random.nextInt(21);

      // Check if a user was mentioned:
      var member = author;
      if (event.message.mentions.isNotEmpty) {
        member = event.message.mentions[0].getFromCache()!;
      }
      ;
      final embed = EmbedBuilder()
        ..addAuthor((author) {
          author.name = "${member.username}'s pik længde";
        })
        ..description = '``8=${'=' * (length)}D``'
        ..color = getColorForUserFromMessage(event.message);

      await channel.sendMessage(MessageBuilder.embed(embed));
    }

    // SIMPRATE KOMMANDO
    if (content.startsWith('${prefix}simprate')) {
      var random = Random();
      var procent = random.nextInt(101);

      // Check if a user was mentioned:
      var member = author;
      if (event.message.mentions.isNotEmpty) {
        member = event.message.mentions[0].getFromCache()!;
      }
      ;
      final embed = EmbedBuilder()
        ..addAuthor((author) {
          author.name = 'Er ${member.username} en simp?';
        })
        ..description = '<@${member.id}> er ``$procent%`` Simp'
        ..color = getColorForUserFromMessage(event.message);

      await channel.sendMessage(MessageBuilder.embed(embed));
    }

    // UPTIME KOMMANDO
    if (content.trim() == '${prefix}uptime') {
      var uptime = bot.uptime;

      var dage = 'dage';
      var timer = 'timer';
      var minutter = 'minutter';
      if (uptime.inDays == 1) {
        dage = 'dag';
      }
      if (uptime.inHours == 1) {
        timer = 'time';
      }
      if (uptime.inMinutes == 1) {
        minutter = 'minut';
      }

      final embed = EmbedBuilder()
        ..addAuthor((author) {
          author.name = 'Uptime';
        })
        ..description =
            'Jeg har været online i: \n${uptime.inDays} $dage, ${uptime.inHours} $timer, ${uptime.inMinutes} $minutter'
        ..color = getColorForUserFromMessage(event.message);

      await channel.sendMessage(MessageBuilder.embed(embed));
    }

    if (content.startsWith('${prefix}urban')) {
      var args = content.replaceFirst('${prefix}urban', '').trim();
      final embed = EmbedBuilder()
        ..color = getColorForUserFromMessage(event.message);

      if (args.isEmpty) {
        embed.description = 'Du har ikke skrevet et ord.';
      } else {}
      // Make request to urban:
      var url = Uri.parse(
          'https://mashape-community-urban-dictionary.p.rapidapi.com/define?term=$args');

      var headers = {
        'x-rapidapi-host': 'mashape-community-urban-dictionary.p.rapidapi.com',
        'x-rapidapi-key': '61a6ec9668msh399d69bdd49216dp13b82djsna3e4e1072d56'
      };
      //Map<String, String> qParams = {'term': args};
      var response = await http.get(url, headers: headers);
      // Sæt json i embed
      print(jsonDecode(response.body.toString()));
      //await channel
      //    .sendMessage(MessageBuilder.content(response.body.toString()));
      //embed.description = response.toString();
      //await channel.sendMessage(MessageBuilder.embed(embed));
    }
  });
}
// TODO: Export any libraries intended for clients of this package.
