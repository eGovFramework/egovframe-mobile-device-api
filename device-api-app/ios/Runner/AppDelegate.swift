import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Google Maps API 키 설정 (Info.plist에서 읽어옴)
    if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
       let plist = NSDictionary(contentsOfFile: path),
       let apiKey = plist["GMSApiKey"] as? String {
      GMSServices.provideAPIKey(apiKey)
    }
    
    // RAM 정보 수집을 위한 플랫폼 채널 설정
    guard let controller = window?.rootViewController as? FlutterViewController else {
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    let ramChannel = FlutterMethodChannel(name: "egovframe_mobile_deviceapi_app/ram_info", binaryMessenger: controller.binaryMessenger)
    
    ramChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getTotalRam" {
        let ramInfo = self.getTotalRam()
        result(ramInfo)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func getTotalRam() -> String {
    var info = mach_task_basic_info()
    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
    
    let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
      $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
        task_info(mach_task_self_,
                 task_flavor_t(MACH_TASK_BASIC_INFO),
                 $0,
                 &count)
      }
    }
    
    if kerr == KERN_SUCCESS {
      // 물리 메모리 정보 가져오기
      var hostSize = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
      var hostInfo = vm_statistics64()
      let hostResult = withUnsafeMutablePointer(to: &hostInfo) {
        $0.withMemoryRebound(to: integer_t.self, capacity: Int(hostSize)) {
          host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &hostSize)
        }
      }
      
      if hostResult == KERN_SUCCESS {
        let totalPages = Int64(hostInfo.free_count + hostInfo.active_count + hostInfo.inactive_count + hostInfo.wire_count + hostInfo.compressor_page_count)
        let pageSize = vm_kernel_page_size
        let totalMemory = totalPages * Int64(pageSize)
        let totalMemoryGB = Double(totalMemory) / (1024.0 * 1024.0 * 1024.0)
        
        let freePages = Int64(hostInfo.free_count)
        let freeMemory = freePages * Int64(pageSize)
        let freeMemoryGB = Double(freeMemory) / (1024.0 * 1024.0 * 1024.0)
        
        //return String(format: "Total: %.1f GB, Available: %.1f GB", totalMemoryGB, freeMemoryGB)
        return String(format: "Total: %.1f GB",totalMemoryGB)
      }
    }
    
    return "Unknown"
  }
}
