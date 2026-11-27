import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_scan.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/label_value.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/kst_datetime_util.dart';
import 'package:flutter/material.dart';

class BarcodeOverview extends StatelessWidget {
  final BarcodeScan scan;
  final DateTime? capturedAt;
  final VoidCallback onScanTap;
  final Widget? footer;

  const BarcodeOverview({
    super.key,
    required this.scan,
    this.capturedAt,
    required this.onScanTap,
    this.footer,
  });

  bool get _hasResult => capturedAt != null && scan.hasReading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayCodeType = scan.codeType?.isNotEmpty == true
        ? scan.codeType!
        : '-';
    final displayCodeText = scan.codeText?.isNotEmpty == true
        ? scan.codeText!
        : '-';
    final displayTimestamp =
        capturedAt == null ? '-' : KstDateTimeUtil.format(capturedAt!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!_hasResult)
          InfoBox(text: l10n.barcodeNoScanResultYet)
        else
          LabelValueGroup(
            entries: [
              LabelValueEntry(
                label: l10n.barcodeCodeTypeLabel,
                value: displayCodeType,
              ),
              LabelValueEntry(
                label: l10n.barcodeCodeTextLabel,
                value: displayCodeText,
              ),
              LabelValueEntry(
                label: l10n.barcodeCodeDtLabel,
                value: displayTimestamp,
              ),
            ],
          ),
        const SizedBox(height: 24),
        CustomButton(
          text: l10n.barcodeToggleButton,
          onTap: onScanTap,
          icon: const Icon(
            Icons.qr_code_scanner,
            color: EgovColor.white100,
            size: 20,
          ),
        ),
        if (footer != null) ...[
          const SizedBox(height: 16),
          footer!,
        ],
      ],
    );
  }
}
