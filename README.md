# Barbu score

Barbu score is a Flutter app to fill scores during a Barbu card game (also known as Tafferan or King
of heart).

## Installation

This is a Flutter app so you need to install Flutter, like described in
the [doc](https://docs.flutter.dev/get-started/install).

You should also install fvm tool, as
described [here](https://fvm.app/documentation/getting-started/installation) and get the Flutter
version set in the .fvmrc file of the repo with ```fvm use {barbu_score.version}```

To get all dependencies and create generated files run these commands:

```
fvm flutter pub get
fvm dart run build_runner build
```

To launch the project on Android device, an upload keystore file need to be created, as
described [here](https://docs.flutter.dev/deployment/android#create-an-upload-keystore).

**If you don't want to contribute and just want to play, you can download the app
in [PlayStore](https://play.google.com/store/apps/details?id=zigotote.barbu_score).**

## Contributing

If you notice something you would like to change, feel free to fill an issue or open a Pull request.
Please explain why you want this changes so that I can understand your changes.

## Testing

Every changes should be tested. Before pushing, please check ```fvm flutter test``` result is OK.
A Github action also runs on each PR to check tests status.

Code coverage can be monitored with lcov. This tool **only works on Mac and Linux** for now, and can
be installed with `sudo apt-get install lcov -y`. To generate code coverage files, use these
commands :

```
fvm flutter test --coverage
lcov -r coverage/lcov.info "lib/commons/l10n/" -o coverage/lcov_cleaned.info
genhtml coverage/lcov_cleaned.info -o coverage/html
open coverage/html/index.html
```

## Release the app

Before releasing, the app needs to be tested on a real device with

```
fvm flutter build apk --release
fvm flutter install
```

App update can be tested with

```
fvm flutter build apk --release
adb install build/app/outputs/flutter-apk/app-release.apk
```

If everything is fine, the app bundle can be build
with ```fvm flutter build appbundle --obfuscate --split-debug-info="zigotote/barbu_score/debug"```
and uploaded to PlayStore.

See [Flutter deployment doc](https://docs.flutter.dev/deployment/android#building-the-app-for-release)
for more info.

/!\ If there is an alert "This appbundle has native code and you didn't imported debug symbols" in
PlayStore

- Change the .aab extension to .zip
- extract it
- find debug symbols under the base/lib/ directory.
- Compress all of it to a zip file
- upload it in Play Store in Bundle Explorer -> Your version -> Downloads -> native debug symbols

## Licence

[MIT](https://choosealicense.com/licenses/mit/)
