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

class UserDeviceConstants {
  static const String deviceInfo = "device_info";
  static const String metadata = "metadata";
  static const String lastKnownPosition = "last_known_position";
  static const String preferences = "preferences";
}

class UserDeviceMetadataConstants {
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String isSignedIn = "is_signed_in";
  static const String lastSignInTime = "last_sign_in_time";
}

class UserDevicePreferencesConstants {
  static const String language = "language";
  static const String themeMode = "theme_mode";
}

class UserDeviceInfoConstants {
  static const String deviceId = "device_id";
  static const String deviceCategory = "device_category";
  static const String isPhysicalDevice = "is_physical_device";
  static const String model = "model";
  static const String operatingSystem = "operating_system";
}

class UserLastKnownPositionConstants {
  static const String ip = "ip";
  static const String city = "city";
  static const String country = "country";
}

enum UserLanguage {
  arabic,
  bulgarian,
  catalan,
  chinese,
  croatian,
  czech,
  danish,
  dutch,
  english,
  finnish,
  french,
  german,
  greek,
  hebrew,
  hindi,
  hungarian,
  indonesian,
  italian,
  japanese,
  korean,
  lithuanian,
  malay,
  norwegian,
  polish,
  portuguese,
  romanian,
  russian,
  slovak,
  slovenian,
  spanish,
  swedish,
  thai,
  turkish,
  ukrainian,
  vietnamese,
}

/// {@template known_device}
/// Represents a trusted or previously authenticated device.
///
/// This model can be used to keep track of devices that have been recognized
/// during sign-in, password reset, or other sensitive operations. It is useful
/// for security notifications, device management, and fraud detection.
///
/// Each device is identified by its unique [deviceId] and labeled by its [brand].
/// Optionally, it includes a [lastKnownPosition] to provide geographic context.
///
/// {@endtemplate}
class UserDevice extends Equatable {
  final String deviceId;

  /// Static hardware and platform information describing the device.
  ///
  /// This includes immutable characteristics such as:
  /// - [brand] (e.g., "Apple", "Samsung")
  /// - [model] (e.g., "iPhone 14", "Pixel 7")
  /// - [deviceId] (a unique, persistent identifier for the device)
  /// - [deviceType] (phone, desktop, or web)
  /// - [isPhysicalDevice] (indicates whether the device is real or emulated)
  ///
  /// This information is useful for device recognition, analytics, and enforcing
  /// platform-specific behaviors (e.g., disabling payments on simulators).
  ///
  /// It typically remains stable throughout the life of the device.
  final UserDeviceInfo deviceInfo;

  /// Temporal and contextual metadata related to this device’s usage.
  ///
  /// This includes timestamps that capture key lifecycle moments, such as:
  /// - [createdAt]: When the device was first recognized by the system.
  /// - [updatedAt]: When it was last updated (e.g., new location, preferences).
  /// - [lastSignInTime]: The last time the user authenticated from this device.
  ///
  /// This information is essential for:
  /// - Security audits
  /// - Detecting dormant or suspicious devices
  /// - Displaying human-readable "last used" timestamps in UI
  final UserDeviceMetadata metadata;

  /// The last known geographic location where this device was used.
  ///
  /// It typically contains contextual information such as:
  /// - `city` (e.g., "Paris")
  /// - `country` (e.g., "France")
  ///
  /// This field is useful for security purposes like identifying
  /// suspicious login attempts, notifying the user of new sign-ins,
  /// or visualizing the device's usage history geographically.
  final UserLastKnownPosition lastKnownPosition;

  /// The user interface preferences associated with this device.
  ///
  /// This includes user-specific settings that affect the experience on this device,
  /// such as:
  /// - [themeMode]: Whether the device uses light, dark, or system theme.
  /// - [localization]: The language or locale configured on the device.
  ///
  /// This information can be used to:
  /// - Synchronize theme and language across sessions or devices.
  /// - Personalize notifications and in-app content based on locale.
  /// - Respect the user's appearance preferences when rendering UI.
  ///
  /// These preferences are typically read from system settings at runtime
  /// and stored to maintain consistency in multi-device environments.
  final UserDevicePreferences preferences;

