import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/file_readwrite_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/server_connection_utils.dart';
import 'package:flutter/material.dart';

import 'filereadwrite_detail.dart';

class FileReadWriteListPage extends StatefulWidget {
  const FileReadWriteListPage({super.key});

  @override
  State<FileReadWriteListPage> createState() => _FileReadWriteListPageState();
}

class _FileReadWriteListPageState extends State<FileReadWriteListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<FileInfo> serverFileList = [];
  bool isLoading = true;
  String errorMessage = '';
  String deviceUuid = '';
  late final FileRepository _fileRepository;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
    _fileRepository = getIt<FileRepository>();
    _initializeApp();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 앱 초기화
  Future<void> _initializeApp() async {
    await _getDeviceUUID();
    await _loadServerFileList();
  }

  /// 디바이스 UUID를 생성
  Future<void> _getDeviceUUID() async {
    deviceUuid = await DeviceIdService.getDeviceId();
    setState(() {});
  }

  Future<void> _loadServerFileList() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
        context: context,
        operation: () async {
          final serverFiles = await _fileRepository.getFileInfoList(deviceUuid);
          setState(() {
            serverFileList = serverFiles;
            isLoading = false;
          });
        },
        errorTitle: '서버 연결 오류',
        errorMessage: '서버에 연결할 수 없습니다. 파일 목록을 다시 시도해주세요.',
      );
    } catch (e) {
      String errorMessage = e.toString();
      String userMessage;
      
      if (errorMessage.contains('서버 초기화 오류')) {
        userMessage = '서버 초기화 오류가 발생했습니다.\n서버 관리자에게 문의하세요.';
      } else if (errorMessage.contains('네트워크 연결')) {
        userMessage = '네트워크 연결을 확인해주세요.';
      } else if (errorMessage.contains('시간 초과')) {
        userMessage = '서버 응답이 너무 느립니다.\n잠시 후 다시 시도해주세요.';
      } else {
        userMessage = '서버 파일 목록 조회 실패: $e';
      }
      
      if (mounted) {
        setState(() {
          this.errorMessage = userMessage;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteServerFile(FileInfo serverFile) async {
    try {
      final result = await showPromptDialog(
        context,
        title: '서버 파일 삭제',
        message: '${serverFile.fileName} 파일을 서버에서 삭제하시겠습니까?',
        confirmText: '삭제',
        cancelText: '취소',
      );

      if (result == true) {
        await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
          context: context,
          operation: () async {
            final success = await _fileRepository.deleteServerFile(
              sn: serverFile.sn,
              uuid: deviceUuid,
            );

            if (success) {
              if (mounted) {
                await showStatusDialog(
                  context,
                  variant: StatusVariant.success,
                  title: '성공',
                  message: '서버 파일이 삭제되었습니다: ${serverFile.fileName}',
                );
                if (mounted) {
                  setState(() {
                    isLoading = true;
                    errorMessage = '';
                  });
                  _loadServerFileList();
                }
              }
            } else {
              if (mounted) {
                showStatusDialog(
                  context,
                  variant: StatusVariant.error,
                  title: '오류',
                  message: '서버 파일 삭제에 실패했습니다: ${serverFile.fileName}',
                );
              }
            }
          },
          errorTitle: '서버 연결 오류',
          errorMessage: '서버에 연결할 수 없습니다. 파일 삭제를 다시 시도해주세요.',
        );
      }
    } catch (e) {
      if (mounted) {
        showStatusDialog(
          context,
          variant: StatusVariant.error,
          title: '오류',
          message: '서버 파일 삭제 중 오류가 발생했습니다: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        title: 'File ReadWrite API',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: CustomTabBar(
          controller: _tabController,
          tabs: const ['기능설명', '주요기능', '라이선스'],
          onTap: (index) {
            if (index == 1) {
              // "주요기능" 탭 선택 시 처음 화면으로 돌아가기
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
                    'File ReadWrite 기능 설명',
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
                              text: '서버에 저장된 파일들의 리스트를 조회하고 관리할 수 있습니다.',
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
                                              setState(() {
                                                isLoading = true;
                                                errorMessage = '';
                                              });
                                              _loadServerFileList();
                                            },
                                            child: const Text('다시 시도'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : serverFileList.isEmpty
                                      ? Center(
                                          child: Text(
                                            '서버에 파일이 없습니다.',
                                            style: EgovText.regular.copyWith(color: EgovColor.gray40),
                                          ),
                                        )
                                      : RefreshIndicator(
                                          onRefresh: _loadServerFileList,
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(0),
                                            itemCount: serverFileList.length,
                                            itemBuilder: (context, index) {
                                              final serverFile = serverFileList[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 12),
                                                child: _TouchFeedbackWidget(
                                                  onTap: () async {
                                                    final result = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => FileReadWriteDetailPage(serverFile: serverFile),
                                                      ),
                                                    );
                                                    
                                                    if (result == true) {
                                                      setState(() {
                                                        isLoading = true;
                                                        errorMessage = '';
                                                      });
                                                      _loadServerFileList();
                                                    }
                                                  },
                                                  child: DeviceCardExtended(
                                                    title: serverFile.fileName,
                                                    details: [
                                                      {'label': '파일 크기', 'value': serverFile.formattedSize},
                                                      {'label': '업로드일', 'value': serverFile.formattedDate},
                                                      {'label': '파일 SN', 'value': serverFile.fileSn.toString()},
                                                      {'label': '사용 여부', 'value': serverFile.useYn == 'Y' ? '사용' : '미사용'},
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
                    setState(() {
                      isLoading = true;
                      errorMessage = '';
                    });
                    _loadServerFileList();
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
                CustomButton(
                  text: '이전 화면',
                  onTap: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
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
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
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

// 확장된 DeviceCard 위젯
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
