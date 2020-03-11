package kr.go.egovframework.hyb.plugin;

import java.io.File;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;

import android.os.Environment;
import android.os.StatFs;

/**  
 * @Class Name : EgovStorageInfo.java
 * @Description : EgovStorageInfo.java Class
 * @Modification Information  
 * @
 * @  수정일       수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012.08.22   서형주                 최초생성
 * 
 *  Copyright (C) by MOPAS All right reserved.
 */

public class EgovStorageInfo extends CordovaPlugin  {

    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) {
        if ("fileSystemSize".equals(action)) {

            FileSystemSize fileSystemSize = new FileSystemSize();

            fileSystemSize.totalInternal = formatSize(getTotalInternalMemorySize());
            fileSystemSize.availableInternal = formatSize(getAvailableInternalMemorySize());
            if (isExternalMemoryAvailable() == true) {
                fileSystemSize.totalExternal = formatSize(getTotalExternalMemorySize());
                fileSystemSize.availableInternal = formatSize(getAvailableExternalMemorySize());
            }

            String memorySyze = fileSystemSize.totalInternal;

            if (fileSystemSize != null && memorySyze.length() > 0) {
            	callbackContext.success(memorySyze);
                return true;
            } else {
            	callbackContext.error("Expected one non-empty string argument.");
                return true;
            }
        } else {
            return false;
        }
    }

    private static boolean isExternalMemoryAvailable() {
        return Environment.getExternalStorageState().equals(
                Environment.MEDIA_MOUNTED);
    }

    private static long getTotalInternalMemorySize() {
        File path = Environment.getDataDirectory();
        StatFs stat = new StatFs(path.getPath());
        long blockSize = stat.getBlockSize();
        long totalBlocks = stat.getBlockCount();

        return totalBlocks * blockSize;
    }

    private static long getAvailableInternalMemorySize() {
        File path = Environment.getDataDirectory();
        StatFs stat = new StatFs(path.getPath());
        long blockSize = stat.getBlockSize();
        long availableBlocks = stat.getAvailableBlocks();

        return availableBlocks * blockSize;
    }

    private static long getTotalExternalMemorySize() {
        if (isExternalMemoryAvailable() == true) {
            File path = Environment.getExternalStorageDirectory();
            StatFs stat = new StatFs(path.getPath());
            long blockSize = stat.getBlockSize();
            long totalBlocks = stat.getBlockCount();

            return totalBlocks * blockSize;
        } else {
            return -1;
        }
    }

    private static long getAvailableExternalMemorySize() {
        if (isExternalMemoryAvailable() == true) {
            File path = Environment.getExternalStorageDirectory();
            StatFs stat = new StatFs(path.getPath());
            long blockSize = stat.getBlockSize();
            long availableBlocks = stat.getAvailableBlocks();

            return availableBlocks * blockSize;
        } else {
            return -1;
        }
    }

    private static String formatSize(long size) {
        long diskSize = size;
        String suffix = null;

        if (diskSize >= 1024) {
            suffix = "KB";
            diskSize /= 1024;
            if (diskSize >= 1024) {
                suffix = "MB";
                diskSize /= 1024;
            }
        }

        StringBuilder resultBuffer = new StringBuilder(Long.toString(diskSize));

        int commaOffset = resultBuffer.length() - 3;
        while (commaOffset > 0) {
            resultBuffer.insert(commaOffset, ',');
            commaOffset -= 3;
        }

        if (suffix != null) {
            resultBuffer.append(suffix);
        }

        return resultBuffer.toString();
    }

    public class FileSystemSize {

        String totalInternal;
        String availableInternal;
        String totalExternal;
        String availableExternal;

    }

}
