import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/file_readwrite_repository.dart';
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

import 'filereadwrite_list.dart';

class FileReadWriteDetailPage extends StatefulWidget {
  final FileInfo serverFile;
  
  const FileReadWriteDetailPage({
    super.key,
    required this.serverFile,
  });

  @override
  State<FileReadWriteDetailPage> createState() => _FileReadWriteDetailPageState();
}

class _FileReadWriteDetailPageState extends State<FileReadWriteDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;
  late final FileRepository _fileRepository;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
    _fileRepository = getIt<FileRepository>();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _deleteServerFile() async {
    try {
      final result = await showPromptDialog(
        context,
        title: '서버 파일 삭제',
        message: '${widget.serverFile.fileName} 파일을 서버에서 삭제하시겠습니까?',
        confirmText: '삭제',
        cancelText: '취소',
      );

      if (result == true) {
        await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
          context: context,
          operation: () async {
            final success = await _fileRepository.deleteServerFile(
              sn: widget.serverFile.sn,
            );

            if (success) {
              if (mounted) {
                await showStatusDialog(
                  context,
                  variant: StatusVariant.success,
                  title: '성공',
                  message: '서버 파일이 삭제되었습니다: ${widget.serverFile.fileName}',
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
                  message: '서버 파일 삭제에 실패했습니다: ${widget.serverFile.fileName}',
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
                              text: '선택한 파일의 상세 정보를 확인하고 관리할 수 있습니다.',
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
                                        {'label': '파일명', 'value': widget.serverFile.fileName},
                                        {'label': '파일 경로', 'value': widget.serverFile.filePath},
                                        {'label': '파일 크기', 'value': widget.serverFile.formattedSize},
                                        {'label': '업로드일', 'value': widget.serverFile.formattedDate},
                                        {'label': '파일 SN', 'value': widget.serverFile.fileSn.toString()},
                                        {'label': 'UUID', 'value': widget.serverFile.uuid},
                                        {'label': '사용 여부', 'value': widget.serverFile.useYn == 'Y' ? '사용' : '미사용'},
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
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FileReadWriteListPage(),
                    ),
                  ),
                  icon: const Icon(
                    Icons.list,
                    color: EgovColor.white100,
                    size: 20,
                  ),
                ),
                CustomButton(
                  text: '삭제',
                  onTap: isLoading ? null : _deleteServerFile,
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
