import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/domain/shared/entities/app_item.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/view/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/view/fileOpener_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/interface/view/interface_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/view/media_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/view/network_main.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/view/device_info_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileMgmt/view/file_mgmt_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileReadWrite/view/file_readwrite_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/view/gps_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/view/barcode_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/compass/view/compass_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/contacts/view/contacts_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/push/view/push_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/socket/view/socket_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/streaming/view/streaming_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/view/face_mesh_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/view/iot_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/aiChat/view/ai_chat_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/sqlite/view/sqlite_main.dart';

class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  int? _openIndex; // 현재 열린 아이템의 인덱스
  final ScrollController _scrollController = ScrollController();
  /// 아코디언 헤더(title)용 키 — 열릴 때 이 지점으로 스크롤/포커스
  final List<GlobalKey> _headerKeys = [];
  final List<FocusNode> _headerFocusNodes = [];
  List<AppItem> _appItems = [];
  bool _isLoading = true;
  static const Duration _accordionAnimDuration = Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    _loadAppData();
  }

  Future<void> _loadAppData() async {
    try {
      // JSON 파일에서 데이터 로드
      final String jsonString = await rootBundle.loadString(
        'data/app_list_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> appsList = jsonData['apps'] ?? [];
      _appItems = appsList.map((item) => AppItem.fromJson(item)).toList();

      for (final node in _headerFocusNodes) {
        node.dispose();
      }
      _headerKeys.clear();
      _headerFocusNodes.clear();
      for (int i = 0; i < _appItems.length; i++) {
        _headerKeys.add(GlobalKey());
        _headerFocusNodes.add(FocusNode(debugLabel: 'appListHeader_$i'));
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _focusOpenedHeader(int index) {
    if (!mounted ||
        index < 0 ||
        index >= _headerKeys.length ||
        index >= _headerFocusNodes.length) {
      return;
    }

    final headerContext = _headerKeys[index].currentContext;
    if (headerContext != null) {
      Scrollable.ensureVisible(
        headerContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    }

    final focusNode = _headerFocusNodes[index];
    if (focusNode.canRequestFocus) {
      focusNode.requestFocus();
    }
  }

  void _toggleAccordion(int index) {
    final closing = _openIndex == index;
    setState(() {
      if (closing) {
        _openIndex = null;
      } else {
        _openIndex = index;
      }
    });

    if (closing) return;

    // 펼침 애니메이션 이후 title이 보이도록 스크롤·포커스
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(_accordionAnimDuration);
      if (!mounted || _openIndex != index) return;
      _focusOpenedHeader(index);
    });
  }

  void _navigateToTargetPage(String? targetPage) {
    if (targetPage == null) return;

    switch (targetPage) {
      case 'device_info_page':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeviceInfoPage()),
        );
        break;
      case 'accelerator_info_page':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AcceleratorInfoPage()),
        );
        break;
      case 'device_file_mgmt':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FileMgmtPage()),
        );
        break;
      case 'gps':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GpsMainPage()),
        );
        break;
      case 'file_readWrite':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FileReadWriteMainPage(),
          ),
        );
        break;
      case 'media':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MediaScreen()),
        );
        break;
      case 'interface':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InterfaceScreen()),
        );
        break;
      case 'network':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NetworkScreen()),
        );
        break;
      case 'file_opener':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FileOpenerScreen()),
        );
        break;
      case 'barcode':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BarcodePage()),
        );
        break;
      case 'compass':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CompassPage()),
        );
        break;
      case 'contacts':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ContactsPage()),
        );
        break;
      case 'push':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PushPage()),
        );
        break;
      case 'socket':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SocketPage()),
        );
        break;
      case 'streaming':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StreamingPage()),
        );
        break;
      case 'faceMesh':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FaceMeshPage()),
        );
        break;
      case 'iot':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IotPage()),
        );
        break;
      case 'aiChat':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AiChatPage()),
        );
        break;
      case 'sqlite':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SqliteMainPage()),
        );
        break;
      // 다른 페이지들도 여기에 추가할 수 있습니다
      default:
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final node in _headerFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth > 600 ? 24.0 : 16.0;
        final itemSpacing = constraints.maxWidth > 600 ? 20.0 : 16.0;

        return SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Column(
            children: List.generate(_appItems.length, (index) {
              final item = _appItems[index];
              final isOpen = _openIndex == index;

              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _toggleAccordion(index),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth > 600 ? 20.0 : 16.0,
                          vertical: constraints.maxWidth > 600 ? 16.0 : 12.0,
                        ),
                        decoration: ShapeDecoration(
                          color: EgovColor.secondary5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            // 헤더(title) — 열릴 때 스크롤/포커스 기준
                            Focus(
                              focusNode: _headerFocusNodes[index],
                              child: KeyedSubtree(
                                key: _headerKeys[index],
                                child: Semantics(
                                  header: true,
                                  expanded: isOpen,
                                  button: true,
                                  label: item.subtitle.isNotEmpty
                                      ? '${item.title} ${item.subtitle}'
                                      : item.title,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                item.title,
                                                style: TextStyle(
                                                  color: EgovColor.secondary80,
                                                  fontSize:
                                                      constraints.maxWidth > 600
                                                      ? 18.0
                                                      : 17.0,
                                                  fontFamily: 'Pretendard GOV',
                                                  fontWeight: FontWeight.w700,
                                                  height: 1.50,
                                                ),
                                              ),
                                            ),
                                            if (item.subtitle.isNotEmpty) ...[
                                              const SizedBox(width: 6),
                                              Text(
                                                item.subtitle,
                                                style: TextStyle(
                                                  color: EgovColor.secondary80.withValues(alpha: 0.6),
                                                  fontSize:
                                                      (constraints.maxWidth >
                                                              600
                                                          ? 18.0
                                                          : 17.0) -
                                                      2,
                                                  fontFamily: 'Pretendard GOV',
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.50,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      AnimatedRotation(
                                        turns: isOpen ? -0.25 : 0.25,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: const Color.fromARGB(
                                            255,
                                            11,
                                            14,
                                            18,
                                          ).withValues(alpha: 0.3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // 확장되는 콘텐츠 부분
                            ClipRect(
                              child: AnimatedSize(
                                duration: _accordionAnimDuration,
                                curve: Curves.easeInOut,
                                child: isOpen
                                    ? AnimatedOpacity(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        opacity: 1.0,
                                        child: _buildAccordionContent(
                                          context,
                                          item,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index < _appItems.length - 1)
                    SizedBox(height: itemSpacing),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildIconWidget(String iconUrl, double width, double height) {
    if (iconUrl.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        iconUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholderBuilder: (context) => Icon(
          Icons.speed,
          size: width * 0.8,
          color: const Color(0xFF052B57),
        ),
      );
    } else {
      return Image.asset(
        iconUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.speed,
          size: width * 0.8,
          color: const Color(0xFF052B57),
        ),
      );
    }
  }

  Widget _buildAccordionContent(BuildContext context, AppItem item) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isWideScreen ? 20.0 : 16.0),
          margin: const EdgeInsets.all(8.0), // 8px 여백 추가
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: const Color(0xFFB1B8BE)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: const Color(0xFF052B57),
                        fontSize: isWideScreen ? 18.0 : 17.0,
                        fontFamily: 'Pretendard GOV',
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                  ),
                  if (item.hasIcon && item.iconUrl != null) ...[
                    SizedBox(width: 12),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildIconWidget(item.iconUrl!, 50, 50),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 12),
              Text(
                item.description,
                style: TextStyle(
                  color: const Color(0xFF464C53),
                  fontSize: isWideScreen ? 17.0 : 16.0,
                  fontFamily: 'Pretendard GOV',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              if (item.targetPage != null) ...[
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _navigateToTargetPage(item.targetPage),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        l10n.commonShortcut,
                        style: TextStyle(
                          color: const Color(0xFF1E2124),
                          fontSize: isWideScreen ? 17.0 : 16.0,
                          fontFamily: 'Pretendard GOV',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: const Color(0xFF1E2124).withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
