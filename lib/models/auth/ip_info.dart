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

/// {@template ip_info}
/// Represents the IP and geolocation metadata of the current device.
///
/// This model holds minimal but useful network information, such as the public
/// IP address, country, and city. It is typically obtained from external APIs
/// like `ipinfo.io` or `ip-api.com` and used for telemetry, region detection,
/// or security validation (e.g., login from unusual country).
///
/// All fields are nullable because network or API failures may result in
/// incomplete data.
/// {@endtemplate}
class IpInfo {
  /// The public IP address of the device (e.g., `"192.168.0.1"` or `"2001:0db8::1"`).
  final String? ip;

  /// The ISO or localized country name associated with the IP address.
  final String? country;

  /// The city corresponding to the IP address location.
  final String? city;

  /// Creates a new [IpInfo] instance with optional location attributes.
  IpInfo({required this.ip, required this.city, required this.country});
}
