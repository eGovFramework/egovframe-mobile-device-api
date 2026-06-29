import 'dart:async';
import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/data/datasources/media_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/injection_container.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/usecases/media_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/footer.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/infobox.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/license.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/tabbar.dart';
import 'package:egovframe_mobile_deviceapi_app/core/device_id_service.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import 'media_description.dart';
import 'media_list.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _subTabController;
  List<MediaFileInfo> _mediaFiles = [];
  bool _isLoading = false;
  String _deviceUuid = '';
  int _mediaSn = 1;

  bool _isSelectionMode = false;
  Set<String> _selectedFiles = <String>{};

  // Use Cases
  late final MediaUseCase _mediaUseCase;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _subTabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
      // 탭 변경 시 선택 모드 종료
      if (_isSelectionMode) {
        _exitSelectionMode();
      }
    });
    _subTabController.addListener(() {
      setState(() {});
      if (_isSelectionMode) {
        _exitSelectionMode();
      }
    });

    // Use Cases 초기화
    _mediaUseCase = getIt<MediaUseCase>();

    _initializeApp();
  }

  /// 앱 초기화
  Future<void> _initializeApp() async {
    await _getDeviceUUID();
    await _refreshLocalMediaList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subTabController.dispose();
    super.dispose();
  }

  /// 디바이스 UUID 생성
  Future<void> _getDeviceUUID() async {
    _deviceUuid = await DeviceIdService.getDeviceId();
    setState(() {});
  }

  /// 로컬 미디어 파일 목록 새로고침
  Future<void> _refreshLocalMediaList() async {
    if (_deviceUuid.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _mediaFiles = await _mediaUseCase.getLocalMediaFiles();
      setState(() {});
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _navigateToServerList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MediaListPage(),
      ),
    );

    // 서버 목록 화면에서 돌아오면 로컬 목록을 새로고침
    // (서버에서 다운로드한 파일이 로컬에 저장될 수 있음)
    if (mounted) {
      await _refreshLocalMediaList();
    }
  }

  /// 이미지를 선택
  Future<void> _selectImage(ImageSource source) async {
    try {
      if (Platform.isAndroid) {
        if (source == ImageSource.camera) {
          final permissionStatus =
              await PermissionManager.requestCameraPermission();
          if (permissionStatus != PermissionStatus.granted) {
            _showMessage(
              PermissionManager.getPermissionMessage(permissionStatus, '카메라'),
            );
            if (permissionStatus == PermissionStatus.permanentlyDenied) {
              await PermissionManager.showPermissionSettingsDialog(
                context,
                '카메라',
              );
            }
            return;
          }
        } else {
          // 저장소 권한 확인
          final permissionStatus =
              await PermissionManager.requestStoragePermission();
          if (permissionStatus == PermissionStatus.permanentlyDenied) {
            _showMessage(
              PermissionManager.getPermissionMessage(permissionStatus, '저장소'),
            );
              await PermissionManager.showPermissionSettingsDialog(
                context,
                '저장소',
              );
          }
        }
      }
      final XFile? imageFile = await MediaService.pickImage(source);
      if (imageFile == null) {
        if (Platform.isIOS && source == ImageSource.camera) {
          final status = await Permission.camera.status;
          if (status.isPermanentlyDenied) {
            await PermissionManager.showPermissionSettingsDialog(
              context,
              '카메라',
            );
            return;
          } else if (status.isDenied) {
            _showMessage('카메라 권한이 필요합니다. 설정에서 권한을 허용해주세요.');
            return;
          }
        }
        _showMessage('이미지 선택이 취소되었습니다.');
        return;
      }
      await _uploadSelectedImage(imageFile);
    } catch (e) {
      _showMessage('이미지 선택 오류: $e');
    }
  }

  /// 비디오를 선택
  Future<void> _selectVideo(ImageSource source) async {
    try {
      if (Platform.isAndroid) {
        if (source == ImageSource.camera) {
          final permissionStatus =
              await PermissionManager.requestCameraPermission();
          if (permissionStatus != PermissionStatus.granted) {
            _showMessage(
              PermissionManager.getPermissionMessage(permissionStatus, '카메라'),
            );
            if (permissionStatus == PermissionStatus.permanentlyDenied) {
              await PermissionManager.showPermissionSettingsDialog(
                context,
                '카메라',
              );
            }
            return;
          }
        } else {
          final permissionStatus =
              await PermissionManager.requestStoragePermission();
          if (permissionStatus == PermissionStatus.permanentlyDenied) {
            _showMessage(
              PermissionManager.getPermissionMessage(permissionStatus, '저장소'),
            );
              await PermissionManager.showPermissionSettingsDialog(
                context,
                '저장소',
              );
          }
        }
      }
      final XFile? videoFile = await MediaService.pickVideo(source);
      if (videoFile == null) {
        if (Platform.isIOS && source == ImageSource.camera) {
          final status = await Permission.camera.status;
          if (status.isPermanentlyDenied) {
            await PermissionManager.showPermissionSettingsDialog(
              context,
              '카메라',
            );
            return;
          } else if (status.isDenied) {
            _showMessage('카메라 권한이 필요합니다. 설정에서 권한을 허용해주세요.');
            return;
          }
        }
        _showMessage('비디오 선택이 취소되었습니다.');
        return;
      }
      await _uploadSelectedVideo(videoFile);
    } catch (e) {
      _showMessage('비디오 선택 오류: $e');
    }
  }

  /// 선택된 이미지를 로컬에 저장
  Future<void> _uploadSelectedImage(XFile imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = await MediaService.saveImageFile(imageFile, fileName);
      if (savedPath == null) {
        _showMessage('이미지 저장에 실패했습니다.');
        return;
      }

      _showMessage('이미지가 성공적으로 저장되었습니다.');
      // 로컬 목록 새로고침
      await _refreshLocalMediaList();
      setState(() {});
    } catch (e) {
      _showMessage('이미지 저장 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadSelectedVideo(XFile videoFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
      final savedPath = await MediaService.saveVideoFile(videoFile, fileName);
      if (savedPath == null) {
        _showMessage('비디오 저장에 실패했습니다.');
        return;
      }

      _showMessage('비디오가 성공적으로 저장되었습니다.');
      await _refreshLocalMediaList();
      setState(() {});
    } catch (e) {
      _showMessage('비디오 저장 오류: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 이미지를 선택하고 서버에 업로드
  /// 미디어 선택 모드
  void _startSelectionMode() {
    setState(() {
      _isSelectionMode = true;
      _selectedFiles.clear();
    });
  }

  /// 선택 모드를 종료
  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedFiles.clear();
    });
  }

  /// 파일 선택/해제를 토글
  void _toggleFileSelection(String filePath) {
    setState(() {
      if (_selectedFiles.contains(filePath)) {
        _selectedFiles.remove(filePath);
      } else {
        _selectedFiles.add(filePath);
      }

      if (_selectedFiles.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  /// 선택된 파일들을 삭제
  Future<void> _deleteSelectedFiles() async {
    if (_selectedFiles.isEmpty) return;

    final confirmed = await _showConfirmDialog(
      '선택된 파일 삭제',
      '선택된 ${_selectedFiles.length}개 파일을 삭제하시겠습니까?',
    );

    if (confirmed) {
      List<int> serverSnList = [];
      List<String> localFilePaths = [];

      print('=== 선택된 파일들 ===');
      for (String filePath in _selectedFiles) {
        print('선택된 파일: $filePath');

        MediaFileInfo? selectedFile;
        for (MediaFileInfo file in _mediaFiles) {
          if (file.path == filePath) {
            selectedFile = file;
            break;
          }
        }

        if (selectedFile != null) {
          if (selectedFile.serverSn != null && selectedFile.serverSn! > 0) {
            serverSnList.add(selectedFile.serverSn!);
            print('서버 파일 추가: SN=${selectedFile.serverSn}, 경로=$filePath');
          } else {
            localFilePaths.add(filePath);
            print('로컬 파일 추가: $filePath');
          }
        } else {
          localFilePaths.add(filePath);
          print('MediaFileInfo를 찾을 수 없음, 로컬 파일로 처리: $filePath');
        }
      }
      print('서버 파일 개수: ${serverSnList.length}');
      print('로컬 파일 개수: ${localFilePaths.length}');
      print('==================');

      int totalSuccessCount = 0;
      int totalFailCount = 0;

      // 서버 파일들 개별 삭제
      for (int sn in serverSnList) {
        try {
          print('서버 파일 삭제 시도: SN=$sn');
          final result = await MediaService.deleteMediaFromServer(sn, _deviceUuid);
          if (result['success'] == true) {
            totalSuccessCount++;
            print('서버 파일 삭제 성공: SN=$sn');

            // 서버 삭제 성공 후 해당하는 로컬 파일도 삭제
            for (String filePath in _selectedFiles) {
              final file = File(filePath);
              if (await file.exists()) {
                try {
                  await file.delete();
                  print('로컬 파일도 삭제됨: $filePath');
                } catch (e) {
                  print('로컬 파일 삭제 실패: $filePath, $e');
                }
              }
            }
          } else {
            totalFailCount++;
            print('서버 파일 삭제 실패: SN=$sn, ${result['message']}');
          }
        } catch (e) {
          totalFailCount++;
          print('서버 파일 삭제 오류: SN=$sn, $e');
        }
      }

      // 로컬 파일들 개별 삭제
      for (String filePath in localFilePaths) {
        try {
          print('로컬 파일 삭제 시도: $filePath');
          final success = await MediaService.deleteMediaFile(filePath);
          if (success) {
            totalSuccessCount++;
            print('로컬 파일 삭제 성공: $filePath');
          } else {
            totalFailCount++;
            print('로컬 파일 삭제 실패: $filePath');
          }
        } catch (e) {
          totalFailCount++;
          print('로컬 파일 삭제 오류: $e');
        }
      }

      _showMessage('삭제 완료: 성공 $totalSuccessCount개, 실패 $totalFailCount개');
      _exitSelectionMode();
      await _refreshLocalMediaList();
    }
  }

  /// 이미지를 전체 화면으로 열기
  void _showImageFullScreen(MediaFileInfo imageFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageViewScreen(imageFile: imageFile),
      ),
    );
  }

  //// 비디오 재생
  void _playVideo(MediaFileInfo videoFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoFile: videoFile),
      ),
    );
  }

  /// 미디어 선택 옵션
  final ImagePicker picker = ImagePicker();

  void _showMediaPickerOptions(String mediaType) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text('카메라에서 $mediaType'),
              onTap: () {
                Navigator.pop(context);
                if (mediaType == '이미지') {
                  _selectImage(ImageSource.camera);
                } else {
                  _selectVideo(ImageSource.camera);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text('갤러리에서 $mediaType'),
              onTap: () {
                Navigator.pop(context);
                if (mediaType == '이미지') {
                  _selectImage(ImageSource.gallery);
                } else {
                  _selectVideo(ImageSource.gallery);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMessage(String message) async {
    await showStatusDialog(
      context,
      variant: StatusVariant.success,
      title: '알림',
      message: message,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.white100,
      extendBodyBehindAppBar: false,
      appBar: CustomAppBar(
        title: _isSelectionMode ? '${_selectedFiles.length}개 선택됨' : '미디어 API',
        leading: IconButton(
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
                  _selectedFiles.clear();
                });
              },
            )
          else if (_tabController.index == 1)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: EgovColor.white100),
              onSelected: _handleMenuAction,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'pick_image',
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        color: EgovColor.primary50,
                      ),
                      const SizedBox(width: 8),
                      Text('이미지 선택', style: EgovText.regular),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'pick_video',
                  child: Row(
                    children: [
                      Icon(Icons.video_call, color: EgovColor.primary50),
                      const SizedBox(width: 8),
                      Text('비디오 선택', style: EgovText.regular),
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
                const MediaFunctionPage(),
                // 주요기능 탭
                _buildMainFunctionTab(),
                // 라이선스 탭
                const License(),
              ],
            ),
          ),
          if (_tabController.index == 1)
            _isSelectionMode && _selectedFiles.isNotEmpty
                ? BottomButtonRow(
                    buttons: [
                      CustomButton(
                        text: '삭제',
                        icon: const Icon(Icons.delete, size: 18),
                        normalColor: EgovColor.danger50,
                        onTap: _deleteSelectedFiles,
                      ),
                      CustomButton(
                        text: '업로드',
                        icon: const Icon(Icons.upload, size: 18),
                        normalColor: EgovColor.primary50,
                        onTap: _uploadSelectedFiles,
                      ),
                    ],
                  )
                : BottomButtonRow(
                    buttons: [
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

  /// 주요기능 탭
  Widget _buildMainFunctionTab() {
    return Column(
      children: [
        // 서브탭 바
        Container(
          color: EgovColor.white100,
          child: TabBar(
            controller: _subTabController,
            labelColor: EgovColor.primary50,
            unselectedLabelColor: EgovColor.gray40,
            indicatorColor: EgovColor.primary50,
            tabs: const [
              Tab(text: '이미지'),
              Tab(text: '비디오'),
            ],
          ),
        ),
        // 서브탭 내용
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            children: [
              _buildImageSubTab(),
              _buildVideoSubTab(),
            ],
          ),
        ),
      ],
    );
  }

  /// 이미지 서브탭
  Widget _buildImageSubTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InfoBox(text: '이미지를 선택하고 관리할 수 있습니다.'),
            const SizedBox(height: 16),

            // 이미지 목록
            _buildImageList(),
          ],
        ),
      ),
    );
  }

  /// 비디오 서브탭
  Widget _buildVideoSubTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InfoBox(text: '비디오를 선택하고 관리할 수 있습니다.'),
            const SizedBox(height: 16),

            // 비디오 목록
            _buildVideoList(),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'pick_image':
        _showMediaPickerOptions('이미지');
        break;
      case 'pick_video':
        _showMediaPickerOptions('비디오');
        break;
    }
  }

  /// 선택된 파일들을 서버에 일괄 업로드
  Future<void> _uploadSelectedFiles() async {
    if (_selectedFiles.isEmpty) return;

    final confirmed = await _showConfirmDialog(
      '선택된 파일 업로드',
      '선택된 ${_selectedFiles.length}개 파일을 서버에 업로드하시겠습니까?',
    );

    if (confirmed) {
      try {
        setState(() {
          _isLoading = true;
        });

        // 선택된 파일들을 File 리스트로 변환
        List<File> filesToUpload = [];
        for (String filePath in _selectedFiles) {
          final file = File(filePath);
          if (await file.exists()) {
            filesToUpload.add(file);
          }
        }

        if (filesToUpload.isEmpty) {
          _showMessage('업로드할 유효한 파일이 없습니다.');
          return;
        }

        // 업로드 API 호출 (단일/여러 파일 모두 지원)
        final result = await MediaService.uploadMediaToServer(
          files: filesToUpload,
          uuid: _deviceUuid,
          startSn: _mediaSn,
        );

        if (result['success'] == true) {
          // successCount가 없을 수 있으므로 안전하게 처리
          int successCount = 0;
          if (result['successCount'] != null) {
            if (result['successCount'] is int) {
              successCount = result['successCount'] as int;
            } else if (result['successCount'] is String) {
              successCount = int.tryParse(result['successCount'] as String) ?? 0;
            } else {
              successCount = (result['successCount'] as num?)?.toInt() ?? 0;
            }
          } else {
            // successCount가 없으면 fileSn이 있는지 확인 (단일 파일)
            if (result['fileSn'] != null) {
              successCount = 1;
            } else {
              // fileResults에서 성공한 개수 계산
              final fileResults = result['fileResults'] as List?;
              if (fileResults != null) {
                successCount = fileResults.where((r) => r['status'] == 'SUCCESS').length;
              }
            }
          }
          
          int failCount = 0;
          if (result['failCount'] != null) {
            if (result['failCount'] is int) {
              failCount = result['failCount'] as int;
            } else if (result['failCount'] is String) {
              failCount = int.tryParse(result['failCount'] as String) ?? 0;
            } else {
              failCount = (result['failCount'] as num?)?.toInt() ?? 0;
            }
          } else {
            // failCount가 없으면 fileResults에서 실패한 개수 계산
            final fileResults = result['fileResults'] as List?;
            if (fileResults != null) {
              failCount = fileResults.where((r) => r['status'] == 'FAIL').length;
            }
          }
          
          int totalFiles = filesToUpload.length;
          if (result['totalFiles'] != null) {
            if (result['totalFiles'] is int) {
              totalFiles = result['totalFiles'] as int;
            } else if (result['totalFiles'] is String) {
              totalFiles = int.tryParse(result['totalFiles'] as String) ?? filesToUpload.length;
            } else {
              totalFiles = (result['totalFiles'] as num?)?.toInt() ?? filesToUpload.length;
            }
          }
          
          String message = '업로드 완료: 성공 $successCount개';
          if (failCount > 0) {
            message += ', 실패 $failCount개';
          }
          
          // SN 업데이트 (성공한 파일 개수만큼 증가)
          _mediaSn += successCount;
          
          _showMessage(message);
        } else {
          final message = result['resultMessage'] ?? result['message'] ?? '업로드 실패';
          _showMessage(message);
        }

        _exitSelectionMode();
        await _refreshLocalMediaList();
      } catch (e) {
        _showMessage('업로드 중 오류가 발생했습니다: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// 이미지 목록을 구성
  Widget _buildImageList() {
    final imageFiles = _mediaFiles
        .where((file) => file.type == MediaType.image)
        .toList();

    final displayFiles = imageFiles;

    if (displayFiles.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.image, size: 64, color: EgovColor.gray30),
              const SizedBox(height: 16),
              Text(
                _isLoading ? '이미지 목록을 불러오는 중...' : '저장된 이미지가 없습니다.',
                style: EgovText.bodyLarge.copyWith(color: EgovColor.gray60),
              ),
              const SizedBox(height: 8),
              Text(
                _isLoading ? '잠시만 기다려주세요.' : '하단의 이미지 선택 버튼을 눌러 이미지를 추가해보세요.',
                style: EgovText.bodyMedium.copyWith(color: EgovColor.gray50),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.image, color: EgovColor.success50, size: 24),
                const SizedBox(width: 8),
                Text(
                  _isSelectionMode
                      ? '선택된 이미지 (${_selectedFiles.length}개)'
                      : '로컬 이미지 목록 (${displayFiles.length}개)',
                  style: EgovText.title.copyWith(
                    fontWeight: FontWeight.bold,
                    color: EgovColor.gray90,
                  ),
                ),
                const Spacer(),
                if (_isSelectionMode) ...[
                  IconButton(
                    onPressed: _selectedFiles.isNotEmpty
                        ? _deleteSelectedFiles
                        : null,
                    icon: const Icon(Icons.delete),
                    tooltip: '선택된 파일 삭제',
                    color: _selectedFiles.isNotEmpty ? EgovColor.danger50 : EgovColor.gray40,
                  ),
                  IconButton(
                    onPressed: _exitSelectionMode,
                    icon: const Icon(Icons.close),
                    tooltip: '선택 모드 종료',
                  ),
                ] else ...[
                  IconButton(
                    onPressed: _isLoading ? null : _refreshLocalMediaList,
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
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0, 
              ),
              itemCount: displayFiles.length,
              itemBuilder: (context, index) {
                final imageFile = displayFiles[index];
                return _buildImageCard(imageFile);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 비디오 목록을 구성
  Widget _buildVideoList() {
    final videoFiles = _mediaFiles
        .where((file) => file.type == MediaType.video)
        .toList();

    final displayFiles = videoFiles;

    if (displayFiles.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.videocam, size: 64, color: EgovColor.gray30),
              const SizedBox(height: 16),
              Text(
                _isLoading ? '비디오 목록을 불러오는 중...' : '저장된 비디오가 없습니다.',
                style: EgovText.bodyLarge.copyWith(color: EgovColor.gray60),
              ),
              const SizedBox(height: 8),
              Text(
                _isLoading ? '잠시만 기다려주세요.' : '하단의 비디오 선택 버튼을 눌러 비디오를 추가해보세요.',
                style: EgovText.bodyMedium.copyWith(color: EgovColor.gray50),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.videocam, color: EgovColor.danger50, size: 24),
                const SizedBox(width: 8),
                Text(
                  _isSelectionMode
                      ? '선택된 비디오 (${_selectedFiles.length}개)'
                      : '로컬 비디오 목록 (${displayFiles.length}개)',
                  style: EgovText.title.copyWith(
                    fontWeight: FontWeight.bold,
                    color: EgovColor.gray90,
                  ),
                ),
                const Spacer(),
                // 선택 모드일 때 삭제 버튼과 취소 버튼
                if (_isSelectionMode) ...[
                  IconButton(
                    onPressed: _selectedFiles.isNotEmpty
                        ? _deleteSelectedFiles
                        : null,
                    icon: const Icon(Icons.delete),
                    tooltip: '선택된 파일 삭제',
                    color: _selectedFiles.isNotEmpty ? EgovColor.danger50 : EgovColor.gray40,
                  ),
                  IconButton(
                    onPressed: _exitSelectionMode,
                    icon: const Icon(Icons.close),
                    tooltip: '선택 모드 종료',
                  ),
                ] else ...[
                  // 일반 모드일 때 새로고침 버튼
                  IconButton(
                    onPressed: _isLoading ? null : _refreshLocalMediaList,
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
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0, // 1:1 비율로 되돌림
              ),
              itemCount: displayFiles.length,
              itemBuilder: (context, index) {
                final videoFile = displayFiles[index];
                return _buildVideoCard(videoFile);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 이미지 목록을 구성
  Widget _buildImageCard(MediaFileInfo imageFile) {
    final isServerFile = imageFile.path.startsWith('server://');
    final serverSn = isServerFile
        ? int.tryParse(imageFile.path.replaceFirst('server://', ''))
        : null;
    final isSelected = _selectedFiles.contains(imageFile.path);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (_isSelectionMode) {
            _toggleFileSelection(imageFile.path);
          } else {
            if (isServerFile && serverSn != null) {
              final downloadUrl = MediaService.getMediaDownloadUrl(serverSn);
              _showMessage('서버 파일 다운로드: $downloadUrl');
            } else {
              _showImageFullScreen(imageFile);
            }
          }
        },
        onLongPress: () {
          if (!_isSelectionMode) {
            _startSelectionMode();
            _toggleFileSelection(imageFile.path);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.5,
              child: Container(
                decoration: BoxDecoration(color: EgovColor.gray10),
                child: Stack(
                  children: [
                    // 이미지 또는 서버 파일 표시
                    if (isServerFile)
                      Container(
                        color: EgovColor.primary5,
                        child: Icon(
                          Icons.cloud_done,
                          size: 32,
                          color: EgovColor.primary60,
                        ),
                      )
                    else
                      SizedBox.expand(
                        child: Image.file(
                          File(imageFile.path),
                          fit: BoxFit.cover,
                          cacheWidth: 200, // 메모리 사용량 최적화
                          cacheHeight: 200,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.broken_image,
                            size: 32,
                            color: EgovColor.gray30,
                          ),
                        ),
                      ),
                    if (isServerFile)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: EgovColor.primary60,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.cloud,
                            color: EgovColor.white100,
                            size: 12,
                          ),
                        ),
                      ),
                    if (_isSelectionMode)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected ? EgovColor.primary50 : EgovColor.white100,
                            border: Border.all(
                              color: isSelected ? EgovColor.primary50 : EgovColor.gray40,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: EgovColor.white100,
                                  size: 16,
                                )
                              : null,
                        ),
                      ),
                    if (_isSelectionMode && isSelected)
                      Container(color: EgovColor.primary50.withOpacity(0.3)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: EgovColor.white100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      imageFile.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            imageFile.typeString,
                            style: TextStyle(
                              color: EgovColor.gray60,
                              fontSize: 9,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isServerFile) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.cloud,
                            size: 10,
                            color: EgovColor.primary60,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 비디오 목록
  Widget _buildVideoCard(MediaFileInfo videoFile) {
    final isServerFile = videoFile.path.startsWith('server://');
    final serverSn = isServerFile
        ? int.tryParse(videoFile.path.replaceFirst('server://', ''))
        : null;
    final isSelected = _selectedFiles.contains(videoFile.path);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (_isSelectionMode) {
            _toggleFileSelection(videoFile.path);
          } else {
            if (isServerFile && serverSn != null) {
              final downloadUrl = MediaService.getMediaDownloadUrl(serverSn);
              _showMessage('서버 파일 다운로드: $downloadUrl');
            } else {
              _playVideo(videoFile);
            }
          }
        },
        onLongPress: () {
          if (!_isSelectionMode) {
            _startSelectionMode();
            _toggleFileSelection(videoFile.path);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.5,
              child: Container(
                decoration: BoxDecoration(color: EgovColor.gray10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isServerFile)
                      Container(
                        color: EgovColor.danger5,
                        child: Icon(
                          Icons.cloud_done,
                          size: 32,
                          color: EgovColor.danger60,
                        ),
                      )
                    else
                      Container(
                        color: EgovColor.black50,
                        child: Icon(
                          Icons.videocam,
                          size: 32,
                          color: EgovColor.white100,
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: EgovColor.black50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: EgovColor.white100,
                        size: 24,
                      ),
                    ),
                    if (isServerFile)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: EgovColor.danger60,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.cloud,
                            color: EgovColor.white100,
                            size: 12,
                          ),
                        ),
                      ),
                    if (_isSelectionMode)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected ? EgovColor.primary50 : EgovColor.white100,
                            border: Border.all(
                              color: isSelected ? EgovColor.primary50 : EgovColor.gray40,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: EgovColor.white100,
                                  size: 16,
                                )
                              : null,
                        ),
                      ),
                    if (_isSelectionMode && isSelected)
                      Container(color: EgovColor.primary50.withOpacity(0.3)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      videoFile.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            videoFile.typeString,
                            style: TextStyle(
                              color: EgovColor.gray60,
                              fontSize: 9,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isServerFile) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.cloud,
                            size: 10,
                            color: EgovColor.danger60,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 이미지를 전체 화면으로 보여주는 화면
class ImageViewScreen extends StatelessWidget {
  final MediaFileInfo imageFile;

  const ImageViewScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EgovColor.gray100,
      appBar: AppBar(
        backgroundColor: EgovColor.gray100,
        foregroundColor: EgovColor.white100,
        title: Text(imageFile.name),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.file(
            File(imageFile.path),
            fit: BoxFit.contain,
            cacheWidth: 1200, // 메모리 최적화를 위한 최대 너비
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.broken_image, size: 64, color: EgovColor.white100),
            ),
          ),
        ),
      ),
    );
  }
}

/// 비디오를 재생하는 화면
class VideoPlayerScreen extends StatefulWidget {
  final MediaFileInfo videoFile;

  const VideoPlayerScreen({super.key, required this.videoFile});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Timer? _hideControlsTimer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    if (_isDisposed) return;

    try {
      _controller = VideoPlayerController.file(File(widget.videoFile.path));
      await _controller!.initialize();

      if (_isDisposed) {
        _controller?.dispose();
        return;
      }

      // 비디오 정보 설정
      _totalDuration = _controller!.value.duration;
      _isPlaying = _controller!.value.isPlaying;

      // 리스너 추가
      _controller!.addListener(_videoListener);

      if (mounted && !_isDisposed) {
        setState(() {
          _isInitialized = true;
        });

        _controller!.play();
      }
    } catch (e) {
      if (mounted && !_isDisposed) {
        setState(() {
          _hasError = true;
        });
      }
      print('비디오 초기화 실패: $e');
    }
  }

  void _videoListener() {
    if (_controller != null && mounted && !_isDisposed) {
      setState(() {
        _currentPosition = _controller!.value.position;
        _isPlaying = _controller!.value.isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _hideControlsTimer?.cancel();
    
    // 비디오 재생 중이면 먼저 정지
    if (_controller != null) {
      try {
        _controller!.removeListener(_videoListener);
        if (_controller!.value.isPlaying) {
          _controller!.pause();
        }
        _controller!.dispose();
      } catch (e) {
        print('비디오 플레이어 정리 중 오류: $e');
      }
    }
    _controller = null;
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller != null && !_isDisposed) {
      if (_isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
      _showControlsTemporarily();
    }
  }

  void _showControlsTemporarily() {
    if (!_isDisposed && mounted) {
      setState(() {
        _showControls = true;
      });

      _hideControlsTimer?.cancel();
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !_isDisposed && _isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _seekTo(Duration position) {
    if (_controller != null && !_isDisposed) {
      _controller!.seekTo(position);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  Widget _buildVideoControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            EgovColor.black75,
            Colors.transparent,
            Colors.transparent,
            EgovColor.black75,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    await _cleanupVideo();
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
                ),
                Expanded(
                  child: Text(
                    widget.videoFile.name,
                    style: const TextStyle(
                      color: EgovColor.white100,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Center(
              child: IconButton(
                onPressed: _togglePlayPause,
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 진행바
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: EgovColor.white100,
                    inactiveTrackColor: EgovColor.white50,
                    thumbColor: EgovColor.white100,
                    overlayColor: EgovColor.white25,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                    ),
                  ),
                  child: Slider(
                    value: _currentPosition.inMilliseconds.toDouble(),
                    max: _totalDuration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      _seekTo(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),

                Row(
                  children: [
                    Text(
                      _formatDuration(_currentPosition),
                      style: EgovText.bodySmall.copyWith(color: EgovColor.white100),
                    ),
                    const Spacer(),
                    Text(
                      _formatDuration(_totalDuration),
                      style: EgovText.bodySmall.copyWith(color: EgovColor.white100),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 뒤로가기 시 비디오 정리
  Future<void> _cleanupVideo() async {
    if (_controller != null && !_isDisposed) {
      try {
        if (_controller!.value.isInitialized && _controller!.value.isPlaying) {
          await _controller!.pause();
        }
        // 약간의 지연을 주어 pause가 완료되도록 함
        await Future.delayed(const Duration(milliseconds: 150));
      } catch (e) {
        print('비디오 정지 중 오류: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _cleanupVideo();
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: EgovColor.gray100,
        appBar: AppBar(
          backgroundColor: EgovColor.gray100,
          foregroundColor: EgovColor.white100,
          title: Text(widget.videoFile.name),
        ),
        body: Center(
        child: _hasError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: EgovColor.white100),
                  const SizedBox(height: 16),
                  Text(
                    '비디오를 재생할 수 없습니다.',
                    style: EgovText.regular.copyWith(color: EgovColor.white100),
                  ),
                ],
              )
            : !_isInitialized
            ? const CircularProgressIndicator()
            : GestureDetector(
                onTap: () {
                  if (_showControls) {
                    setState(() {
                      _showControls = false;
                    });
                    _hideControlsTimer?.cancel();
                  } else {
                    _showControlsTemporarily();
                  }
                },
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                    if (_showControls) _buildVideoControls(),
                  ],
                ),
              ),
      ),
      ),
    );
  }
}
