/** 
 * @fileoverview 모바일 전자정부 하이브리드 앱 FileReaderWriter API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 나신일
 * @version 1.0 
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2015. 4. 20.   신용호 		iscroll5 적용 
 */

/*********************************************************
 * A TAG 링크 컨트롤
 *********************************************************/

/** 파일 읽기 메뉴 설명 */
var fileReadDescription = '<p>File Reader API 기능을 이용하여 모바일 디바이스의 디렉토리 및 파일을 조회 및 삭제하는 기능을 제공 함</p>';

/** 서버 전송 메뉴 설명 */
var fileTransferDescription = '<p>File Writer API 기능을 이용하여 모바일 디바이스의 파일을 서버로 전송하는 기능을 제공 함</p>'; 

/** 파일 복구 메뉴 설명 */
var fileRestoreDescription = '<p>File Writer API 기능을 이용하여 서버에 위치한 파일을 모바일 디바이스로 전송하는 기능을 제공 함</p>'; 

/** iScroll 객체 */
var myScroll;

/**
 * iScroll 적용
 * @returns 
 * @type 
 */
function loaded(scrollTarget) {
    
    // Use this for high compatibility (iDevice + Android)
	var options = {
            scrollX: true,
            scrollbars: true
        }

	console.log("device.version >>> "+device.version);
	if (parseFloat(device.version)>=4.0) {
		options["click"] = true;
	}

    setTimeout(function () {

    	myScroll = new IScroll(scrollTarget, options);
    	myScroll.refresh();
    	document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
    	
    },500);
}
/**
 * A tag의 링크 변경s
 * @returns 
 * @type 
 */
function fn_egov_init_hrefLink(){
    document.addEventListener("backbutton", backKeyDown, false);     
    $("#btnMoveLocalStorage").attr("href","javascript:fn_egov_move_localStorage();");
    $("#btnBackupFileList").attr("href","javascript:fn_egov_move_backup_file_list();");
    $("#btnMoveFileList").attr("href","javascript:fn_egov_load_fileInfoList();");
    $("#btnCaptureVideo").attr("href","javascript:fn_egov_captureVideo();");
    
    $(document).on("pageshow", "#localStorage", function(event, ui){
        if(myScroll != null) {
            
            myScroll.destroy();
        }
        loaded('#mainWrapper');
    });

    $(document).on("pageshow", "#serverFileList", function(event, ui){
        
        if(myScroll != null) {
            
            myScroll.destroy();
        }
        loaded('#subWrapper');
    });
}

/**
 * Android Back 버튼 클릭 이벤트 function.
 * @returns intro or importanceList 화면에서 종료하고 나머지 화면에선 back 처리
 * @type
*/

function backKeyDown(e) {	
    if($.mobile.activePage.is('#intro') || $.mobile.activePage.is('#main')){

        e.preventDefault();
        navigator.app.exitApp();

    }else{
        navigator.app.backHistory();
    }
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

/** 서버로부터 전송받은 파일 정보 리스트 */
var fileInfoList;

/**
 * 장치의 File System 정보 조회
 * @returns 
 * @type 
 */
function fn_egov_localStorageInfo() {
    window.requestFileSystem(LocalFileSystem.PERSISTENT, 0,
                        function(fs){ // success get file system
                             console.log('DeviceAPIGuide fn_egov_localStorageInfo Success');
                             fileSystem = fs;
                             dirEntry = fs.root;
                             rootDirEntry = fs.root;
                             
                        }, function(evt){ // error get file system
                             console.log('DeviceAPIGuide fn_egov_localStorageInfo Fail');
                        }
                    );
}

/**
 * 디렉토리 정보 획득을 위한 인스턴스 생성 및 정보 획득
 * @returns
 * @type 
 */
function fn_egov_readDirectory() {	
		
    var directoryReader = dirEntry.createReader();
    directoryReader.readEntries(fn_egov_listDir, fn_egov_fileError);
}

/**
 * 디렉토리 위치 정보 획득
 * @returns
 * @type 
 */
function fn_egov_goDirectory(directoryEntry) {
    console.log('DeviceAPIGuide fn_egov_readDirectory Success');
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
        dirEntry = fileSystem.root;
        fn_egov_readDirectory();
    } else {
        dirEntry.getDirectory(dir, {}, fn_egov_goDirectory, fn_egov_fileError);
    }
    
    myScroll.refresh();
}




/**
 * 디렉토리 정보 조회 성공 후 파싱
 * @returns 
 * @type 
 */
