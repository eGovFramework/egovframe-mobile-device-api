# Flutter 관련 규칙
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Maps 관련 규칙
-keep class com.google.android.gms.maps.** { *; }
-keep class com.google.android.gms.location.** { *; }
-keep class com.google.android.gms.common.** { *; }

# Google Maps 메모리 최적화
-keep class com.google.android.gms.maps.model.** { *; }
-keep class com.google.android.gms.maps.GoogleMap** { *; }
-keep class com.google.android.gms.maps.CameraUpdate** { *; }

# ImageReader 최적화
-keep class android.media.ImageReader { *; }
-keep class android.media.Image { *; }
-keep class android.media.Image$Plane { *; }

# 메모리 최적화
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-dontpreverify

# Google Maps 메모리 최적화
-keep class com.google.android.gms.maps.** { *; }
-keep class com.google.android.gms.location.** { *; }
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.maps.model.** { *; }
-keep class com.google.android.gms.maps.GoogleMap** { *; }
-keep class com.google.android.gms.maps.CameraUpdate** { *; }

# Flutter 메모리 최적화
-keep class io.flutter.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }

# 네트워크 관련 규칙
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }

# JSON 관련 규칙
-keep class com.google.gson.** { *; }
-keep class com.fasterxml.jackson.** { *; }

# 일반적인 Android 규칙
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# 네이티브 메서드 규칙
-keepclasseswithmembernames class * {
    native <methods>;
}

# Serializable 규칙
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Google Play Core 관련 규칙 (deferred components 미사용 시 경고 무시)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
