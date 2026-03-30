import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_description.dart';
import 'package:flutter/material.dart';

class FileOpenerFunctionPage extends StatefulWidget {
  const FileOpenerFunctionPage({super.key});

  @override
  State<FileOpenerFunctionPage> createState() => _FileOpenerFunctionPageState();
}

class _FileOpenerFunctionPageState extends State<FileOpenerFunctionPage> {
  Map<String, dynamic>? fileOpenerData;

  @override
  void initState() {
    super.initState();
    _loadFileOpenerData();
  }

  Future<void> _loadFileOpenerData() async {
    await TextService.loadTextData();
    final data = TextService.getSection('fileopener');
    setState(() {
      fileOpenerData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FeatureDescription(
          jsonData: fileOpenerData,
          infoBoxText: fileOpenerData?['title1']?['content'] ?? '문서 뷰어를 통해 다양한 파일 형식을 열고 관리할 수 있습니다.',
          tableTitle: '',
          tableData: [],
        ),
      ),
    );
  }
}

