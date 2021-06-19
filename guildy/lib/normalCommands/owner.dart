import 'dart:async';
import 'package:guildy/main.dart';
import 'package:guildy/utils/db_handler.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:guildy/utils/utils.dart';

Future<void> testCommand(CommandContext ctx, String content) async {
  if (await checkGuildyTeam(ctx)) {
    await ctx.reply(MessageBuilder.content('jajajaja'));
  }
}

Future<void> sqlCommand(CommandContext ctx, String content) async {
  if (await checkOwner(ctx)) {
    var args = content.replaceFirst('${prefix}sql', '').trim();
    executeSQL(args);
    final embed = EmbedBuilder()
      ..addAuthor((author) {
        author.name = 'SQL udført';
      })
      ..description = '```sql\n$args\n```';

    await ctx.reply(MessageBuilder.embed(embed));
  }
}
