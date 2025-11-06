// coverage:ignore-file
import 'package:barbu_score/commons/utils/l10n_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../commons/widgets/custom_buttons.dart';
import '../../../commons/widgets/my_default_page.dart';
import '../notifiers/device_info_provider.dart';

enum _ContactType { bug, feature, other }

class ContactButton extends ConsumerWidget {
  static const _mailScheme = "mailto";

  const ContactButton({super.key});

  String _deviceInfosBody(WidgetRef ref) {
    final deviceInfo = ref.read(deviceInfoProvider).value;
    if (deviceInfo != null) {
      return "Phone: ${deviceInfo.device}\nAndroid version: ${deviceInfo.deviceSdk}\nApp version : ${deviceInfo.appVersion}";
    }
    return "";
  }

  String _buildQueryParameters(
    BuildContext context,
    WidgetRef ref,
    _ContactType contactType,
  ) {
    final subject = switch (contactType) {
      _ContactType.bug => context.l10n.reportBug,
      _ContactType.feature => context.l10n.requestFeature,
      _ContactType.other => context.l10n.contact,
    };
    String body = switch (contactType) {
      _ContactType.bug => context.l10n.reportBugMail,
      _ContactType.feature => context.l10n.requestFeatureMail,
      _ContactType.other => "",
    };
    body += "\n\n------\n${_deviceInfosBody(ref)}";

    final params = {"subject": subject, "body": body};
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  String _mailWithSubAddress(String subAddress) {
    return "barbu.score+$subAddress@gmail.com";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButtonFullWidth(
      child: Text(
        context.l10n.contact,
        semanticsLabel: context.l10n.contactByMail,
      ),
      onPressed: () => showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (_) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MyDefaultPage.appPadding.horizontal / 2,
          ),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.contactReason),
              ElevatedButtonFullWidth(
                child: Text(context.l10n.bug),
                onPressed: () => launchUrl(
                  Uri(
                    scheme: _mailScheme,
                    path: _mailWithSubAddress("bug"),
                    query: _buildQueryParameters(
                      context,
                      ref,
                      _ContactType.bug,
                    ),
                  ),
                ),
              ),
              ElevatedButtonFullWidth(
                child: Text(context.l10n.feature),
                onPressed: () => launchUrl(
                  Uri(
                    scheme: _mailScheme,
                    path: _mailWithSubAddress("feature"),
                    query: _buildQueryParameters(
                      context,
                      ref,
                      _ContactType.feature,
                    ),
                  ),
                ),
              ),
              ElevatedButtonFullWidth(
                child: Text(context.l10n.other),
                onPressed: () => launchUrl(
                  Uri(
                    scheme: _mailScheme,
                    path: _mailWithSubAddress("contact"),
                    query: _buildQueryParameters(
                      context,
                      ref,
                      _ContactType.other,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
