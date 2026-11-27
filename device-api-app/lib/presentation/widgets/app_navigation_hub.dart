import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/app_item.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/app_navigation.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 더보기 탭 — 앱 목록 및 API 화면 이동 허브
class AppNavigationHub extends StatefulWidget {
  final String? currentTargetPage;

  const AppNavigationHub({super.key, this.currentTargetPage});

  @override
  State<AppNavigationHub> createState() => _AppNavigationHubState();
}

class _AppNavigationHubState extends State<AppNavigationHub> {
  List<AppItem> _appItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppData();
  }

  Future<void> _loadAppData() async {
    try {
      final jsonString = await rootBundle.loadString('data/app_list_data.json');
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final appsList = jsonData['apps'] as List<dynamic>? ?? [];

      setState(() {
        _appItems = appsList.map((item) => AppItem.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _onAppListTap() {
    AppNavigation.navigateToAppList(context);
  }

  void _onAppTap(AppItem item) {
    final targetPage = item.targetPage;
    if (targetPage == null) return;
    if (targetPage == widget.currentTargetPage) return;

    AppNavigation.navigateToTarget(context, targetPage);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.commonTabMore,
          style: EgovText.title.copyWith(color: EgovColor.gray90),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.navigationHubDescription,
          style: EgovText.caption.copyWith(height: 1.5),
        ),
        const SizedBox(height: 20),
        _NavigationCard(
          title: l10n.applicationListTitle,
          subtitle: l10n.navigationHubAppListSubtitle,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: EgovColor.primary5,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.apps_outlined,
              color: EgovColor.primary50,
              size: 24,
            ),
          ),
          onTap: _onAppListTap,
        ),
        const SizedBox(height: 12),
        ..._appItems.map((item) {
          final isCurrent = item.targetPage == widget.currentTargetPage;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _NavigationCard(
              title: item.title,
              subtitle: item.subtitle,
              leading: _buildAppIcon(item),
              isCurrent: isCurrent,
              onTap: isCurrent ? null : () => _onAppTap(item),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAppIcon(AppItem item) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: EgovColor.primary5,
        borderRadius: BorderRadius.circular(10),
      ),
      child: item.hasIcon && item.iconUrl != null
          ? _buildIconWidget(item.iconUrl!, 24, 24)
          : const Icon(
              Icons.extension_outlined,
              color: EgovColor.primary50,
              size: 24,
            ),
    );
  }

  Widget _buildIconWidget(String iconUrl, double width, double height) {
    if (iconUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(iconUrl, width: width, height: height);
    }
    return Image.asset(
      iconUrl,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class _NavigationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final VoidCallback? onTap;
  final bool isCurrent;

  const _NavigationCard({
    required this.title,
    required this.subtitle,
    required this.leading,
    this.onTap,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isCurrent ? EgovColor.primary50 : EgovColor.white100,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCurrent ? EgovColor.primary50 : EgovColor.gray20,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 14),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: EgovText.medium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isCurrent
                              ? EgovColor.white100
                              : EgovColor.gray90,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Text(
                        subtitle,
                        style: EgovText.medium.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isCurrent
                              ? EgovColor.white100.withValues(alpha: 0.7)
                              : EgovColor.gray90.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isCurrent)
                const Icon(
                  Icons.chevron_right,
                  color: EgovColor.gray40,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
