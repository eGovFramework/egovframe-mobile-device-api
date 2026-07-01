import 'package:egovframe_mobile_deviceapi_app/data/datasources/file_opener_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';

import 'fileopener_detail.dart';

class FileOpenerListPage extends StatefulWidget {
  const FileOpenerListPage({super.key});

  @override
  State<FileOpenerListPage> createState() => _FileOpenerListPageState();
}

class _FileOpenerListPageState extends State<FileOpenerListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ServerFileInfo> serverFiles = [];
  bool isLoading = true;
  String errorMessage = '';
  bool isDownloading = false;
  String? downloadingFileName;
  double downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {}); // 탭 변경 시 UI 업데이트
      }
    });
    _loadServerFiles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadServerFiles() async {
    if (!mounted) return;
    
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
          errorMessage = '';
        });
      }

      final files = await FileOpenerService.getServerFileList();
      
      if (mounted) {
        setState(() {
          serverFiles = files;
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      ErrorHandler.logError(e, stackTrace, context: 'FileOpenerListPage._loadServerFiles');
      if (mounted) {
        setState(() {
          errorMessage = ErrorHandler.messageFor(e);
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        title: 'File Opener API',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
          onPressed: () {
            if (mounted) {
              Navigator.maybePop(context);
            }
          },
        ),
        bottom: CustomTabBar(
          controller: _tabController,
          tabs: const ['기능설명', '주요기능', '라이선스'],
          onTap: (index) {
            if (index == 1) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 기능설명 탭
                const Center(
                  child: Text(
                    'File Opener 기능 설명',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                // 주요기능 탭
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            InfoBox(
                              text: '서버에 저장된 파일들의 리스트를 조회하고 다운로드할 수 있습니다.',
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: errorMessage.isNotEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.error, size: 64, color: EgovColor.danger50),
                                          const SizedBox(height: 16),
                                          Text(
                                            errorMessage,
                                            style: EgovText.regular.copyWith(color: EgovColor.danger50),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (mounted) {
                                                setState(() {
                                                  isLoading = true;
                                                  errorMessage = '';
                                                });
                                                _loadServerFiles();
                                              }
                                            },
                                            child: const Text('다시 시도'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : serverFiles.isEmpty
                                      ? Center(
                                          child: Text(
                                            '서버에 파일이 없습니다.',
                                            style: EgovText.regular.copyWith(color: EgovColor.gray40),
                                          ),
                                        )
                                      : RefreshIndicator(
                                          onRefresh: _loadServerFiles,
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(0),
                                            itemCount: serverFiles.length,
                                            itemBuilder: (context, index) {
                                              final serverFile = serverFiles[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 12),
                                                child: _TouchFeedbackWidget(
                                                  onTap: () async {
                                                    final result = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => FileOpenerDetailPage(serverFile: serverFile),
                                                      ),
                                                    );
                                                    
                                                    // 다운로드 성공으로 인한 새로고침 요청인 경우
                                                    if (result == true && mounted) {
                                                      setState(() {
                                                        isLoading = true;
                                                        errorMessage = '';
                                                      });
                                                      _loadServerFiles();
                                                    }
                                                  },
                                                  child: DeviceCardExtended(
                                                    title: serverFile.orignlFileNm,
                                                    subtitle: '${serverFile.fileType.displayName} • ${serverFile.formattedFileSize}',
                                                    details: [
                                                      {'label': '파일 타입', 'value': serverFile.fileType.displayName},
                                                      {'label': '파일 크기', 'value': serverFile.formattedFileSize},
                                                      {'label': '업데이트일', 'value': serverFile.formattedUpdateDate},
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                            ),
                          ],
                        ),
                      ),
                // 라이선스 탭
                const License(),
              ],
            ),
          ),
          if (_tabController.index == 1)
            BottomButtonRow(
              buttons: [
                CustomButton(
                  text: '새로고침',
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        isLoading = true;
                        errorMessage = '';
                      });
                      _loadServerFiles();
                    }
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
                CustomButton(
                  text: '로컬 목록',
                  onTap: () {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.folder,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
              ],
            )
          else
            const SizedBox.shrink(), // 빈 공간으로 처리
          const Footer(),
        ],
      ),
    );
  }
}

class _TouchFeedbackWidget extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const _TouchFeedbackWidget({
    required this.onTap,
    required this.child,
  });

  @override
  State<_TouchFeedbackWidget> createState() => _TouchFeedbackWidgetState();
}

class _TouchFeedbackWidgetState extends State<_TouchFeedbackWidget> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (mounted) {
          setState(() => isPressed = true);
        }
      },
      onTapUp: (_) {
        if (mounted) {
          setState(() => isPressed = false);
        }
      },
      onTapCancel: () {
        if (mounted) {
          setState(() => isPressed = false);
        }
      },
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: isPressed 
            ? [
                BoxShadow(
                  color: EgovColor.black10,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ]
            : [
                BoxShadow(
                  color: EgovColor.black25,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: Transform.scale(
          scale: isPressed ? 0.95 : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}

// DeviceCard 위젯
class DeviceCardExtended extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Map<String, String>> details;
  final VoidCallback? onTap;
  final bool showArrow;
  final bool isSelected;

  const DeviceCardExtended({
    super.key,
    required this.title,
    this.subtitle,
    required this.details,
    this.onTap,
    this.showArrow = true,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: EgovColor.white100,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: isSelected ? 3 : 1,
            color: isSelected ? EgovColor.primary50 : const Color(0xFFB1B8BE),
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
                              color: Color(0xFF1E2124),
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
                  if (subtitle != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        subtitle!,
                        style: const TextStyle(
                          color: Color(0xFF464C53),
                          fontSize: 15,
                          fontFamily: 'Pretendard GOV',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  ...details.map((detail) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${detail['label']} :',
                          style: const TextStyle(
                            color: Color(0xFF1E2124),
                            fontSize: 13,
                            fontFamily: 'Pretendard GOV',
                            fontWeight: FontWeight.w700,
                            height: 1.50,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            detail['value'] ?? '',
                            style: const TextStyle(
                              color: Color(0xFF1E2124),
                              fontSize: 13,
                              fontFamily: 'Pretendard GOV',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
