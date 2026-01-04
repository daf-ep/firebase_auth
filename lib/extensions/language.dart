// Copyright (C) 2026 Fiber
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

import 'package:flutter/material.dart';

import '../models/user/language.dart';

extension LanguageLocaleExtension on Language {
  Locale convert() => switch (this) {
    Language.arabic => const Locale('ar'),
    Language.bulgarian => const Locale('bg'),
    Language.catalan => const Locale('ca'),
    Language.chinese => const Locale('zh'),
    Language.croatian => const Locale('hr'),
    Language.czech => const Locale('cs'),
    Language.danish => const Locale('da'),
    Language.dutch => const Locale('nl'),
    Language.english => const Locale('en'),
    Language.finnish => const Locale('fi'),
    Language.french => const Locale('fr'),
    Language.german => const Locale('de'),
    Language.greek => const Locale('el'),
    Language.hebrew => const Locale('he'),
    Language.hindi => const Locale('hi'),
    Language.hungarian => const Locale('hu'),
    Language.indonesian => const Locale('id'),
    Language.italian => const Locale('it'),
    Language.japanese => const Locale('ja'),
    Language.korean => const Locale('ko'),
    Language.lithuanian => const Locale('lt'),
    Language.malay => const Locale('ms'),
    Language.norwegian => const Locale('no'),
    Language.polish => const Locale('pl'),
    Language.portuguese => const Locale('pt'),
    Language.romanian => const Locale('ro'),
    Language.russian => const Locale('ru'),
    Language.slovak => const Locale('sk'),
    Language.slovenian => const Locale('sl'),
    Language.spanish => const Locale('es'),
    Language.swedish => const Locale('sv'),
    Language.thai => const Locale('th'),
    Language.turkish => const Locale('tr'),
    Language.ukrainian => const Locale('uk'),
    Language.vietnamese => const Locale('vi'),
  };

  String get languageCode => convert().languageCode;
}
