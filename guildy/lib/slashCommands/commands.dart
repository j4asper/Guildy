import 'package:guildy/utils/utils.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

Future<void> pingSlashCommand(InteractionEvent event) async {
  await event.acknowledge();

  var latency = event.interaction.guild
      ?.getFromCache()
      ?.shard
      .gatewayLatency
      .inMilliseconds;
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
    ..color = getColorForUserFromMember(event.interaction.memberAuthor);

  await event.respond(MessageBuilder.embed(embed));
}
