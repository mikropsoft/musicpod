import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:ubuntu_service/ubuntu_service.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import '../../app.dart';
import '../../build_context_x.dart';
import '../../common.dart';
import '../../constants.dart';
import '../../library.dart';
import '../../settings.dart';
import '../../theme.dart';
import '../globals.dart';
import 'connectivity_notifier.dart';
import 'master_items.dart';

class MasterDetailPage extends StatelessWidget {
  const MasterDetailPage({
    super.key,
    required this.countryCode,
  });

  final String? countryCode;

  @override
  Widget build(BuildContext context) {
    final appStateService = getService<AppStateService>();
    final appIndex = appStateService.appIndex;

    // Connectivity
    final isOnline = context.watch<ConnectivityNotifier>().isOnline;

    // Library
    final libraryModel = context.watch<LibraryModel>();

    final masterItems = createMasterItems(
      libraryModel: libraryModel,
      isOnline: isOnline,
      countryCode: countryCode,
    );

    return YaruMasterDetailTheme(
      data: YaruMasterDetailTheme.of(context).copyWith(
        sideBarColor: getSideBarColor(context.t),
      ),
      child: YaruMasterDetailPage(
        navigatorKey: navigatorKey,
        onSelected: (value) => appStateService.setAppIndex(value ?? 0),
        appBar: const HeaderBar(
          style: YaruTitleBarStyle.undecorated,
          title: Text('MusicPod'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: SettingsButton(),
            ),
          ],
        ),
        layoutDelegate: const YaruMasterFixedPaneDelegate(
          paneWidth: 250,
        ),
        breakpoint: kMasterDetailBreakPoint,
        controller: YaruPageController(
          length: libraryModel.totalListAmount,
          initialIndex: appIndex.watch(context),
        ),
        tileBuilder: (context, index, selected, availableWidth) {
          final item = masterItems[index];

          return MasterTile(
            pageId: item.pageId,
            libraryModel: libraryModel,
            selected: selected,
            title: item.titleBuilder(context),
            subtitle: item.subtitleBuilder?.call(context),
            leading: item.iconBuilder?.call(
              context,
              selected,
            ),
          );
        },
        pageBuilder: (context, index) => YaruDetailPage(
          body: masterItems[index].pageBuilder(context),
        ),
      ),
    );
  }
}
