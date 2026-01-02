// Copyright (C) 2025 Fiber
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

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'language.dart';

class SessionConstants {
  static const String deviceInfo = "device_info";
  static const String metadata = "metadata";
  static const String networkLocation = "network_location";
  static const String preferences = "preferences";
}

class SessionMetadataConstants {
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String isSignedIn = "is_signed_in";
  static const String lastSignInTime = "last_sign_in_time";
}

class SessionPreferencesConstants {
  static const String language = "language";
  static const String themeMode = "theme_mode";
}

class DeviceInfoConstants {
  static const String deviceId = "device_id";
  static const String deviceCategory = "device_category";
  static const String isPhysicalDevice = "is_physical_device";
  static const String model = "model";
  static const String operatingSystem = "operating_system";
}

class NetworkLocationConstants {
  static const String ip = "ip";
  static const String city = "city";
  static const String country = "country";
}

class Session extends Equatable {
  final String deviceId;
  final DeviceInfo deviceInfo;
  final SessionMetadata metadata;
  final NetworkLocation networkLocation;
  final SessionPreferences preferences;

  const Session({
    required this.deviceId,
    required this.deviceInfo,
    required this.metadata,
    required this.networkLocation,
    required this.preferences,
  });

  factory Session.fromMap(String deviceId, Map<String, dynamic> map) {
    return Session(
      deviceId: deviceId,
      deviceInfo: DeviceInfo.fromMap(map[SessionConstants.deviceInfo]),
      metadata: SessionMetadata.fromMap(map[SessionConstants.metadata]),
      networkLocation: NetworkLocation.fromMap(map[SessionConstants.networkLocation]),
      preferences: SessionPreferences.fromMap(map[SessionConstants.preferences]),
    );
  }

  Session copyWith({
    String? deviceId,
    DeviceInfo? deviceInfo,
    SessionMetadata? metadata,
    NetworkLocation? networkLocation,
    SessionPreferences? preferences,
  }) {
    return Session(
      deviceId: deviceId ?? this.deviceId,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      metadata: metadata ?? this.metadata,
      networkLocation: networkLocation ?? this.networkLocation,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SessionConstants.deviceInfo: deviceInfo.toMap(),
      SessionConstants.metadata: metadata.toMap(),
      SessionConstants.networkLocation: networkLocation.toMap(),
      SessionConstants.preferences: preferences.toMap(),
    };
  }

  @override
  List<Object?> get props => [deviceId, deviceInfo, metadata, networkLocation, preferences];
}

class SessionMetadata extends Equatable {
  final int createdAt;
  final int updatedAt;
  final int lastSignInTime;
  final bool isSignedIn;

  const SessionMetadata({
    required this.createdAt,
    required this.updatedAt,
    required this.lastSignInTime,
    required this.isSignedIn,
  });

  factory SessionMetadata.fromMap(Map<String, dynamic> map) {
    return SessionMetadata(
      createdAt: map[SessionMetadataConstants.createdAt],
      updatedAt: map[SessionMetadataConstants.updatedAt],
      isSignedIn: map[SessionMetadataConstants.isSignedIn],
      lastSignInTime: map[SessionMetadataConstants.lastSignInTime],
    );
  }

  SessionMetadata copyWith({int? createdAt, int? updatedAt, bool? isSignedIn, int? lastSignInTime}) {
    return SessionMetadata(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      SessionMetadataConstants.createdAt: createdAt,
      SessionMetadataConstants.updatedAt: updatedAt,
      SessionMetadataConstants.isSignedIn: isSignedIn,
      SessionMetadataConstants.lastSignInTime: lastSignInTime,
    };
  }

  @override
  List<Object?> get props => [createdAt, updatedAt, lastSignInTime, isSignedIn];
}

class SessionPreferences extends Equatable {
  final Language language;
  final ThemeMode themeMode;

  const SessionPreferences({required this.language, required this.themeMode});

