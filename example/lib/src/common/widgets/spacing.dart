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

import 'package:flutter/material.dart';

const double _size0 = 0;
const double _size4 = 4;
const double _size8 = 8;
const double _size12 = 12;
const double _size16 = 16;
const double _size24 = 24;
const double _size32 = 32;
const double _size40 = 40;
const double _size64 = 64;

enum Spacing {
  size0,
  size4,
  size8,
  size12,
  size16,
  size24,
  size32,
  size40,
  size64;

  double get value => switch (this) {
    Spacing.size0 => _size0,
    Spacing.size4 => _size4,
    Spacing.size8 => _size8,
    Spacing.size12 => _size12,
    Spacing.size16 => _size16,
    Spacing.size24 => _size24,
    Spacing.size32 => _size32,
    Spacing.size40 => _size40,
    Spacing.size64 => _size64,
  };
}

class AppSpacing extends StatelessWidget {
  final double space;

  const AppSpacing._({this.space = 0});

  factory AppSpacing.size0() => AppSpacing._(space: Spacing.size0.value);
  factory AppSpacing.size4() => AppSpacing._(space: Spacing.size4.value);
  factory AppSpacing.size8() => AppSpacing._(space: Spacing.size8.value);
  factory AppSpacing.size12() => AppSpacing._(space: Spacing.size12.value);
  factory AppSpacing.size16() => AppSpacing._(space: Spacing.size16.value);
  factory AppSpacing.size24() => AppSpacing._(space: Spacing.size24.value);
  factory AppSpacing.size32() => AppSpacing._(space: Spacing.size32.value);
  factory AppSpacing.size40() => AppSpacing._(space: Spacing.size40.value);
  factory AppSpacing.size64() => AppSpacing._(space: Spacing.size64.value);

  @override
  Widget build(BuildContext context) => SizedBox(width: space, height: space);
}
