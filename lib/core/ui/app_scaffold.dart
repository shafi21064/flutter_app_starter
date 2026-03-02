// ──────────────────────────────────────────────────────────────
// lib/core/ui/app_scaffold.dart
// PURPOSE : Common page wrapper that applies the OfflineBanner
//           and provides a consistent layout structure.
//
// HOW TO USE:
//   AppScaffold(
//     title: 'My Page',
//     body: MyContent(),
//   );
// ──────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Material, MaterialType; // For Material-based widgets if needed

import '../connectivity/offline_banner.dart';

/// Standard scaffold wrapper used across all pages, using Cupertino style.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showAppBar = false,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: showAppBar
          ? CupertinoNavigationBar(
              middle: title != null ? Text(title!) : null,
              trailing: actions != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!,
                    )
                  : null,
            )
          : null,
      child: Stack(
        children: [
          Image.asset("assets/images/themes/bg.jpg", fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          SafeArea(
            child: Column(
              children: [
                const OfflineBanner(),
                Expanded(
                  child: Material(
                    // Some widgets like Gap or list tiles might still expect a Material ancestor
                    type: MaterialType.transparency,
                    child: body,
                  ),
                ),
                if (bottomNavigationBar != null) ...[bottomNavigationBar!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
