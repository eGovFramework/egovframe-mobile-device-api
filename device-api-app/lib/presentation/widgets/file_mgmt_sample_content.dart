import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

AppLocalizations readPresentationLocalizations() {
  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  return lookupAppLocalizations(locale);
}

class FileMgmtSampleContent {
  FileMgmtSampleContent._();

  static String welcome(AppLocalizations l10n) =>
      l10n.fileMgmtWelcomeFileContent;

  static String forFileName(AppLocalizations l10n, String fileName) {
    final timestamp = DateTime.now().toString();
    final isoTimestamp = DateTime.now().toIso8601String();

    if (fileName.endsWith('.txt')) {
      return l10n.fileMgmtSampleTxtContent(timestamp);
    }
    if (fileName.endsWith('.json')) {
      return '{\n  "title": "${l10n.fileMgmtSampleJsonTitle}",\n'
          '  "created": "$isoTimestamp",\n'
          '  "description": "${l10n.fileMgmtSampleJsonDescription}"\n}';
    }
    if (fileName.endsWith('.md')) {
      return l10n.fileMgmtSampleMdContent(
        l10n.fileMgmtSampleMdTitle,
        timestamp,
        l10n.fileMgmtSampleMdSectionTitle,
      );
    }
    return l10n.fileMgmtSampleDefaultContent(timestamp);
  }

  static String copySuffix(AppLocalizations l10n) => l10n.fileMgmtCopySuffix;
}
