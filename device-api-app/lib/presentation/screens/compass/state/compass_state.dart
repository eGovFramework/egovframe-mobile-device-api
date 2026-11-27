import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_heading.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/compass/entities/compass_info.dart';

class CompassMainState {
  final bool isLoading;
  final bool isWatching;
  final bool isAwaitingReading;
  final DateTime? capturedAt;
  final String? loadError;
  final String uuid;
  final CompassHeading heading;

  const CompassMainState({
    required this.isLoading,
    required this.isWatching,
    required this.isAwaitingReading,
    this.capturedAt,
    this.loadError,
    required this.uuid,
    required this.heading,
  });

  factory CompassMainState.initial() {
    return const CompassMainState(
      isLoading: true,
      isWatching: false,
      isAwaitingReading: false,
      uuid: '',
      heading: CompassHeading.inactive(),
    );
  }

  bool get hasCapturedReading =>
      capturedAt != null && heading.magneticHeading != null;

  CompassMainState copyWith({
    bool? isLoading,
    bool? isWatching,
    bool? isAwaitingReading,
    DateTime? capturedAt,
    bool clearCapturedAt = false,
    String? loadError,
    bool clearLoadError = false,
    String? uuid,
    CompassHeading? heading,
  }) {
    return CompassMainState(
      isLoading: isLoading ?? this.isLoading,
      isWatching: isWatching ?? this.isWatching,
      isAwaitingReading: isAwaitingReading ?? this.isAwaitingReading,
      capturedAt: clearCapturedAt ? null : (capturedAt ?? this.capturedAt),
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
      uuid: uuid ?? this.uuid,
      heading: heading ?? this.heading,
    );
  }
}

class CompassListState {
  final bool isLoading;
  final List<CompassInfo> compassList;
  final String errorMessage;

  const CompassListState({
    required this.isLoading,
    required this.compassList,
    required this.errorMessage,
  });

  factory CompassListState.initial() {
    return const CompassListState(
      isLoading: true,
      compassList: [],
      errorMessage: '',
    );
  }

  CompassListState copyWith({
    bool? isLoading,
    List<CompassInfo>? compassList,
    String? errorMessage,
  }) {
    return CompassListState(
      isLoading: isLoading ?? this.isLoading,
      compassList: compassList ?? this.compassList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
