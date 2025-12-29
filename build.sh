#!/bin/sh

flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner build