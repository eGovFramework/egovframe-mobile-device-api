import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

import 'infobox.dart';
import 'table.dart';

class License extends StatelessWidget {
  const License({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          InfoBox(text: l10n.licenseIntroText),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  CommonTable(
                    title: l10n.licenseInfoTitle,
                    data: [
                      {
                        'label': l10n.licenseLabelLicense,
                        'value': l10n.licenseValueApache,
                      },
                      {
                        'label': l10n.licenseLabelDeveloper,
                        'value': l10n.licenseValueDeveloper,
                      },
                      {
                        'label': l10n.licenseLabelVersion,
                        'value': l10n.licenseValueVersion,
                      },
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: EgovColor.gray20),
                  const SizedBox(height: 16),
                  Text(
                    l10n.licenseCopyrightYear,
                    textAlign: TextAlign.center,
                    style: EgovText.caption.copyWith(color: EgovColor.gray60),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.licenseCopyrightNotice,
                    textAlign: TextAlign.center,
                    style: EgovText.caption.copyWith(
                      color: EgovColor.gray50,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
