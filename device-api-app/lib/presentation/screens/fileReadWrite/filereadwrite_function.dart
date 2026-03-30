import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_description.dart';
import 'package:flutter/material.dart';

class FileReadWriteFunctionPage extends StatefulWidget {
  const FileReadWriteFunctionPage({super.key});

  @override
  State<FileReadWriteFunctionPage> createState() => _FileReadWriteFunctionPageState();
}

class _FileReadWriteFunctionPageState extends State<FileReadWriteFunctionPage> {
  Map<String, dynamic>? fileReadWriteData;

  @override
  void initState() {
    super.initState();
    _loadFileReadWriteData();
  }

  Future<void> _loadFileReadWriteData() async {
    await TextService.loadTextData();
    final data = TextService.getSection('fileReadWrite');
    setState(() {
      fileReadWriteData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FeatureDescription(
          jsonData: fileReadWriteData,
          infoBoxText: fileReadWriteData?['title1']?['content'] ?? '파일 읽기/쓰기 기능을 통해 로컬 파일을 생성, 조회, 삭제하고 서버와 파일을 주고받을 수 있습니다.',
          tableTitle: '',
          tableData: [],
        ),
      ),
    );
  }
}

