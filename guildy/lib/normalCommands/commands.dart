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

Future<void> supportServerCommand(CommandContext ctx, String content) async {
  final embed = EmbedBuilder()
    ..description =
        'Du kan joine vores support server, ved at klikken [HER](https://discord.gg/ks3n5hK)'
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> inviteCommand(CommandContext ctx, String content) async {
  final embed = EmbedBuilder()
    ..description =
        'Du kan invitere mig til din egen server, ved at klikke [HER](https://top.gg/bot/692019210683154462)'
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> matchCommand(CommandContext ctx, String content) async {
  var num = Random().nextInt(101);
  if (ctx.message.mentions.isEmpty) {
    final embed = EmbedBuilder()
      ..description = 'Du har ikke nævnt en bruger'
      ..color = getColorForUserFromMessage(ctx.message);
    await ctx.reply(MessageBuilder.embed(embed));
  } else if (ctx.message.mentions.length == 1) {
    final embed = EmbedBuilder()
      ..description =
          '<@!${ctx.author.id}> og <@!${ctx.message.mentions[0].getFromCache()?.id}> matcher ``$num%``'
      ..color = getColorForUserFromMessage(ctx.message);
    await ctx.reply(MessageBuilder.embed(embed));
  } else {
    final embed = EmbedBuilder()
      ..description =
          '<@!${ctx.message.mentions[0].getFromCache()?.tag}> og <@!${ctx.message.mentions[1].getFromCache()?.tag}> matcher ``$num%``'
      ..color = getColorForUserFromMessage(ctx.message);
    await ctx.reply(MessageBuilder.embed(embed));
  }
}

Future<void> iqCommand(CommandContext ctx, String content) async {
  var iq = Random().nextInt(202);
  var tekst;
  var member;
  if (ctx.message.mentions.isEmpty) {
    member = '<@!${ctx.member?.id}>';
  } else {
    member = '<@!${ctx.message.mentions[0].id}>';
  }

  if (iq < 5) {
    tekst =
        'Holy fuck. Ikke meget at sige, fordi du kan ikke læse... Jeg får en lavere iq når jeg ser på dette.';
  } else if (iq < 50) {
    tekst = 'En iq under 50 er vel ok. Blev du tabt som barn?';
  } else if (iq < 100) {
    tekst =
        'Din iq er lav, men heldigvis ikke under 50, hvis det kan gøre dig glad...';
  } else if (iq < 150) {
    tekst =
        'Du ligger omkring gennemsnittet! Det er fedt, er det ikke? Pfff NOT.';
  } else if (iq < 200) {
    tekst = "Høj IQ hva' smart ass. Do you understand this.";
  } else if (iq == 201) {
    tekst = 'Uha, 201 IQ, jeg tager hatten af.';
  }

  final embed = EmbedBuilder()
    ..description = "**$member's IQ:** ``$iq``\n```$tekst```"
    ..thumbnailUrl =
        'https://cdn130.picsart.com/285413130007211.png?type=webp&to=min&r=640'
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> reportCommand(CommandContext ctx, String content) async {
  final embed = EmbedBuilder()
    ..addAuthor((author) {
      author.name = 'Discord';
      author.url = 'https://dis.gd/request';
      author.iconUrl =
          'https://discord.com/assets/2c21aeda16de354ba5334551a883b481.png';
    })
    ..description =
        'Klik [HER](https://dis.gd/request) for at kontakte discord tillids og sikerhedsteam. Skriv kun hvis du skal anmelde en bruger, som har brudt discords Terms of Service.'
    ..title = 'Kontakt discords Tillids & Sikkerhedsteam!'
    ..thumbnailUrl =
        'https://discord.com/assets/4ff060e44afc171e9622fbe589c2c09e.png'
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> tosCommand(CommandContext ctx, String content) async {
  final embed = EmbedBuilder()
    ..addAuthor((author) {
      author.name = 'Discord';
      author.url = 'https://dis.gd/request';
      author.iconUrl =
          'https://discord.com/assets/2c21aeda16de354ba5334551a883b481.png';
    })
    ..description =
        'Klik [HER](https://discordapp.com/terms) for at læse discord Terms of Service (ToS), og læs også Discords retningslinjer [HER](https://discord.com/guidelines). Disse skal overholdes for at være på discord!'
    ..title = 'Discords Terms of Service & Retningslinjer!'
    ..thumbnailUrl =
        'https://discord.com/assets/4ff060e44afc171e9622fbe589c2c09e.png'
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> coinflipCommand(CommandContext ctx, String content) async {
  var img;
  var tekst;
  if (Random().nextInt(2) == 1) {
    img = 'https://i.ibb.co/fMvR8Kw/Plat.png';
    tekst = 'plat';
  } else {
    img = 'https://i.ibb.co/7pKZ6hh/Krone.png';
    tekst = 'krone';
  }
  final embed = EmbedBuilder()
    ..title = 'Det blev $tekst!'
    ..thumbnailUrl = img
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.reply(MessageBuilder.embed(embed));
}

Future<void> feedbackCommand(CommandContext ctx, String content) async {
  var channel = await ctx.client.fetchChannel(709077988452466811.toSnowflake())
      as TextChannel;
  var feedback =
      content.toLowerCase().replaceFirst('${prefix}feedback', '').trim();
  if (feedback.isEmpty) {
    var embed = EmbedBuilder()
      ..description = 'Du har ikke skrevet noget feedback!'
      ..color = getColorForUserFromMessage(ctx.message);
    // Send embed som bekrftelse på feedback
    await ctx.sendMessage(MessageBuilder.embed(embed));
    return;
  }
  final embed = EmbedBuilder()
    ..title = 'Feedback'
    ..description = feedback
    ..addAuthor((author) {
      author.name = ctx.guild?.name;
      author.iconUrl = ctx.guild?.iconURL();
    })
    ..addFooter((footer) {
      footer.iconUrl = ctx.author.avatarURL();
      footer.text = 'Sendt af: ${ctx.author.username} | ID: ${ctx.author.id}';
    })
    ..color = getColorForUserFromMessage(ctx.message);

  // Send embed til feedback kanal først
  await channel.sendMessage(MessageBuilder.embed(embed));

  var embed1 = EmbedBuilder()
    ..description = 'Din feedback er blevet sendt til support serveren!'
    ..color = getColorForUserFromMessage(ctx.message);
  // Send embed som bekrftelse på feedback
  await ctx.sendMessage(MessageBuilder.embed(embed1));
}

//////////////////////////////////////////////////////////////////////////////

Future<void> statsCommand(CommandContext ctx, String content) async {
  var guild_count = ctx.client.guilds.count;
  var member_count = ctx.client.users.count;
  var uptime =
      '${ctx.client.uptime.inDays} dag(e) og ${ctx.client.uptime.inHours} time(r)';

  final embed = EmbedBuilder()
    ..addField(
        name: 'Bot information',
        content:
            '**ID:** ``${ctx.client.self.id}``\n**Trello:** [Trello.com](https://trello.com/b/pvaW8xbe/guildydk)')
    ..addField(
        name: 'Stats',
        content:
            '**Servere:** $guild_count\n**Brugere:** $member_count\n**Uptime:** $uptime')
    ..addField(
        name: 'Links',
        content:
            '[Upvote](https://top.gg/bot/692019210683154462/vote) | [Support server](https://discord.gg/ks3n5hK)')
    ..addAuthor((author) {
      author.name = 'Find Guildy her';
      author.iconUrl = 'https://img.icons8.com/plasticine/2x/invite.png';
    })
    ..thumbnailUrl = ctx.client.self.avatarURL()
    ..color = getColorForUserFromMessage(ctx.message);

  await ctx.sendMessage(MessageBuilder.embed(embed));
}
