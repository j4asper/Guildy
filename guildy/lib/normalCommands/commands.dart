import 'dart:async';
import 'dart:math' show Random;
import 'dart:convert' show jsonDecode;
import 'package:guildy/main.dart';
import 'package:http/http.dart' as http;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:guildy/utils/utils.dart';

Future<void> pikCommand(CommandContext ctx, String content) async {
  var random = Random();
  var length = random.nextInt(21);

  // Check if a user was mentioned:
  var member = ctx.author;
  if (ctx.message.mentions.isNotEmpty) {
    member = ctx.message.mentions[0].getFromCache()!;
  }
  ;
  final embed = EmbedBuilder()
    ..addAuthor((author) {
      author.name = "${member.username}'s pik længde";
    })
    ..description = '``8=${'=' * (length)}D``'
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> pingCommand(CommandContext ctx, String content) async {
  var latency = ctx.client.shardManager.gatewayLatency.inMilliseconds;
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
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> uptimeCommand(CommandContext ctx, String content) async {
  var uptime = ctx.client.uptime;
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
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> urbanCommand(CommandContext ctx, String content) async {
  var args = content
      .toLowerCase()
      .replaceFirst('${prefix}urban', '')
      .trim()
      .replaceAll(' ', '_');
  final embed = EmbedBuilder()..color = getColorForUserFromMessage(ctx.message);

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
  var data = jsonDecode(response.body)['list'];
  var random = Random();
  var num = random.nextInt(data.length - 1);
  var definition =
      data[num]['definition'].replaceAll('[', '').replaceAll(']', '');
  var example = data[num]['example'].replaceAll('[', '').replaceAll(']', '');
  embed.title = data[num]['word'];
  embed.description = '**Definition:**\n$definition\n\n**Eksemel:**\n$example';
  embed.addAuthor((author) {
    author.name = 'Urban Dictionary';
    author.url = data[num]['permalink'];
    author.iconUrl =
        'https://slack-files2.s3-us-west-2.amazonaws.com/avatars/2018-01-11/297387706245_85899a44216ce1604c93_512.jpg';
  });
  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> simprateCommand(CommandContext ctx, String content) async {
  var random = Random();
  var procent = random.nextInt(101);

  // Check if a user was mentioned:
  var member = ctx.author;
  if (ctx.message.mentions.isNotEmpty) {
    member = ctx.message.mentions[0].getFromCache()!;
  }
  ;
  final embed = EmbedBuilder()
    ..addAuthor((author) {
      author.name = 'Er ${member.username} en simp?';
    })
    ..description = '<@${member.id}> er ``$procent%`` Simp'
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> privacyCommand(CommandContext ctx, String content) async {
  final embed = EmbedBuilder()
    ..addField(
        name: "Brug af Server ID'er:",
        content:
            'Guildy gemmer din servers ID, hvis du aktivere en feature eller ændre din prefix! Dette gør at vi kan finde din server og sørge for at du får det, som du har aktiveret/ændret.')
    ..addField(
        name: "Brug af Bruger ID'er:",
        content:
            "Guildy gemmer bruger ID'er, hvis du f.eks. laver en konto. Ændre du noget som kun ændres for din bruger, så kan du være meget sikker på at vi har gemt dit ID, for at du har adgang til det du har ændret eller aktiveret.")
    ..addField(
        name: 'Fjernelse af Data:',
        content:
            'Hvis du vil have data fjernet, så kontakt os på vores [support server](https://discord.gg/ks3n5hK), hvis du kicker Guildy vil alle data om din server blive fjernet, __ikke__ dine bruger data.')
    ..addField(
        name: 'Andet?',
        content:
            'Vi gemmer ikke logs, beskeder, profilbilleder eller ligende. Skriv til os på vores [support server](https://discord.gg/ks3n5hK) hvis du har spørgsmål.')
    ..description =
        "Guildy's fortrolighedspolitik, et krav fra discord at have fra den 18. august."
    ..addAuthor((author) {
      author.name = 'Fortrolighedspolitik';
    })
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> avatarCommand(CommandContext ctx, String content) async {
  var avatarUrl;
  var authorText;
  if (ctx.message.mentions.isNotEmpty) {
    avatarUrl = ctx.message.mentions[0].getFromCache()?.avatarURL();
    authorText = "${ctx.message.mentions[0].getFromCache()?.username}'s avatar";
  } else {
    avatarUrl = ctx.author.avatarURL();
    authorText = 'Din avatar';
  }

  final embed = EmbedBuilder()
    ..imageUrl = avatarUrl
    ..addAuthor((author) {
      author.name = authorText;
      author.url = avatarUrl;
    })
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> inviteCommand(CommandContext ctx, String content) async {
  final embed = EmbedBuilder()
    ..description =
        'Du kan joine vores support server ved at klikken [HER](https://discord.gg/ks3n5hK)'
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}
