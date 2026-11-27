import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_guide_page.dart';
import 'package:flutter/material.dart';

class DeviceFunctionPage extends StatelessWidget {
  const DeviceFunctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureGuidePage(
      sectionKey: 'deviceInfo',
      additionalSectionKeys: ['systemStatus'],
    );
  }
}
