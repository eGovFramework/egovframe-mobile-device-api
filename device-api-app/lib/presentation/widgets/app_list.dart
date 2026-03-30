import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/domain/entities/app_item.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/accelerator/accelerator_info.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/fileopener/fileOpener_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/interface/interface_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/media/media_main.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/network/network_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screens/deviceInfo/deviceInfo_main.dart';
import '../screens/fileMgmt/fileMgmt_main.dart';
import '../screens/fileReadWrite/fileReadWrite_main.dart';
import '../screens/gps/gps_main.dart';

class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  int? _openIndex; // 현재 열린 아이템의 인덱스
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _itemKeys = [];
  List<AppItem> _appItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppData();
  }

  Future<void> _loadAppData() async {
    try {
      // JSON 파일에서 데이터 로드
      final String jsonString = await rootBundle.loadString('data/app_list_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> appsList = jsonData['apps'] ?? [];
      _appItems = appsList.map((item) => AppItem.fromJson(item)).toList();
      
      // 각 아이템에 대한 GlobalKey 초기화
      _itemKeys.clear();
      for (int i = 0; i < _appItems.length; i++) {
        _itemKeys.add(GlobalKey());
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading app data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleAccordion(int index) {
    setState(() {
      if (_openIndex == index) {
        // 같은 아이템을 클릭하면 닫기
        _openIndex = null;
      } else {
        // 다른 아이템을 클릭하면 이전 아이템은 닫고 새로운 아이템 열기
        _openIndex = index;
        
        // 아코디언이 열릴 때 해당 헤더로 스크롤
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_itemKeys.length > index && _itemKeys[index].currentContext != null) {
            Scrollable.ensureVisible(
              _itemKeys[index].currentContext!,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  void _navigateToTargetPage(String? targetPage) {
    if (targetPage == null) return;
    
    switch (targetPage) {
      case 'device_info_page':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DeviceInfoPage(),
          ),
        );
        break;
      case 'accelerator_info_page':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AcceleratorInfoPage(),
          ),
        );
        break;
      case 'device_file_mgmt':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FileManagementScreen(),
          ),
        );
        break;
      case 'gps':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GpsMainPage(),
          ),
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
          MaterialPageRoute(
            builder: (context) => const MediaScreen(),
          ),
        );
        break;
      case 'interface':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const InterfaceScreen(),
          ),
        );
        break;
      case 'network':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NetworkScreen(),
          ),
        );
        break;
      case 'file_opener':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FileOpenerScreen(),
          ),
        );
        break;
      // 다른 페이지들도 여기에 추가할 수 있습니다
      default:
        print('Unknown target page: $targetPage');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth > 600 ? 24.0 : 16.0;
        final itemSpacing = constraints.maxWidth > 600 ? 20.0 : 16.0;
        
        return SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
          child: Column(
            children: List.generate(_appItems.length, (index) {
              final item = _appItems[index];
              final isOpen = _openIndex == index;
              
              return Column(
                children: [
                  Material(
                    key: _itemKeys[index], // GlobalKey를 헤더에 적용
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
                            // 헤더 부분
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      color: EgovColor.secondary80,
                                      fontSize: constraints.maxWidth > 600 ? 18.0 : 17.0,
                                      fontFamily: 'Pretendard GOV',
                                      fontWeight: FontWeight.w700,
                                      height: 1.50,
                                    ),
                                  ),
                                ),
                                AnimatedRotation(
                                  turns: isOpen ? -0.25 : 0.25,
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: const Color(0xFF052B57).withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                            // 확장되는 콘텐츠 부분
                            ClipRect(
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                                child: isOpen 
                                  ? AnimatedOpacity(
                                      duration: const Duration(milliseconds: 300),
                                      opacity: 1.0,
                                      child: _buildAccordionContent(context, item),
                                    )
                                  : const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index < _appItems.length - 1) SizedBox(height: itemSpacing),
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
              side: BorderSide(
                width: 1,
                color: const Color(0xFFB1B8BE),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.hasIcon && item.iconUrl != null) ...[
                Container(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildIconWidget(item.iconUrl!, 50, 50),
                  ),
                ),
                SizedBox(height: 16),
              ],
              Text(
                item.title,
                style: TextStyle(
                  color: const Color(0xFF052B57),
                  fontSize: isWideScreen ? 18.0 : 17.0,
                  fontFamily: 'Pretendard GOV',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                ),
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
              SizedBox(height: 16),
              if (item.targetPage != null) ...[
                GestureDetector(
                  onTap: () => _navigateToTargetPage(item.targetPage),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Text(
                        '바로가기',
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
                        color: const Color(0xFF1E2124).withOpacity(0.3),
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
