// Copyright (C) 2025 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import '../../../models/auth/ip_info.dart';
import '../../../models/user/session.dart';
import 'network_service.dart';

@internal
abstract class DeviceInfoService {
  /// Latest resolved IP-related information for the current device.
  ///
  /// This may be `null` if the information has not yet been resolved,
  /// if the network is unavailable, or if all remote lookups failed.
  IpInfo? get ipInfo;

  /// Reactive stream of IP-related information.
  ///
  /// Emits whenever the IP information becomes available or is refreshed.
  /// Useful for triggering geo-aware logic or updating UI once the data
  /// has been successfully resolved.
  Stream<IpInfo?> get ipInfoStream;

  /// Unique identifier associated with the current device.
  ///
  /// The concrete value and stability guarantees depend on the underlying
  /// platform (e.g. Android ID, iOS identifierForVendor, desktop machine ID).
  /// A fallback value is provided when no identifier can be resolved.
  String get identifier;

  /// Reactive stream of the device identifier.
  ///
  /// Emits when the identifier is first resolved or if it changes due to
  /// platform-specific behavior.
  Stream<String> get identifierStream;

  /// Human-readable device model or system description.
  ///
  /// Examples include phone model names or desktop system identifiers.
  /// A placeholder value may be used until the information is available.
  String get model;

  /// Reactive stream of the device model.
  ///
  /// Emits when the model information is resolved or updated.
  Stream<String> get modelStream;

  /// Indicates whether the device is considered a physical device.
  ///
  /// On mobile platforms, this typically distinguishes real devices from
  /// emulators. On desktop platforms, this value is provided by convention.
  bool get isPhysical;

  /// Reactive stream of the physical device flag.
  ///
  /// Emits whenever the physical/emulated status is resolved or changes.
  Stream<bool> get isPhysicalStream;

  /// Operating system on which the application is currently running.
  ///
  /// This value represents the **resolved runtime platform** (e.g. iOS,
  /// Android, macOS, Windows, Linux) in a normalized, type-safe form.
  ///
  /// It allows application logic to branch on platform capabilities
  /// without directly relying on low-level platform checks such as
  /// `Platform.isXXX`.
  OperatingSystem get operatingSystem;

  /// Reactive stream of the operating system.
  ///
  /// Emits when the operating system information is resolved or if the
  /// runtime environment changes (e.g. during hot restart or testing).
  ///
  /// Most applications can treat this value as stable for the lifetime
  /// of the process, but the stream is provided for consistency with
  /// the reactive API design.
  Stream<OperatingSystem> get operatingSystemStream;

  /// High-level category describing the current device type.
  ///
  /// This abstraction groups devices into coarse categories such as
  /// `mobile`, `desktop`, or `web`, enabling adaptive UI and behavior
  /// without coupling to specific platforms.
  ///
  /// The category is derived from the resolved operating system and
  /// device characteristics.
  DeviceCategory get device;

  /// Reactive stream of the device category.
  ///
  /// Emits whenever the derived device category changes. While this
  /// is typically stable during the application lifetime, exposing
  /// a stream ensures consistency with the service’s reactive model
  /// and supports dynamic environments or advanced testing scenarios.
  Stream<DeviceCategory> get deviceStream;
}

@Singleton(as: DeviceInfoService, order: -1)
class DeviceInfoServiceImpl implements DeviceInfoService {
  final NetworkService _network;

  DeviceInfoServiceImpl(this._network);

  final _ipInfoSubject = BehaviorSubject<IpInfo?>.seeded(null);
  final _identifierSubject = BehaviorSubject<String>.seeded("-");
  final _modelSubject = BehaviorSubject<String>.seeded("-");
  final _isPhysicalSubject = BehaviorSubject<bool>.seeded(true);
  final _operatingSystemSubject = BehaviorSubject<OperatingSystem>.seeded(OperatingSystem.unknown);
  final _deviceSubject = BehaviorSubject<DeviceCategory>.seeded(DeviceCategory.unknown);

  @override
  IpInfo? get ipInfo => _ipInfoSubject.value;

  @override
  Stream<IpInfo?> get ipInfoStream => _ipInfoSubject.stream;

  @override
  String get identifier => _identifierSubject.value;

