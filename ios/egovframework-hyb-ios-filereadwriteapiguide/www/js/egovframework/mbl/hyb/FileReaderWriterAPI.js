/** 
 * 모바일 전자정부 하이브리드 앱 FileReaderWriter API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2015. 6. 13.   신용호 		server URL EGovComModule에서 가져오도록 수정 
 */


/*********************************************************
 * A TAG 링크 컨트롤
 *********************************************************/

/** 파일 읽기 메뉴 설명 */
var fileReadDescription = '<p>File Reader API 기능을 이용하여 모바일 디바이스의 디렉토리 및 파일을 조회 및 삭제 할 수 있습니다.</p>';

/** 서버 전송 메뉴 설명 */
var fileTransferDescription = '<p>File Writer API 기능을 이용하여 모바일 디바이스의 파일을 서버로 전송 합니다.</p>'; 

/** 파일 복구 메뉴 설명 */
var fileRestoreDescription = '<p>File Writer API 기능을 이용하여 서버에 위치한 파일을 모바일 디바이스로 전송합니다.</p>'; 


/**
 * A tag의 링크 변경s
 * @returns
 * @type
 */
function fn_egov_init_hrefLink(){
    $("#btnMoveLocalStorage").attr("href","javascript:fn_egov_move_localStorage();");
    $("#btnBackupFileList").attr("href","javascript:fn_egov_move_backup_file_list();");
    $("#btnMoveFileList").attr("href","javascript:fn_egov_load_fileInfoList();");
    $("#btnCaptureVideo").attr("href","javascript:fn_egov_captureVideo();");

    EgovInterface.geturl(function(serverContext){
        console.log("DeviceAPIGuide serverContext Config Success");
        
        serverURL = serverContext; // EGovComModule.h 에서 가져온다.
        //alert("serverContext : "+ serverContext);
    });
    
}


/*********************************************************
 * iScroll 컨트롤 
 *********************************************************/
var mainiScroll;
var subiScroll;


/**
 * iScroll 초기화 작업
 * @returns 
 * @type 
 */
function fn_egov_load_iScroll(){

    //setTimeout(function () {
               
    mainiScroll = new IScroll('#mainWrapper', {
                            scrollX: true,
                            scrollbars: true,
                            mouseWheel: true,
                            interactiveScrollbars: true,
                            shrinkScrollbars: 'scale',
                            fadeScrollbars: true,
                            click: true
                        });
    subiScroll = new IScroll('#subWrapper', {
                            scrollX: true,
                            scrollbars: true,
                            mouseWheel: true,
                            interactiveScrollbars: true,
                            shrinkScrollbars: 'scale',
                            fadeScrollbars: true,
                            click: true
                        });
    
    document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
    //},500);

}


/*********************************************************
 * File Directory
 *********************************************************/

/** File API 관련 공통 파일시스템 인스턴스 */
var fileSystem; 

/** File API 관련 공통 디렉토리 인스턴스 */
var dirEntry;

/** File API 관련 root 디렉토리 인스턴스 */
var rootDirEntry;

/** 디렉토리 조회 타입 */
var readDirType;

/** 파일 업/다운로드 서버 URL */
//var serverURL = "http://192.168.100.140:8080/deviceWeb";
var serverURL = "";

/** 서버로부터 전송받은 파일 정보 리스트 */
var fileInfoList;





/**
 * 장치의 File System 정보 조회
 * @returns 
 * @type 
 */
function fn_egov_localStorageInfo() {
    console.log("[DeviceAPI Guide] fn_egov_localStorageInfo : Success ");
    window.requestFileSystem(LocalFileSystem.PERSISTENT, 0,
                        function(fs){ // success get file system
                            fileSystem = fs;
                            dirEntry = fs.root;
                            rootDirEntry = fs.root;
                            //fn_egov_readDirectory();
                            console.log("fn_egov_localStorageInfo : success callback");
                            //listDir(dirEntry);
                        }, function(evt){ // error get file system
                            console.log("File System Error: "+evt.target.error.code);
                        }
                    );
}

/**
 * 디렉토리 정보 획득을 위한 인스턴스 생성 및 정보 획득
 * @returns
 * @type 
 */
function fn_egov_readDirectory() {
    console.log("[DeviceAPI Guide] fn_egov_readDirectory : Success ");
	var directoryReader = dirEntry.createReader();
	directoryReader.readEntries(fn_egov_listDir, fn_egov_fileError);
}