  const UserDevice({
    required this.deviceId,
    required this.deviceInfo,
    required this.metadata,
    required this.lastKnownPosition,
    required this.preferences,
  });

  factory UserDevice.fromMap(Map<String, dynamic> map) {
    return UserDevice(
      deviceId: map[UserDeviceConstants.deviceInfo][UserDeviceInfoConstants.deviceId],
      deviceInfo: UserDeviceInfo.fromMap(map[UserDeviceConstants.deviceInfo]),
      metadata: UserDeviceMetadata.fromMap(map[UserDeviceConstants.metadata]),
      lastKnownPosition: UserLastKnownPosition.fromMap(map[UserDeviceConstants.lastKnownPosition]),
      preferences: UserDevicePreferences.fromMap(map[UserDeviceConstants.preferences]),
    );
  }

  UserDevice copyWith({
    String? deviceId,
    UserDeviceInfo? deviceInfo,
    UserDeviceMetadata? metadata,
    UserLastKnownPosition? lastKnownPosition,
    UserDevicePreferences? preferences,
  }) {
    return UserDevice(
      deviceId: deviceId ?? this.deviceId,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      metadata: metadata ?? this.metadata,
      lastKnownPosition: lastKnownPosition ?? this.lastKnownPosition,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserDeviceConstants.deviceInfo: deviceInfo.toMap(),
      UserDeviceConstants.metadata: metadata.toMap(),
      UserDeviceConstants.lastKnownPosition: lastKnownPosition.toMap(),
      UserDeviceConstants.preferences: preferences.toMap(),
    };
  }

  @override
  List<Object?> get props => [deviceId, deviceInfo, metadata, lastKnownPosition, preferences];
}

/// {@template known_device_metadata}
/// Represents lifecycle and activity-related metadata for a known device.
///
/// This model captures key timestamps related to the recognition,
/// usage, and maintenance of a device associated with a user account.
///
/// It is useful for:
/// - Security monitoring (e.g., last access, inactive devices)
/// - Device management interfaces (e.g., sort by recent usage)
/// - Analytics and user behavior tracking
/// {@endtemplate}
class UserDeviceMetadata extends Equatable {
  /// The timestamp (in milliseconds since epoch) when this device entry was first created.
  ///
  /// This value represents when the device was initially registered or recognized
  /// by the system (e.g., during first login, OTP validation, or account association).
  ///
  /// It can be used for:
  /// - Displaying the age of a known device
  /// - Auditing security history
  /// - Identifying old or inactive devices
  final int createdAt;

  /// The timestamp (in milliseconds since epoch) of the most recent update to this device entry.
  ///
  /// This value reflects the last known interaction involving this device,
  /// such as a sign-in event, location update, or preference change.
  ///
  /// It is useful for:
  /// - Sorting devices by recent activity
  /// - Expiring or purging outdated entries
  /// - Displaying last usage information to the user
  final int updatedAt;

  /// The timestamp (in milliseconds since epoch) of the last successful sign-in using this device.
  ///
  /// This can be used to sort devices by recency, detect dormant devices,
  /// and notify users when their account was accessed from this device.
  /// It is stored as a Unix timestamp in UTC.
  final int lastSignInTime;

  /// Whether the user is currently authenticated on this device.
  ///
  /// This flag indicates an active session. Useful for:
  /// - Showing "currently logged in" devices
  /// - Distinguishing offline/trusted but inactive devices
  /// - Applying logout flows to specific devices
  final bool isSignedIn;

  const UserDeviceMetadata({
    required this.createdAt,
    required this.updatedAt,
    required this.lastSignInTime,
    required this.isSignedIn,
  });

