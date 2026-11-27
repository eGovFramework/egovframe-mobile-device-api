import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/widgets/push_connection_status_card.dart';

import 'package:flutter/material.dart';



class PushOverview extends StatelessWidget {

  final bool isLoading;

  final bool isInitialized;

  final bool permissionDenied;

  final String tokenId;

  final VoidCallback? onOpenSettings;

  final Widget? footer;



  const PushOverview({

    super.key,

    required this.isLoading,

    required this.isInitialized,

    required this.permissionDenied,

    required this.tokenId,

    this.onOpenSettings,

    this.footer,

  });



  @override

  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;



    return Column(

      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [

        _PushStatusLine(

          isLoading: isLoading,

          isInitialized: isInitialized,

          permissionDenied: permissionDenied,

          onOpenSettings: onOpenSettings,

        ),

        if (isInitialized && tokenId.isNotEmpty) ...[

          const SizedBox(height: 12),

          _CompactTokenRow(tokenId: tokenId),

        ],

        const SizedBox(height: 20),

        _WebAdminGuideCard(

          title: l10n.pushWebAdminTitle,

          description: l10n.pushWebAdminDesc,

        ),

        const SizedBox(height: 16),

        footer ?? const PushConnectionBar(),

      ],

    );

  }

}



class _WebAdminGuideCard extends StatelessWidget {

  final String title;

  final String description;



  const _WebAdminGuideCard({

    required this.title,

    required this.description,

  });



  @override

  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: EgovColor.primary5,

        borderRadius: BorderRadius.circular(8),

        border: Border.all(color: EgovColor.primary20),

      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              const Icon(Icons.computer, size: 20, color: EgovColor.primary50),

              const SizedBox(width: 8),

              Expanded(

                child: Text(

                  title,

                  style: EgovText.medium.copyWith(

                    color: EgovColor.primary50,

                    fontWeight: FontWeight.w700,

                  ),

                ),

              ),

            ],

          ),

          const SizedBox(height: 8),

          Text(

            description,

            style: EgovText.caption.copyWith(

              color: EgovColor.gray70,

              height: 1.5,

            ),

          ),

        ],

      ),

    );

  }

}



class _PushStatusLine extends StatelessWidget {

  final bool isLoading;

  final bool isInitialized;

  final bool permissionDenied;

  final VoidCallback? onOpenSettings;



  const _PushStatusLine({

    required this.isLoading,

    required this.isInitialized,

    required this.permissionDenied,

    this.onOpenSettings,

  });



  @override

  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;



    final Color dotColor;

    final String statusText;



    if (isLoading) {

      dotColor = EgovColor.gray40;

      statusText = l10n.pushAutoSetupInProgress;

    } else if (permissionDenied) {

      dotColor = EgovColor.warning50;

      statusText = l10n.pushPermissionDenied;

    } else if (isInitialized) {

      dotColor = EgovColor.success50;

      statusText = l10n.pushPermissionGranted;

    } else {

      dotColor = EgovColor.gray40;

      statusText = l10n.pushStatusNotInitialized;

    }



    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

      decoration: BoxDecoration(

        color: EgovColor.gray5,

        borderRadius: BorderRadius.circular(8),

        border: Border.all(color: EgovColor.gray20),

      ),

      child: Row(

        children: [

          if (isLoading)

            const SizedBox(

              width: 14,

              height: 14,

              child: CircularProgressIndicator(strokeWidth: 2),

            )

          else

            Container(

              width: 8,

              height: 8,

              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),

            ),

          const SizedBox(width: 8),

          Expanded(

            child: Text(

              statusText,

              style: EgovText.caption.copyWith(

                color: EgovColor.gray70,

                fontWeight: FontWeight.w600,

              ),

            ),

          ),

          if (permissionDenied && onOpenSettings != null)

            TextButton(

              onPressed: onOpenSettings,

              style: TextButton.styleFrom(

                padding: EdgeInsets.zero,

                minimumSize: Size.zero,

                tapTargetSize: MaterialTapTargetSize.shrinkWrap,

              ),

              child: Text(

                l10n.pushPermissionOpenSettings,

                style: EgovText.caption.copyWith(color: EgovColor.primary50),

              ),

            ),

        ],

      ),

    );

  }

}



class _CompactTokenRow extends StatelessWidget {

  final String tokenId;



  const _CompactTokenRow({required this.tokenId});



  @override

  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;



    return Container(

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(

        color: EgovColor.white100,

        borderRadius: BorderRadius.circular(8),

        border: Border.all(color: EgovColor.gray20),

      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(

            l10n.pushTokenLabel,

            style: EgovText.caption.copyWith(

              color: EgovColor.gray60,

              fontWeight: FontWeight.w600,

            ),

          ),

          const SizedBox(height: 6),

          SelectableText(

            tokenId,

            style: EgovText.caption.copyWith(

              color: EgovColor.primary50,

              fontWeight: FontWeight.w600,

              height: 1.4,

            ),

          ),

        ],

      ),

    );

  }

}


