import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/media_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/server_connection_utils.dart';
import 'package:flutter/material.dart';

import 'media_list.dart';

class MediaDetailPage extends StatefulWidget {
  final MediaFileInfo mediaFile;
  
  const MediaDetailPage({
    super.key,
    required this.mediaFile,
  });

  @override
  State<MediaDetailPage> createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends State<MediaDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _downloadMedia() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
        context: context,
        operation: () async {
          final result = await MediaService.downloadMedia(
            widget.mediaFile.fileSn ?? 0,
            widget.mediaFile.name,
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
                message: '미디어 파일이 성공적으로 다운로드되었습니다: ${widget.mediaFile.name}',
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
          _downloadProgress = 0.0;
        });
      }
    }
  }

  Future<void> _deleteMedia() async {
    try {
      final result = await showPromptDialog(
        context,
        title: '서버 미디어 삭제',
        message: '${widget.mediaFile.name} 파일을 서버에서 삭제하시겠습니까?',
        confirmText: '삭제',
        cancelText: '취소',
      );

      if (result == true) {
        await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
          context: context,
          operation: () async {
            // media 테이블의 sn을 사용 (fileSn이 아님)
            final sn = int.tryParse(widget.mediaFile.sn ?? '0') ?? 0;
            final uuid = await DeviceIdService.getDeviceId();
            final deleteResult = await MediaService.deleteMediaFromServer(sn, uuid);

            if (deleteResult['success'] == true) {
              if (mounted) {
                await showStatusDialog(
                  context,
                  variant: StatusVariant.success,
                  title: '성공',
                  message: '서버 미디어가 삭제되었습니다: ${widget.mediaFile.name}',
                );
                if (mounted) {
                  Navigator.pop(context, true);
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
        title: '미디어 상세정보',
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
                // 기능설명 탭
                const Center(
                  child: Text(
                    '미디어 상세정보 기능 설명',
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
                              text: '선택한 미디어 파일의 상세 정보를 확인하고 관리할 수 있습니다.',
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    CommonTable(
                                      title: 'Media 상세정보',
                                      data: [
                                        {'label': '파일명', 'value': widget.mediaFile.name},
                                        {'label': '파일 크기', 'value': widget.mediaFile.formattedSize},
                                        {'label': '미디어 타입', 'value': widget.mediaFile.typeString},
                                        if (widget.mediaFile.fileStreCours != null && widget.mediaFile.fileStreCours!.isNotEmpty)
                                          {'label': '파일 경로', 'value': widget.mediaFile.fileStreCours!},
                                        if (widget.mediaFile.streFileNm != null && widget.mediaFile.streFileNm!.isNotEmpty)
                                          {'label': '저장 파일명', 'value': widget.mediaFile.streFileNm!},
                                      ],
                                    ),
                                  ],
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
          // 주요기능 탭에서만 버튼 표시
          if (_tabController.index == 1)
            BottomButtonRow(
              buttons: [
                CustomButton(
                  text: '목록',
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MediaListPage(),
                    ),
                  ),
                  icon: const Icon(
                    Icons.list,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
                CustomButton(
                  text: '다운로드',
                  onTap: _isDownloading ? null : _downloadMedia,
                  icon: _isDownloading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: _downloadProgress,
                            valueColor: const AlwaysStoppedAnimation<Color>(EgovColor.white100),
                          ),
                        )
                      : const Icon(
                          Icons.download,
                          color: EgovColor.white100,
                          size: 20,
                        ),
                  normalColor: EgovColor.primary50,
                  fontSize: 15,
                  horizontalPadding: 12,
                ),
                CustomButton(
                  text: '삭제',
                  onTap: isLoading ? null : _deleteMedia,
                  icon: isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(EgovColor.white100),
                        ),
                      )
                    : const Icon(
                        Icons.delete,
                        color: EgovColor.white100,
                        size: 20,
                      ),
                  normalColor: EgovColor.danger50,
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
