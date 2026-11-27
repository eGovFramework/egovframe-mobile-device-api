import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

class AiChatAiServerBanner extends StatelessWidget {
  const AiChatAiServerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: EgovColor.danger50),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 18,
            color: EgovColor.danger50,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.aiChatAiServerDisconnected,
              style: EgovText.caption.copyWith(
                color: EgovColor.gray90,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