/**
 * 디렉토리 위치 정보 획득
 * @returns
 * @type 
 */
function fn_egov_goDirectory(directoryEntry) {
	dirEntry = directoryEntry;
	fn_egov_readDirectory();
}

/**
 * 현재 파일 시스템 내, 위치 정보 획득
 * @returns
 * @type 
 */
function fn_egov_chdir(dir) {
	if (dir == "../") {
		dirEntry.getParent(fn_egov_goDirectory, fn_egov_fileError);
	} else if (dir == "/") {
        console.log("fn_egov_chdir : go to root Dir");
		dirEntry = fileSystem.root;
		fn_egov_readDirectory();
	} else {
		dirEntry.getDirectory(dir, {}, fn_egov_goDirectory, fn_egov_fileError);
	}
}




/**
 * 디렉토리 정보 조회 성공 후 파싱
 * @returns 
 * @type 
 */
function fn_egov_listDir(entries){

    $('#listView').text("");
	var linkVal = "javascript:fn_egov_chdir('/');";
	var imageSrc = "images/egovframework/mbl/hyb/folder.png";
	var subject = "/";
	var brief = "Go to root";
    
	if (dirEntry.fullPath != fileSystem.root.fullPath) {
        $('<li data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-li-has-thumb ui-btn-up-c"><div class="ui-btn-inner ui-li" aria-hidden="true"><div class="ui-btn-text"><a href="'
        + linkVal
        + '" class="ui-link-inherit" data-transition="flip" ><img src="'
        + imageSrc
        + '" class="ui-li-thumb" /><h3 class="ui-li-heading">'
        + subject
        + '</h3><p class="ui-li-desc">'
        + brief
        + '</p></a></div><span class="ui-icon ui-icon-arrow-r ui-icon-shadow"></span></div></li>').appendTo('#listView');
        
		linkVal = "javascript:fn_egov_chdir('../');";
		imageSrc = "images/egovframework/mbl/hyb/folder.png";
		subject = "../";
		brief = "Go Up";
		
        $('<li data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-li-has-thumb ui-btn-up-c"><div class="ui-btn-inner ui-li" aria-hidden="true"><div class="ui-btn-text"><a href="'
        + linkVal
        + '" class="ui-link-inherit" data-transition="flip" ><img src="'
        + imageSrc
        + '" class="ui-li-thumb" /><h3 class="ui-li-heading">'
        + subject
        + '</h3><p class="ui-li-desc">'
        + brief
        + '</p></a></div><span class="ui-icon ui-icon-arrow-r ui-icon-shadow"></span></div></li>').appendTo('#listView');
	}
    
    if(entries.length == 1){
        navigator.notification.alert("모바일 기기 파일 쓰기를 먼저 진행해 주세요.", null, 'Info');
    }
    
	for ( var i = 0; i < entries.length; i++) {
        
        
		if (entries[i].isFile) {
            
			imageSrc = "images/egovframework/mbl/hyb/file.png";
			subject = entries[i].name;
            console.log(">>>>>"+entries[i].fullPath);
            console.log(">>> "+fileSystem.root.toURL());
            console.log(">>> "+fileSystem.root.nativeURL);

            
			var ext = entries[i].name.split('.').pop().toLowerCase();
			if ("txt".indexOf(ext) >= 0) {
				brief = "Text";
			} else if ("png,jpg,jpeg,bmp".indexOf(ext) >= 0) {
				brief = "Image";
			} else {
				brief = "File";
			}
			
			linkVal = "javascript:fn_egov_open_dir_dialogue('" + subject + "', '" + readDirType + "');";
		} else {
			linkVal = "javascript:fn_egov_chdir('" + entries[i].name + "');";
			imageSrc = "images/egovframework/mbl/hyb/folder.png";
			subject = entries[i].name;
			brief = "Directory";
		}
        
		$('<li data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-li-has-thumb ui-btn-up-c"><div class="ui-btn-inner ui-li" aria-hidden="true"><div class="ui-btn-text"><a href="'
        + linkVal
        + '" class="ui-link-inherit" data-transition="pop" ><img src="'
        + imageSrc
        + '" class="ui-li-thumb" /><h3 class="ui-li-heading">'
        + subject
        + '</h3><p class="ui-li-desc">'
        + brief
        + '</p></a></div><span class="ui-icon ui-icon-arrow-r ui-icon-shadow"></span></div></li>').appendTo('#listView');
	}
    console.log("[DeviceAPI Guide] fn_egov_listDir : Success ");
    
    mainiScroll.refresh();
}

