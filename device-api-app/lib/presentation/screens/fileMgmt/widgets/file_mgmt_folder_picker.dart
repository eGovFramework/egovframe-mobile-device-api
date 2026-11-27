import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/domain/fileMgmt/entities/file_mgmt_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/fileMgmt/usecases/file_mgmt_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/toast.dart';
import 'package:flutter/material.dart';

class FileMgmtFolderPicker extends StatefulWidget {
  final String title;
  final String initialPath;
  final FileMgmtUseCase useCase;

  const FileMgmtFolderPicker({
    super.key,
    required this.title,
    required this.initialPath,
    required this.useCase,
  });

  @override
  State<FileMgmtFolderPicker> createState() => _FileMgmtFolderPickerState();
}

class _FileMgmtFolderPickerState extends State<FileMgmtFolderPicker> {
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

  Future<void> _loadDirectories() async {
    setState(() => _isLoading = true);
    try {
      final result = await widget.useCase.listDirectory(_currentPath);
      if (result is FileMgmtDirectorySuccess) {
        setState(() {
          _directories = result.contents.whereType<Directory>().toList();
        });
      } else if (result is FileMgmtDirectoryFailure && mounted) {
        showStatusToast(
          context,
          variant: StatusVariant.error,
          title: AppLocalizations.of(context)!.commonError,
          message: AppLocalizations.of(
            context,
          )!.fileMgmtFolderCreateFailed(result.message),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _navigateToDirectory(String path) async {
    _pathHistory.add(_currentPath);
    _currentPath = path;
    await _loadDirectories();
  }

  Future<void> _navigateBack() async {
    if (_pathHistory.isEmpty) return;
    _currentPath = _pathHistory.removeLast();
    await _loadDirectories();
  }

  Future<void> _navigateToRoot() async {
    try {
      final rootPath = await widget.useCase.getDocumentsRoot();
      _pathHistory.clear();
      _currentPath = rootPath;
      await _loadDirectories();
    } catch (e) {
      if (!mounted) return;
      showStatusToast(
        context,
        variant: StatusVariant.error,
        title: AppLocalizations.of(context)!.commonError,
        message: AppLocalizations.of(context)!.fileMgmtRenameFailed(e.toString()),
      );
    }
  }

  Future<void> _createNewFolder() async {
    final controller = TextEditingController();
    final folderName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.fileMgmtCreateFolderTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.fileMgmtFeatureTitle,
            hintText: AppLocalizations.of(context)!.fileMgmtNewFolder,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.commonCancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text(AppLocalizations.of(context)!.commonCreate),
          ),
        ],
      ),
    );

    if (folderName == null) return;
    setState(() => _isLoading = true);
    final result = await widget.useCase.createDirectory(
      parentPath: _currentPath,
      name: folderName,
    );
    if (result is FileMgmtOperationSuccess) {
      await _loadDirectories();
      if (mounted) {
        showStatusToast(
          context,
          variant: StatusVariant.success,
          title: AppLocalizations.of(context)!.commonSuccess,
          message: AppLocalizations.of(context)!.fileMgmtFolderCreated(folderName),
        );
      }
    } else if (result is FileMgmtOperationFailure && mounted) {
      showStatusToast(
        context,
        variant: StatusVariant.error,
        title: AppLocalizations.of(context)!.commonError,
        message: AppLocalizations.of(
          context,
        )!.fileMgmtFolderCreateFailed(result.message),
      );
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: EgovColor.white100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(widget.title, style: EgovText.title)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: EgovColor.gray60),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: EgovColor.gray5,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: EgovColor.gray20),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _pathHistory.isNotEmpty ? _navigateBack : null,
                    icon: Icon(
                      Icons.arrow_back,
                      color: _pathHistory.isNotEmpty
                          ? EgovColor.primary50
                          : EgovColor.gray40,
                    ),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: _navigateToRoot,
                    icon: Icon(Icons.home, color: EgovColor.primary50),
                    iconSize: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(_currentPath, style: EgovText.caption),
                    ),
                  ),
                  IconButton(
                    onPressed: _createNewFolder,
                    icon: Icon(
                      Icons.create_new_folder,
                      color: EgovColor.success50,
                    ),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          EgovColor.primary50,
                        ),
                      ),
                    )
                  : _directories.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 48,
                            color: EgovColor.gray40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.fileMgmtNoSubFolder,
                            style: EgovText.regular.copyWith(
                              color: EgovColor.gray40,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _directories.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: EgovColor.gray10),
                      itemBuilder: (context, index) {
                        final directory = _directories[index];
                        final name = directory.path.split('/').last;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
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
                          title: Text(name, style: EgovText.medium),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.commonCancel,
                    style: EgovText.regular.copyWith(color: EgovColor.gray60),
                  ),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: AppLocalizations.of(context)!.fileMgmtSelectThisFolder,
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
