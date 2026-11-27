/// 미디어 기능의 사진첩(갤러리) 연동 옵션.
///
/// 기본값은 모두 `false`이며, 이 경우 **기존 동작만** 수행합니다.
/// (앱 `Documents/media/` 저장 · 로컬 삭제만)
///
/// 사용 예:
/// ```dart
/// // 카메라 촬영 시 사진첩에도 저장
/// static const bool saveCameraCaptureToGallery = true;
///
/// // 로컬 삭제 시 사진첩 연동 항목도 삭제
/// static const bool deleteFromGalleryWhenLocalDeleted = true;
/// ```
abstract final class MediaGalleryOptions {
  /// **카메라 촬영 시 사진첩 저장**
  ///
  /// `true`: 카메라로 촬영한 이미지/비디오를 앱 로컬(`Documents/media/`)에 저장한 뒤 기기 사진첩(갤러리)에도 복사합니다. 갤러리에서 고른 파일은 대상이 아닙니다.
  /// `false`(기본): 앱 로컬에만 저장합니다. (기존 동작)
  static const bool saveCameraCaptureToGallery = true;

  /// **로컬 삭제 시 사진첩 연동 삭제**
  ///
  /// `true`: 앱에서 로컬 미디어를 삭제할 때, [saveCameraCaptureToGallery]로 사진첩에 저장되며 연동 ID가 기록된 파일이면 사진첩에서도 함께 삭제합니다.
  /// `false`(기본): 앱 로컬 파일만 삭제합니다. (기존 동작)
  ///
  /// 참고: 이 옵션만 `true`이고 저장 옵션이 `false`이면 연동 기록이 없어 사진첩 삭제는 수행되지 않습니다.
  static const bool deleteFromGalleryWhenLocalDeleted = true;
}
