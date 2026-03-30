import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_description.dart';
import 'package:flutter/material.dart';

class MediaFunctionPage extends StatefulWidget {
  const MediaFunctionPage({super.key});

  @override
  State<MediaFunctionPage> createState() => _MediaFunctionPageState();
}

class _MediaFunctionPageState extends State<MediaFunctionPage> {
  Map<String, dynamic>? mediaData;

  @override
  void initState() {
    super.initState();
    _loadMediaData();
  }

  Future<void> _loadMediaData() async {
    await TextService.loadTextData();
    final data = TextService.getSection('media');
    setState(() {
      mediaData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FeatureDescription(
          jsonData: mediaData,
          infoBoxText: mediaData?['title1']?['content'] ?? '미디어 API를 통해 이미지와 비디오를 선택하고 관리할 수 있습니다.',
          tableTitle: '',
          tableData: [],
        ),
      ),
    );
  }
}