  @override
  Stream<String> get identifierStream => _identifierSubject.stream;

  @override
  String get model => _modelSubject.value;

  @override
  Stream<String> get modelStream => _modelSubject.stream;

  @override
  bool get isPhysical => _isPhysicalSubject.value;

  @override
  Stream<bool> get isPhysicalStream => _isPhysicalSubject.stream;

  @override
  OperatingSystem get operatingSystem => _operatingSystemSubject.value;

  @override
  Stream<OperatingSystem> get operatingSystemStream => _operatingSystemSubject.stream;

  @override
  DeviceCategory get device => _deviceSubject.value;

  @override
  Stream<DeviceCategory> get deviceStream => _deviceSubject.stream;

  @PostConstruct()
  init() async {
    getDeviceInfo();
    getIpInfo();
    getDevice();
    getOs();
  }

  StreamSubscription<bool>? networkSub;
}

extension on DeviceInfoServiceImpl {
  void getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    String? identifier;
    String? model;
    bool? isPhysical;

    if (Platform.isIOS) {
      final ios = await deviceInfoPlugin.iosInfo;
      identifier = ios.identifierForVendor;
      model = ios.model;
      isPhysical = ios.isPhysicalDevice;
    } else if (Platform.isAndroid) {
      final android = await deviceInfoPlugin.androidInfo;
      identifier = await const AndroidId().getId();
      model = android.model;
      isPhysical = android.isPhysicalDevice;
    } else if (Platform.isMacOS) {
      final mac = await deviceInfoPlugin.macOsInfo;
      identifier = mac.systemGUID;
      model = mac.model;
      isPhysical = true;
    } else if (Platform.isWindows) {
      final windows = await deviceInfoPlugin.windowsInfo;
      identifier = windows.deviceId;
      model = windows.computerName;
      isPhysical = true;
    } else if (Platform.isLinux) {
      final linux = await deviceInfoPlugin.linuxInfo;
      identifier = linux.machineId;
      model = linux.prettyName;
      isPhysical = true;
    }

    _identifierSubject.value = identifier ?? "-";
    _modelSubject.value = model ?? "-";
    _isPhysicalSubject.value = isPhysical ?? true;
  }

  void getIpInfo() {
    networkSub = _network.isReachableStream.distinct().listen((isReachable) {
      if (isReachable) {
        networkSub?.cancel();
        networkSub = null;

        _getIpInfo();
      }
    });
  }

  Future<void> _getIpInfo() async {
    final info = await _tryFetchFromIpInfo() ?? await _tryFetchFromIpApi();
    _ipInfoSubject.value = info;
  }

  Future<IpInfo?> _tryFetchFromIpApi() async {
    try {
      final response = await http.get(Uri.parse('http://ip-api.com/json/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return IpInfo(ip: data['query'], city: data['city'], country: data['countryCode']);
      }
    } catch (_) {}
    return null;
  }

  Future<IpInfo?> _tryFetchFromIpInfo() async {
    try {
      final response = await http.get(Uri.parse('https://ipinfo.io/json'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return IpInfo(ip: data['ip'], city: data['city'], country: data['country']);
      }
    } catch (_) {}
    return null;
  }

  void getDevice() {
    final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalShortestSide = firstView.physicalSize.shortestSide / firstView.devicePixelRatio;

    final category = switch (true) {
      _ when (Platform.isAndroid || Platform.isIOS) && logicalShortestSide < 600 => DeviceCategory.phone,
      _ when (Platform.isAndroid || Platform.isIOS) && logicalShortestSide >= 600 => DeviceCategory.tablet,
      _ when (Platform.isLinux || Platform.isMacOS || Platform.isWindows) => DeviceCategory.desktop,
      _ => DeviceCategory.unknown,
    };

    _deviceSubject.value = category;
  }

  void getOs() {
    _operatingSystemSubject.value = switch (Platform.operatingSystem) {
      "android" => OperatingSystem.android,
      "ios" => OperatingSystem.ios,
      "linux" => OperatingSystem.linux,
      "macos" => OperatingSystem.macos,
      "windows" => OperatingSystem.windows,
      _ => OperatingSystem.unknown,
    };
  }
}
