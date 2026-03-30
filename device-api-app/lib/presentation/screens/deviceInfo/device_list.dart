import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String detailLabel;
  final String detailValue;
  final VoidCallback? onTap;
  final bool showArrow;

  const DeviceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.detailLabel,
    required this.detailValue,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: EgovColor.white100,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: EgovColor.gray20,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: EgovColor.gray90,
                              fontSize: 19,
                              fontFamily: 'Pretendard GOV',
                              fontWeight: FontWeight.w700,
                              height: 1.50,
                            ),
                          ),
                        ),
                        if (showArrow) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: EgovColor.gray40,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      subtitle,
                      style: EgovText.regular.copyWith(
                        color: EgovColor.gray70,
                        fontSize: 15,
                        height: 1.50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$detailLabel :',
                        style: EgovText.captionBold.copyWith(
                          height: 1.50,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          detailValue,
                          style: EgovText.caption.copyWith(
                            color: EgovColor.gray90,
                            height: 1.50,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
