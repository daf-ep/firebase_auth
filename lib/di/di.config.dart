// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fiber_firebase_auth/src/api/forgot_password.dart' as _i176;
import 'package:fiber_firebase_auth/src/api/sign_in_service.dart' as _i60;
import 'package:fiber_firebase_auth/src/api/sign_up_service.dart' as _i865;
import 'package:fiber_firebase_auth/src/api/user_service.dart' as _i597;
import 'package:fiber_firebase_auth/src/api/validator_service.dart' as _i58;
import 'package:fiber_firebase_auth/src/internal/app/app_info_service.dart'
    as _i865;
import 'package:fiber_firebase_auth/src/internal/device/device_info_service.dart'
    as _i348;
import 'package:fiber_firebase_auth/src/internal/device/network_service.dart'
    as _i484;
import 'package:fiber_firebase_auth/src/internal/local/device_service.dart'
    as _i592;
import 'package:fiber_firebase_auth/src/internal/local/local_version_service.dart'
    as _i606;
import 'package:fiber_firebase_auth/src/internal/local/rate_limite.dart'
    as _i907;
import 'package:fiber_firebase_auth/src/internal/local/user_service.dart'
    as _i816;
import 'package:fiber_firebase_auth/src/internal/remote/auth/auth_service.dart'
    as _i455;
import 'package:fiber_firebase_auth/src/internal/remote/cloud_functions/otp_service.dart'
    as _i807;
import 'package:fiber_firebase_auth/src/internal/remote/database/device_service.dart'
    as _i454;
import 'package:fiber_firebase_auth/src/internal/remote/database/remote_version_service.dart'
    as _i96;
import 'package:fiber_firebase_auth/src/internal/remote/database/user_id_service.dart'
    as _i294;
import 'package:fiber_firebase_auth/src/internal/remote/database/user_service.dart'
    as _i41;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i484.NetworkService>(
      () => _i484.NetworkServiceImpl()..init(),
    );
    gh.singleton<_i348.DeviceInfoService>(
      () => _i348.DeviceInfoServiceImpl(gh<_i484.NetworkService>())..init(),
    );
    gh.singleton<_i455.RemoteAuthService>(
      () => _i455.RemoteAuthServiceImpl()..init(),
    );
    gh.singleton<_i58.ValidatorService>(() => _i58.ValidatorServiceImpl());
    gh.singleton<_i865.AppInfoService>(
      () => _i865.AppInfoServiceImpl()..init(),
    );
    gh.singleton<_i294.RemoteUserIdService>(
      () => _i294.RemoteUserIdServiceImpl(),
    );
    gh.singleton<_i606.LocalVersionService>(
      () =>
          _i606.LocalVersionServiceImpl(gh<_i455.RemoteAuthService>())..init(),
    );
    gh.singleton<_i96.RemoteVersionService>(
      () =>
          _i96.RemoteVersionServiceImpl(gh<_i455.RemoteAuthService>())..init(),
    );
    gh.singleton<_i807.RemoteOtpService>(
      () => _i807.RemoteOtpServiceImpl(gh<_i348.DeviceInfoService>()),
    );
    gh.singleton<_i176.ForgotPasswordService>(
      () => _i176.ForgotPasswordServiceImpl(
        gh<_i348.DeviceInfoService>(),
        gh<_i484.NetworkService>(),
        gh<_i294.RemoteUserIdService>(),
        gh<_i807.RemoteOtpService>(),
      ),
    );
    gh.singleton<_i41.RemoteUserService>(
      () => _i41.RemoteUserServiceImpl(
        gh<_i455.RemoteAuthService>(),
        gh<_i348.DeviceInfoService>(),
      ),
    );
    gh.singleton<_i454.RemoteDeviceService>(
      () => _i454.RemoteDeviceServiceImpl(
        gh<_i455.RemoteAuthService>(),
        gh<_i348.DeviceInfoService>(),
      ),
    );
    gh.singleton<_i907.LocalRateLimiteService>(
      () => _i907.LocalRateLimiteServiceImpl(gh<_i348.DeviceInfoService>()),
    );
    gh.singleton<_i816.LocalUserService>(
      () => _i816.LocalUserServiceImpl(
        gh<_i455.RemoteAuthService>(),
        gh<_i41.RemoteUserService>(),
        gh<_i96.RemoteVersionService>(),
      )..init(),
    );
    gh.singleton<_i597.UserService>(
      () => _i597.UserServiceImpl(
        gh<_i816.LocalUserService>(),
        gh<_i455.RemoteAuthService>(),
      )..init(),
    );
    gh.singleton<_i592.LocalDeviceService>(
      () => _i592.LocalDeviceServiceImpl(
        gh<_i455.RemoteAuthService>(),
        gh<_i816.LocalUserService>(),
        gh<_i348.DeviceInfoService>(),
        gh<_i606.LocalVersionService>(),
      ),
    );
    gh.singleton<_i60.SignInService>(
      () => _i60.SignInServiceImpl(
        gh<_i348.DeviceInfoService>(),
        gh<_i484.NetworkService>(),
        gh<_i455.RemoteAuthService>(),
        gh<_i454.RemoteDeviceService>(),
        gh<_i592.LocalDeviceService>(),
        gh<_i807.RemoteOtpService>(),
        gh<_i294.RemoteUserIdService>(),
        gh<_i816.LocalUserService>(),
      ),
    );
    gh.singleton<_i865.SignUpService>(
      () => _i865.SignUpServiceImpl(
        gh<_i348.DeviceInfoService>(),
        gh<_i484.NetworkService>(),
        gh<_i455.RemoteAuthService>(),
        gh<_i41.RemoteUserService>(),
        gh<_i816.LocalUserService>(),
        gh<_i58.ValidatorService>(),
      ),
    );
    return this;
  }
}