/**
 * 디렉토리 정보 조회 실패
 * @returns 
 * @type 
 */
function fn_egov_fileError(error) {
    console.log('listDir readEntries error: '+error.code);
}


/**
 * 선택된 파일에 대한 작업 선택 다이얼로그 생성
 * @returns 
 * @type 
 */
function fn_egov_open_dir_dialogue(subject, type) {
    var btmItem = [{id : 'button1', value: type}];
    jActionSheet('', 'File Info', 'c', btmItem , function(r) {
                if(r == "upload"){
                    fn_egov_request_uploadFile(subject);
                }else if(r == "delete"){
                    fn_egov_deleteFile(subject);
                }
                 
            });
}




/**
 * 선택된 파일에 대한 파일 업로드 호출
 * @returns 
 * @type 
 */
function fn_egov_request_uploadFile(fileName){
    $.mobile.loading("show");
    console.log(" path >>> "+dirEntry.fullPath);
    dirEntry.getFile(fileName, null, fn_egov_uploadFile, fn_egov_fail);

    
}


/**
 * 파라미터로 전달된 파일을 서버로 업로드 
 * @returns 
 * @type 
 */
function fn_egov_uploadFile(fileEntry) {
    var options = new FileUploadOptions();
    options.fileKey="file";
    options.fileName=fileEntry.name;
    options.mimeType="video/quicktime";
    
    var params = {uuid :  device.uuid};
    options.params = params;
    
    console.log("fn_egov_uploadFile : " + options.params.uuid);
    var ft = new FileTransfer();
    
    console.log("*** upload path : "+fileEntry.fullPath);
    console.log("*** upload path : "+fileEntry.nativeURL);

    ft.upload(fileEntry.nativeURL, serverURL + "/frw/fileUpload.do?uuid=" + encodeURI(device.uuid), fn_egov_onFileUploadSuccess, fn_egov_upload_fail, options);
}


/**
 * 파일 업로드 Success Callback Function
 * @returns 
 * @type 
 */
function fn_egov_onFileUploadSuccess(r) {
    //디버그 코드
    console.log(">>> Code = " + r.responseCode);
    console.log(">>> Response = " + r.response);
    console.log(">>> Sent = " + r.bytesSent);
    

    if(r.responseCode == 200 && r.response){
        navigator.notification.alert("파일 업로드 완료. 서버 목록을 확인해 주세요.", null, 'Info');
    }else{
        navigator.notification.alert("파일 업로드 실패", null, 'Info');
    }
    $.mobile.loading("hide");
    console.log("[DeviceAPI Guide] fn_egov_onFileUploadSuccess : Completed ");
}

/**
 * 파일 업로드 fail Callback Function
 * @returns
 * @type
 */
function fn_egov_upload_fail(error) {
    navigator.notification.alert("파일 업로드 실패", null, 'Info');
    console.log("[DeviceAPI Guide] fn_egov_fileRemoved : fn_egov_upload_fail, error code = " + error.code);
    //navigator.notification.alert(error.code, null, 'Info');
    $.mobile.loading("hide");
}


/**
 * 선택된 파일에 대한 삭제 요청
 * @returns 
 * @type 
 */
function fn_egov_deleteFile(fileName){
    if (confirm("Do you want to Delete it?")) {
        dirEntry.getFile(fileName, null, fn_egov_removeFileEntry, fn_egov_fail);
    }
}

/**
 * 검색된 파일에 대한 삭제 수행
 * @returns 
 * @type 
 */
function fn_egov_removeFileEntry(fileEntry) {
    fileEntry.remove(fn_egov_fileRemoved, fn_egov_fail);
}


/**
 * 파일 삭제 완료 후 호출되는 Callback Function
 * @returns 
 * @type 
 */
function fn_egov_fileRemoved() {
    console.log("[DeviceAPI Guide] fn_egov_fileRemoved : Success ");
    navigator.notification.alert("File has been removed.", null, 'Info');
    fn_egov_readDirectory();
    //self.location = "#explorer";
}


/**
 * 공통 fail Callback Function
 * @returns 
 * @type 
 */
function fn_egov_fail(error) {
    console.log("[DeviceAPI Guide] fn_egov_fileRemoved : fn_egov_fail, error code = " + error.code);
    //navigator.notification.alert(error.code, null, 'Info');
    $.mobile.loading("hide");
}


