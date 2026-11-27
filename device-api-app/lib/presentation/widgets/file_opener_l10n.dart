import 'package:egovframe_mobile_deviceapi_app/domain/fileopener/entities/file_opener_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';

String fileOpenerTypeLabel(AppLocalizations l10n, FileType fileType) {
  return switch (fileType) {
    FileType.document => l10n.fileOpenerTypeDocument,
    FileType.text => l10n.fileOpenerTypeText,
    FileType.spreadsheet => l10n.fileOpenerTypeSpreadsheet,
    FileType.presentation => l10n.fileOpenerTypePresentation,
    FileType.other => l10n.fileOpenerTypeOther,
  };
}