  factory UserDeviceMetadata.fromMap(Map<String, dynamic> map) {
    return UserDeviceMetadata(
      createdAt: map[UserDeviceMetadataConstants.createdAt],
      updatedAt: map[UserDeviceMetadataConstants.updatedAt],
      isSignedIn: map[UserDeviceMetadataConstants.isSignedIn],
      lastSignInTime: map[UserDeviceMetadataConstants.lastSignInTime],
    );
  }

  UserDeviceMetadata copyWith({int? createdAt, int? updatedAt, bool? isSignedIn, int? lastSignInTime}) {
    return UserDeviceMetadata(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSignedIn: isSignedIn ?? this.isSignedIn,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserDeviceMetadataConstants.createdAt: createdAt,
      UserDeviceMetadataConstants.updatedAt: updatedAt,
      UserDeviceMetadataConstants.isSignedIn: isSignedIn,
      UserDeviceMetadataConstants.lastSignInTime: lastSignInTime,
    };
  }

  @override
  List<Object?> get props => [createdAt, updatedAt, lastSignInTime, isSignedIn];
}

/// {@template device_preferences}
/// Represents user-defined visual and language preferences specific to a device.
///
/// This model captures configurable preferences that personalize the user experience
/// on a per-device basis, such as display mode and locale settings.
///
/// It is commonly used for:
/// - Adapting the UI to user expectations (theme, language)
/// - Synchronizing preferences across sessions
/// - Providing analytics on user behavior and regional trends
/// {@endtemplate}
class UserDevicePreferences extends Equatable {
  /// The language or locale used on this device at the time of its last activity.
  ///
  /// This can be used to adapt user notifications, analyze regional usage trends,
  /// or enhance fraud detection by identifying suspicious location-locale mismatches.
  ///
  /// For example, a French user accessing their account from a device set to Russian
  /// might trigger additional verification steps.
  final UserLanguage language;

  /// The preferred theme mode (light, dark, or system) configured on the device.
  ///
  /// This setting reflects the user's current display preference and can be used to:
  /// - Adapt the UI to match light or dark mode automatically.
  /// - Provide consistent theming across devices and sessions.
  /// - Store or synchronize the appearance setting for analytics or user preferences.
  ///
  /// Values include:
  /// - [ThemeMode.light]: Light theme explicitly selected.
  /// - [ThemeMode.dark]: Dark theme explicitly selected.
  /// - [ThemeMode.system]: Follows the system-wide theme preference.
  final ThemeMode themeMode;

  const UserDevicePreferences({required this.language, required this.themeMode});

  factory UserDevicePreferences.fromMap(Map<String, dynamic> map) {
    return UserDevicePreferences(
      language: UserLanguage.values.byName(map[UserDevicePreferencesConstants.language]),
      themeMode: ThemeMode.values.byName(map[UserDevicePreferencesConstants.themeMode]),
    );
  }

  UserDevicePreferences copyWith({UserLanguage? language, ThemeMode? themeMode}) {
    return UserDevicePreferences(language: language ?? this.language, themeMode: themeMode ?? this.themeMode);
  }

  Map<String, dynamic> toMap() {
    return {
      UserDevicePreferencesConstants.language: language.name,
      UserDevicePreferencesConstants.themeMode: themeMode.name,
    };
  }

  @override
  List<Object?> get props => [language, themeMode];
}

/// {@template operating_system}
/// Defines the supported operating systems on which the application can run.
///
/// This enum provides a standardized representation of platforms returned by
/// `Platform.operatingSystem`, allowing for consistent platform-based logic,
/// analytics segmentation, or feature toggling.
///
/// The [value] getter returns a human-readable name of the operating system,
/// which can be displayed in logs, telemetry dashboards, or user-facing UIs.
/// {@endtemplate}
enum OperatingSystem {
  /// Represents Android-based devices.
  android,

  /// Represents Apple iOS devices such as iPhones and iPads.
  ios,

  /// Represents Linux distributions running on desktop or embedded systems.
  linux,

  /// Represents Apple macOS desktop or laptop computers.
  macos,

  /// Represents Microsoft Windows desktop or laptop computers.
  windows,

  /// Used when the operating system cannot be identified or is unsupported.
  unknown;

