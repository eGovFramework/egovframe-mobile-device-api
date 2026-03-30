import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/data/datasources/network_service.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MinimalMapWidget extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final double? initialZoom;
  final Function(Position)? onLocationChanged;
  final Function(LatLng)? onMapTapped;
  final Position? currentPosition; // 현재 위치 추가

  const MinimalMapWidget({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialZoom = 15.0,
    this.onLocationChanged,
    this.onMapTapped,
    this.currentPosition,
  });

  @override
  State<MinimalMapWidget> createState() => _MinimalMapWidgetState();
}

class _MinimalMapWidgetState extends State<MinimalMapWidget> with WidgetsBindingObserver {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoading = true;
  String _errorMessage = '';
  Set<Marker> _markers = {};
  Timer? _memoryCleanupTimer;
  Position? _lastKnownPosition;
  bool _isNetworkAvailable = false;
  bool _isMapInitialized = false;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  final NetworkService _networkService = NetworkService();

  // 기본 위치 (서울시청)
  static const double _defaultLatitude = 37.560636;
  static const double _defaultLongitude = 126.973672;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkNetworkAndInitialize();
    _startMemoryCleanup();
    _setupConnectivityListener();
  }

  // @override
  // void didUpdateWidget(MinimalMapWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //
  //   // initialLatitude/Longitude 변경 감지
  //   final newLat = widget.initialLatitude;
  //   final newLon = widget.initialLongitude;
  //   final oldLat = oldWidget.initialLatitude;
  //   final oldLon = oldWidget.initialLongitude;
  //
  //   if ((newLat != oldLat || newLon != oldLon) &&
  //       newLat != null && newLon != null) {
  //     print('위치 변경 감지: $newLat, $newLon');
  //     // 빌드 완료 후에 실행하도록 지연
  //     Future.microtask(() {
  //       if (mounted) {
  //         _updateMapLocation();
  //       }
  //     });
  //   }
  //
  //   // currentPosition 변경 감지 (현재 위치 버튼 클릭 시)
  //   final newPosition = widget.currentPosition;
  //   final oldPosition = oldWidget.currentPosition;
  //
  //   if (newPosition != oldPosition && newPosition != null) {
  //     print('현재 위치 변경 감지: ${newPosition.latitude}, ${newPosition.longitude}');
  //     // 빌드 완료 후에 실행하도록 지연
  //     Future.microtask(() {
  //       if (mounted) {
  //         _moveToCurrentPosition(newPosition);
  //       }
  //     });
  //   }
  // }

  @override
  void didUpdateWidget(MinimalMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 위젯이 실제로 변경되었는지 확인
    bool needsUpdate = false;

    // initialLatitude/Longitude 변경 감지
    final newLat = widget.initialLatitude;
    final newLon = widget.initialLongitude;
    final oldLat = oldWidget.initialLatitude;
    final oldLon = oldWidget.initialLongitude;

    if ((newLat != oldLat || newLon != oldLon) &&
        newLat != null && newLon != null) {
      needsUpdate = true;
      print('위치 변경 감지: $newLat, $newLon');
    }

    // currentPosition 변경 감지
    final newPosition = widget.currentPosition;
    final oldPosition = oldWidget.currentPosition;

    if (newPosition != oldPosition && newPosition != null) {
      needsUpdate = true;
      print('현재 위치 변경 감지: ${newPosition.latitude}, ${newPosition.longitude}');
    }

    // 실제로 변경이 있을 때만 업데이트
    if (needsUpdate && mounted) {
      // 빌드 완료 후에 실행하도록 지연
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (newLat != null && newLon != null &&
            (newLat != oldLat || newLon != oldLon)) {
          _updateMapLocation();
        }

        if (newPosition != null && newPosition != oldPosition) {
          _moveToCurrentPosition(newPosition);
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('앱이 포그라운드로 복귀 - 네트워크 확인 및 지도 재초기화');
      _checkNetworkAndInitialize();
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = _networkService.connectivityStream.listen(
      (ConnectivityResult result) {
        final wasAvailable = _isNetworkAvailable;
        _isNetworkAvailable = result != ConnectivityResult.none;
        
        print('네트워크 상태 변경: ${_isNetworkAvailable ? "연결됨" : "연결 안됨"}');
        
        if (_isNetworkAvailable && !wasAvailable && !_isMapInitialized) {
          print('네트워크 연결됨 - 지도 초기화 시작');
          _initializeMap();
        }
      },
    );
  }

  Future<void> _checkNetworkAndInitialize() async {
    try {
      print('네트워크 연결 상태 확인 중...');
      _isNetworkAvailable = await _networkService.isNetworkAvailable();
      
      if (_isNetworkAvailable) {
        print('네트워크 연결됨 - 지도 초기화 시작');
        await _initializeMap();
      } else {
        print('네트워크 연결 안됨 - 지도 초기화 대기 중...');
        setState(() {
          _isLoading = true;
          _errorMessage = '';
        });
        
        int retryCount = 0;
        const maxRetries = 10;
        
        while (retryCount < maxRetries && !_isNetworkAvailable && mounted) {
          await Future.delayed(const Duration(milliseconds: 500));
          _isNetworkAvailable = await _networkService.isNetworkAvailable();
          retryCount++;
          
          if (_isNetworkAvailable) {
            print('네트워크 연결 확인됨 - 지도 초기화 시작');
            await _initializeMap();
            break;
          }
        }
        
        if (!_isNetworkAvailable && mounted) {
          print('네트워크 연결 없음 - 오프라인 모드로 기본 위치 설정');
          _setDefaultLocation();
          _isMapInitialized = true;
        }
      }
    } catch (e) {
      print('네트워크 확인 오류: $e');
      _setDefaultLocation();
      _isMapInitialized = true;
    }
  }

  // void _startMemoryCleanup() {
  //   // 15초마다 메모리 정리 (더 자주)
  //   _memoryCleanupTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
  //     if (mounted) {
  //       _cleanupMemory();
  //     }
  //   });
  // }

  // void _cleanupMemory() {
  //   // 메모리 정리 로직
  //   if (Platform.isAndroid) {
  //     try {
  //       // 가비지 컬렉션 강제 실행
  //       SystemChannels.platform.invokeMethod('System.gc');
  //       // 로그 제거 (15초마다 출력되어 로그가 너무 많이 쌓임)
  //     } catch (e) {
  //       print('메모리 정리 실패: $e');
  //     }
  //   }
  // }

  void _startMemoryCleanup() {
    // 기존 타이머가 있으면 먼저 취소
    _memoryCleanupTimer?.cancel();

    // 10초마다 메모리 정리 (더 자주 실행)
    _memoryCleanupTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      _cleanupMemory();
    });
  }

  void _cleanupMemory() {
    if (!mounted) return;

    // 메모리 정리 로직
    if (Platform.isAndroid) {
      try {
        // 가비지 컬렉션 강제 실행
        SystemChannels.platform.invokeMethod('System.gc');

        // 지도 컨트롤러가 있으면 메모리 정리 시도
        if (_mapController != null) {
          // 마커가 너무 많으면 정리
          if (_markers.length > 10) {
            if (mounted) {
              setState(() {
                // 가장 오래된 마커 제거 (필요시)
                // 현재는 단일 마커만 사용하므로 생략 가능
              });
            }
          }
        }
      } catch (e) {
        // 로그 출력 최소화 (너무 많은 로그는 성능 저하)
        // print('메모리 정리 실패: $e');
      }
    }
  }

  Future<void> _initializeMap() async {
    if (_isMapInitialized) {
      print('지도가 이미 초기화됨 - 스킵');
      return;
    }

    try {
      print('MinimalMapWidget 초기화 시작');
      
      if (!_isNetworkAvailable) {
        _isNetworkAvailable = await _networkService.isNetworkAvailable();
        if (!_isNetworkAvailable) {
          print('네트워크 연결 없음 - 오프라인 모드로 진행');
        }
      }
      
      final hasPermission = await _checkLocationPermission();
      
      if (hasPermission) {
        await _getCurrentLocation();
      } else {
        _setDefaultLocation();
      }
      
      _isMapInitialized = true;
    } catch (e) {
      print('지도 초기화 오류: $e');
      _setDefaultLocation();
      _isMapInitialized = true;
    }
  }

  Future<bool> _checkLocationPermission() async {
    final status = await Permission.location.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final result = await Permission.location.request();
      return result.isGranted;
    }
    
    return false;
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      print('현재 위치 가져오기 시작');

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('위치 서비스가 비활성화되어 있습니다.');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      print('=== 현재 위치 가져오기 성공 ===');
      print('위도: ${position.latitude}');
      print('경도: ${position.longitude}');
      print('정확도: ${position.accuracy}m');
      print('고도: ${position.altitude}m');
      print('속도: ${position.speed}m/s');
      print('방향: ${position.heading}°');
      print('신호 품질: ${position.accuracy < 10 ? "양호" : position.accuracy < 50 ? "보통" : "나쁨"}');
      print('===============================');

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      // 마커 추가 및 지도 이동
      _addCurrentLocationMarker();
      
      if (widget.onLocationChanged != null) {
        widget.onLocationChanged!(position);
      }

      // 지도 컨트롤러가 준비되면 위치 이동
      if (_mapController != null) {
        _moveToLocation(position.latitude, position.longitude);
      } else {
        // 지도 컨트롤러가 아직 준비되지 않은 경우, 약간의 지연 후 재시도
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (_mapController != null) {
            _moveToLocation(position.latitude, position.longitude);
          }
        });
      }

    } catch (e) {
      print('현재 위치 가져오기 실패: $e');
      setState(() {
        _errorMessage = '현재 위치를 가져올 수 없습니다: ${e.toString()}';
        _isLoading = false;
      });
      _setDefaultLocation();
    }
  }

  void _setDefaultLocation() {
    print('기본 위치 설정');
    setState(() {
      _currentPosition = Position(
        latitude: widget.initialLatitude ?? _defaultLatitude,
        longitude: widget.initialLongitude ?? _defaultLongitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
      );
      _isLoading = false;
    });

    _addCurrentLocationMarker();
    _moveToLocation(
      widget.initialLatitude ?? _defaultLatitude,
      widget.initialLongitude ?? _defaultLongitude,
    );
  }

  void _addCurrentLocationMarker() {
    if (_currentPosition != null) {
      print('마커 추가 시작: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
      if (mounted) {
        setState(() {
          _markers = {
            Marker(
              markerId: const MarkerId('current_location'),
              position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              infoWindow: const InfoWindow(
                title: '현재 위치',
              ),
            ),
          };
        });
      }
      print('마커 추가 완료: ${_markers.length}개 마커');
    } else {
      print('현재 위치가 null이므로 마커를 추가할 수 없음');
    }
  }

  void _moveToLocation(double latitude, double longitude) {
    if (_mapController != null) {
      print('지도 중심 이동: $latitude, $longitude');
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(latitude, longitude),
          widget.initialZoom ?? 15.0,
        ),
      );
      print('지도 이동 명령 실행 완료');
    } else {
      print('지도 컨트롤러가 아직 준비되지 않음');
    }
  }

  void _updateMapLocation() {
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      print('지도 위치 업데이트: ${widget.initialLatitude}, ${widget.initialLongitude}');
      
      // 새로운 위치로 Position 객체 생성
      final newPosition = Position(
        latitude: widget.initialLatitude!,
        longitude: widget.initialLongitude!,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
      );

      // setState를 안전하게 호출
      if (mounted) {
        setState(() {
          _currentPosition = newPosition;
        });
      }

      // 마커 업데이트
      _addCurrentLocationMarker();
      
      // 지도 이동
      _moveToLocation(widget.initialLatitude!, widget.initialLongitude!);
      
      // 콜백 호출
      if (widget.onLocationChanged != null) {
        widget.onLocationChanged!(newPosition);
      }
    }
  }

  void _moveToCurrentPosition(Position position) {
    print('현재 위치로 지도 이동: ${position.latitude}, ${position.longitude}');
    
    // 현재 위치 업데이트
    if (mounted) {
      setState(() {
        _currentPosition = position;
      });
    }

    // 마커 업데이트
    _addCurrentLocationMarker();
    
    // 지도 이동
    _moveToLocation(position.latitude, position.longitude);
  }


  @override
  Widget build(BuildContext context) {
    print('MinimalMapWidget 빌드: isLoading=$_isLoading, errorMessage=$_errorMessage');
    print('현재 위치: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}');
    print('지도 컨트롤러 상태: ${_mapController != null ? "준비됨" : "준비 안됨"}');

    if (_isLoading) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: EgovColor.gray5,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                _isNetworkAvailable 
                    ? '지도를 불러오는 중...' 
                    : '네트워크 연결 확인 중...',
                style: TextStyle(
                  fontSize: 16,
                  color: EgovColor.gray40,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: EgovColor.gray10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: EgovColor.danger50,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: EgovColor.danger50,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: EgovColor.black10,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AbsorbPointer(
          absorbing: false, // 지도 터치 이벤트 허용
          child: Stack(
            children: [
              GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition?.latitude ?? _defaultLatitude,
                  _currentPosition?.longitude ?? _defaultLongitude,
                ),
                zoom: widget.initialZoom ?? 15.0,
              ),
              // onMapCreated: (GoogleMapController controller) async {
              //   print('Google Maps 컨트롤러 생성 완료');
              //   _mapController = controller;
              //
              //   try {
              //     // 지도 스타일 설정 (기본 스타일 사용)
              //     await controller.setMapStyle(null);
              //     print('지도 스타일 설정 완료');
              //
              //   } catch (e) {
              //     print('지도 스타일 설정 실패: $e');
              //   }
              //
              //   // 지도 상호작용 테스트
              //   print('지도 상호작용 설정:');
              //   print('- scrollGesturesEnabled: true');
              //   print('- zoomGesturesEnabled: true');
              //   print('- tiltGesturesEnabled: true');
              //   print('- rotateGesturesEnabled: true');
              //
              //   // 지도 컨트롤러가 준비되면 현재 위치로 이동
              //   if (_currentPosition != null) {
              //     Future.delayed(const Duration(milliseconds: 500), () {
              //       _moveToLocation(_currentPosition!.latitude, _currentPosition!.longitude);
              //     });
              //   }
              // },
              onMapCreated: (GoogleMapController controller) {
                // 지도 컨트롤러 저장 (비동기 작업 최소화)
                _mapController = controller;
                print('Google Maps 컨트롤러 생성 완료');

                // setMapStyle(null) 호출 제거 (기본 스타일 사용 시 불필요)
                // await controller.setMapStyle(null); <- 이 줄 제거

                // 지도 컨트롤러가 준비되면 현재 위치로 이동 (지연 최소화)
                if (_currentPosition != null && mounted) {
                  // 즉시 실행하되, 안전하게 처리
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _mapController != null) {
                      _moveToLocation(_currentPosition!.latitude, _currentPosition!.longitude);
                    }
                  });
                }
              },
              markers: _markers,
              onTap: widget.onMapTapped,
              zoomControlsEnabled: true, // 확대/축소 버튼 표시
              scrollGesturesEnabled: true, // 마우스 드래그로 지도 이동
              zoomGesturesEnabled: true, // 마우스 휠로 확대/축소
              tiltGesturesEnabled: false, // 지도 기울기 조작 (우클릭+드래그)
              rotateGesturesEnabled: false, // 지도 회전 조작 (Shift+드래그)
              myLocationEnabled: false, // 내 위치 표시 (파란 점)
              myLocationButtonEnabled: false, // 내 위치 버튼 표시
              mapType: MapType.normal, // 지도 타입 (일반/위성/하이브리드)
              compassEnabled: false, // 나침반 표시
              mapToolbarEnabled: false, // 지도 도구 모음 표시
              buildingsEnabled: false, // 3D 건물 표시
              trafficEnabled: false, // 교통 정보 표시
              indoorViewEnabled: false, // 실내 지도 표시
              onCameraMove: null, // 카메라 이동 이벤트 핸들러
              onCameraIdle: null, // 카메라 이동 완료 이벤트 핸들러
              liteModeEnabled: false, // 라이트 모드 (성능 최적화)
            ),
            
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    // _memoryCleanupTimer?.cancel();
    // _connectivitySubscription?.cancel();
    // _mapController?.dispose();
    // super.dispose();

    // 위젯이 dispose되는지 확인
    if (!mounted) return;

    // Observer 제거
    WidgetsBinding.instance.removeObserver(this);

    // 타이머 취소 및 null 처리
    _memoryCleanupTimer?.cancel();
    _memoryCleanupTimer = null;

    // 네트워크 구독 취소 및 null 처리
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;

    // 지도 컨트롤러 명시적 해제 (중요!)
    if (_mapController != null) {
      try {
        _mapController!.dispose();
      } catch (e) {
        print('지도 컨트롤러 dispose 오류: $e');
      } finally {
        _mapController = null;
      }
    }

    // 마커 정리
    _markers.clear();

    // 위치 정보 정리
    _currentPosition = null;
    _lastKnownPosition = null;

    // 상태 플래그 초기화
    _isMapInitialized = false;
    _isLoading = false;
    _errorMessage = '';

    super.dispose();

  }
}
