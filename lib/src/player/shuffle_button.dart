import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../build_context_x.dart';
import '../../l10n.dart';
import '../common/icons.dart';
import 'player_model.dart';

class ShuffleButton extends ConsumerWidget {
  const ShuffleButton({
    super.key,
    required this.active,
  });

  final bool active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.t;
    final shuffle = ref.watch(playerModelProvider.select((m) => m.shuffle));
    final setShuffle = ref.read(playerModelProvider).setShuffle;

    return IconButton(
      tooltip: context.l10n.shuffle,
      icon: Icon(
        Iconz().shuffle,
        color: !active
            ? theme.disabledColor
            : (shuffle
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface),
      ),
      onPressed: !active ? null : () => setShuffle(!(shuffle)),
    );
  }
}