  factory SessionPreferences.fromMap(Map<String, dynamic> map) {
    return SessionPreferences(
      language: Language.values.byName(map[SessionPreferencesConstants.language]),
      themeMode: ThemeMode.values.byName(map[SessionPreferencesConstants.themeMode]),
    );
  }

  SessionPreferences copyWith({Language? language, ThemeMode? themeMode}) {
    return SessionPreferences(language: language ?? this.language, themeMode: themeMode ?? this.themeMode);
  }

  Map<String, dynamic> toMap() {
    return {SessionPreferencesConstants.language: language.name, SessionPreferencesConstants.themeMode: themeMode.name};
  }

  @override
  List<Object?> get props => [language, themeMode];
}

enum OperatingSystem {
  android,
  ios,
  linux,
  macos,
  windows,
  unknown;

  String get value => switch (this) {
    OperatingSystem.android => "Android",
    OperatingSystem.ios => "iOS",
    OperatingSystem.linux => "Linux",
    OperatingSystem.macos => "macOS",
    OperatingSystem.windows => "Windows",
    OperatingSystem.unknown => "Unknown",
  };
}

enum DeviceCategory { phone, tablet, desktop, unknown }

class DeviceInfo extends Equatable {
  final OperatingSystem operatingSystem;
  final String model;
  final String deviceId;
  final bool isPhysicalDevice;
  final DeviceCategory deviceCategory;

  const DeviceInfo({
    required this.operatingSystem,
    required this.model,
    required this.deviceId,
    required this.isPhysicalDevice,
    required this.deviceCategory,
  });

  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    return DeviceInfo(
      deviceId: map[DeviceInfoConstants.deviceId],
      deviceCategory: DeviceCategory.values.byName(map[DeviceInfoConstants.deviceCategory]),
      isPhysicalDevice: map[DeviceInfoConstants.isPhysicalDevice],
      model: map[DeviceInfoConstants.model],
      operatingSystem: OperatingSystem.values.byName(map[DeviceInfoConstants.operatingSystem]),
    );
  }

  DeviceInfo copyWith({
    String? deviceId,
    DeviceCategory? deviceCategory,
    bool? isPhysicalDevice,
    String? model,
    OperatingSystem? operatingSystem,
  }) {
    return DeviceInfo(
      deviceId: deviceId ?? this.deviceId,
      deviceCategory: deviceCategory ?? this.deviceCategory,
      isPhysicalDevice: isPhysicalDevice ?? this.isPhysicalDevice,
      model: model ?? this.model,
      operatingSystem: operatingSystem ?? this.operatingSystem,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DeviceInfoConstants.deviceId: deviceId,
      DeviceInfoConstants.deviceCategory: deviceCategory.name,
      DeviceInfoConstants.isPhysicalDevice: isPhysicalDevice,
      DeviceInfoConstants.model: model,
      DeviceInfoConstants.operatingSystem: operatingSystem.name,
    };
  }

  @override
  List<Object?> get props => [operatingSystem, model, deviceId, isPhysicalDevice, deviceCategory];
}

class NetworkLocation extends Equatable {
  final String? ip;
  final String? city;
  final String? country;

  const NetworkLocation({required this.ip, required this.city, required this.country});

  factory NetworkLocation.fromMap(Map<String, dynamic> map) {
    return NetworkLocation(
      ip: map[NetworkLocationConstants.ip],
      city: map[NetworkLocationConstants.city],
      country: map[NetworkLocationConstants.country],
    );
  }

  NetworkLocation copyWith({ValueGetter<String?>? ip, ValueGetter<String?>? city, ValueGetter<String?>? country}) {
    return NetworkLocation(
      ip: ip != null ? ip() : this.ip,
      city: city != null ? city() : this.city,
      country: country != null ? country() : this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      NetworkLocationConstants.ip: ip,
      NetworkLocationConstants.city: city,
      NetworkLocationConstants.country: country,
    };
  }

  @override
  List<Object?> get props => [ip, city, country];
}
