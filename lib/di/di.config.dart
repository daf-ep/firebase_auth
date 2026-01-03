// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fiber_firebase_auth/src/api/auth/forgot_password.dart'
    as _i1004;
import 'package:fiber_firebase_auth/src/api/auth/sign_in_service.dart' as _i573;
import 'package:fiber_firebase_auth/src/api/auth/sign_up_service.dart' as _i899;
import 'package:fiber_firebase_auth/src/api/user/current_user_service.dart'
    as _i1062;
import 'package:fiber_firebase_auth/src/api/user/data.dart' as _i1015;
import 'package:fiber_firebase_auth/src/api/user/sessions/all_sessions_service.dart'
    as _i825;
import 'package:fiber_firebase_auth/src/api/user/sessions/current_session_service.dart'
    as _i607;
import 'package:fiber_firebase_auth/src/api/user/user_metadata_service.dart'
    as _i0;
import 'package:fiber_firebase_auth/src/internal/app/app_info_service.dart'
    as _i865;
import 'package:fiber_firebase_auth/src/internal/auth/forgot_password_service.dart'
    as _i953;
import 'package:fiber_firebase_auth/src/internal/auth/rate_limite/local_service.dart'
    as _i134;
import 'package:fiber_firebase_auth/src/internal/auth/rate_limite/rate_limite_service.dart'
    as _i596;
import 'package:fiber_firebase_auth/src/internal/auth/rate_limite/remote_service.dart'
    as _i396;
import 'package:fiber_firebase_auth/src/internal/auth/sign_in_service.dart'
    as _i521;
import 'package:fiber_firebase_auth/src/internal/auth/sign_up_service.dart'
    as _i566;
import 'package:fiber_firebase_auth/src/internal/auth/user_service.dart'
    as _i114;
import 'package:fiber_firebase_auth/src/internal/device/device_info_service.dart'
    as _i348;
import 'package:fiber_firebase_auth/src/internal/device/network_service.dart'
    as _i484;
import 'package:fiber_firebase_auth/src/internal/settings/preferences_service.dart'
    as _i13;
import 'package:fiber_firebase_auth/src/internal/user/metadata/local_service.dart'
    as _i976;
import 'package:fiber_firebase_auth/src/internal/user/metadata/metadata_service.dart'
    as _i945;
import 'package:fiber_firebase_auth/src/internal/user/metadata/remote_service.dart'
    as _i533;
import 'package:fiber_firebase_auth/src/internal/user/sessions/local_service.dart'
    as _i692;
import 'package:fiber_firebase_auth/src/internal/user/sessions/remote_service.dart'
    as _i324;
import 'package:fiber_firebase_auth/src/internal/user/sessions/sessions_service.dart'
    as _i357;
import 'package:fiber_firebase_auth/src/internal/user/user/current_user_service.dart'
    as _i701;
import 'package:fiber_firebase_auth/src/internal/user/user/local_current_user_service.dart'
    as _i1072;
import 'package:fiber_firebase_auth/src/internal/user/user/remote_current_user_service.dart'
    as _i848;
import 'package:fiber_firebase_auth/src/internal/user/version/local_service.dart'
    as _i34;
import 'package:fiber_firebase_auth/src/internal/user/version/remote_service.dart'
    as _i521;
import 'package:fiber_firebase_auth/src/internal/user/version/version_service.dart'
    as _i626;
import 'package:fiber_firebase_auth/src/internal/users/sessions_service.dart'
    as _i1052;