  /// Returns a human-readable string representation of the operating system.
  ///
  /// Example:
  /// ```dart
  /// final os = OperatingSystem.android;
  /// print(os.value); // "Android"
  /// ```
  String get value => switch (this) {
    OperatingSystem.android => "Android",
    OperatingSystem.ios => "iOS",
    OperatingSystem.linux => "Linux",
    OperatingSystem.macos => "macOS",
    OperatingSystem.windows => "Windows",
    OperatingSystem.unknown => "Unknown",
  };
}

/// {@template device_category}
/// Classifies the device form factor or usage category.
///
/// This enum differentiates between types of hardware environments in which
/// the app runs, such as handheld devices, tablets, or desktops. It is used for
/// UI adaptation, analytics segmentation, or security validation.
/// {@endtemplate}
enum DeviceCategory {
  /// A handheld device such as a smartphone.
  phone,

  /// A tablet device with a larger screen and similar OS to a phone.
  tablet,

  /// A desktop or laptop computer environment.
  desktop,

  /// Used when the device type cannot be determined.
  unknown,
}

/// {@template device_info}
/// Describes the hardware and platform characteristics of a device.
///
/// This model captures immutable technical attributes such as brand, model,
/// unique identifier, and type classification. It is typically used for
/// identifying and managing devices in a security context, device lists,
/// telemetry, or fraud detection workflows.
///
/// The values are usually collected from native platform APIs or browser metadata.
/// {@endtemplate}
class UserDeviceInfo extends Equatable {
  /// The operating system currently running on the device.
  ///
  /// Represents the underlying platform such as Android, iOS, macOS, Windows, Linux, or Web.
  /// This value is typically derived from system-level APIs (e.g., `Platform.operatingSystem`)
  /// and is used to:
  /// - Customize behavior or UI per platform.
  /// - Segment analytics or telemetry by OS.
  /// - Apply security policies specific to certain environments.
  final OperatingSystem operatingSystem;

  /// The specific model name or number of the device (e.g., "iPhone 14", "Pixel 7").
  ///
  /// This value complements [brand] by specifying the exact model.
  /// It helps users recognize their devices in security alerts or device lists,
  /// and can be useful for filtering or customizing features based on capabilities.
  final String model;

  /// A persistent and unique identifier associated with the device.
  ///
  /// This ID is generally derived from system-level identifiers such as:
  /// - Android ID
  /// - iOS identifierForVendor (IDFV)
  /// - Web browser fingerprint
  ///
  /// It is used internally to distinguish and track trusted devices across sessions.
  /// For privacy and consistency, this value should be generated and stored securely.
  final String deviceId;

  /// Indicates whether the device is a physical (real) device or an emulator/simulator.
  ///
  /// This can be used to:
  /// - Prevent certain operations (e.g., payment) in non-physical environments.
  /// - Filter telemetry data to focus on real-world usage.
  /// - Detect potential testing or automation environments.
  ///
  /// On most platforms, this value is inferred from system APIs and may not be 100% reliable.
  final bool isPhysicalDevice;

  /// The type of device on which the application was accessed.
  ///
  /// This distinguishes between different device categories such as:
  /// - [DeviceType.phone]: Smartphones and tablets (iOS, Android).
  /// - [DeviceType.desktop]: Desktop or laptop environments (macOS, Windows, Linux).
  /// - [DeviceType.web]: Web browsers on any platform.
  ///
  /// This classification enables tailored user experiences, feature gating,
  /// analytics segmentation, and improved security by detecting unusual device types.
  ///
  /// For example, a user who always signs in from a [DeviceType.phone] might
  /// trigger a warning when signing in from a [DeviceType.desktop] or [DeviceType.web].
  final DeviceCategory deviceCategory;

  const UserDeviceInfo({
    required this.operatingSystem,
    required this.model,
    required this.deviceId,
    required this.isPhysicalDevice,
    required this.deviceCategory,
  });

