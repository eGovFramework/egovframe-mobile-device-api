import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_description.dart';
import 'package:flutter/material.dart';

class AcceleratorFunctionPage extends StatefulWidget {
  const AcceleratorFunctionPage({super.key});

  @override
  State<AcceleratorFunctionPage> createState() => _AcceleratorFunctionPageState();
}

class _AcceleratorFunctionPageState extends State<AcceleratorFunctionPage> {
  Map<String, dynamic>? acceleratorData;

  @override
  void initState() {
    super.initState();
    _loadAcceleratorData();
  }

  Future<void> _loadAcceleratorData() async {
    await TextService.loadTextData();
    final data = TextService.getSection('accelerator');
    setState(() {
      acceleratorData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FeatureDescription(
          jsonData: acceleratorData, infoBoxText: 'deviceInfo 가속기 내용', tableTitle: '', tableData: [],
        ),
      ),
    );
  }
}
