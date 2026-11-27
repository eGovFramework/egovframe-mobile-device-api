import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/usecases/face_mesh_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/face_mesh_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/state/face_mesh_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'face_mesh_controller.g.dart';

FaceMeshUseCase _faceMeshUseCase(Ref ref) =>
    ref.read(faceMeshUseCaseProvider);

@riverpod
class FaceMeshMain extends _$FaceMeshMain {
  @override
  FaceMeshMainState build() {
    Future.microtask(_initialize);
    return FaceMeshMainState.initial();
  }

  Future<void> _initialize() async {
    final uuid = await _faceMeshUseCase(ref).getDeviceUuid();
    state = state.copyWith(isLoading: false, uuid: uuid);
  }

  Future<FaceMeshPickResult> pickAndDetect(ImageSource source) async {
    state = state.copyWith(isProcessing: true, errorMessage: '');

    final result = await _faceMeshUseCase(ref).pickAndDetect(source);

    switch (result) {
      case FaceMeshPickSuccess(:final session):
        state = state.copyWith(
          isProcessing: false,
          session: session,
          errorMessage: '',
        );
      case FaceMeshPickCancelled():
        state = state.copyWith(isProcessing: false);
      case FaceMeshPickPermissionDenied(:final message):
        state = state.copyWith(isProcessing: false, errorMessage: message);
      case FaceMeshPickFailure(:final message):
        state = state.copyWith(isProcessing: false, errorMessage: message);
    }

    return result;
  }

  void applySession(FaceMeshSession session) {
    final withSource = session.source == null
        ? session.copyWith(source: 'camera')
        : session;
    state = state.copyWith(session: withSource, errorMessage: '');
  }

  void clearResult() {
    state = state.copyWith(clearSession: true, errorMessage: '');
  }

  Future<FaceMeshUploadResult> uploadSession() async {
    final session = state.session;
    if (session == null || !session.hasFaces) {
      return const FaceMeshUploadFailure(
        FaceMeshMessageKeys.noDetectionData,
      );
    }
    return _faceMeshUseCase(ref).uploadSessionToStore(session);
  }
}

@riverpod
class FaceMeshList extends _$FaceMeshList {
  @override
  FaceMeshListState build() {
    Future.microtask(reload);
    return FaceMeshListState.initial();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _faceMeshUseCase(ref).loadList();

    switch (result) {
      case FaceMeshListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          faceMeshList: items,
          errorMessage: '',
        );
      case FaceMeshListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          faceMeshList: [],
          errorMessage: '',
        );
      case FaceMeshListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          faceMeshList: [],
          errorMessage: message,
        );
    }
  }

  /// faceGroupId soft delete (USE_YN='N')
  Future<FaceMeshDeleteBatchResult> deleteSelectedGroups(
    Iterable<String> faceGroupIds,
  ) async {
    final groupIdSet = faceGroupIds.toSet();
    if (groupIdSet.isEmpty) {
      return const FaceMeshDeleteBatchFailure(
        FaceMeshMessageKeys.noSelection,
      );
    }

    final items = state.faceMeshList
        .where((item) => groupIdSet.contains(item.faceGroupId))
        .toList();

    return _faceMeshUseCase(ref).deleteItems(items);
  }
}

@riverpod
class FaceMeshDetail extends _$FaceMeshDetail {
  @override
  FaceMeshDetailState build(int sn) {
    return FaceMeshDetailState.initial(sn: sn);
  }

  void initialize(FaceMeshRecord fallbackRecord) {
    state = state.copyWith(
      fallbackRecord: fallbackRecord,
      record: fallbackRecord,
      clearError: true,
    );
  }

  Future<FaceMeshDeleteBatchResult> deleteRecord() async {
    state = state.copyWith(isDeleting: true);

    final target = state.displayRecord;
    if (target == null) {
      state = state.copyWith(isDeleting: false);
      return const FaceMeshDeleteBatchFailure(
        FaceMeshMessageKeys.noSelection,
      );
    }

    final result = await _faceMeshUseCase(ref).deleteItems([target]);
    state = state.copyWith(isDeleting: false);
    return result;
  }
}
