import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/datasources/file_readwrite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/file_readwrite_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/repositories/file_readwrite_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/server_connection_utils.dart';
import 'package:flutter/material.dart';

import '../media/media_main.dart';
import 'filereadwrite_description.dart';
import 'filereadwrite_list.dart';

class FileReadWriteMainPage extends StatefulWidget {
  const FileReadWriteMainPage({super.key});

  @override
  State<FileReadWriteMainPage> createState() => _FileReadWriteMainPageState();
}

class _FileReadWriteMainPageState extends State<FileReadWriteMainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _fileContentController = TextEditingController();
  List<FileInfo> _fileList = [];
  late final FileRepository _fileRepository;
  Set<String> _selectedFiles = {}; // 선택된 파일명들을 저장
  String _statusMessage = '파일을 생성하거나 목록을 새로고침해주세요.';
  bool _isLoading = false;
  String _deviceUuid = '';

  FileInfo _convertLocalFileToFileInfo(LocalFileInfo localFile) {
    return FileInfo(
      sn: 0,
      fileSn: 0,
      uuid: _deviceUuid,
      fileName: localFile.name,
      filePath: localFile.path,
      fileSize: localFile.size,
      uploadDate: localFile.lastModified.toIso8601String(),
      useYn: 'Y',
    );
  }

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
    _fileNameController.dispose();
    _fileContentController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await _getDeviceUUID();
    await _refreshFileList();
  }

  /// 디바이스 UUID 생성
  Future<void> _getDeviceUUID() async {
    _deviceUuid = await DeviceIdService.getDeviceId();
    setState(() {});
  }

  Future<void> _refreshFileList() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '파일 목록을 불러오는 중...';
      _selectedFiles.clear();
    });

    try {
      final localFileList = await FileReadWriteService.getAllFileList(_deviceUuid);
      final fileList = localFileList.map((localFile) => _convertLocalFileToFileInfo(localFile)).toList();
      setState(() {
        _fileList = fileList;
        _statusMessage = '파일 목록이 업데이트되었습니다. (${fileList.length}개)';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '파일 목록 조회 실패: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 파일 생성
  void _showCreateFileDialog() {
    _fileNameController.clear();
    _fileContentController.clear();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.create_new_folder,
              color: EgovColor.primary50,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('파일 생성'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _fileNameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: '파일 이름',
                  hintText: 'example.txt',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.insert_drive_file),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _fileContentController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: 4,
                minLines: 1,
                decoration: InputDecoration(
                  labelText: '파일 내용',
                  hintText: '파일에 저장할 내용을 입력하세요...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.edit_note),
                ),
              ),
            ],
          ),
        ),
        actions: [
          CustomButton(
            text: '취소',
            onTap: () => Navigator.of(context).pop(),
            normalColor: EgovColor.gray30,
            pressedColor: EgovColor.gray50,
          ),
          const SizedBox(width: 8),
          CustomButton(
            text: '생성',
            onTap: _isLoading ? null : _createTextFile,
            isLoading: _isLoading,
            normalColor: EgovColor.success50,
            pressedColor: EgovColor.success70,
          ),
        ],
      ),
    );
  }

  /// 텍스트 파일을 생성
  Future<void> _createTextFile() async {
    if (_fileNameController.text.trim().isEmpty) {
      _showMessage('파일 이름을 입력해주세요.');
      return;
    }

    if (_fileContentController.text.trim().isEmpty) {
      _showMessage('파일 내용을 입력해주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = '파일을 생성하는 중...';
    });

    try {
      final fileName = _fileNameController.text.trim();
      final content = _fileContentController.text.trim();
      
      final fullFileName = fileName.contains('.') ? fileName : '$fileName.txt';
      
      final success = await FileReadWriteService.writeTextFile(fullFileName, content);
      
      if (success) {
        setState(() {
          _statusMessage = '파일이 성공적으로 생성되었습니다: $fullFileName';
        });
        _fileNameController.clear();
        _fileContentController.clear();
        Navigator.of(context).pop(); // 다이얼로그 닫기
        
        setState(() {
          _selectedFiles.clear();
        });
        
        await _refreshFileList();
      } else {
        setState(() {
          _statusMessage = '파일 생성에 실패했습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = '파일 생성 오류: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 파일 읽기
  Future<void> _readFile(String fileName) async {
    try {
      if (_isMediaFile(fileName)) {
        _showMediaFile(fileName);
        return;
      }
      
      final content = await FileReadWriteService.readTextFile(fileName);
      if (content != null) {
        _showFileContentDialog(fileName, content);
      } else {
        _showMessage('파일을 읽을 수 없습니다: $fileName');
      }
    } catch (e) {
      _showMessage('파일 읽기 오류: $e');
    }
  }

  /// 파일이 미디어 파일인지 확인
  bool _isMediaFile(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'mp4', 'avi', 'mov', 'wmv', 'flv', 'webm', 'mp3', 'wav', 'aac', 'ogg', 'm4a'].contains(extension);
  }

  /// 미디어 파일 전체화면
  void _showMediaFile(String fileName) {
    final fileInfo = _fileList.firstWhere(
      (file) => file.fileName == fileName,
      orElse: () => throw Exception('파일을 찾을 수 없습니다'),
    );

    final mediaFileInfo = MediaFileInfo(
      name: fileInfo.fileName,
      path: fileInfo.filePath,
      size: fileInfo.fileSize,
      type: _getMediaTypeFromExtension(fileName),
      lastModified: DateTime.tryParse(fileInfo.uploadDate) ?? DateTime.now(),
      serverSn: 0,
    );

    if (_isImageFile(fileName)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImageViewScreen(imageFile: mediaFileInfo),
        ),
      );
    }
    else if (_isVideoFile(fileName)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(videoFile: mediaFileInfo),
        ),
      );
    }
    else {
      _showMessage('이 파일 형식은 미리보기를 지원하지 않습니다: $fileName');
    }
  }

  /// 이미지 파일인지 확인
  bool _isImageFile(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  /// 비디오 파일인지 확인
  bool _isVideoFile(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'].contains(extension);
  }

  /// 파일 확장자에 따른 MediaType을 반환
  MediaType _getMediaTypeFromExtension(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return MediaType.image;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
      case 'flv':
      case 'webm':
        return MediaType.video;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'ogg':
      case 'm4a':
        return MediaType.audio;
      default:
        return MediaType.unknown;
    }
  }

  /// 파일 확장자에 따른 아이콘을 반환
  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
      case 'flv':
      case 'webm':
        return Icons.videocam;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'ogg':
      case 'm4a':
        return Icons.audiotrack;
      case 'txt':
        return Icons.text_snippet;
      case 'json':
        return Icons.data_object;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// 파일 확장자에 따른 아이콘 배경색을 반환
  Color _getFileIconColor(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return EgovColor.point50;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
      case 'flv':
      case 'webm':
        return EgovColor.secondary50;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'ogg':
      case 'm4a':
        return EgovColor.warning50;
      case 'txt':
        return EgovColor.success50;
      case 'json':
        return EgovColor.information50;
      case 'pdf':
        return EgovColor.danger50;
      default:
        return EgovColor.gray50;
    }
  }

  /// 파일을 삭제
  Future<void> _deleteFile(String fileName) async {
    final confirmed = await _showConfirmDialog(
      '파일 삭제',
      '$fileName 파일을 삭제하시겠습니까?',
    );

    if (confirmed) {
      try {
        final fileInfo = _fileList.firstWhere(
          (file) => file.fileName == fileName,
          orElse: () => throw Exception('파일을 찾을 수 없습니다'),
        );
        
        final file = File(fileInfo.filePath);
        print('개별 파일 삭제 시도: ${fileInfo.filePath}');
        
        if (await file.exists()) {
          print('파일 존재 확인됨, 삭제 시도 중...');
          await file.delete();
          print('파일 삭제 성공: ${fileInfo.filePath}');
          _showMessage('파일이 삭제되었습니다: $fileName');
          
          setState(() {
            _selectedFiles.remove(fileName);
          });
          
          await _refreshFileList();
        } else {
          print('파일이 존재하지 않음: ${fileInfo.filePath}');
          _showMessage('파일이 존재하지 않습니다: $fileName');
        }
      } catch (e) {
        _showMessage('파일 삭제 오류: $e');
      }
    }
  }

  /// 파일 내용
  void _showFileContentDialog(String fileName, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          fileName,
          style: const TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: EgovColor.gray5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EgovColor.gray20),
              ),
              child: Text(
                content,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        actions: [
          CustomButton(
            text: '닫기',
            onTap: () => Navigator.of(context).pop(),
            normalColor: EgovColor.gray30,
            pressedColor: EgovColor.gray50,
          ),
        ],
      ),
    );
  }

  /// 메시지
  Future<void> _showMessage(String message) async {
    await showStatusDialog(
      context,
      variant: StatusVariant.success,
      title: '알림',
      message: message,
    );
  }

  /// 확인 다이얼로그
  Future<bool> _showConfirmDialog(String title, String content) async {
    final result = await showPromptDialog(
      context,
      title: title,
      message: content,
      confirmText: '확인',
      cancelText: '취소',
    );
    return result ?? false;
  }

  /// 파일 선택 토글
  void _toggleFileSelection(String fileName) {
    setState(() {
      if (_selectedFiles.contains(fileName)) {
        _selectedFiles.remove(fileName);
      } else {
        _selectedFiles.add(fileName);
      }
    });
  }

  /// 파일 업로드
  Future<void> _uploadFile() async {
    if (_selectedFiles.isEmpty) {
      _showMessage('업로드할 파일을 선택해주세요.');
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = '선택된 파일들을 서버로 업로드하는 중... (${_selectedFiles.length}개)';
    });

    try {
      // 선택된 파일들을 File 리스트로 변환
      List<File> filesToUpload = [];
      for (String fileName in _selectedFiles) {
        try {
          final fileInfo = _fileList.firstWhere((f) => f.fileName == fileName);
          final file = File(fileInfo.filePath);
          if (await file.exists()) {
            filesToUpload.add(file);
          }
        } catch (e) {
          print('파일 찾기 실패: $fileName, $e');
        }
      }

      if (filesToUpload.isEmpty) {
        _showMessage('업로드할 유효한 파일이 없습니다.');
        return;
      }

      await ServerConnectionUtils.checkConnectionAndExecuteIfConnected(
        context: context,
        operation: () async {
          // 일괄 업로드 API 호출
          final result =
              await _fileRepository.uploadFile(uuid: _deviceUuid, files: filesToUpload);

          int successCount = 0;
          int failCount = 0;

          if (result['success'] == true) {
            // 다중 파일 업로드 응답 형식 (fileResults 존재)
            if (result['fileResults'] is List) {
              final totalFiles = (result['totalFiles'] ?? filesToUpload.length) as int;
              final fileResults = result['fileResults'] as List<dynamic>;
              successCount =
                  fileResults.where((r) => r['insertSuccess'] == true).length;
              failCount = totalFiles - successCount;
            } else {
              // 단일 파일 업로드 응답 형식 (fileResults / totalFiles 없음)
              successCount = filesToUpload.length;
              failCount = 0;
            }
          } else {
            // API 자체가 실패한 경우
            failCount = filesToUpload.length;
          }

          setState(() {
            _statusMessage = '업로드 완료: 성공 $successCount개, 실패 $failCount개';
            _selectedFiles.clear();
          });

          if (result['success'] == true && successCount > 0) {
            _showMessage(
              '업로드 완료: 성공 $successCount개${failCount > 0 ? ', 실패 $failCount개' : ''}',
            );
            await _refreshFileList();
          } else {
            final errorMessage =
                result['message'] ?? result['resultMessage'] ?? '알 수 없는 오류';
            _showMessage('업로드 실패: $errorMessage');
          }
        },
        errorTitle: '서버 연결 오류',
        errorMessage: '서버에 연결할 수 없습니다. 파일 업로드를 다시 시도해주세요.',
      );
    } catch (e) {
      _showMessage('업로드 중 오류가 발생했습니다: $e');
      print('파일 업로드 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 선택한 로컬 파일들을 삭제
  Future<void> _deleteSelectedFiles() async {
    if (_selectedFiles.isEmpty) {
      _showMessage('삭제할 파일을 선택해주세요.');
      return;
    }

    final confirmed = await _showConfirmDialog(
      '파일 삭제',
      '선택한 ${_selectedFiles.length}개 파일을 삭제하시겠습니까?',
    );

    if (confirmed) {
      setState(() {
        _isLoading = true;
        _statusMessage = '선택된 파일들을 삭제하는 중... (${_selectedFiles.length}개)';
      });

      try {
        int successCount = 0;
        int failCount = 0;
        List<String> failedFiles = [];

        for (String fileName in _selectedFiles) {
          try {
            final fileInfo = _fileList.firstWhere(
              (file) => file.fileName == fileName,
              orElse: () => throw Exception('파일을 찾을 수 없습니다: $fileName'),
            );
            
            final file = File(fileInfo.filePath);
            print('파일 삭제 시도: ${fileInfo.filePath}');
            
            if (await file.exists()) {
              print('파일 존재 확인됨, 삭제 시도 중...');
              await file.delete();
              print('파일 삭제 성공: ${fileInfo.filePath}');
              successCount++;
            } else {
              print('파일이 존재하지 않음: ${fileInfo.filePath}');
              failCount++;
              failedFiles.add(fileName);
            }
          } catch (e) {
            failCount++;
            failedFiles.add(fileName);
            print('파일 삭제 오류 ($fileName): $e');
          }
        }

        setState(() {
          _statusMessage = '삭제 완료: 성공 ${successCount}개, 실패 ${failCount}개';
          _selectedFiles.clear(); // 삭제 후 선택 해제
        });

        if (failCount == 0) {
          _showMessage('모든 파일이 성공적으로 삭제되었습니다.');
        } else {
          _showMessage('삭제 완료: 성공 ${successCount}개, 실패 ${failCount}개\n실패한 파일: ${failedFiles.join(', ')}');
        }

        // 삭제 후 파일 목록 새로고침
        await _refreshFileList();
      } catch (e) {
        setState(() {
          _statusMessage = '파일 삭제 실패: $e';
        });
        _showMessage('파일 삭제 실패: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToServerList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FileReadWriteListPage(),
      ),
    );
  }

  /// 로컬 파일 목록을 빌드
  Widget _buildLocalFileList() {
    if (_fileList.isEmpty) {
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
              '저장된 파일이 없습니다.',
              style: EgovText.bodyLarge.copyWith(
                color: EgovColor.gray60,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: _fileList.length,
      itemBuilder: (context, index) {
        final fileInfo = _fileList[index];
        final isSelected = _selectedFiles.contains(fileInfo.fileName);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            elevation: 2,
            color: isSelected ? EgovColor.primary10 : EgovColor.white100,
            child: ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: _getFileIconColor(fileInfo.fileName),
                    child: Icon(
                      _getFileIcon(fileInfo.fileName),
                      color: EgovColor.white100,
                      size: 20,
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: EgovColor.primary50,
                          shape: BoxShape.circle,
                          border: Border.all(color: EgovColor.white100, width: 1),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: EgovColor.white100,
                          size: 10,
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(
                fileInfo.fileName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? EgovColor.primary70 : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('크기: ${fileInfo.formattedSize}'),
                  Text(
                    '수정일: ${fileInfo.formattedDate}',
                    style: TextStyle(
                      color: EgovColor.gray60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _readFile(fileInfo.fileName),
                    icon: Icon(_isMediaFile(fileInfo.fileName) ? Icons.play_circle_outline : Icons.visibility),
                    color: _isMediaFile(fileInfo.fileName) ? EgovColor.information50 : EgovColor.success50,
                    iconSize: 20,
                    tooltip: _isMediaFile(fileInfo.fileName) ? '미리보기' : '읽기',
                  ),
                  IconButton(
                    onPressed: () => _deleteFile(fileInfo.fileName),
                    icon: const Icon(Icons.delete_outline),
                    color: EgovColor.danger50,
                    iconSize: 20,
                    tooltip: '삭제',
                  ),
                ],
              ),
              onTap: () => _toggleFileSelection(fileInfo.fileName),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        title: 'FileReaderWriter API',
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
                const FileReadWriteFunctionPage(),
                // 주요기능 탭
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // 상단 버튼들
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    text: '파일 생성',
                                    onTap: _isLoading ? null : _showCreateFileDialog,
                                    isLoading: _isLoading,
                                    icon: const Icon(Icons.save),
                                    normalColor: EgovColor.primary50,
                                    pressedColor: EgovColor.primary70,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ServerConnectionButtonFactory.listButton(
                                    text: '서버 파일 목록',
                                    onServerConnected: () async => _navigateToServerList(),
                                    errorTitle: '서버 연결 오류',
                                    errorMessage: '서버에 연결할 수 없습니다. 웹서버가 실행중인지 확인해주세요.',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
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
                                              '로컬 파일 목록 (${_fileList.length})',
                                              style: EgovText.title.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: EgovColor.primary50,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: _isLoading ? null : _refreshFileList,
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
                                        child: _buildLocalFileList(),
                                      ),
                                    ],
                                  ),
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
                // 로컬 파일 목록에서 업로드
                ServerConnectionButtonFactory.uploadButton(
                  text: _selectedFiles.isEmpty ? '업로드' : '업로드 (${_selectedFiles.length}개)',
                  onServerConnected: () async => _uploadFile(),
                  errorTitle: '서버 연결 오류',
                  errorMessage: '서버에 연결할 수 없습니다. 웹서버가 실행중인지 확인해주세요.',
                ),
                // 로컬 파일 삭제
                CustomButton(
                  text: _selectedFiles.isEmpty ? '삭제' : '삭제 (${_selectedFiles.length}개)',
                  onTap: _isLoading ? null : _deleteSelectedFiles,
                  isLoading: _isLoading,
                  icon: const Icon(Icons.delete),
                  normalColor: _selectedFiles.isEmpty ? EgovColor.danger50 : EgovColor.danger70,
                  pressedColor: (_selectedFiles.isEmpty ? EgovColor.danger50 : EgovColor.danger70).withValues(alpha: 0.7),
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
