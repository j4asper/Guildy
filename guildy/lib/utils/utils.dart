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

FutureOr<bool> commandBefore(CommandContext ctx) {
  if (ctx.author.bot) {
    // Stop the bot from invoking it's own commands
    return false;
  } else {
    return true;
  }
}
