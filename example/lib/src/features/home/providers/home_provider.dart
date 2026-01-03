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
// Fiber BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import 'package:fiber_firebase_auth/fiber_firebase_auth.dart';

import '../../../common/provider/state_provider.dart';
import '../../../models/user_profil.dart';

class HomeState {
  UserProfil? profil;

  HomeState({required this.profil});
}

class HomeProvider extends StateProvider<HomeState> {
  final _user = FiberAuth.user;

  HomeProvider()
    : super(
        HomeState(
          profil: FiberAuth.user.data.custom.value == null
              ? null
              : UserProfil.fromJson(FiberAuth.user.data.custom.value!),
        ),
      ) {
    _user.data.custom.stream
        .distinct()
        .listen((custom) {
          if (custom == null) return;
          state.profil = UserProfil.fromJson(custom);
          notifyListeners();
        })
        .store(this);

    _user.sessions.all.sessions.stream.listen((sessions) {
      sessions?.forEach((session) {
        print("==========+> session: ${session.metadata.isSignedIn}");
      });
    });
  }

  void signOut() => _user.current.signOut();
}
