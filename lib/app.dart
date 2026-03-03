// ──────────────────────────────────────────────────────────────
// lib/app.dart
// PURPOSE : Root CupertinoApp.router widget.
//           Wires up GoRouter, theme, locale, and l10n delegates.
//           Starts deep-link listener after first frame.
// ──────────────────────────────────────────────────────────────

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Brightness, DefaultTextStyle, Theme, ThemeData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:enyx_starter/core/localization/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/config/env.dart';
import 'core/theme/app_fonts.dart';
import 'core/theme/theme_controller.dart';
import 'core/utils/app_sizes.dart';
import 'core/localization/locale_controller.dart';
import 'core/routing/app_router.dart';
import 'main.dart' show startPostLaunchServices;

class EnyxStarterApp extends ConsumerStatefulWidget {
  const EnyxStarterApp({super.key});

  @override
  ConsumerState<EnyxStarterApp> createState() => _EnyxStarterAppState();
}

class _EnyxStarterAppState extends ConsumerState<EnyxStarterApp> {
  @override
  void initState() {
    super.initState();
    // Start deep-link listener after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startPostLaunchServices(ProviderScope.containerOf(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);
    final themeData = ref.watch(themeDataProvider);
    final fontKey = ref.watch(fontFamilyProvider);
    final fontFamily = AppTypography.getFontFamily(fontKey);
    final width = MediaQuery.sizeOf(context).width;

    // Update global scale from MediaQuery to avoid mutating layout state
    // during RenderLayoutBuilder.performLayout.
    AppSizes.updateScale(width);

    return CupertinoApp.router(
      title: 'Enyx Starter${Env.appNameSuffix}',
      debugShowCheckedModeBanner: !Env.isProd,

      // ── Theme ────────────────────────────────────────────
      theme: themeData,

      // ── Locale ───────────────────────────────────────────
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ── Router ───────────────────────────────────────────
      routerConfig: router,
      builder: (context, child) {
        final brightness = themeData.brightness ?? Brightness.dark;
        final materialTheme = ThemeData(
          brightness: brightness,
          fontFamily: fontFamily,
        );

        return Theme(
          data: materialTheme,
          child: DefaultTextStyle(
            style: TextStyle(
              fontFamily: fontFamily,
              color: brightness == Brightness.dark
                  ? const Color(0xFFE8E8ED)
                  : const Color(0xFF1D1D1F),
            ),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
