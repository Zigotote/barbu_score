// coverage:ignore-file
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final deviceInfoProvider = FutureProvider.autoDispose<MyDeviceInfo>((_) async {
  final (package, device) = await (
    PackageInfo.fromPlatform(),
    DeviceInfoPlugin().androidInfo,
  ).wait;
  return (
    appVersion: package.version,
    device: device.model,
    deviceSdk: device.version.sdkInt,
  );
});

typedef MyDeviceInfo = ({String appVersion, String device, int deviceSdk});
