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

import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/subjects.dart';

abstract class NetworkService {
  /// Indicates whether the device currently has an active internet connection.
  ///
  /// This getter reflects the **latest known network reachability state**
  /// as observed by the underlying connectivity monitoring mechanism.
  ///
  /// A value of:
  /// - `true` means the network is considered reachable (internet access available),
  /// - `false` means the device is offline or the internet is not reachable.
  ///
  /// This getter provides **synchronous access** to the current state and is
  /// safe to use in conditional logic where immediate availability is required.
  /// Consumers should not attempt to infer connectivity by other means.
  bool get isReachable;

  /// Reactive stream of the network reachability state.
  ///
  /// This stream emits a new value whenever the device’s internet connectivity
  /// status changes (e.g. online → offline, offline → online).
  ///
  /// Typical use cases include:
  /// - enabling or disabling network-dependent features,
  /// - triggering background synchronization when connectivity is restored,
  /// - updating UI indicators (offline banners, retry states).
  ///
  /// Consumers should prefer this stream for reacting to connectivity changes
  /// rather than polling the synchronous [isReachable] getter.
  Stream<bool> get isReachableStream;
}

@Singleton(as: NetworkService, order: -1)
class NetworkServiceImpl implements NetworkService {
  final _isReachableSubject = BehaviorSubject<bool>.seeded(false);

  @override
  bool get isReachable => _isReachableSubject.value;

  @override
  Stream<bool> get isReachableStream => _isReachableSubject.stream;

  @PostConstruct()
  init() async {
    listenToReachable();
  }
}

extension on NetworkServiceImpl {
  void listenToReachable() {
    InternetConnection().onStatusChange.distinct().listen((isReachable) {
      _isReachableSubject.value = isReachable == InternetStatus.connected;
    });
  }
}
