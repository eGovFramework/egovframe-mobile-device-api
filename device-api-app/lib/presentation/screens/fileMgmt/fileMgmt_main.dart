import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/datasources/file_management_service.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:flutter/material.dart';

import 'fileMgmt_description.dart';

/// eGovFrame 디바이스 파일관리 화면
class FileManagementScreen extends StatefulWidget {
  const FileManagementScreen({super.key});

  @override
  State<FileManagementScreen> createState() => _FileManagementScreenState();
}

class _FileManagementScreenState extends State<FileManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FileManagementService _fileService = FileManagementService();
  
  String _currentPath = '';
  List<FileSystemEntity> _currentContents = [];
  final List<String> _pathHistory = [];
  final Set<String> _selectedItems = {};
  bool _isLoading = false;
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
    _initializeFileSystem();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 파일 시스템 초기화
  Future<void> _initializeFileSystem() async {
    setState(() => _isLoading = true);
    
    try {
      // 권한 요청 (iOS에서는 항상 true 반환)
      final hasPermission = await _fileService.requestPermissions();
      if (!hasPermission) {
        if (mounted) {
          _showPermissionDialog();
        }
        return;
      }
      
      // 문서 디렉토리 경로 가져오기
      try {
        _currentPath = await _fileService.getApplicationDocumentsPath();
        AppLogger.d('초기화된 경로: $_currentPath');
      } catch (e, stackTrace) {
        if (mounted) {
          await ErrorHandler.handleException(
            context,
            e,
            stackTrace: stackTrace,
            logContext: 'FileMgmtPage._initializeFileSystem.documentsPath',
            title: '문서 폴더 접근 실패',
          );
        }
        return;
      }
      
      // 디렉토리 내용 로드
      await _loadDirectoryContents();
      
      // iOS에서 초기 샘플 파일 생성 (테스트용)
      if (Platform.isIOS && _currentContents.isEmpty) {
        try {
          await _fileService.createSampleFile(
            _currentPath, 
            'welcome.txt', 
            'eGovFrame 파일관리 기능에 오신 것을 환영합니다!\n\n이 파일은 iOS에서 파일관리 기능이 정상 작동하는지 확인하기 위한 샘플 파일입니다.'
          );
          await _loadDirectoryContents();
        } catch (e, stackTrace) {
          ErrorHandler.logError(e, stackTrace, context: 'FileMgmtPage._initializeFileSystem.sampleFile');
        }
      }
      
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FileMgmtPage._initializeFileSystem',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 디렉토리 내용 로드
  Future<void> _loadDirectoryContents() async {
    try {
      setState(() => _isLoading = true);
      final contents = await _fileService.listDirectoryContents(_currentPath);
      setState(() {
        _currentContents = contents;
        _selectedItems.clear();
        _isSelectionMode = false;
      });
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FileMgmtPage._loadDirectoryContents',
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 디렉토리 이동
  Future<void> _navigateToDirectory(String path) async {
    _pathHistory.add(_currentPath);
    _currentPath = path;
    await _loadDirectoryContents();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        title: _isSelectionMode ? '${_selectedItems.length}개 선택됨' : 'File Management API',
        leading: _pathHistory.isNotEmpty && !_isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
                onPressed: _navigateBack,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.close, color: EgovColor.white100),
              onPressed: () {
                setState(() {
                  _isSelectionMode = false;
                  _selectedItems.clear();
                });
              },
            )
          else if (_tabController.index == 1)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: EgovColor.white100),
              onSelected: _handleMenuAction,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'new_folder',
                  child: Row(
                    children: [
                      Icon(Icons.create_new_folder, color: EgovColor.primary50),
                      const SizedBox(width: 8),
                      Text('새 폴더', style: EgovText.regular),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'create_sample',
                  child: Row(
                    children: [
                      Icon(Icons.note_add, color: EgovColor.primary50),
                      const SizedBox(width: 8),
                      Text('샘플 파일 생성', style: EgovText.regular),
                    ],
                  ),
                ),
              ],
            ),
        ],
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
                const FileFunctionPage(),
                // 주요기능 탭
                _buildMainFunctionTab(),
                // 라이선스 탭
                const License(),
              ],
            ),
          ),
          // 주요기능 탭에서만 버튼 표시
          if (_tabController.index == 1)
            _isSelectionMode && _selectedItems.isNotEmpty
                ? BottomButtonRow(
                    buttons: [
                      CustomButton(
                        text: '복사',
                        icon: const Icon(Icons.copy, size: 18),
                        normalColor: EgovColor.information50,
                        onTap: _copySelectedItems,
                      ),
                      CustomButton(
                        text: '이동',
                        icon: const Icon(Icons.drive_file_move, size: 18),
                        normalColor: EgovColor.warning40,
                        onTap: _moveSelectedItems,
                      ),
                      CustomButton(
                        text: '삭제',
                        icon: const Icon(Icons.delete, size: 18),
                        normalColor: EgovColor.danger50,
                        onTap: _deleteSelectedItems,
                      ),
                    ],
                  )
                : const SizedBox.shrink()
          else
            const SizedBox.shrink(), // 빈 공간으로 처리
          const Footer(),
        ],
      ),
    );
  }

  Widget _buildMainFunctionTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InfoBox(
                    text: '파일과 폴더를 관리할 수 있습니다. 길게 눌러서 복사, 이동, 삭제 작업을 수행하세요.',
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  // 파일 목록
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: EgovColor.gray20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildFileList(),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildFileList() {
    if (_currentContents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 48, color: EgovColor.gray40),
            const SizedBox(height: 8),
            Text(
              '빈 폴더입니다',
              style: EgovText.regular.copyWith(color: EgovColor.gray40),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: _currentContents.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: EgovColor.gray10,
      ),
      itemBuilder: (context, index) {
        final entity = _currentContents[index];
        final isDirectory = entity is Directory;
        final name = entity.path.split('/').last;
        final isSelected = _selectedItems.contains(entity.path);
        
        return Container(
          decoration: BoxDecoration(
            color: isSelected ? EgovColor.primary5 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: _isSelectionMode
                ? Checkbox(
                    value: isSelected,
                    activeColor: EgovColor.primary50,
                    onChanged: (selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedItems.add(entity.path);
                        } else {
                          _selectedItems.remove(entity.path);
                        }
                      });
                    },
                  )
                : Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDirectory ? EgovColor.primary10 : EgovColor.gray10,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      isDirectory ? Icons.folder : _fileService.getFileIcon(name),
                      color: isDirectory ? EgovColor.primary50 : EgovColor.gray60,
                      size: 20,
                    ),
                  ),
            title: Text(
              name,
              style: EgovText.medium.copyWith(
                fontWeight: isDirectory ? FontWeight.w600 : FontWeight.w500,
                color: EgovColor.gray90,
              ),
            ),
            subtitle: FutureBuilder<Map<String, dynamic>>(
              future: _fileService.getFileInfo(entity.path),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                
                final info = snapshot.data!;
                String subtitleText;
                if (isDirectory) {
                  subtitleText = '${info['itemCount']}개 항목';
                } else {
                  subtitleText = info['sizeFormatted'] ?? '';
                }
                
                return Text(
                  subtitleText,
                  style: EgovText.caption,
                );
              },
            ),
            trailing: isSelected 
                ? Icon(Icons.check_circle, color: EgovColor.primary50)
                : null,
            onTap: () {
              if (_isSelectionMode) {
                setState(() {
                  if (isSelected) {
                    _selectedItems.remove(entity.path);
                  } else {
                    _selectedItems.add(entity.path);
                  }
                });
              } else if (isDirectory) {
                _navigateToDirectory(entity.path);
              }
            },
            onLongPress: () {
              setState(() {
                _isSelectionMode = true;
                _selectedItems.add(entity.path);
              });
            },
          ),
        );
      },
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'new_folder':
        _showCreateDirectoryDialog();
        break;
      case 'create_sample':
        _showCreateSampleFileDialog();
        break;
    }
  }

  void _showCreateDirectoryDialog() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: EgovColor.white100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          '새 폴더 생성',
          style: EgovText.title,
        ),
        content: TextField(
          controller: controller,
          style: EgovText.regular,
          decoration: InputDecoration(
            labelText: '폴더 이름',
            labelStyle: EgovText.caption,
            hintText: '새 폴더',
            hintStyle: EgovText.caption,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: EgovColor.gray20),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: EgovColor.primary50, width: 2),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: EgovText.regular.copyWith(color: EgovColor.gray60),
            ),
          ),
          CustomButton(
            text: '생성',
            width: 80,
            height: 40,
            onTap: () async {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context);
                await _createDirectory(controller.text.trim());
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createDirectory(String name) async {
    try {
      setState(() => _isLoading = true);
      await _fileService.createDirectory(_currentPath, name);
      if (mounted) {
        showStatusDialog(
          context,
          variant: StatusVariant.success,
          title: '성공',
          message: '폴더가 생성되었습니다: $name',
        );
      }
      await _loadDirectoryContents();
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FileMgmtPage._createFolder',
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showCreateSampleFileDialog() {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('샘플 파일 생성'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '파일 이름',
                hintText: 'sample.txt',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final fileName = nameController.text.trim();
              if (fileName.isNotEmpty) {
                Navigator.pop(context);
                await _createSampleFile(fileName);
              }
            },
            child: const Text('생성'),
          ),
        ],
      ),
    );
  }

  Future<void> _createSampleFile(String fileName) async {
    try {
      setState(() => _isLoading = true);
      
      String content;
      if (fileName.endsWith('.txt')) {
        content = '이것은 샘플 텍스트 파일입니다.\n생성 시간: ${DateTime.now()}\n\neGovFrame 디바이스 파일관리 기능 테스트';
      } else if (fileName.endsWith('.json')) {
        content = '{\n  "title": "샘플 JSON 파일",\n  "created": "${DateTime.now().toIso8601String()}",\n  "description": "eGovFrame 파일관리 테스트"\n}';
      } else if (fileName.endsWith('.md')) {
        content = '# 샘플 마크다운 파일\n\n생성 시간: ${DateTime.now()}\n\n## eGovFrame 디바이스 파일관리\n\n- 폴더 생성\n- 파일 생성\n- 복사/이동/삭제';
      } else {
        content = 'eGovFrame 디바이스 파일관리 샘플 파일\n생성 시간: ${DateTime.now()}';
      }
      
      await _fileService.createSampleFile(_currentPath, fileName, content);
      
      if (mounted) {
        showStatusDialog(
          context,
          variant: StatusVariant.success,
          title: '성공',
          message: '샘플 파일이 생성되었습니다: $fileName',
        );
      }
      await _loadDirectoryContents();
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FileMgmtPage._createSampleFile',
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateBack() async {
    if (_pathHistory.isNotEmpty) {
      _currentPath = _pathHistory.removeLast();
      await _loadDirectoryContents();
    }
  }

  Future<void> _deleteSelectedItems() async {
    if (_selectedItems.isEmpty) return;
    
    final confirmed = await _showConfirmDialog(
      '선택한 ${_selectedItems.length}개 항목을 삭제하시겠습니까?',
      '삭제된 항목은 복구할 수 없습니다.',
    );
    
    if (!confirmed) return;
    
    try {
      setState(() => _isLoading = true);
      
      for (final path in _selectedItems) {
        await _fileService.deleteFileOrDirectory(path);
      }
      
      if (mounted) {
        showStatusDialog(
          context,
          variant: StatusVariant.success,
          title: '성공',
          message: '${_selectedItems.length}개 항목이 삭제되었습니다.',
        );
      }
      await _loadDirectoryContents();
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FileMgmtPage._deleteSelected',
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _copySelectedItems() async {
    if (_selectedItems.isEmpty) return;
    
    final destinationPath = await _showFolderSelectionDialog('복사할 폴더를 선택하세요');
    if (destinationPath == null) return;
    
    try {
      setState(() => _isLoading = true);
      
      for (final sourcePath in _selectedItems) {
        final sourceParentPath = sourcePath.substring(0, sourcePath.lastIndexOf('/'));
        
        if (sourceParentPath == destinationPath) {
          // 같은 디렉토리 내에서 복사하는 경우 - 복사본으로 생성
          await _copyWithNewName(sourcePath);
        } else {
          // 다른 디렉토리로 복사하는 경우
          await _fileService.copyFileOrDirectory(sourcePath, destinationPath);
        }
      }
      
      if (mounted) {
        showStatusDialog(
          context,
          variant: StatusVariant.success,
          title: '성공',
          message: '${_selectedItems.length}개 항목이 복사되었습니다.',
        );
      }
      await _loadDirectoryContents();
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FileMgmtPage._copySelected',
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 선택된 파일/디렉토리 이동
  Future<void> _moveSelectedItems() async {
    if (_selectedItems.isEmpty) return;
    
    final destinationPath = await _showFolderSelectionDialog('이동할 폴더를 선택하세요');
    if (destinationPath == null) return;
    
    try {
      setState(() => _isLoading = true);
      
      for (final sourcePath in _selectedItems) {
        final sourceParentPath = sourcePath.substring(0, sourcePath.lastIndexOf('/'));
        
        if (sourceParentPath == destinationPath) {
          // 같은 디렉토리 내에서 이동하는 경우 - 이름 변경
          await _renameItem(sourcePath);
        } else {
          // 다른 디렉토리로 이동하는 경우
          await _fileService.moveFileOrDirectory(sourcePath, destinationPath);
        }
      }
      
      if (mounted) {
        showStatusDialog(
          context,
          variant: StatusVariant.success,
          title: '성공',
          message: '${_selectedItems.length}개 항목이 이동되었습니다.',
        );
      }
      await _loadDirectoryContents();
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FileMgmtPage._moveSelected',
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

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

  void _showPermissionDialog() {
    showPromptDialog(
      context,
      title: '파일 접근 권한 필요',
      message: '파일 관리 기능을 사용하려면 다음 권한이 필요합니다:\n\n• 저장소 접근 권한\n• 모든 파일 관리 권한 (Android 11+)\n\n설정 > 앱 > egovframe_mobile_deviceapi_app > 권한에서 "모든 파일 관리" 권한을 허용해주세요.',
      confirmText: '설정 열기',
      cancelText: '취소',
      onConfirm: () async {
        await _fileService.openPermissionSettings();
        await Future.delayed(const Duration(seconds: 1));
        _initializeFileSystem();
      },
    );
  }

  /// 같은 디렉토리 내에서 복사할 때 새 이름으로 복사
  Future<void> _copyWithNewName(String sourcePath) async {
    final sourceName = sourcePath.split('/').last;
    final extension = sourceName.contains('.') ? '.${sourceName.split('.').last}' : '';
    final nameWithoutExt = sourceName.contains('.') 
        ? sourceName.substring(0, sourceName.lastIndexOf('.'))
        : sourceName;
    
    String newName = '${nameWithoutExt}_복사본$extension';
    int counter = 1;
    
    // 중복되지 않는 이름 찾기
    while (await _fileExists('$_currentPath/$newName')) {
      newName = '${nameWithoutExt}_복사본$counter$extension';
      counter++;
    }
    
    final newPath = '$_currentPath/$newName';
    
    // 직접 새 이름으로 복사
    if (await FileSystemEntity.isFile(sourcePath)) {
      final sourceFile = File(sourcePath);
      await sourceFile.copy(newPath);
    } else if (await FileSystemEntity.isDirectory(sourcePath)) {
      await _copyDirectoryWithNewName(sourcePath, newPath);
    }
  }
  
  /// 디렉토리를 새 이름으로 복사
  Future<void> _copyDirectoryWithNewName(String sourcePath, String destinationPath) async {
    final sourceDirectory = Directory(sourcePath);
    final destinationDirectory = Directory(destinationPath);
    
    await destinationDirectory.create(recursive: true);
    
    await for (final entity in sourceDirectory.list()) {
      final entityName = entity.path.split('/').last;
      final newEntityPath = '$destinationPath/$entityName';
      
      if (entity is File) {
        await entity.copy(newEntityPath);
      } else if (entity is Directory) {
        await _copyDirectoryWithNewName(entity.path, newEntityPath);
      }
    }
  }

  /// 이름 변경 (이동 시 같은 디렉토리 내에서)
  Future<void> _renameItem(String sourcePath) async {
    final sourceName = sourcePath.split('/').last;
    final controller = TextEditingController(text: sourceName);
    
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이름 변경'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '새 이름',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty && controller.text.trim() != sourceName) {
                Navigator.pop(context, controller.text.trim());
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('변경'),
          ),
        ],
      ),
    );
    
    if (newName != null && newName != sourceName) {
      final newPath = '$_currentPath/$newName';
      
      if (await FileSystemEntity.isFile(sourcePath)) {
        await File(sourcePath).rename(newPath);
      } else if (await FileSystemEntity.isDirectory(sourcePath)) {
        await Directory(sourcePath).rename(newPath);
      }
    }
  }

  /// 파일/디렉토리 존재 여부 확인
  Future<bool> _fileExists(String path) async {
    return await FileSystemEntity.isFile(path) || await FileSystemEntity.isDirectory(path);
  }

  /// 폴더 선택 다이얼로그 표시
  Future<String?> _showFolderSelectionDialog(String title) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => FolderSelectionDialog(
        title: title,
        initialPath: _currentPath,
        fileService: _fileService,
      ),
    );
  }
}

/// 폴더 선택 다이얼로그 위젯
class FolderSelectionDialog extends StatefulWidget {
  final String title;
  final String initialPath;
  final FileManagementService fileService;

  const FolderSelectionDialog({
    super.key,
    required this.title,
    required this.initialPath,
    required this.fileService,
  });

  @override
  State<FolderSelectionDialog> createState() => _FolderSelectionDialogState();
}

class _FolderSelectionDialogState extends State<FolderSelectionDialog> {
  String _currentPath = '';
  List<Directory> _directories = [];
  final List<String> _pathHistory = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentPath = widget.initialPath;
    _loadDirectories();
  }

  /// 디렉토리 목록 로드
  Future<void> _loadDirectories() async {
    setState(() => _isLoading = true);
    
    try {
      final contents = await widget.fileService.listDirectoryContents(_currentPath);
      final directories = contents.whereType<Directory>().toList();
      
      setState(() {
        _directories = directories;
      });
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FolderSelectionDialog._loadDirectories',
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 디렉토리 이동
  Future<void> _navigateToDirectory(String path) async {
    _pathHistory.add(_currentPath);
    _currentPath = path;
    await _loadDirectories();
  }

  /// 뒤로 가기
  Future<void> _navigateBack() async {
    if (_pathHistory.isNotEmpty) {
      _currentPath = _pathHistory.removeLast();
      await _loadDirectories();
    }
  }

  /// 루트 디렉토리로 이동
  Future<void> _navigateToRoot() async {
    try {
      final rootPath = await widget.fileService.getApplicationDocumentsPath();
      _pathHistory.clear();
      _currentPath = rootPath;
      await _loadDirectories();
    } catch (e, stackTrace) {
      if (mounted) {
        await ErrorHandler.handleException(
          context,
          e,
          stackTrace: stackTrace,
          logContext: 'FolderSelectionDialog._navigateToRoot',
        );
      }
    }
  }

  /// 새 폴더 생성
  Future<void> _createNewFolder() async {
    final controller = TextEditingController();
    
    final folderName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 폴더 생성'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '폴더 이름',
            hintText: '새 폴더',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('생성'),
          ),
        ],
      ),
    );

    if (folderName != null) {
      try {
        setState(() => _isLoading = true);
        await widget.fileService.createDirectory(_currentPath, folderName);
        await _loadDirectories();
        
        if (mounted) {
          showStatusDialog(
            context,
            variant: StatusVariant.success,
            title: '성공',
            message: '폴더가 생성되었습니다: $folderName',
          );
        }
      } catch (e, stackTrace) {
        if (mounted) {
          await ErrorHandler.handleException(
            context,
            e,
            stackTrace: stackTrace,
            logContext: 'FolderSelectionDialog._createNewFolder',
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: EgovColor.white100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: EgovText.title,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: EgovColor.gray60),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 네비게이션 바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: EgovColor.gray5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EgovColor.gray20),
              ),
              child: Row(
                children: [
                  // 뒤로 가기 버튼
                  IconButton(
                    onPressed: _pathHistory.isNotEmpty ? _navigateBack : null,
                    icon: Icon(
                      Icons.arrow_back,
                      color: _pathHistory.isNotEmpty ? EgovColor.primary50 : EgovColor.gray40,
                    ),
                    iconSize: 20,
                  ),
                  
                  // 홈 버튼
                  IconButton(
                    onPressed: _navigateToRoot,
                    icon: Icon(Icons.home, color: EgovColor.primary50),
                    iconSize: 20,
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // 현재 경로 표시
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        _currentPath.replaceAll('/data/user/0/com.example.egovframe_mobile_deviceapi_app/app_flutter', '~/Documents'),
                        style: EgovText.caption,
                      ),
                    ),
                  ),
                  
                  // 새 폴더 생성 버튼
                  IconButton(
                    onPressed: _createNewFolder,
                    icon: Icon(Icons.create_new_folder, color: EgovColor.success50),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // 폴더 목록
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(EgovColor.primary50),
                      ),
                    )
                  : _directories.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder_open, size: 48, color: EgovColor.gray40),
                              const SizedBox(height: 8),
                              Text(
                                '폴더가 없습니다',
                                style: EgovText.regular.copyWith(color: EgovColor.gray40),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: _directories.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: EgovColor.gray10,
                          ),
                          itemBuilder: (context, index) {
                            final directory = _directories[index];
                            final name = directory.path.split('/').last;
                            
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: EgovColor.primary10,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.folder,
                                  color: EgovColor.primary50,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                name,
                                style: EgovText.medium,
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: EgovColor.gray40,
                              ),
                              onTap: () => _navigateToDirectory(directory.path),
                            );
                          },
                        ),
            ),
            
            Divider(color: EgovColor.gray20),
            
            // 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '취소',
                    style: EgovText.regular.copyWith(color: EgovColor.gray60),
                  ),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: '여기에 선택',
                  width: 120,
                  height: 40,
                  onTap: () => Navigator.pop(context, _currentPath),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
