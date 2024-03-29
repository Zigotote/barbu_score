# Barbu score

Barbu score is a Flutter app to fill scores during a Barbu card game (also known as Tafferan or King
of heart).

## Installation

This is a Flutter app so you need to install Flutter, like described in
the [doc](https://docs.flutter.dev/get-started/install).

...

To get all dependencies and create generated files run these commands :

```
flutter pub get
dart run build_runner build
```

And that's it ! Now you can do awesome work to improve this app.

_Note_ : I only tested this app on Android devices so the iOS version could be a bit flaky.

**If you don't want to contribute and just want to play, you can download the app
in [PlayStore](https://play.google.com/store/apps/details?id=zigotote.barbu_score).**

## Contributing

If you notice something you would like to change, feel free to fill an issue or open a Pull request.
Please explain why you want this changes so that I can understand your changes.

## Release the app

Before releasing, the app needs to be tested on a real device with

```
flutter build apk --release
flutter install
```

If everything is fine, the app bundle can be build
with ```flutter build appbundle --obfuscate --split-debug-info="zigotote/barbu_score/debug"``` and
uploaded to PlayStore.

See [Flutter deployment doc](https://docs.flutter.dev/deployment/android#building-the-app-for-release)
for more info.

## Licence

[MIT](https://choosealicense.com/licenses/mit/)