  factory UserDeviceInfo.fromMap(Map<String, dynamic> map) {
    return UserDeviceInfo(
      deviceId: map[UserDeviceInfoConstants.deviceId],
      deviceCategory: DeviceCategory.values.byName(map[UserDeviceInfoConstants.deviceCategory]),
      isPhysicalDevice: map[UserDeviceInfoConstants.isPhysicalDevice],
      model: map[UserDeviceInfoConstants.model],
      operatingSystem: OperatingSystem.values.byName(map[UserDeviceInfoConstants.operatingSystem]),
    );
  }

  UserDeviceInfo copyWith({
    String? deviceId,
    DeviceCategory? deviceCategory,
    bool? isPhysicalDevice,
    String? model,
    OperatingSystem? operatingSystem,
  }) {
    return UserDeviceInfo(
      deviceId: deviceId ?? this.deviceId,
      deviceCategory: deviceCategory ?? this.deviceCategory,
      isPhysicalDevice: isPhysicalDevice ?? this.isPhysicalDevice,
      model: model ?? this.model,
      operatingSystem: operatingSystem ?? this.operatingSystem,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserDeviceInfoConstants.deviceId: deviceId,
      UserDeviceInfoConstants.deviceCategory: deviceCategory.name,
      UserDeviceInfoConstants.isPhysicalDevice: isPhysicalDevice,
      UserDeviceInfoConstants.model: model,
      UserDeviceInfoConstants.operatingSystem: operatingSystem,
    };
  }

  @override
  List<Object?> get props => [operatingSystem, model, deviceId, isPhysicalDevice, deviceCategory];
}

/// {@template last_known_position}
/// Represents the last known geographic location of a device.
///
/// This includes optional [city] and [country] fields, typically derived from
/// IP-based geolocation. It can help users recognize where a login or action occurred.
///
/// {@endtemplate}
class UserLastKnownPosition extends Equatable {
  /// The last known public IP address from which this device was accessed.
  ///
  /// This value is typically captured during authentication or device registration,
  /// and can be used for:
  /// - Displaying access location details to the user
  /// - Enhancing security and fraud detection (e.g., unexpected country/IP)
  /// - Performing IP-based geolocation or risk scoring
  ///
  /// The IP address may be IPv4 or IPv6 depending on the network.
  final String? ip;

  /// The name of the city where the device was last detected or used, if available.
  ///
  /// This value is typically obtained through IP geolocation or GPS data,
  /// and is useful for providing the user with contextual information during
  /// security events (e.g., "Login from Paris") or for internal analytics.
  ///
  /// This field is nullable because the city may not always be retrievable,
  /// especially when location data is limited or anonymized.
  final String? city;

  /// The name of the country where the device was last detected or used, if available.
  ///
  /// Like [city], this is typically derived from IP-based geolocation or GPS input.
  /// It helps determine the broader region of access and can be used for:
  /// - Regional access restrictions
  /// - Language/locale assumptions
  /// - Fraud detection (e.g., sign-in from unexpected countries)
  ///
  /// This field is nullable when the country cannot be determined reliably.
  final String? country;

  /// Creates a new [UserLastKnownPosition] instance with optional city and country.
  const UserLastKnownPosition({required this.ip, required this.city, required this.country});

  factory UserLastKnownPosition.fromMap(Map<String, dynamic> map) {
    return UserLastKnownPosition(
      ip: map[UserLastKnownPositionConstants.ip],
      city: map[UserLastKnownPositionConstants.city],
      country: map[UserLastKnownPositionConstants.country],
    );
  }

  UserLastKnownPosition copyWith({
    ValueGetter<String?>? ip,
    ValueGetter<String?>? city,
    ValueGetter<String?>? country,
  }) {
    return UserLastKnownPosition(
      ip: ip != null ? ip() : this.ip,
      city: city != null ? city() : this.city,
      country: country != null ? country() : this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserLastKnownPositionConstants.ip: ip,
      UserLastKnownPositionConstants.city: city,
      UserLastKnownPositionConstants.country: country,
    };
  }

  @override
  List<Object?> get props => [ip, city, country];
}
