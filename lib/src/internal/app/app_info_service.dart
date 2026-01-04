// Copyright (C) 2025 Fiber SAS
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber SAS. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber SAS.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber SAS.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER SAS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/subjects.dart';

@internal
abstract class AppInfoService {
  /// Human-readable application name.
  ///
  /// This value represents the **display name of the application** as defined
  /// in the platform configuration (e.g. `CFBundleDisplayName` on iOS,
  /// `android:label` on Android).
  ///
  /// It is resolved at runtime from the underlying platform metadata and
  /// exposed as a synchronous getter for convenience.
  ///
  /// This getter always returns the **latest known value** and is guaranteed
  /// to be non-null once the service has been initialized.
  String get name;

  /// Reactive stream of the application name.
  ///
  /// This stream emits the application name whenever it becomes available
  /// or changes during the lifecycle of the app.
  ///
  /// Typical use cases include:
  /// - binding the app name to UI elements (headers, settings screens),
  /// - reacting to delayed initialization (e.g. splash → main flow),
  /// - observing potential dynamic updates in multi-flavor or white-label setups.
  ///
  /// Consumers should prefer this stream when reacting to changes rather
  /// than polling the synchronous [name] getter.
  Stream<String> get nameStream;
}

@Singleton(as: AppInfoService, order: -1)
class AppInfoServiceImpl implements AppInfoService {
  final _appNameSubject = BehaviorSubject<String>.seeded("");

  @override
  String get name => _appNameSubject.value;

  @override
  Stream<String> get nameStream => _appNameSubject.stream;

  @PostConstruct(preResolve: true)
  Future<void> init() async {
    await getApplicationInfo();
  }
}

extension on AppInfoServiceImpl {
  Future<void> getApplicationInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _appNameSubject.value = packageInfo.appName;
  }
}
