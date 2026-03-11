import 'package:JsxposedX/core/providers/locale_provider.dart';
import 'package:JsxposedX/core/providers/theme_provider.dart';
import 'package:JsxposedX/core/routes/app_router.dart';
import 'package:JsxposedX/core/themes/app_theme.dart';
import 'package:JsxposedX/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 Provider 获取 GoRouter，避免重复创建
    final router = ref.watch(appRouterProvider);
    // 监听语言变化
    final locale = ref.watch(localeProvider);
    // 监听主题变化
    final theme = ref.watch(themeProvider);

    return ScreenUtilInit(
      // 设计稿尺寸（根据你的设计稿调整，常用 375x812 或 360x690）
      designSize: const Size(375, 812),
      // 最小文字适配
      minTextAdapt: true,
      // 分屏适配
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'JsxposedX',
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'CN'), // 中文
            Locale('en', 'US'), // 英文
          ],
          // 强制使用 Provider 中的 locale，忽略系统语言
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            return locale; // 直接返回 Provider 中的值
          },

          // 主题配置（支持动态切换）
          theme: theme.brightness == Brightness.light
              ? theme
              : AppTheme.lightTheme(theme.colorScheme.primary),
          darkTheme: theme.brightness == Brightness.dark
              ? theme
              : AppTheme.darkTheme(theme.colorScheme.primary),
          themeMode: theme.brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          builder: FlutterSmartDialog.init(),
        );
      },
    );
  }
}
