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
import 'package:fiber_firebase_auth/src/api/user/email_service.dart' as _i569;
import 'package:fiber_firebase_auth/src/api/user/password_histories_service.dart'
    as _i928;
import 'package:fiber_firebase_auth/src/api/user/preferred_language_service.dart'
    as _i13;
import 'package:fiber_firebase_auth/src/api/user/sessions/all_sessions_service.dart'
    as _i825;
import 'package:fiber_firebase_auth/src/api/user/sessions/current_session_service.dart'
    as _i607;
import 'package:fiber_firebase_auth/src/api/user/user_metadata_service.dart'
    as _i0;
import 'package:fiber_firebase_auth/src/api/users_service.dart' as _i1003;
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
import 'package:fiber_firebase_auth/src/internal/current_user/current_user_service.dart'
    as _i359;
import 'package:fiber_firebase_auth/src/internal/current_user/data_service.dart'
    as _i877;
import 'package:fiber_firebase_auth/src/internal/current_user/email_service.dart'
    as _i948;
import 'package:fiber_firebase_auth/src/internal/current_user/helpers/current_user_helper_service.dart'
    as _i201;
import 'package:fiber_firebase_auth/src/internal/current_user/helpers/local_current_user_helper_service.dart'
    as _i1044;
import 'package:fiber_firebase_auth/src/internal/current_user/helpers/remote_current_user_helper_service.dart'
    as _i42;
import 'package:fiber_firebase_auth/src/internal/current_user/metadata_service.dart'
    as _i343;
import 'package:fiber_firebase_auth/src/internal/current_user/password_histories.dart'
    as _i53;
import 'package:fiber_firebase_auth/src/internal/current_user/preferred_language_service.dart'
    as _i276;
import 'package:fiber_firebase_auth/src/internal/current_user/sessions_service.dart'
    as _i1025;
import 'package:fiber_firebase_auth/src/internal/device/device_info_service.dart'
    as _i348;
import 'package:fiber_firebase_auth/src/internal/device/network_service.dart'
    as _i484;
