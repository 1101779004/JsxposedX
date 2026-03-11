import 'package:JsxposedX/common/pages/error_page.dart';
import 'package:JsxposedX/core/routes/routes/home_route.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routerNeglect: false,
    initialLocation: '/',
    debugLogDiagnostics: true,
    //debug开启日志
    redirect: (context, state) {
      return null;
    },
    routes: [
      ...homeRoutes,
      GoRoute(
        path: '/:notFound(.*)',
        builder: (context, state) {
          return ErrorPage(error: state.matchedLocation);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return ErrorPage(error: state.error);
    },
  );
});