function fn_egov_listDir(entries){
    console.log('DeviceAPIGuide fn_egov_listDir Success');
        
    $('#listView').empty();
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
    for ( var i = 0; i < entries.length; i++) {
    	        
        if (entries[i].isFile) {
            
            imageSrc = "images/egovframework/mbl/hyb/file.png";
            subject = entries[i].name;
            
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
    
    myScroll.refresh();
}

/**
 * 디렉토리 정보 조회 실패
 * @returns 
 * @type 
 */
function fn_egov_fileError(error) {
    console.log('DeviceAPIGuide fn_egov_fileError Fail');
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
    //3G 사용시 과금이 발생 할 수 있다는 경고 메시지 표시
    if(!fn_egov_network_check(true)) {
        return;
    }

    $.mobile.loading("show");
    dirEntry.getFile(fileName, null, fn_egov_uploadFile, fn_egov_fail);

    
}


/**
 * 파라미터로 전달된 파일을 서버로 업로드 
 * @returns 
 * @type 
 */
function fn_egov_uploadFile(fileEntry) {
    console.log('DeviceAPIGuide fn_egov_uploadFile Success');
    var options = new FileUploadOptions();
    options.fileKey="file";
    options.fileName=fileEntry.name;
    options.mimeType="video/mp4";
    
    var params = {uuid :  device.uuid};
    options.params = params;    
    
    console.log("fileEntry.nativeURL : "+fileEntry.nativeURL);
    window.plugins.EgovInterface.geturl(function(serverURL) {
        var ft = new FileTransfer();
        ft.upload(fileEntry.nativeURL, serverURL + "/frw/xml/fileUpload.do?uuid=" + encodeURI(device.uuid), fn_egov_onFileUploadSuccess, fn_egov_fail, options);
	});
}


/**
 * 파일 업로드 Success Callback Function
 * @returns 
 * @type 
 */
function fn_egov_onFileUploadSuccess(r) {   
    console.log('DeviceAPIGuide fn_egov_onFileUploadSuccess request Completed');
    if(r.responseCode == 200 && r.response == "\"ok\""){
        navigator.notification.alert("파일 업로드 완료. 서버 목록을 확인해 주세요.", null, 'Info');
    }else{
        navigator.notification.alert("파일 업로드 실패", null, 'Info');
    }
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
    console.log('DeviceAPIGuide fn_egov_removeFileEntry Success');
    fileEntry.remove(fn_egov_fileRemoved, fn_egov_fail);
}


/**
 * 파일 삭제 완료 후 호출되는 Callback Function
 * @returns 
 * @type 
 */
function fn_egov_fileRemoved() {
    console.log('DeviceAPIGuide fn_egov_fileRemoved Success');
    navigator.notification.alert("File has been removed.", null, 'Info');
    fn_egov_readDirectory();
}


/**
 * 공통 fail Callback Function
 * @returns 
 * @type 
 */
function fn_egov_fail(error) {
    console.log('DeviceAPIGuide fn_egov_fail Fail');
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
    console.log('DeviceAPIGuide fn_egov_captureSuccess Success');
    var i, len;
    
    for (i = 0, len = mediaFiles.length; i < len; i += 1) {
        window.resolveLocalFileSystemURI(mediaFiles[i].fullPath, fn_egov_onResolveFileSuccess, fn_egov_fail);
    }
}

/**
 * 동영상 캡처에 대한 Fail Callback
 * @returns 
 * @type 
 */
function fn_egov_captureError(error) {
    console.log('DeviceAPIGuide fn_egov_captureError Fail');
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
    navigator.device.capture.captureVideo(fn_egov_captureSuccess, fn_egov_captureError, {limit: 1});
}

/**
 * 촬영된 동영상 FileEntry 조회 Success Callback Function
 * 조회된 동영상 파일을 Root 폴더로 복사
 * @returns 
 * @type 
 */
function fn_egov_onResolveFileSuccess(fileEntry) {
    console.log('DeviceAPIGuide fn_egov_onResolveFileSuccess Success');
    var date = new Date().getTime();
    fileEntry.copyTo(rootDirEntry, "M" + date + ".MOV", fn_egov_onFileCopySuccess, fn_egov_fail);
}


/**
 * 조회된 동영상 파일을 Root 폴더로 복사 Success Callback Function
 * 디렉토리 새로고침 수행
 * @returns 
 * @type 
 */
function fn_egov_onFileCopySuccess(fileEntry){
    console.log('DeviceAPIGuide fn_egov_onFileCopySuccess Success');
    navigator.notification.alert("동영상 캡처가 완료 되었습니다. 파일 읽기를 통해 확인 할 수 있습니다.", null, 'Info');
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
    
    fn_egov_readDirectory();
        
    $.mobile.changePage("#localStorage", "slide", false, false);
}

/**
 * 서버 백업 파일 조회 화면 이동 함수
 * 
 * @returns 
 * @type 
 */
function fn_egov_move_backup_file_list(){	
    $('#dirDescription').html(fileTransferDescription);//파일 전송에 대한 기능 설명 
    
    readDirType = 'upload';//리스트의 파일 선택시 사용자가 사용할 기능 정의
    fn_egov_readDirectory();
    $.mobile.changePage("#localStorage", "slide", false, false);
}

/**
 * 서버에 저장된 파일 리스트 조회 요청 함수
 * 
 * @returns 
 * @type 
 */
function fn_egov_load_fileInfoList(){	
    //3G 사용시 과금이 발생 할 수 있다는 경고 메시지 표시
    if(!fn_egov_network_check(false)) {
        return;
    }
    var acceptType = "xml";    
    $('#serverListDescription').html(fileRestoreDescription);//파일 복구에 대한 기능 설명 
    var params = {uuid :  device.uuid}
    
    window.plugins.EgovInterface.post("/frw/xml/fileInfoList.do", acceptType, params, fn_egov_make_FileInfoList);
}


/**
 * 
 * 서버에서 조회된 파일 리스트를 리스트 형태로 출력
 * @returns 
 * @type 
 */
function fn_egov_make_FileInfoList(xmldata){
    console.log('DeviceAPIGuide fn_egov_make_FileInfoList Success');
    var list_html = "";
    var nLoop = 0;
    var listCount = $(xmldata).find("fileInfoList").length;
    if (listCount < 1) {
        navigator.notification.alert("서버로 전송된 파일이 없습니다.", null, 'Info');
    }
    $(xmldata).find("fileInfoList").each(function(){
        var fileSn = $(this).find("fileSn").text();
        var fileNm = $(this).find("fileNm").text();
        var fileSize = $(this).find("fileSize").text();
        var linkVal = "javascript:fn_egov_open_down_dialogue('" + fileSn + "','" + fileNm + "');";
        nLoop++;
        list_html += '<li><a href="' + linkVal + '">';
        list_html += '<h3>' + fileNm + '</h3>';
        list_html += '<p><strong>Size : ' + fileSize + '</strong></p></a></li>';
        });

    var theList = $('#fileList');
    theList.html(list_html);
    $.mobile.changePage("#serverFileList", "slide", false, false);
    theList.listview("refresh");
}

/**
 * 선택된 파일에 대한 작업 선택 다이얼로그 생성(삭제 or 다운로드)
 * @returns 
 * @type 
 */
function fn_egov_open_down_dialogue(fileSn,fileNm) {	
    var btmItem = [{id : 'button1', value: "download"},
                   {id : 'button2', value: "delete"}];
    jActionSheet('', 'File Info', 'c', btmItem , function(r) {
                 if(r == "download"){
                    fn_egov_downloadFile(fileSn,fileNm);
                 }else if(r == "delete"){
                    fn_egov_delete_fileInfo(fileSn);

                 }
                 
                 });
}

/**
 * 선택된 파일을 서버에서 삭제한다.
 * @returns 
 * @type 
 */
function fn_egov_delete_fileInfo(fileSn){
    //3G 사용시 과금이 발생 할 수 있다는 경고 메시지 표시
    if(!fn_egov_network_check(false)) {
        return;
    }
    
    var acceptType = "xml";
    var params = {uuid :  device.uuid, fileSn : fileSn}
    
    window.plugins.EgovInterface.post("/frw/xml/deleteFile.do", acceptType, params,
                                     function(xmldata){
                                        console.log('DeviceAPIGuide fn_egov_delete_fileInfo request Completed');                                        
                                        if($(xmldata).find("resultState").text() == "OK"){	
                                            navigator.notification.alert($(xmldata).find("resultMessage").text(), null, 'Info');
                                            fn_egov_load_fileInfoList();
                                        } else {
                                            navigator.notification.alert($(xmldata).find("resultMessage").text(), null, 'Info');
                                        }
                                        
                                     });

}


/**
 * 선택된 파일을 서버에서 다운로드 받는다.
 * @returns 
 * @type 
 */
function fn_egov_downloadFile(fileSn,fileNm){	
    //3G 사용시 과금이 발생 할 수 있다는 경고 메시지 표시
    if(!fn_egov_network_check(true)) {
    	return;
    }
    
    $.mobile.loading("show");
    
    fileSystem.root.getFile(fileNm, {create: true, exclusive: false}, function(fileEntry) {
        //var localPath = fileEntry.fullPath;
    	var localPath = fileEntry.nativeURL;
        //localpath = localPath.substring(7);
        console.log("download localpath : " + localPath)
        
        window.plugins.EgovInterface.geturl(function(serverURL) {
            var fileTransfer = new FileTransfer();
            fileTransfer.download(
                    serverURL + "/frw/xml/fileDownload.do?uuid=" + encodeURI(device.uuid) + "&fileSn=" + fileSn,
                    localPath,
                    function(entry) {
                        console.log('DeviceAPIGuide fn_egov_downloadFile request Completed');
                        navigator.notification.alert("다운로드가 완료 되었습니다. 파일 읽기를 통해 확인 할 수 있습니다.", null, 'Info');
                        $.mobile.loading("hide");                          
                        },
                        function(error) {
                            console.log('DeviceAPIGuide fn_egov_downloadFile Fail');
                            $.mobile.loading("hide");
                            }
                        );
            });
    }, fn_egov_fail);
}

function permissionSuccess(status) {
    console.log('### check permission');
    if( !status.hasPermission ) {
        permissionError();
    } else {
        console.log('### permission is OK');
    }
}
