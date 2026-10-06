import 'package:dio/dio.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/remote/Routes.dart';
import 'package:novabank/shared/SecureStorage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  final noAuthEndpoints = {
    LOGIN,
    REGISTER,
    REGISTER_VERIFY_OTP,
    RESEND_REGISTER_VERIFY_OTP,
    FORGOT_PASSWORD,
    RESET_FORGOT_PASSWORD,
    REFRESH_TOKEN
  };

  AuthInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (noAuthEndpoints.contains(options.path)) {
      return handler.next(options);
    }
    final access = await TokenStorage.readAccessToken();
    if (access != null) {
      options.headers['Authorization'] = 'Bearer $access';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final req = err.requestOptions;
    if (noAuthEndpoints.contains(req.path)) {
      return handler.next(err);
    }
    if (err.response?.statusCode == 401 && !req.extra.containsKey('retry')) {
      try {
        final refreshed = await _handleRefreshToken();
        if (refreshed) {
          final opts = Options(
            method: req.method,
            headers: {
              ...req.headers,
              'Authorization': 'Bearer ${await TokenStorage.readAccessToken()}',
            },
            extra: {...req.extra, 'retry': true},
          );
          final cloneResponse = await dio.request(
            req.path,
            data: req.data,
            queryParameters: req.queryParameters,
            options: opts,
          );
          return handler.resolve(cloneResponse);
        } else {
          handler.next(err);
        }
      } catch (_) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  Future<bool> _handleRefreshToken() async {
    var manager = Manager();
    if (_isRefreshing) {
      while (_isRefreshing) {
        await Future.delayed(Duration(milliseconds: 150));
      }
      return (await TokenStorage.readAccessToken()) != null;
    }
    final refresh = await TokenStorage.readRefreshToken();
    if (refresh == null) {
      manager.performLogout();
      return false;
    }

    _isRefreshing = true;
    return manager.refreshToken(refresh);
  }
}
