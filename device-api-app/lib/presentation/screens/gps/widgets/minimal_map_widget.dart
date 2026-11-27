import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/data/network/datasources/network_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/widgets/gps_map_fallback.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MinimalMapWidget extends ConsumerStatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final double? initialZoom;
  final Function(Position)? onLocationChanged;
  final Function(LatLng)? onMapTapped;
  final Position? currentPosition;

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
  ConsumerState<MinimalMapWidget> createState() => _MinimalMapWidgetState();
}

class _MinimalMapWidgetState extends ConsumerState<MinimalMapWidget>
    with WidgetsBindingObserver {
  final bool _useGoogleMaps = AppConfig.isGoogleMapsConfigured;
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoading = true;
  String _errorMessage = '';
  Set<Marker> _markers = {};
  bool _isNetworkAvailable = false;
  bool _isMapInitialized = false;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  NetworkService get _networkService => ref.read(networkServiceProvider);

  // 기본 위치 (서울시청)
  static const double _defaultLatitude = 37.560636;
  static const double _defaultLongitude = 126.973672;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (_useGoogleMaps) {
      _checkNetworkAndInitialize();
      _setupConnectivityListener();
    } else {
      // API 키 미설정 시 GPS 조회를 기다리지 않고 fallback을 즉시 표시
      _isLoading = false;
      _isMapInitialized = true;
      if (widget.currentPosition != null) {
        _currentPosition = widget.currentPosition;
      }
    }
  }

  @override
  void didUpdateWidget(MinimalMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool needsUpdate = false;

    final newLat = widget.initialLatitude;
    final newLon = widget.initialLongitude;
    final oldLat = oldWidget.initialLatitude;
    final oldLon = oldWidget.initialLongitude;

    if ((newLat != oldLat || newLon != oldLon) &&
        newLat != null &&
        newLon != null) {
      needsUpdate = true;
    }

    final newPosition = widget.currentPosition;
    final oldPosition = oldWidget.currentPosition;

    if (newPosition != oldPosition && newPosition != null) {
      needsUpdate = true;
    }

    if (needsUpdate && mounted) {
      if (!_useGoogleMaps) {
        if (newPosition != null && newPosition != oldPosition) {
          setState(() => _currentPosition = newPosition);
        }
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (newLat != null &&
            newLon != null &&
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
    if (state == AppLifecycleState.resumed && _useGoogleMaps) {
      _checkNetworkAndInitialize();
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = _networkService.connectivityStream.listen((
      ConnectivityResult result,
    ) {
      final wasAvailable = _isNetworkAvailable;
      _isNetworkAvailable = result != ConnectivityResult.none;

      if (_isNetworkAvailable && !wasAvailable && !_isMapInitialized) {
        _initializeMap();
      }
    });
  }

  Future<void> _checkNetworkAndInitialize() async {
    try {
      _isNetworkAvailable = await _networkService.isNetworkAvailable();

      if (_isNetworkAvailable) {
        await _initializeMap();
      } else {
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
            await _initializeMap();
            break;
          }
        }

        if (!_isNetworkAvailable && mounted) {
          _setDefaultLocation();
          _isMapInitialized = true;
        }
      }
    } catch (e) {
      _setDefaultLocation();
      _isMapInitialized = true;
    }
  }

  Future<void> _initializeMap() async {
    if (_isMapInitialized) {
      return;
    }

    try {
      if (!_isNetworkAvailable) {
        _isNetworkAvailable = await _networkService.isNetworkAvailable();
        if (!_isNetworkAvailable) {}
      }

      final hasPermission = await _checkLocationPermission();

      if (hasPermission) {
        await _getCurrentLocation();
      } else {
        _setDefaultLocation();
      }

      _isMapInitialized = true;
    } catch (e) {
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
    if (!_useGoogleMaps) return;
    final l10n = AppLocalizations.of(context)!;

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(l10n.gpsLocationServiceDisabled);
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

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
      setState(() {
        _errorMessage = l10n.gpsFetchFailed(e.toString());
        _isLoading = false;
      });
      _setDefaultLocation();
    }
  }

  void _setDefaultLocation() {
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
    if (!_useGoogleMaps || _currentPosition == null) return;

    if (mounted) {
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            infoWindow: InfoWindow(
              title: AppLocalizations.of(context)!.gpsCurrentLocation,
            ),
          ),
        };
      });
    }
  }

  void _moveToLocation(double latitude, double longitude) {
    if (!_useGoogleMaps || _mapController == null) return;

    _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(latitude, longitude),
        widget.initialZoom ?? 15.0,
      ),
    );
  }

  void _updateMapLocation() {
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
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

      if (mounted) {
        setState(() {
          _currentPosition = newPosition;
        });
      }

      _addCurrentLocationMarker();
      _moveToLocation(widget.initialLatitude!, widget.initialLongitude!);
      if (widget.onLocationChanged != null) {
        widget.onLocationChanged!(newPosition);
      }
    }
  }

  void _moveToCurrentPosition(Position position) {
    if (mounted) {
      setState(() {
        _currentPosition = position;
      });
    }

    _addCurrentLocationMarker();
    _moveToLocation(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                !_useGoogleMaps
                    ? l10n.gpsLoadingLocation
                    : _isNetworkAvailable
                    ? l10n.gpsLoadingMap
                    : l10n.gpsCheckingNetwork,
                style: TextStyle(fontSize: 16, color: EgovColor.gray40),
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
              Icon(Icons.error_outline, size: 48, color: EgovColor.danger50),
              const SizedBox(height: 16),
              Text(
                _errorMessage,
                style: TextStyle(fontSize: 14, color: EgovColor.danger50),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (!_useGoogleMaps) {
      return GpsMapFallback(position: _currentPosition);
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
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;

                  if (_currentPosition != null && mounted) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && _mapController != null) {
                        _moveToLocation(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        );
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
    WidgetsBinding.instance.removeObserver(this);

    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;

    if (_mapController != null) {
      try {
        _mapController!.dispose();
      } catch (e) {
        appLogError('Failed to dispose map controller', e);
      } finally {
        _mapController = null;
      }
    }

    _markers.clear();
    _currentPosition = null;
    _isMapInitialized = false;
    _isLoading = false;
    _errorMessage = '';

    super.dispose();
  }
}
