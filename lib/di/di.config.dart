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
import 'package:fiber_firebase_auth/src/app/app_info_service.dart' as _i274;
import 'package:fiber_firebase_auth/src/device/device_info_service.dart'
    as _i124;
import 'package:fiber_firebase_auth/src/device/network_service.dart' as _i879;
import 'package:fiber_firebase_auth/src/firebase/auth/auth_service.dart'
    as _i1001;
import 'package:fiber_firebase_auth/src/firebase/database/device_service.dart'
    as _i178;
import 'package:fiber_firebase_auth/src/firebase/database/otp_service.dart'
    as _i539;
import 'package:fiber_firebase_auth/src/firebase/database/rate_limite.dart'
    as _i929;
import 'package:fiber_firebase_auth/src/firebase/database/remote_version_service.dart'
    as _i1000;
import 'package:fiber_firebase_auth/src/firebase/database/user_id_service.dart'
    as _i1065;
import 'package:fiber_firebase_auth/src/firebase/database/user_service.dart'
    as _i944;
import 'package:fiber_firebase_auth/src/local_storage/services/device_service.dart'
    as _i540;
import 'package:fiber_firebase_auth/src/local_storage/services/local_version_service.dart'
    as _i927;
import 'package:fiber_firebase_auth/src/local_storage/services/rate_limite.dart'
    as _i75;
import 'package:fiber_firebase_auth/src/local_storage/services/user_service.dart'
    as _i687;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i879.NetworkService>(
      () => _i879.NetworkServiceImpl()..init(),
    );
    gh.singleton<_i124.DeviceInfoService>(
      () => _i124.DeviceInfoServiceImpl(gh<_i879.NetworkService>())..init(),
    );
    gh.singleton<_i58.ValidatorService>(() => _i58.ValidatorServiceImpl());
    gh.singleton<_i1001.AuthService>(() => _i1001.AuthServiceImpl()..init());
    gh.singleton<_i274.AppInfoService>(
      () => _i274.AppInfoServiceImpl()..init(),
    );
    gh.singleton<_i1065.UserIdService>(() => _i1065.UserIdServiceImpl());
    gh.singleton<_i1000.RemoteVersionService>(
      () => _i1000.RemoteVersionServiceImpl(gh<_i1001.AuthService>())..init(),
    );
    gh.singleton<_i539.OtpService>(() => _i539.OtpServiceImpl());
    gh.singleton<_i944.UserService>(
      () => _i944.UserServiceImpl(
        gh<_i1001.AuthService>(),
        gh<_i124.DeviceInfoService>(),
      ),
    );
    gh.singleton<_i687.LocalUserService>(
      () => _i687.LocalUserServiceImpl(
        gh<_i1001.AuthService>(),
        gh<_i944.UserService>(),
        gh<_i1000.RemoteVersionService>(),
      )..init(),
    );
    gh.singleton<_i927.LocalVersionService>(
      () => _i927.LocalVersionServiceImpl(gh<_i687.LocalUserService>())..init(),
    );
    gh.singleton<_i75.LocalRateLimiteService>(
      () => _i75.LocalRateLimiteServiceImpl(gh<_i124.DeviceInfoService>()),
    );
    gh.singleton<_i178.DeviceService>(
      () => _i178.DeviceServiceImpl(
        gh<_i1001.AuthService>(),
        gh<_i124.DeviceInfoService>(),
      ),
    );
    gh.singleton<_i540.LocalDeviceService>(
      () => _i540.LocalDeviceServiceImpl(
        gh<_i1001.AuthService>(),
        gh<_i687.LocalUserService>(),
        gh<_i124.DeviceInfoService>(),
      ),
    );
    gh.singleton<_i929.RateLimiteService>(
      () => _i929.RateLimiteServiceImpl(
        gh<_i124.DeviceInfoService>(),
        gh<_i75.LocalRateLimiteService>(),
      ),
    );
    gh.singleton<_i597.UserService>(
      () => _i597.UserServiceImpl(
        gh<_i687.LocalUserService>(),
        gh<_i1001.AuthService>(),
      )..init(),
    );
    gh.singleton<_i865.SignUpService>(
      () => _i865.SignUpServiceImpl(
        gh<_i124.DeviceInfoService>(),
        gh<_i879.NetworkService>(),
        gh<_i1001.AuthService>(),
        gh<_i944.UserService>(),
        gh<_i687.LocalUserService>(),
        gh<_i58.ValidatorService>(),
      ),
    );
    gh.singleton<_i176.ForgotPasswordService>(
      () => _i176.ForgotPasswordServiceImpl(
        gh<_i124.DeviceInfoService>(),
        gh<_i879.NetworkService>(),
        gh<_i929.RateLimiteService>(),
        gh<_i1065.UserIdService>(),
        gh<_i539.OtpService>(),
      ),
    );
    gh.singleton<_i60.SignInService>(
      () => _i60.SignInServiceImpl(
        gh<_i124.DeviceInfoService>(),
        gh<_i879.NetworkService>(),
        gh<_i1001.AuthService>(),
        gh<_i178.DeviceService>(),
        gh<_i540.LocalDeviceService>(),
        gh<_i539.OtpService>(),
        gh<_i929.RateLimiteService>(),
        gh<_i1065.UserIdService>(),
      ),
    );
    return this;
  }
}
