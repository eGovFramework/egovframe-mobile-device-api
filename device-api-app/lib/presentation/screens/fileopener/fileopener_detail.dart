import 'package:egovframe_mobile_deviceapi_app/data/datasources/file_opener_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/table.dart';
import 'package:flutter/material.dart';

class FileOpenerDetailPage extends StatefulWidget {
  final ServerFileInfo serverFile;
  
  const FileOpenerDetailPage({
    super.key,
    required this.serverFile,
  });

  @override
  State<FileOpenerDetailPage> createState() => _FileOpenerDetailPageState();
}

class _FileOpenerDetailPageState extends State<FileOpenerDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;
  bool isDownloading = false;
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _downloadFile() async {
    if (!mounted) return;
    
    if (mounted) {
      setState(() {
        isDownloading = true;
        downloadProgress = 0.0;
      });
    }

    try {
      final fileInfo = await FileOpenerService.downloadServerFileWithProgress(
        widget.serverFile,
        (progress) {
          if (mounted) {
            setState(() {
              downloadProgress = progress;
            });
          }
        },
      );

      if (fileInfo != null) {
        if (mounted) {
          await showStatusDialog(
            context,
            variant: StatusVariant.success,
            title: '성공',
            message: '파일이 다운로드되었습니다: ${widget.serverFile.orignlFileNm}',
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
            message: '파일 다운로드에 실패했습니다',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showStatusDialog(
          context,
          variant: StatusVariant.error,
          title: '오류',
          message: '파일 다운로드 중 오류가 발생했습니다: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
          downloadProgress = 0.0;
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
        title: '파일 상세정보',
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
                              text: '선택한 파일의 상세 정보를 확인하고 다운로드할 수 있습니다.',
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    CommonTable(
                                      title: 'File 상세정보',
                                      data: [
                                        {'label': '파일명', 'value': widget.serverFile.orignlFileNm},
                                        {'label': '파일 타입', 'value': widget.serverFile.fileType.displayName},
                                        {'label': '파일 크기', 'value': widget.serverFile.formattedFileSize},
                                        {'label': '업데이트일', 'value': widget.serverFile.formattedUpdateDate},
                                        {'label': '파일번호', 'value': widget.serverFile.fileSn},
                                        {'label': '저장 파일명', 'value': widget.serverFile.streFileNm},
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
          if (_tabController.index == 1)
            BottomButtonRow(
              buttons: [
                CustomButton(
                  text: '목록',
                  onTap: () {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(
                    Icons.list,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
                CustomButton(
                  text: isDownloading ? '다운로드 중...' : '다운로드',
                  onTap: isLoading || isDownloading ? null : _downloadFile,
                  icon: isDownloading 
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: downloadProgress,
                          valueColor: const AlwaysStoppedAnimation<Color>(EgovColor.white100),
                        ),
                      )
                    : const Icon(
                        Icons.download,
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