import 'package:fiber_firebase_auth/src/internal/users/users_service.dart'
    as _i838;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await gh.singletonAsync<_i13.PreferencesService>(
      () => _i13.PreferencesService.create(),
      preResolve: true,
    );
    gh.singleton<_i484.NetworkService>(
      () => _i484.NetworkServiceImpl()..init(),
    );
    gh.singleton<_i348.DeviceInfoService>(
      () => _i348.DeviceInfoServiceImpl(gh<_i484.NetworkService>())..init(),
    );
    gh.singleton<_i838.UsersService>(() => _i838.UsersServiceImpl());
    gh.singleton<_i1052.UsersSessionsService>(
      () => _i1052.UsersSessionsServiceImpl(),
    );
    gh.singleton<_i396.RemoteRateLimiteService>(
      () => _i396.RemoteRateLimiteServiceImpl(),
    );
    gh.singleton<_i953.AuthForgotPasswordService>(
      () => _i953.AuthForgotPasswordServiceImpl(),
    );
    gh.singleton<_i865.AppInfoService>(
      () => _i865.AppInfoServiceImpl()..init(),
    );
    gh.singleton<_i114.AuthUserService>(
      () => _i114.AuthUserServiceImpl()..init(),
    );
    gh.singleton<_i566.AuthSignUpService>(() => _i566.AuthSignUpServiceImpl());
    gh.singleton<_i134.LocalRateLimiteService>(
      () => _i134.LocalRateLimiteServiceImpl(),
    );
    gh.singleton<_i1072.LocalCurrentUserService>(
      () => _i1072.LocalCurrentUserServiceImpl(),
    );
    gh.singleton<_i848.RemoteCurrentUserService>(
      () => _i848.RemoteCurrentUserServiceImpl(gh<_i114.AuthUserService>()),
    );
    gh.singleton<_i976.LocalUserMetadataService>(
      () => _i976.LocalUserMetadataServiceImpl(gh<_i114.AuthUserService>()),
    );
    gh.singleton<_i521.RemoteVersionService>(
      () => _i521.RemoteVersionServiceImpl(gh<_i114.AuthUserService>())..init(),
    );
    gh.singleton<_i596.RateLimiteService>(
      () => _i596.RateLimiteServiceImpl(
        gh<_i134.LocalRateLimiteService>(),
        gh<_i396.RemoteRateLimiteService>(),
      ),
    );
    gh.singleton<_i533.RemoteUserMetadataService>(
      () => _i533.RemoteUserMetadataServiceImpl(gh<_i114.AuthUserService>()),
    );
    gh.singleton<_i1062.CurrentUserService>(
      () => _i1062.CurrentUserServiceImpl(gh<_i114.AuthUserService>())..init(),
    );
    gh.singleton<_i945.UserMetadataService>(
      () => _i945.UserMetadataServiceImpl(
        gh<_i976.LocalUserMetadataService>(),
        gh<_i533.RemoteUserMetadataService>(),
      ),
    );
    gh.singleton<_i34.LocalVersionService>(
      () => _i34.LocalVersionServiceImpl(gh<_i114.AuthUserService>())..init(),
    );
    gh.singleton<_i324.RemoteSessionsService>(
      () => _i324.RemoteSessionsServiceImpl(
        gh<_i348.DeviceInfoService>(),
        gh<_i114.AuthUserService>(),
      )..init(),
    );
    gh.singleton<_i626.VersionService>(
      () => _i626.VersionServiceImpl(
        gh<_i34.LocalVersionService>(),
        gh<_i521.RemoteVersionService>(),
      ),
    );
    gh.singleton<_i692.LocalSessionsService>(
      () => _i692.LocalSessionsServiceImpl(
        gh<_i348.DeviceInfoService>(),
        gh<_i114.AuthUserService>(),
      ),
    );
    gh.singleton<_i357.SessionsService>(
      () => _i357.SessionsServiceImpl(
        gh<_i692.LocalSessionsService>(),
        gh<_i324.RemoteSessionsService>(),
      ),
    );
    gh.singleton<_i521.AuthSignInService>(
      () => _i521.AuthSignInServiceImpl(gh<_i348.DeviceInfoService>()),
    );
    gh.singleton<_i1004.ForgotPasswordService>(
      () => _i1004.ForgotPasswordServiceImpl(
        gh<_i348.DeviceInfoService>(),
        gh<_i484.NetworkService>(),
        gh<_i953.AuthForgotPasswordService>(),
        gh<_i596.RateLimiteService>(),
        gh<_i838.UsersService>(),
      ),
    );
    gh.singleton<_i701.CurrentUserService>(
      () => _i701.CurrentUserServiceImpl(
        gh<_i1072.LocalCurrentUserService>(),
        gh<_i848.RemoteCurrentUserService>(),
        gh<_i626.VersionService>(),
        gh<_i114.AuthUserService>(),
        gh<_i357.SessionsService>(),
      )..init(),
    );
    gh.singleton<_i899.SignUpService>(
      () => _i899.SignUpServiceImpl(
        gh<_i348.DeviceInfoService>(),
        gh<_i484.NetworkService>(),
        gh<_i596.RateLimiteService>(),
        gh<_i566.AuthSignUpService>(),
        gh<_i701.CurrentUserService>(),
      ),
    );
    gh.singleton<_i0.UserMetadataService>(
      () => _i0.UserMetadataServiceImpl(gh<_i701.CurrentUserService>())..init(),
    );
    gh.singleton<_i1015.UserDataService>(
      () => _i1015.UserDataServiceImpl(gh<_i701.CurrentUserService>())..init(),
    );
    gh.singleton<_i825.AllSessionsService>(
      () =>
          _i825.AllSessionsServiceImpl(gh<_i701.CurrentUserService>())..init(),
    );
    gh.singleton<_i573.SignInService>(
      () => _i573.SignInServiceImpl(
        gh<_i348.DeviceInfoService>(),
        gh<_i484.NetworkService>(),
        gh<_i596.RateLimiteService>(),
        gh<_i357.SessionsService>(),
        gh<_i521.AuthSignInService>(),
        gh<_i945.UserMetadataService>(),
        gh<_i1052.UsersSessionsService>(),
        gh<_i838.UsersService>(),
      ),
    );
    gh.singleton<_i607.CurrentSessionService>(
      () => _i607.CurrentSessionServiceImpl(
        gh<_i348.DeviceInfoService>(),
        gh<_i701.CurrentUserService>(),
        gh<_i357.SessionsService>(),
        gh<_i13.PreferencesService>(),
      )..init(),
    );
    return this;
  }
}
