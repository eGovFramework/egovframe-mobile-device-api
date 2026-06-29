import 'package:egovframe_mobile_deviceapi_app/data/datasources/media_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/media_info.dart';
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

import 'media_description.dart';
import 'media_detail.dart';
import 'media_main.dart';

class MediaListPage extends StatefulWidget {
  const MediaListPage({super.key});

  @override
  State<MediaListPage> createState() => _MediaListPageState();
}

class _MediaListPageState extends State<MediaListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<MediaFileInfo> serverMediaFiles = [];
  bool isLoading = true;
  String errorMessage = '';
  String deviceUuid = '';
  bool _isDownloading = false;
  String? _downloadingFileName;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
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
    await _loadServerMediaList();
  }
  Future<void> _getDeviceUUID() async {
    deviceUuid = await DeviceIdService.getDeviceId();
    setState(() {});
  }

  Future<void> _loadServerMediaList() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
        context: context,
        operation: () async {
          final serverFiles = await MediaService.getServerMediaList(deviceUuid);
          setState(() {
            serverMediaFiles = serverFiles;
            isLoading = false;
          });
        },
        errorTitle: '서버 연결 오류',
        errorMessage: '서버에 연결할 수 없습니다. 미디어 목록을 다시 시도해주세요.',
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
        userMessage = '서버 미디어 목록 조회 실패: $e';
      }
      
      if (mounted) {
        setState(() {
          this.errorMessage = userMessage;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _downloadServerMedia(MediaFileInfo mediaFile) async {
    setState(() {
      _isDownloading = true;
      _downloadingFileName = mediaFile.name;
      _downloadProgress = 0.0;
    });

    try {
      await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
        context: context,
        operation: () async {
          final result = await MediaService.downloadMedia(
            mediaFile.fileSn ?? 0,
            mediaFile.name,
            (progress) {
              setState(() {
                _downloadProgress = progress;
              });
            },
          );

          if (result['success'] == true) {
            if (mounted) {
              showStatusDialog(
                context,
                variant: StatusVariant.success,
                title: '다운로드 완료',
                message: '미디어 파일이 성공적으로 다운로드되었습니다: ${mediaFile.name}',
              );
            }
          } else {
            if (mounted) {
              showStatusDialog(
                context,
                variant: StatusVariant.error,
                title: '다운로드 실패',
                message: '미디어 파일 다운로드에 실패했습니다: ${result['message']}',
              );
            }
          }
        },
        errorTitle: '서버 연결 오류',
        errorMessage: '서버에 연결할 수 없습니다. 미디어 다운로드를 다시 시도해주세요.',
      );
    } catch (e) {
      if (mounted) {
        showStatusDialog(
          context,
          variant: StatusVariant.error,
          title: '오류',
          message: '미디어 다운로드 중 오류가 발생했습니다: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadingFileName = null;
          _downloadProgress = 0.0;
        });
      }
    }
  }

  Future<void> _deleteServerMedia(MediaFileInfo mediaFile) async {
    try {
      final result = await showPromptDialog(
        context,
        title: '서버 미디어 삭제',
        message: '${mediaFile.name} 파일을 서버에서 삭제하시겠습니까?',
        confirmText: '삭제',
        cancelText: '취소',
      );

      if (result == true) {
        await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
          context: context,
          operation: () async {
            // media 테이블의 sn을 사용 (fileSn이 아님)
            final sn = int.tryParse(mediaFile.sn ?? '0') ?? 0;
            final deleteResult = await MediaService.deleteMediaFromServer(sn, deviceUuid);

            if (deleteResult['success'] == true) {
              if (mounted) {
                await showStatusDialog(
                  context,
                  variant: StatusVariant.success,
                  title: '성공',
                  message: '서버 미디어가 삭제되었습니다: ${mediaFile.name}',
                );
                if (mounted) {
                  setState(() {
                    isLoading = true;
                    errorMessage = '';
                  });
                  _loadServerMediaList();
                }
              }
            } else {
              if (mounted) {
                showStatusDialog(
                  context,
                  variant: StatusVariant.error,
                  title: '오류',
                  message: '서버 미디어 삭제에 실패했습니다: ${deleteResult['message']}',
                );
              }
            }
          },
          errorTitle: '서버 연결 오류',
          errorMessage: '서버에 연결할 수 없습니다. 미디어 삭제를 다시 시도해주세요.',
        );
      }
    } catch (e) {
      if (mounted) {
        showStatusDialog(
          context,
          variant: StatusVariant.error,
          title: '오류',
          message: '서버 미디어 삭제 중 오류가 발생했습니다: $e',
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
        title: '미디어 서버 목록',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: CustomTabBar(
          controller: _tabController,
          tabs: const ['기능설명', '주요기능', '라이선스'],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const MediaFunctionPage(),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            InfoBox(
                              text: '서버에 저장된 미디어 파일들의 리스트를 조회하고 관리할 수 있습니다.',
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
                                              _loadServerMediaList();
                                            },
                                            child: const Text('다시 시도'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : serverMediaFiles.isEmpty
                                      ? Center(
                                          child: Text(
                                            '서버에 미디어 파일이 없습니다.',
                                            style: EgovText.regular.copyWith(color: EgovColor.gray40),
                                          ),
                                        )
                                      : RefreshIndicator(
                                          onRefresh: _loadServerMediaList,
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(0),
                                            itemCount: serverMediaFiles.length,
                                            itemBuilder: (context, index) {
                                              final mediaFile = serverMediaFiles[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 12),
                                                child: _TouchFeedbackWidget(
                                                  onTap: () async {
                                                    final result = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => MediaDetailPage(mediaFile: mediaFile),
                                                      ),
                                                    );
                                                    
                                                    // 삭제 성공으로 인한 새로고침 요청인 경우
                                                    if (result == true) {
                                                      setState(() {
                                                        isLoading = true;
                                                        errorMessage = '';
                                                      });
                                                      _loadServerMediaList();
                                                    }
                                                  },
                                                  child: _buildServerMediaItem(mediaFile),
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
                    _loadServerMediaList();
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
                    Navigator.pop(context);
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

  Widget _buildServerMediaItem(MediaFileInfo mediaFile) {
    final isDownloading = _isDownloading && _downloadingFileName == mediaFile.name;
    
    return Card(
      elevation: 2,
      color: EgovColor.white100,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: mediaFile.type == MediaType.image
              ? EgovColor.point50
              : EgovColor.secondary50,
          child: Icon(
            mediaFile.type == MediaType.image ? Icons.image : Icons.videocam,
            color: EgovColor.white100,
            size: 20,
          ),
        ),
        title: Text(
          mediaFile.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_buildFileInfoText(mediaFile)),
            Text(
              '서버 파일',
              style: TextStyle(fontSize: 11, color: EgovColor.gray60),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDownloading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: _downloadProgress,
                ),
              )
            else
              IconButton(
                onPressed: () => _downloadServerMedia(mediaFile),
                icon: const Icon(Icons.download),
                color: EgovColor.primary50,
                iconSize: 20,
                tooltip: '다운로드',
              ),
            IconButton(
              onPressed: () => _deleteServerMedia(mediaFile),
              icon: const Icon(Icons.delete),
              color: EgovColor.danger50,
              iconSize: 20,
              tooltip: '삭제',
            ),
          ],
        ),
      ),
    );
  }

  /// 파일 정보 텍스트 생성 (확장자 • 크기)
  String _buildFileInfoText(MediaFileInfo mediaFile) {
    String extension = '';
    if (mediaFile.fileExtsn != null && mediaFile.fileExtsn!.isNotEmpty) {
      // fileExtsn이 "."으로 시작하면 제거, 아니면 그대로 사용
      extension = mediaFile.fileExtsn!.startsWith('.') 
          ? mediaFile.fileExtsn!.substring(1) 
          : mediaFile.fileExtsn!;
    } else if (mediaFile.name.isNotEmpty) {
      // fileExtsn이 없으면 파일명에서 확장자 추출
      final parts = mediaFile.name.split('.');
      if (parts.length > 1) {
        extension = parts.last;
      }
    }
    
    final sizeText = mediaFile.size > 0 ? mediaFile.formattedSize : '크기 정보 없음';
    
    if (extension.isNotEmpty) {
      return '$extension • $sizeText';
    } else {
      return sizeText;
    }
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
