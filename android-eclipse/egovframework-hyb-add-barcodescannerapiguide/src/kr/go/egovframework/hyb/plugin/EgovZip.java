package kr.go.egovframework.hyb.plugin;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.StringTokenizer;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.Uri;
import android.util.Log;

public class EgovZip extends CordovaPlugin {

	
    private static final int COMPRESSION_LEVEL = 8;
    private static final int BUFFER_SIZE = 1024 * 2;
	
    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {
        
    	Log.d(this.getClass().getSimpleName(),">>>>> action = "+ action);
    	if ("unzip".equals(action)) {
    		
			String zipFile = Uri.parse(data.getString(0)).getPath(); //data.getString(0);			
			String targetDir = Uri.parse(data.getString(1)).getPath(); //data.getString(1);
			
			Log.d(this.getClass().getSimpleName(),">>>>> zipFile = "+ zipFile);
			Log.d(this.getClass().getSimpleName(),">>>>> targetDir = "+ targetDir);
            
			unzip(zipFile, targetDir, callbackContext);
			
            return true;
        }else if ("zip".equals(action)) {
    		
			String zipFile = Uri.parse(data.getString(0)).getPath(); //data.getString(0);			
			String targetDir = Uri.parse(data.getString(1)).getPath(); //data.getString(1);
			
			Log.d(this.getClass().getSimpleName(),">>>>> zipFile = "+ zipFile);
			Log.d(this.getClass().getSimpleName(),">>>>> targetDir = "+ targetDir);
            
			zip(zipFile, targetDir, callbackContext);
			
            return true;
        }
        return false;
    }

    
    private void unzip(String zipFile, String targetDir, CallbackContext callbackContext){
    	
    	try {
			unzip(zipFile, targetDir, false);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, new JSONObject()));
    	
    }
    
    private void zip(String zipFile, String targetDir, CallbackContext callbackContext){
    	
    	try {
			zip(zipFile, targetDir);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, new JSONObject()));
    	
    }
    
    /**
     * 지정된 폴더를 Zip 파일로 압축한다.
     * @param sourcePath - 압축 대상 디렉토리
     * @param output - 저장 zip 파일 이름
     * @throws Exception
     */
    public static void zip(String sourcePath, String output) throws Exception {

        // 압축 대상(sourcePath)이 디렉토리나 파일이 아니면 리턴한다.
        File sourceFile = new File(sourcePath);
        if (!sourceFile.isFile() && !sourceFile.isDirectory()) {
            throw new Exception("압축 대상의 파일을 찾을 수가 없습니다.");
        }

        // output 의 확장자가 zip이 아니면 리턴한다.
        //if (!(StringUtils.substringAfterLast(output, ".")).equalsIgnoreCase("zip")) {
        //    throw new Exception("압축 후 저장 파일명의 확장자를 확인하세요");
        //}

        FileOutputStream fos = null;
        BufferedOutputStream bos = null;
        ZipOutputStream zos = null;

        try {
            fos = new FileOutputStream(output); // FileOutputStream
            bos = new BufferedOutputStream(fos); // BufferedStream
            zos = new ZipOutputStream(bos); // ZipOutputStream
            zos.setLevel(COMPRESSION_LEVEL); // 압축 레벨 - 최대 압축률은 9, 디폴트 8
            
            zipEntry(sourceFile, sourcePath, zos); // Zip 파일 생성
            zos.finish(); // ZipOutputStream finish
        } finally {
            if (zos != null) {
                zos.close();
            }
            if (bos != null) {
                bos.close();
            }
            if (fos != null) {
                fos.close();
            }
        }
    }

    /**
     * 압축
     * @param sourceFile
     * @param sourcePath
     * @param zos
     * @throws Exception
     */
    private static void zipEntry(File sourceFile, String sourcePath, ZipOutputStream zos) throws Exception {
        // sourceFile 이 디렉토리인 경우 하위 파일 리스트 가져와 재귀호출
        if (sourceFile.isDirectory()) {
        	Log.d("dir >>>","dir = " +sourceFile.getPath());
            if (sourceFile.getName().equalsIgnoreCase(".metadata")) { // .metadata 디렉토리 return
                return;
            }
            File[] fileArray = sourceFile.listFiles(); // sourceFile 의 하위 파일 리스트
            for (int i = 0; i < fileArray.length; i++) {
                zipEntry(fileArray[i], sourcePath, zos); // 재귀 호출
            }
        } else { // sourcehFile 이 디렉토리가 아닌 경우
            BufferedInputStream bis = null;
            
            try {
                String sFilePath = sourceFile.getPath();
                Log.i("file >>>", sFilePath);
                //String zipEntryName = sFilePath.substring(sourcePath.length() + 1, sFilePath.length());
                StringTokenizer tok = new StringTokenizer(sFilePath,"/");
    			
    			int tok_len = tok.countTokens();
    			String zipEntryName=tok.toString();
    			while(tok_len != 0){
    				tok_len--;
    				zipEntryName = tok.nextToken();
    			}
                bis = new BufferedInputStream(new FileInputStream(sourceFile));
                
                ZipEntry zentry = new ZipEntry(zipEntryName);
                zentry.setTime(sourceFile.lastModified());
                zos.putNextEntry(zentry);

                byte[] buffer = new byte[BUFFER_SIZE];
                int cnt = 0;
                
                while ((cnt = bis.read(buffer, 0, BUFFER_SIZE)) != -1) {
                    zos.write(buffer, 0, cnt);
                }
                zos.closeEntry();
            } finally {
                if (bis != null) {
                    bis.close();
                }
            }
        }
    }

    /**
     * Zip 파일의 압축을 푼다.
     *
     * @param zipFile - 압축 풀 Zip 파일
     * @param targetDir - 압축 푼 파일이 들어간 디렉토리
     * @param fileNameToLowerCase - 파일명을 소문자로 바꿀지 여부
     * @throws Exception
     */
    public static void unzip(String zipFile, String targetDir, boolean fileNameToLowerCase) throws Exception {
        FileInputStream fis = null;
        ZipInputStream zis = null;
        ZipEntry zentry = null;

        try {
            fis = new FileInputStream(zipFile); // FileInputStream
            zis = new ZipInputStream(fis); // ZipInputStream

            while ((zentry = zis.getNextEntry()) != null) {
                String fileNameToUnzip = zentry.getName();
                if (fileNameToLowerCase) { // fileName toLowerCase
                    fileNameToUnzip = fileNameToUnzip.toLowerCase();
                }

                File targetFile = new File(targetDir, fileNameToUnzip);

                if (zentry.isDirectory()) {// Directory 인 경우
                    //FileUtils.makeDir(targetFile.getAbsolutePath()); // 디렉토리 생성
                    File path = new File(targetFile.getAbsolutePath());
                    path.mkdirs(); 
                } else { // File 인 경우
                    // parent Directory 생성
                   //FileUtils.makeDir(targetFile.getParent());
                    File path = new File(targetFile.getParent());
                    path.mkdirs(); 
                    unzipEntry(zis, targetFile);
                }
            }
        } finally {
            if (zis != null) {
                zis.close();
            }
            if (fis != null) {
                fis.close();
            }
        }
    }

    /**
     * Zip 파일의 한 개 엔트리의 압축을 푼다.
     *
     * @param zis - Zip Input Stream
     * @param filePath - 압축 풀린 파일의 경로
     * @return
     * @throws Exception
     */
    protected static File unzipEntry(ZipInputStream zis, File targetFile) throws Exception {
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(targetFile);

            byte[] buffer = new byte[BUFFER_SIZE];
            int len = 0;
            while ((len = zis.read(buffer)) != -1) {
                fos.write(buffer, 0, len);
            }
        } finally {
            if (fos != null) {
                fos.close();
            }
        }
        return targetFile;
    }

	
}
