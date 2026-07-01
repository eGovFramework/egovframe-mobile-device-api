import 'package:egovframe_mobile_deviceapi_app/data/datasources/file_opener_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fileopener_description.dart';
import 'fileopener_list.dart';

class FileOpenerScreen extends StatefulWidget {
  const FileOpenerScreen({super.key});

  @override
  State<FileOpenerScreen> createState() => _FileOpenerScreenState();
}

class _FileOpenerScreenState extends State<FileOpenerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<FileOpenerInfo> _files = [];
  List<FileOpenerInfo> _filteredFiles = [];
  bool _isLoading = true;
  FileType? _selectedFileType;
  String _sortBy = 'name'; // name, size, date
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {}); // 탭 변경 시 UI 업데이트
      }
    });
    _loadFiles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFiles() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final files = await FileOpenerService.getLocalFileList();
      if (!mounted) return;
      
      setState(() {
        _files = files;
        _filteredFiles = files;
        _isLoading = false;
      });
      if (mounted) {
        _applyFilters();
      }
    } catch (e, stackTrace) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FileOpenerPage._loadFiles',
        );
      }
    }
  }

  void _navigateToServerList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FileOpenerListPage(),
      ),
    );
  }

  void _applyFilters() {
    if (!mounted) return;
    
    List<FileOpenerInfo> filtered = List.from(_files);

    // 파일 타입 필터
    if (_selectedFileType != null) {
      filtered = filtered.where((file) => file.fileType == _selectedFileType).toList();
    }

    // 정렬
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.fileName.compareTo(b.fileName);
          break;
        case 'size':
          comparison = a.fileSize.compareTo(b.fileSize);
          break;
        case 'date':
          comparison = a.lastModified.compareTo(b.lastModified);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    if (mounted) {
      setState(() {
        _filteredFiles = filtered;
      });
    }
  }

  Future<void> _openFile(FileOpenerInfo fileInfo) async {
    if (!mounted) return;
    
    try {
      final result = await FileOpenerService.openFile(fileInfo);
      if (!mounted) return;
      
      if (result.success) {
        // 파일이 성공적으로 열렸을 때는 alert를 표시하지 않음
        return;
      } else if (result.suggestedApp != null) {
        if (mounted) {
          _showAppDownloadDialog(fileInfo, result.suggestedApp!);
        }
      } else {
        if (mounted) {
          _showErrorSnackBar('파일을 열 수 없습니다: ${result.message}');
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FileOpenerPage._openFile',
        );
      }
    }
  }

  void _showAppDownloadDialog(FileOpenerInfo fileInfo, ViewerApp app) {
    if (!mounted) return;
    
    showPromptDialog(
      context,
      title: '${fileInfo.fileExtension.toUpperCase()} 파일 열기',
      message: '이 파일을 열 수 있는 앱이 없습니다.\n\n권장 앱: ${app.name}\n${app.description}',
      confirmText: '다운로드',
      cancelText: '취소',
      onConfirm: () {
        if (mounted) {
          _openAppStore(app.storeUrl);
        }
      },
    );
  }

  void _openAppStore(String storeUrl) async {
    if (!mounted) return;
    
    try {
      final Uri url = Uri.parse(storeUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        if (mounted) {
          _showSuccessSnackBar('앱 스토어로 이동합니다');
        }
      } else {
        if (mounted) {
          _showErrorSnackBar('앱 스토어를 열 수 없습니다');
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FileOpenerPage._openAppStore',
        );
      }
    }
  }


  Future<void> _pickFiles() async {
    if (!mounted) return;
    
    try {
      final files = await FileOpenerService.pickFiles(allowMultiple: true);
      if (!mounted) return;
      
      if (files != null && files.isNotEmpty) {
        if (mounted) {
          setState(() {
            _files.addAll(files);
          });
          if (mounted) {
            _applyFilters();
          }
          if (mounted) {
            _showSuccessSnackBar('${files.length}개의 파일이 추가되었습니다');
          }
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FileOpenerPage._pickFiles',
        );
      }
    }
  }

  Future<void> _deleteFile(FileOpenerInfo fileInfo) async {
    if (!mounted) return;
    
    final confirmed = await _showDeleteConfirmDialog(fileInfo.fileName);
    if (!mounted) return;
    
    if (confirmed == true) {
      try {
        final success = await FileOpenerService.deleteFile(fileInfo);
        if (!mounted) return;
        
        if (success) {
          if (mounted) {
            setState(() {
              _files.removeWhere((file) => file.filePath == fileInfo.filePath);
            });
            if (mounted) {
              _applyFilters();
            }
            if (mounted) {
              _showSuccessSnackBar('파일이 삭제되었습니다: ${fileInfo.fileName}');
            }
          }
        } else {
          if (mounted) {
            _showErrorSnackBar('파일 삭제에 실패했습니다');
          }
        }
      } catch (e, stackTrace) {
        if (mounted) {
          await ErrorHandler.handleException(
            context,
            e,
            stackTrace: stackTrace,
            logContext: 'FileOpenerPage._deleteFile',
          );
        }
      }
    }
  }

  Future<void> _showSuccessSnackBar(String message) async {
    if (!mounted) return;
    await showStatusDialog(
      context,
      variant: StatusVariant.success,
      title: '성공',
      message: message,
    );
  }

  Future<void> _showErrorSnackBar(String message) async {
    if (!mounted) return;
    await ErrorHandler.showErrorDialog(context, message);
  }

  Future<bool?> _showDeleteConfirmDialog(String fileName) {
    return showPromptDialog(
      context,
      title: '파일 삭제',
      message: '정말로 "$fileName" 파일을 삭제하시겠습니까?',
      confirmText: '삭제',
      cancelText: '취소',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        title: '문서 뷰어 (File Opener)',
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
                const FileOpenerFunctionPage(),
                // 주요기능 탭
                _buildMainFunctionTab(),
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
                  text: '파일 추가',
                  onTap: _isLoading ? null : _pickFiles,
                  isLoading: _isLoading,
                  icon: const Icon(Icons.add, color: EgovColor.white100, size: 20),
                ),
                ServerConnectionButtonFactory.listButton(
                  text: '서버 목록',
                  onServerConnected: () async => _navigateToServerList(),
                  errorTitle: '서버 연결 오류',
                  errorMessage: '서버에 연결할 수 없습니다. 웹서버가 실행중인지 확인해주세요.',
                ),
              ],
            )
          else
            const SizedBox.shrink(),
          const Footer(),
        ],
      ),
    );
  }

  /// 주요기능 탭의 내용을 구성하는 메서드
  Widget _buildMainFunctionTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 파일 목록 카드
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.folder_open,
                          color: EgovColor.primary50,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '로컬 파일 목록 (${_filteredFiles.length})',
                            style: EgovText.title.copyWith(
                              fontWeight: FontWeight.bold,
                              color: EgovColor.primary50,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _isLoading ? null : _loadFiles,
                          icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.refresh),
                          tooltip: '새로고침',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 파일 목록
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildLocalFileList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalFileList() {
    if (_filteredFiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 48,
              color: EgovColor.gray40,
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFileType != null
                  ? '해당 타입의 파일이 없습니다'
                  : '파일이 없습니다',
              style: EgovText.bodyLarge.copyWith(
                color: EgovColor.gray60,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '하단의 파일 추가 버튼을 눌러 파일을 추가하거나\n서버에서 파일을 불러오세요',
              textAlign: TextAlign.center,
              style: EgovText.bodyMedium.copyWith(
                color: EgovColor.gray50,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: _filteredFiles.length,
      itemBuilder: (context, index) {
        final file = _filteredFiles[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildFileItem(file),
        );
      },
    );
  }

  Widget _buildFileItem(FileOpenerInfo file) {
    return Card(
      elevation: 2,
      color: EgovColor.white100,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getFileTypeColor(file.fileType),
          child: Icon(
            _getFileTypeIcon(file.fileType),
            color: EgovColor.white100,
            size: 20,
          ),
        ),
        title: Text(
          file.fileName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${file.fileType.displayName} • ${file.formattedFileSize}'),
            Text(
              file.formattedLastModified,
              style: TextStyle(
                fontSize: 11,
                color: EgovColor.gray60,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _openFile(file),
              icon: const Icon(Icons.open_in_new),
              color: EgovColor.success50,
              iconSize: 20,
              tooltip: '열기',
            ),
            IconButton(
              onPressed: () => _deleteFile(file),
              icon: const Icon(Icons.delete_outline),
              color: EgovColor.danger50,
              iconSize: 20,
              tooltip: '삭제',
            ),
          ],
        ),
        onTap: () => _openFile(file),
      ),
    );
  }


  Color _getFileTypeColor(FileType fileType) {
    switch (fileType) {
      case FileType.document:
        return EgovColor.danger50;
      case FileType.text:
        return EgovColor.information50;
      case FileType.spreadsheet:
        return EgovColor.success50;
      case FileType.presentation:
        return EgovColor.warning50;
      case FileType.other:
        return EgovColor.gray40;
    }
  }

  IconData _getFileTypeIcon(FileType fileType) {
    switch (fileType) {
      case FileType.document:
        return Icons.picture_as_pdf;
      case FileType.text:
        return Icons.article;
      case FileType.spreadsheet:
        return Icons.table_chart;
      case FileType.presentation:
        return Icons.slideshow;
      case FileType.other:
        return Icons.insert_drive_file;
    }
  }
}
