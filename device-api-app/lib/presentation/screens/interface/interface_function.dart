import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_description.dart';
import 'package:flutter/material.dart';

class InterfaceFunctionPage extends StatefulWidget {
  const InterfaceFunctionPage({super.key});

  @override
  State<InterfaceFunctionPage> createState() => InterfaceFunctionPageState();
}

class InterfaceFunctionPageState extends State<InterfaceFunctionPage> {
  Map<String, dynamic>? interfaceData;

  @override
  void initState() {
    super.initState();
    _loadInterfaceData();
  }

  Future<void> _loadInterfaceData() async {
    await TextService.loadTextData();
    final data = TextService.getSection('interface');
    setState(() {
      interfaceData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FeatureDescription(
          jsonData: interfaceData, infoBoxText: 'Interface 내용', tableTitle: '', tableData: [],
        ),
      ),
    );
  }
}
