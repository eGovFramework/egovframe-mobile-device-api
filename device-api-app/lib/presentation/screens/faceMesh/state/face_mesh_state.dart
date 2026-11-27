import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';

class FaceMeshMainState {
  final bool isLoading;
  final bool isProcessing;
  final FaceMeshSession? session;
  final String uuid;
  final String errorMessage;

  const FaceMeshMainState({
    required this.isLoading,
    required this.isProcessing,
    this.session,
    required this.uuid,
    required this.errorMessage,
  });

  factory FaceMeshMainState.initial() {
    return const FaceMeshMainState(
      isLoading: true,
      isProcessing: false,
      uuid: '',
      errorMessage: '',
    );
  }

  bool get hasResult => session != null;

  FaceMeshMainState copyWith({
    bool? isLoading,
    bool? isProcessing,
    FaceMeshSession? session,
    bool clearSession = false,
    String? uuid,
    String? errorMessage,
  }) {
    return FaceMeshMainState(
      isLoading: isLoading ?? this.isLoading,
      isProcessing: isProcessing ?? this.isProcessing,
      session: clearSession ? null : (session ?? this.session),
      uuid: uuid ?? this.uuid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class FaceMeshListState {
  final bool isLoading;
  final List<FaceMeshRecord> faceMeshList;
  final String errorMessage;

  const FaceMeshListState({
    required this.isLoading,
    required this.faceMeshList,
    required this.errorMessage,
  });

  factory FaceMeshListState.initial() {
    return const FaceMeshListState(
      isLoading: true,
      faceMeshList: [],
      errorMessage: '',
    );
  }

  FaceMeshListState copyWith({
    bool? isLoading,
    List<FaceMeshRecord>? faceMeshList,
    String? errorMessage,
  }) {
    return FaceMeshListState(
      isLoading: isLoading ?? this.isLoading,
      faceMeshList: faceMeshList ?? this.faceMeshList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class FaceMeshDetailState {
  final int sn;
  final FaceMeshRecord? record;
  final FaceMeshRecord? fallbackRecord;
  final bool isLoading;
  final bool isDeleting;
  final String? errorMessage;

  const FaceMeshDetailState({
    required this.sn,
    this.record,
    this.fallbackRecord,
    this.isLoading = false,
    this.isDeleting = false,
    this.errorMessage,
  });

  factory FaceMeshDetailState.initial({
    required int sn,
    FaceMeshRecord? fallbackRecord,
  }) =>
      FaceMeshDetailState(sn: sn, fallbackRecord: fallbackRecord);

  FaceMeshRecord? get displayRecord => record ?? fallbackRecord;

  FaceMeshDetailState copyWith({
    FaceMeshRecord? record,
    FaceMeshRecord? fallbackRecord,
    bool clearRecord = false,
    bool? isLoading,
    bool? isDeleting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FaceMeshDetailState(
      sn: sn,
      record: clearRecord ? null : (record ?? this.record),
      fallbackRecord: fallbackRecord ?? this.fallbackRecord,
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