/*********************************************************
 * Capture
 *********************************************************/

/**
 * 동영상 캡처에 대한 Success Callback
 * 촬영된 동영상 FileEntry 조회
 * @returns 
 * @type 
 */
function fn_egov_captureSuccess(mediaFiles) {
    
    console.log("[DeviceAPI Guide] fn_egov_captureSuccess : Success ");
    
    var i, len;
    
    for (i = 0, len = mediaFiles.length; i < len; i += 1) {

        window.resolveLocalFileSystemURI("file://" + mediaFiles[i].fullPath, fn_egov_onResolveFileSuccess, fn_egov_fail);

   
    }
}

/**
 * 동영상 캡처에 대한 Fail Callback
 * @returns 
 * @type 
 */
function fn_egov_captureError(error) {
    var msg = '';
    if(error.code == CaptureError.CAPTURE_NO_MEDIA_FILES){
        msg = '캡처가 중단 되었습니다.';
    }else{
        msg = 'An error occurred during capture: ' + error.code;
    }
    
    navigator.notification.alert(msg, null, 'Info');
}

/**
 * 디바이스의 동영상 캡처 기능을 호출
 * @returns 
 * @type 
 */
function fn_egov_captureVideo() {

    navigator.device.capture.captureVideo(fn_egov_captureSuccess, fn_egov_captureError, {limit: 2});
}

/**
 * 촬영된 동영상 FileEntry 조회 Success Callback Function
 * 조회된 동영상 파일을 Document 폴더로 복사
 * @returns 
 * @type 
 */
function fn_egov_onResolveFileSuccess(fileEntry) {
    var date = new Date().getTime();
    console.log("[DeviceAPI Guide] fn_egov_onResolveFileSuccess : " + fileEntry.name + " created");
    fileEntry.copyTo(rootDirEntry, "M" + date + ".MOV", fn_egov_onFileCopySuccess, fn_egov_fail);
}


/**
 * 조회된 동영상 파일을 Document 폴더로 복사 Success Callback Function
 * 디렉토리 새로고침 수행
 * @returns 
 * @type 
 */
function fn_egov_onFileCopySuccess(fileEntry){
    console.log("[DeviceAPI Guide] fn_egov_onFileCopySuccess : Success " + fileEntry.name);
    navigator.notification.alert("동영상 캡처가 완료 되었습니다. 파일 읽기를 통해 확인 할 수 있습니다.", null, 'Info');
    //fn_egov_readDirectory();
}

/*********************************************************
 * Server Info List Controll
 *********************************************************/

/**
 * 로컬 스토리지 조회 화면 이동 함수
 * 
 * @returns 
 * @type 
 */
function fn_egov_move_localStorage(){
    
    $('#dirDescription').html(fileReadDescription);//파일 조회에 대한 기능 설명 
    
    readDirType = 'delete';//리스트의 파일 선택시 사용자가 사용할 기능 정의
    
    console.log("TEST1");
    
    fn_egov_readDirectory();
    var theList = $('#fileList');

    theList.html("");
    $.mobile.changePage("#localStorage");
    theList.listview("refresh");
}




/**
 * 서버 백업 파일 조회 화면 이동 함수
 * 
 * @returns 
 * @type 
 */
function fn_egov_move_backup_file_list(){
    
    if(!fn_egov_network_check(false)){
        return false;
    }
    
    $('#dirDescription').html(fileTransferDescription);//파일 전송에 대한 기능 설명 
    
    readDirType = 'upload';//리스트의 파일 선택시 사용자가 사용할 기능 정의
    fn_egov_readDirectory();
    var theList = $('#fileList');
    theList.html("");
    $.mobile.changePage("#localStorage");
    theList.listview("refresh"); 
}




/**
 * 서버에 저장된 파일 리스트 조회 요청 함수
 * @returns 
 * @type 
 */
function fn_egov_load_fileInfoList(){
    
    if(!fn_egov_network_check(false)){
        return false;
    }
    
    $('#serverListDescription').html(fileRestoreDescription);//파일 복구에 대한 기능 설명 
    var params = {uuid :  device.uuid}
    
    EgovInterface.submitAsynchronous([params, "/frw/fileInfoList.do"],
                                    fn_egov_make_FileInfoList,
                                    function(error) {
                                    $("#alert_dialog").click( function() {
                                                            jAlert('데이터 전송 중 오류가 발생 했습니다.', '전송 오류', 'c');
                                                        });
                                    });
}


