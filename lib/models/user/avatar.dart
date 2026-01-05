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

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

enum AvatarType { photoAvatar, textAvatar, placeholderAvatar }

class AvatarFields {
  static String get objectType => '__fbs__object_type';
  static String get imagePath => '__fbs__image_path';
  static String get blurHash => '__fbs__blur_hash';
  static String get text => '__fbs__text';
  static String get backgroundColor => '__fbs__background_color';
  static String get placeholder => '__fbs__placeholder';
}

abstract class Avatar extends Equatable {
  const Avatar();

  factory Avatar.fromMap(Map<String, dynamic> map) {
    return switch (AvatarType.values.byName(map[AvatarFields.objectType])) {
      AvatarType.photoAvatar => PhotoAvatar.fromMap(map),
      AvatarType.textAvatar => TextAvatar.fromMap(map),
      AvatarType.placeholderAvatar => PlaceholderAvatar.fromMap(map),
    };
  }

  Map<String, dynamic> toMap();
}

class PhotoAvatar extends Avatar {
  final String imagePath;
  final String? blurHash;

  const PhotoAvatar({required this.imagePath, this.blurHash});

  String get resourceId => p.basenameWithoutExtension(imagePath);

  static PhotoAvatar fromMap(Map<String, dynamic> map) {
    return PhotoAvatar(
      imagePath: map[AvatarFields.imagePath] as String,
      blurHash: map[AvatarFields.blurHash] as String?,
    );
  }

  PhotoAvatar copyWith({String? imagePath, ValueGetter<String?>? blurHash}) {
    return PhotoAvatar(imagePath: imagePath ?? this.imagePath, blurHash: blurHash != null ? blurHash() : this.blurHash);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      AvatarFields.objectType: AvatarType.photoAvatar.name,
      AvatarFields.imagePath: imagePath,
      AvatarFields.blurHash: blurHash,
    };
  }

  @override
  List<Object?> get props => [imagePath, blurHash];
}

class TextAvatar extends Avatar {
  final String text;
  final String? backgroundColor;

  const TextAvatar({required this.text, this.backgroundColor});

  static TextAvatar fromMap(Map<String, dynamic> map) {
    return TextAvatar(
      text: map[AvatarFields.text] as String,
      backgroundColor: map[AvatarFields.backgroundColor] as String?,
    );
  }

  TextAvatar copyWith({String? text, ValueGetter<String?>? backgroundColor}) {
    return TextAvatar(
      text: text ?? this.text,
      backgroundColor: backgroundColor != null ? backgroundColor() : this.backgroundColor,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      AvatarFields.objectType: AvatarType.textAvatar.name,
      AvatarFields.text: text,
      AvatarFields.backgroundColor: backgroundColor,
    };
  }

  @override
  List<Object?> get props => [text, backgroundColor];
}

class PlaceholderAvatar extends Avatar {
  final String placeholder;

  const PlaceholderAvatar({required this.placeholder});

  static PlaceholderAvatar fromMap(Map<String, dynamic> map) {
    return PlaceholderAvatar(placeholder: map[AvatarFields.placeholder] as String);
  }

  PlaceholderAvatar copyWith({String? placeholder}) {
    return PlaceholderAvatar(placeholder: placeholder ?? this.placeholder);
  }

  @override
  Map<String, dynamic> toMap() {
    return {AvatarFields.objectType: AvatarType.placeholderAvatar.name, AvatarFields.placeholder: placeholder};
  }

  @override
  List<Object?> get props => [placeholder];
}
