import 'dart:async';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

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

Future<bool> commandBefore(CommandContext ctx) async {
  if (ctx.author.bot) {
    // Stop the bot from invoking it's own commands
    return false;
  } else {
    return true;
  }
}

Future<bool> checkGuildyTeam(CommandContext ctx) async {
  if (await commandBefore(ctx) && ctx.guild != null) {
    var role_ids = [for (var role in ctx.member!.roles) role.id];
    // check if user has the guildy team role
    if (role_ids.contains(709666805228109874)) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<bool> checkOwner(CommandContext ctx) async {
  if (await commandBefore(ctx)) {
    // Check bot owner AKA Jasper
    if (ctx.author.id == 282660538356596736) {
      return true;
    }
  }
  return false;
}