/**
 * 
 * 서버에서 조회된 파일 리스트를 리스트 형태로 출력
 * @returns 
 * @type 
 */
function fn_egov_make_FileInfoList(data){
    if(data){
        var list_html = "";
        var totcnt = data.fileInfoList.length;
        
        if(totcnt == 0){
            navigator.notification.alert("서버로 전송된 파일이 없습니다.", null, 'Info');
        }
        
        fileInfoList = data.fileInfoList; 

        for (var i = 0; i < totcnt; i++) {
            result = data.fileInfoList[i];
            
            var linkVal = "javascript:fn_egov_open_down_dialogue('" + i + "');";
            
            list_html += '<li><a href="' + linkVal + '">';
            list_html += '<h3>' + result.fileNm + '</h3>';
            list_html += '<p><strong>Size : ' + result.fileSize + '</strong></p></a></li>';
            
        }
        

        var theList = $('#fileList');
        theList.html(list_html);

        $.mobile.changePage("#serverFileList");
        theList.listview("refresh");
        subiScroll.refresh();
        console.log("[DeviceAPI Guide] fn_egov_make_FileInfoList : Completed");
    }else{
        navigator.notification.alert("서버 오류.", null, 'Info');
        console.log("[DeviceAPI Guide] fn_egov_delete_fileInfo : Server Error");
    }
}


/**
 * 선택된 파일에 대한 작업 선택 다이얼로그 생성(삭제 or 다운로드)
 * @returns
 * @type
 */
function fn_egov_open_down_dialogue(fileNum) {
    var btmItem = [{id : 'button1', value: "download"},
                   {id : 'button2', value: "delete"}];
    jActionSheet('', 'File Info', 'c', btmItem , function(r) {
                if(r == "download"){
                    fn_egov_downloadFile(fileNum);
                }else if(r == "delete"){
                    fn_egov_delete_fileInfo(fileNum);
 
                }
                 
                });
}

/**
 * 선택된 파일을 서버에서 삭제한다.
 * @returns 
 * @type 
 */
function fn_egov_delete_fileInfo(fileNum){
    
    if(!fn_egov_network_check(false)){
        return false;
    }
    var params = {uuid :  device.uuid, fileSn : fileInfoList[fileNum].fileSn}
    console.log("fn_egov_delete_fileInfo : " + params.fileSn);
    EgovInterface.submitAsynchronous([params, "/frw/deleteFile.do"],
                                     function(result){
                                     var str = result["resultCode"];
                                        if(result){
                                             navigator.notification.alert("삭제 완료.", null, 'Info');
                                             console.log("[DeviceAPI Guide] fn_egov_delete_fileInfo : Completed");
                                         
                                        fn_egov_load_fileInfoList();
                                        }else{
                                             navigator.notification.alert("서버 오류.", null, 'Info');
                                             console.log("[DeviceAPI Guide] fn_egov_delete_fileInfo : Server Error");
                                        }
                                        
                                    },
                                    function(error) {
                                    $("#alert_dialog").click( function() {
                                                                jAlert('데이터 삭제 중 오류가 발생 했습니다.', '삭제 오류', 'c');
                                                            });
                                    }
                                    );
    
}


/**
 * 선택된 파일을 서버에서 다운로드 받는다.
 * @returns 
 * @type 
 */
function fn_egov_downloadFile(fileNum){
    
    if(!fn_egov_network_check(false)){
        return false;
    }
    var fileTransfer = new FileTransfer();
    $.mobile.loading("show");
    fileTransfer.download(
                        serverURL + "/frw/fileDownload.do?uuid=" + encodeURI(device.uuid) + "&fileSn=" + encodeURI(fileInfoList[fileNum].fileSn),
                        rootDirEntry.nativeURL + "/" +  fileInfoList[fileNum].fileNm,
                        function(entry) {
                            console.log("download complete: " + entry.fullPath);
                            navigator.notification.alert("다운로드가 완료 되었습니다. 파일 읽기를 통해 확인 할 수 있습니다.", null, 'Info');
                            $.mobile.loading("hide");

                            console.log("[DeviceAPI Guide] fn_egov_downloadFile : Completed");
                          
                        },
                        function(error) {
                            navigator.notification.alert("서버 오류.", null, 'Info');
                            console.log("download error source " + error.source);
                            console.log("download error target " + error.target);
                            console.log("download error code" + error.code);
                            $.mobile.loading("hide");
                        });
}