import 'package:fiber_firebase_auth/src/internal/settings/preferences_service.dart'
    as _i13;
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
    await gh.singletonAsync<_i484.NetworkService>(() {
      final i = _i484.NetworkServiceImpl();
      return i.init().then((_) => i);
    }, preResolve: true);
    await gh.singletonAsync<_i865.AppInfoService>(() {
      final i = _i865.AppInfoServiceImpl();
      return i.init().then((_) => i);
    }, preResolve: true);
    await gh.singletonAsync<_i348.DeviceInfoService>(() {
      final i = _i348.DeviceInfoServiceImpl(gh<_i484.NetworkService>());
      return i.init().then((_) => i);
    }, preResolve: true);
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
    gh.singleton<_i114.AuthUserService>(
      () => _i114.AuthUserServiceImpl()..init(),
    );
    gh.singleton<_i566.AuthSignUpService>(() => _i566.AuthSignUpServiceImpl());
    gh.singleton<_i134.LocalRateLimiteService>(
      () => _i134.LocalRateLimiteServiceImpl(),
    );
    gh.singleton<_i1003.UsersService>(() => _i1003.UsersServiceImpl()..init());
    gh.singleton<_i1044.LocalCurrentUserHelperService>(
      () => _i1044.LocalCurrentUserHelperServiceImpl(
        gh<_i114.AuthUserService>(),
        gh<_i838.UsersService>(),
      )..init(),
    );
    gh.singleton<_i596.RateLimiteService>(
      () => _i596.RateLimiteServiceImpl(
        gh<_i134.LocalRateLimiteService>(),
        gh<_i396.RemoteRateLimiteService>(),
      ),
    );
    gh.singleton<_i42.RemoteCurrentUserHelperService>(
      () => _i42.RemoteCurrentUserHelperServiceImpl(
        gh<_i114.AuthUserService>(),
        gh<_i348.DeviceInfoService>(),
        gh<_i838.UsersService>(),
        gh<_i1044.LocalCurrentUserHelperService>(),
      )..init(),
    );
    gh.singleton<_i201.CurrentUserHelperService>(
      () => _i201.CurrentUserHelperServiceImpl(
        gh<_i1044.LocalCurrentUserHelperService>(),
        gh<_i42.RemoteCurrentUserHelperService>(),
        gh<_i348.DeviceInfoService>(),
        gh<_i114.AuthUserService>(),
      )..init(),
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
    gh.singleton<_i343.CurrentUserMetadataService>(
      () => _i343.CurrentUserMetadataServiceImpl(
        gh<_i201.CurrentUserHelperService>(),
      ),
    );
    gh.singleton<_i877.CurrentUserDataService>(
      () => _i877.CurrentUserDataServiceImpl(
        gh<_i201.CurrentUserHelperService>(),
      ),
    );
    gh.singleton<_i1015.UserDataService>(
      () => _i1015.UserDataServiceImpl(gh<_i877.CurrentUserDataService>()),
    );
    gh.singleton<_i1025.CurrentSessionsService>(
      () => _i1025.CurrentSessionsServiceImpl(
        gh<_i114.AuthUserService>(),
        gh<_i201.CurrentUserHelperService>(),
        gh<_i348.DeviceInfoService>(),
        gh<_i13.PreferencesService>(),
      ),
    );
    gh.singleton<_i948.CurrentUserEmailService>(
      () => _i948.CurrentUserEmailServiceImpl(
        gh<_i201.CurrentUserHelperService>(),
      ),
    );
    gh.singleton<_i276.CurrentUserPreferredLanguageService>(
      () => _i276.CurrentUserPreferredLanguageServiceImpl(
        gh<_i201.CurrentUserHelperService>(),
      ),
    );
    gh.singleton<_i53.CurrentUserPasswordHistoriesService>(
      () => _i53.CurrentUserPasswordHistoriesServiceImpl(
        gh<_i201.CurrentUserHelperService>(),
      ),
    );
    gh.singleton<_i13.UserPreferredLanguageService>(
      () => _i13.UserPreferredLanguageServiceImpl(
        gh<_i276.CurrentUserPreferredLanguageService>(),
      ),
    );
    gh.singleton<_i359.CurrentUserService>(
      () => _i359.CurrentUserServiceImpl(
        gh<_i201.CurrentUserHelperService>(),
        gh<_i114.AuthUserService>(),
      ),
    );
    gh.singleton<_i0.UserMetadataService>(
      () => _i0.UserMetadataServiceImpl(gh<_i343.CurrentUserMetadataService>()),
    );
    gh.singleton<_i825.UserAllSessionsService>(
      () =>
          _i825.UserAllSessionsServiceImpl(gh<_i1025.CurrentSessionsService>()),
    );
    gh.singleton<_i569.UserEmailService>(
      () => _i569.UserEmailServiceImpl(gh<_i948.CurrentUserEmailService>()),
    );
    gh.singleton<_i1062.UserService>(
      () => _i1062.UserServiceImpl(
        gh<_i114.AuthUserService>(),
        gh<_i359.CurrentUserService>(),
      ),
    );
    gh.singleton<_i607.UserSessionService>(
      () => _i607.UserSessionServiceImpl(
        gh<_i825.UserAllSessionsService>(),
        gh<_i348.DeviceInfoService>(),
        gh<_i1025.CurrentSessionsService>(),
      ),
    );
    gh.singleton<_i573.SignInService>(
      () => _i573.SignInServiceImpl(
        gh<_i348.DeviceInfoService>(),
        gh<_i484.NetworkService>(),
        gh<_i596.RateLimiteService>(),
        gh<_i1025.CurrentSessionsService>(),
        gh<_i521.AuthSignInService>(),
        gh<_i343.CurrentUserMetadataService>(),
        gh<_i1052.UsersSessionsService>(),
        gh<_i838.UsersService>(),
      ),
    );
    gh.singleton<_i928.UserPasswordHistoriesService>(
      () => _i928.UserPasswordHistoriesServiceImpl(
        gh<_i53.CurrentUserPasswordHistoriesService>(),
      ),
    );
    gh.singleton<_i899.SignUpService>(
      () => _i899.SignUpServiceImpl(
        gh<_i348.DeviceInfoService>(),
        gh<_i484.NetworkService>(),
        gh<_i596.RateLimiteService>(),
        gh<_i566.AuthSignUpService>(),
        gh<_i359.CurrentUserService>(),
      ),
    );
    return this;
  }
}
