import 'dart:async';
import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_result.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/view_model/media_controller.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/state/media_state.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/widgets/media_connection_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/widgets/media_connection_status_card.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/bottom_sheet.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/feature_shell.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/modal.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/server_connection_button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/media_thumbnail.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'video_player_screen.dart';

import 'media_description.dart';
import 'media_list.dart';

class MediaScreen extends ConsumerStatefulWidget {
  const MediaScreen({super.key});

  @override
  ConsumerState<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends ConsumerState<MediaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _subTabController;
  final _shellController = FeatureShellController();

  MediaMain get _notifier => ref.read(mediaMainProvider.notifier);

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _subTabController.addListener(() {
      setState(() {});
      if (ref.read(mediaMainProvider).isSelectionMode) {
        _notifier.exitSelectionMode();
      }
    });
  }

  @override
  void dispose() {
    _subTabController.dispose();
    super.dispose();
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
      await _notifier.reloadLocalMediaList();
    }
  }

  Future<void> _handlePickImage(ImageSource source) async {
    final pickResult = await _notifier.pickImage(source);
    if (!mounted) return;

    switch (pickResult) {
      case MediaPickPermissionDenied(:final permission):
        _showMessage(permission.message);
        if (permission.isPermanentlyDenied) {
          await PermissionManager.showPermissionSettingsDialog(
            context,
            permission.permissionLabel,
          );
        }
      case MediaPickCancelled():
        _showMessage('이미지 선택이 취소되었습니다.');
      case MediaPickFailure(:final message):
        _showMessage(message);
      case MediaPickSuccess(:final file):
        final saveResult = await _notifier.savePickedImage(
          file,
          captureSource: source,
        );
        if (!mounted) return;
        switch (saveResult) {
          case MediaSaveSuccess(:final message):
            _showMessage(message);
          case MediaSaveFailure(:final message):
            _showMessage(message);
        }
    }
  }

  Future<void> _handlePickVideo(ImageSource source) async {
    final pickResult = await _notifier.pickVideo(source);
    if (!mounted) return;

    switch (pickResult) {
      case MediaPickPermissionDenied(:final permission):
        _showMessage(permission.message);
        if (permission.isPermanentlyDenied) {
          await PermissionManager.showPermissionSettingsDialog(
            context,
            permission.permissionLabel,
          );
        }
      case MediaPickCancelled():
        _showMessage('비디오 선택이 취소되었습니다.');
      case MediaPickFailure(:final message):
        _showMessage(message);
      case MediaPickSuccess(:final file):
        final saveResult = await _notifier.savePickedVideo(
          file,
          captureSource: source,
        );
        if (!mounted) return;
        switch (saveResult) {
          case MediaSaveSuccess(:final message):
            _showMessage(message);
          case MediaSaveFailure(:final message):
            _showMessage(message);
        }
    }
  }

  Future<void> _deleteSelectedFiles() async {
    final mediaState = ref.read(mediaMainProvider);
    if (mediaState.selectedFiles.isEmpty) return;

    final confirmed = await _showConfirmDialog(
      '선택된 파일 삭제',
      '선택된 ${mediaState.selectedFiles.length}개 파일을 삭제하시겠습니까?',
    );

    if (!confirmed) return;

    final result = await _notifier.deleteSelectedFiles();
    if (!mounted) return;

    switch (result) {
      case MediaDeleteBatchSuccess(:final message):
        _showMessage(message);
      case MediaDeleteBatchFailure(:final message):
        _showMessage(message);
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

  // 비디오 재생
  void _playVideo(MediaFileInfo videoFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoFile: videoFile),
      ),
    );
  }

  void _showMediaPickerOptions(String mediaType) {
    final bool isImage = mediaType == '이미지';

    showAppActionSheet(
      context,
      title: isImage ? '이미지 추가' : '비디오 추가',
      message: '추가할 $mediaType의 출처를 선택하세요.',
      actions: [
        AppBottomSheetAction(
          label: '카메라에서 $mediaType',
          icon: Icons.camera_alt,
          onTap: () {
            if (isImage) {
              _handlePickImage(ImageSource.camera);
            } else {
              _handlePickVideo(ImageSource.camera);
            }
          },
        ),
        AppBottomSheetAction(
          label: '갤러리에서 $mediaType',
          icon: Icons.photo_library,
          onTap: () {
            if (isImage) {
              _handlePickImage(ImageSource.gallery);
            } else {
              _handlePickVideo(ImageSource.gallery);
            }
          },
        ),
      ],
    );
  }

  Future<void> _showMessage(String message) async {
    await showStatusToast(
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
    final mediaState = ref.watch(mediaMainProvider);

    return FeatureShell(
      controller: _shellController,
      title: '미디어 API',
      currentAppTargetPage: 'media',
      guidePage: const MediaFunctionPage(),
      appBarBuilder: (ctrl) {
        return CustomAppBar(
          title: mediaState.isSelectionMode
              ? '${mediaState.selectedFiles.length}개 선택됨'
              : '미디어 API',
          hideHomeButton: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: EgovColor.white100),
            onPressed: ctrl.handleBack,
          ),
          actions: [
            if (mediaState.isSelectionMode)
              IconButton(
                icon: const Icon(Icons.close, color: EgovColor.white100),
                onPressed: _notifier.exitSelectionMode,
              ),
          ],
        );
      },
      onBeforeBack: (_) {
        if (mediaState.isSelectionMode) {
          _notifier.exitSelectionMode();
          return true;
        }
        return false;
      },
      mainFunctionBody: _buildMainFunctionTab(mediaState),
      bottomBar: mediaState.isSelectionMode && mediaState.selectedFiles.isNotEmpty
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
                CustomButton(
                  text: _subTabController.index == 0 ? '이미지 추가' : '비디오 추가',
                  icon: Icon(
                    _subTabController.index == 0
                        ? Icons.add_photo_alternate
                        : Icons.video_call,
                    size: 18,
                  ),
                  onTap: () => _showMediaPickerOptions(
                    _subTabController.index == 0 ? '이미지' : '비디오',
                  ),
                ),
                ServerConnectionButtonFactory.listButton(
                  text: '서버 목록',
                  onServerConnected: () async => _navigateToServerList(),
                  resolveConnection: MediaConnectionResolver.resolveConnection,
                ),
              ],
            ),
    );
  }

  /// 주요기능 탭
  Widget _buildMainFunctionTab(MediaMainState mediaState) {
    return Column(
      children: [
        // ?????? ??
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
        // ?????? ????
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            children: [
              _buildImageSubTab(mediaState),
              _buildVideoSubTab(mediaState),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: MediaConnectionBar(),
        ),
      ],
    );
  }

  /// 이미지 서브탭
  Widget _buildImageSubTab(MediaMainState mediaState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _buildImageList(mediaState),
    );
  }

  /// 비디오 서브탭
  Widget _buildVideoSubTab(MediaMainState mediaState) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _buildVideoList(mediaState),
    );
  }

  Future<void> _uploadSelectedFiles() async {
    final mediaState = ref.read(mediaMainProvider);
    if (mediaState.selectedFiles.isEmpty) return;

    final connected = await MediaConnectionResolver.resolveConnection(
      context: context,
      ref: ref,
    );
    if (!connected || !mounted) return;

    final confirmed = await showServerRegisterConfirm(
      context,
      title: '미디어 등록',
      message: '선택된 ${mediaState.selectedFiles.length}개 파일을 서버에 등록하시겠습니까?',
    );

    if (!confirmed) return;

    final result = await _notifier.uploadSelectedFiles();
    if (!mounted) return;

    switch (result) {
      case MediaUploadSuccess(:final message):
        _showMessage(message);
      case MediaUploadFailure(:final message):
        _showMessage(message);
    }
  }

  /// 이미지 목록을 구성
  Widget _buildImageList(MediaMainState mediaState) {
    final displayFiles = mediaState.mediaFiles
        .where((file) => file.type == MediaType.image)
        .toList();

    return SizedBox.expand(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.image, color: EgovColor.success50, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mediaState.isSelectionMode
                          ? '선택된 이미지 (${mediaState.selectedFiles.length}개)'
                          : '로컬 이미지 목록 (${displayFiles.length}개)',
                      style: EgovText.title.copyWith(
                        fontWeight: FontWeight.bold,
                        color: EgovColor.gray90,
                      ),
                    ),
                  ),
                  if (mediaState.isSelectionMode) ...[
                    IconButton(
                      onPressed: mediaState.selectedFiles.isNotEmpty
                          ? _deleteSelectedFiles
                          : null,
                      icon: const Icon(Icons.delete),
                      tooltip: '선택된 파일 삭제',
                      color: mediaState.selectedFiles.isNotEmpty
                          ? EgovColor.danger50
                          : EgovColor.gray40,
                    ),
                    IconButton(
                      onPressed: _notifier.exitSelectionMode,
                      icon: const Icon(Icons.close),
                      tooltip: '선택 모드 종료',
                    ),
                  ] else ...[
                    IconButton(
                      onPressed: mediaState.isLoading
                          ? null
                          : _notifier.reloadLocalMediaList,
                      icon: mediaState.isLoading
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
              Expanded(
                child: displayFiles.isEmpty
                    ? _buildEmptyMediaPlaceholder(
                        icon: Icons.image,
                        loadingText: '이미지 목록을 불러오는 중...',
                        emptyText: '저장된 이미지가 없습니다.',
                        hintText: '하단의 이미지 추가 버튼을 눌러 이미지를 추가해보세요.',
                        isLoading: mediaState.isLoading,
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: displayFiles.length,
                        itemBuilder: (context, index) {
                          return _buildImageCard(
                            displayFiles[index],
                            mediaState,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 비디오 목록을 구성
  Widget _buildVideoList(MediaMainState mediaState) {
    final displayFiles = mediaState.mediaFiles
        .where((file) => file.type == MediaType.video)
        .toList();

    return SizedBox.expand(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.videocam, color: EgovColor.danger50, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      mediaState.isSelectionMode
                          ? '선택된 비디오 (${mediaState.selectedFiles.length}개)'
                          : '로컬 비디오 목록 (${displayFiles.length}개)',
                      style: EgovText.title.copyWith(
                        fontWeight: FontWeight.bold,
                        color: EgovColor.gray90,
                      ),
                    ),
                  ),
                  if (mediaState.isSelectionMode) ...[
                    IconButton(
                      onPressed: mediaState.selectedFiles.isNotEmpty
                          ? _deleteSelectedFiles
                          : null,
                      icon: const Icon(Icons.delete),
                      tooltip: '선택된 파일 삭제',
                      color: mediaState.selectedFiles.isNotEmpty
                          ? EgovColor.danger50
                          : EgovColor.gray40,
                    ),
                    IconButton(
                      onPressed: _notifier.exitSelectionMode,
                      icon: const Icon(Icons.close),
                      tooltip: '선택 모드 종료',
                    ),
                  ] else ...[
                    IconButton(
                      onPressed: mediaState.isLoading
                          ? null
                          : _notifier.reloadLocalMediaList,
                      icon: mediaState.isLoading
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
              Expanded(
                child: displayFiles.isEmpty
                    ? _buildEmptyMediaPlaceholder(
                        icon: Icons.videocam,
                        loadingText: '비디오 목록을 불러오는 중...',
                        emptyText: '저장된 비디오가 없습니다.',
                        hintText: '하단의 비디오 추가 버튼을 눌러 비디오를 추가해보세요.',
                        isLoading: mediaState.isLoading,
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: displayFiles.length,
                        itemBuilder: (context, index) {
                          return _buildVideoCard(
                            displayFiles[index],
                            mediaState,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMediaPlaceholder({
    required IconData icon,
    required String loadingText,
    required String emptyText,
    required String hintText,
    required bool isLoading,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: EgovColor.gray30),
            const SizedBox(height: 16),
            Text(
              isLoading ? loadingText : emptyText,
              style: EgovText.bodyLarge.copyWith(color: EgovColor.gray60),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isLoading ? '잠시만 기다려주세요.' : hintText,
              style: EgovText.bodyMedium.copyWith(color: EgovColor.gray50),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(MediaFileInfo imageFile, MediaMainState mediaState) {
    final isServerFile = imageFile.path.startsWith('server://');
    final serverSn = isServerFile
        ? int.tryParse(imageFile.path.replaceFirst('server://', ''))
        : null;
    final isSelected = mediaState.selectedFiles.contains(imageFile.path);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          if (mediaState.isSelectionMode) {
            _notifier.toggleFileSelection(imageFile.path);
          } else {
            if (isServerFile && serverSn != null) {
              final result = await _notifier.getServerDownloadUrl(serverSn);
              switch (result) {
                case MediaDownloadUrlSuccess(:final url):
                  _showMessage('다운로드 URL 확인: $url');
                case MediaDownloadUrlFailure(:final message):
                  _showMessage(message);
              }
            } else {
              _showImageFullScreen(imageFile);
            }
          }
        },
        onLongPress: () {
          if (!mediaState.isSelectionMode) {
            _notifier.startSelectionMode();
            _notifier.toggleFileSelection(imageFile.path);
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
                    // ????? ??? ???? ???? ???
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
                          cacheWidth: 400,
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
                    if (mediaState.isSelectionMode)
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
                    if (mediaState.isSelectionMode && isSelected)
                      Container(color: EgovColor.primary50.withValues(alpha: 0.3)),
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

  Widget _buildVideoCard(MediaFileInfo videoFile, MediaMainState mediaState) {
    final isServerFile = videoFile.path.startsWith('server://');
    final serverSn = isServerFile
        ? int.tryParse(videoFile.path.replaceFirst('server://', ''))
        : null;
    final isSelected = mediaState.selectedFiles.contains(videoFile.path);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          if (mediaState.isSelectionMode) {
            _notifier.toggleFileSelection(videoFile.path);
          } else {
            if (isServerFile && serverSn != null) {
              final result = await _notifier.getServerDownloadUrl(serverSn);
              switch (result) {
                case MediaDownloadUrlSuccess(:final url):
                  _showMessage('다운로드 URL 확인: $url');
                case MediaDownloadUrlFailure(:final message):
                  _showMessage(message);
              }
            } else {
              _playVideo(videoFile);
            }
          }
        },
        onLongPress: () {
          if (!mediaState.isSelectionMode) {
            _notifier.startSelectionMode();
            _notifier.toggleFileSelection(videoFile.path);
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
                      SizedBox.expand(
                        child: VideoThumbnailPreview(
                          videoPath: videoFile.path,
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
                    if (mediaState.isSelectionMode)
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
                    if (mediaState.isSelectionMode && isSelected)
                      Container(color: EgovColor.primary50.withValues(alpha: 0.3)),
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
            cacheWidth: 1200, // ??? ??????? ???? ??? ???
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(Icons.broken_image, size: 64, color: EgovColor.white100),
            ),
          ),
        ),
      ),
    );
  }
}

