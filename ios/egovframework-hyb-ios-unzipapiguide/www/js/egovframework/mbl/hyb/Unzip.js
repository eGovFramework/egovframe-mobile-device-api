/**
 * @fileoverview 모바일 전자정부 하이브리드 앱 Network API 가이드 프로그램 JavaScript
 * JavaScript.
 *
 * @author 서형주
 * @version 1.0
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2015. 4. 20.   신용호 		iscroll5 적용
 * @ 2019.10. 07.   신용호        이미 압축되어 있는 파일인지 체크
 */

/*********************************************************
 * A TAG 링크 컨트롤
 *********************************************************/


/**
 * A tag의 링크 변경
 * @returns
 * @type
 */
function fn_egov_init_hrefLink(){
    
    $("#btnHomePage").attr("href","javascript:fn_homePage_move();");
    $("#btnFile_Explorer").attr("href","javascript:fn_egov_move_localStorage();");
    $("#btnSelectedfiles_Zip").attr("href","javascript:fn_egov_zip_dialogue();");
    
    runPlugin();
    fn_egov_localStorageInfo();
    
}


function runPlugin() {
    
    console.log(">>applicationDirectory:"+ cordova.file.applicationDirectory);
    console.log(">>documentsDirectory  :"+ cordova.file.documentsDirectory);
    console.log(">>tempDirectory       :"+ cordova.file.tempDirectory);
    console.log(">>cacheDirectory      :"+ cordova.file.cacheDirectory);
    
    window.resolveLocalFileSystemURL(cordova.file.applicationDirectory + "wwwUnzip/test2.zip",
                                     function(fs){ // success get file system
                                     console.log(">>test Zip folder :"+ fs);
                                     window.resolveLocalFileSystemURL(
                                            cordova.file.documentsDirectory,
                                            function(destfs){ // success get file system
                                                console.log('requestFileSystem Success -1');
                                                fs.copyTo(destfs,"test2.zip");
                                                                      
                                                console.log(">>>destfs.nativeURL:" + destfs.nativeURL);
                                                console.log(">>>destfs.fullPath:" + destfs.fullPath);
                                                                      
                                            }, function(evt){ // error get file system
                                                console.log('requestFileSystem Fail -2');
                                            }
                                            );
                                     
                                     }, function(evt){ // error get file system
                                     console.log('requestFileSystem Fail -1');
                                     }
                                     );
}


function fn_homePage_move(){
    
    fn_egov_localStorageInfo();
    $.mobile.changePage("#main", "slide", false, false);
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
 * Cordova File Plugin Fail 함수
 *
 * @returns
 * @type
 */
function failFileProcess(error){
    console.log(">> Error:"+error.code);
    
    if(error.code == "1"){
        jAlert('NOT_FOUND_ERR','Error','c',null);
    } else if(error.code == "2"){
        jAlert('SECURITY_ERR','Error','c',null);
    } else if(error.code == "3"){
        jAlert('ABORT_ERR','Error','c',null);
    } else if(error.code == "4"){
        jAlert('NOT_READABLE_ERR','Error','c',null);
    } else if(error.code == "5"){
        jAlert('ENCODING_ERR','Error','c',null);
    } else if(error.code == "6"){
        jAlert('NO_MODIFICATION_ALLOWED_ERR','Error','c',null);
    } else if(error.code == "7"){
        jAlert('INVALID_STATE_ERR','Error','c',null);
    } else if(error.code == "8"){
        jAlert('SYNTAX_ERR','Error','c',null);
    } else if(error.code == "9"){
        jAlert('INVALID_MODIFICATION_ERR','Error','c',null);
    } else if(error.code == "10"){
        jAlert('QUOTA_EXCEEDED_ERR','Error','c',null);
    } else if(error.code == "11"){
        jAlert('TYPE_MISMATCH_ERR','Error','c',null);
    } else if(error.code == "12"){
        jAlert('PATH_EXISTS_ERR','Error','c',null);
    }
    
    $.mobile.loading("hide");
}

/**
 * 로컬 스토리지 조회 화면 이동 함수
 *
 * @returns
 * @type
 */
function fn_egov_move_localStorage(){
    
    fn_egov_readDirectory();
    
    $.mobile.changePage("#localStorage", "slide", false, false);
}


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
                             
                             window.resolveLocalFileSystemURL(cordova.file.documentsDirectory,
                                                              function(destfs){ // success get file system
                                                              dirEntry = destfs;
                                                              rootDirEntry = destfs;
                                                              console.log('dirEntry.fullPath :' + dirEntry.fullPath);
                                                              }, function(evt){ // error get file system
                                                              console.log('requestFileSystem Fail -2');
                                                              }
                                                              );
                             
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
    
}




/**
 * 디렉토리 정보 조회 성공 후 파싱
 * @returns
 * @type
 */
function fn_egov_listDir(entries){
    console.log('DeviceAPIGuide fn_egov_listDir Success');
    
    $('#listView').empty();
    var linkVal = "";
    var imageSrc = "";
    var subject = "";
    var brief = "";
    var imageClass = "ui-li-thumb";
    var chboxHtml = "";
    if (dirEntry.fullPath != rootDirEntry.fullPath) {
        linkVal = "javascript:fn_egov_chdir('../');";
        imageSrc = "images/egovframework/mbl/hyb/folder.png";
        subject = "../";
        brief = "Go Up";
        
        $('<li data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-icon-carat-r ui-li ui-li-has-thumb ui-btn-up-c">'
          +'<div class="ui-btn-inner ui-li" aria-hidden="true"><div class="ui-btn-text" style="margin-left:25px" ><a href="'
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
        
        linkVal = "";
        if (entries[i].isFile) {
            
            imageSrc = "images/egovframework/mbl/hyb/file.png";
            subject = entries[i].name;
            imageClass = "ui-li-thumb-h";
            
            linkVal = "#";
            
            var ext = entries[i].name.split('.').pop().toLowerCase();
            if ("txt".indexOf(ext) >= 0) {
                brief = "Text";
            } else if ("png,jpg,jpeg,bmp".indexOf(ext) >= 0) {
                brief = "Image";
            } else if ("zip".indexOf(ext) >= 0) {
                brief = "Zip";
                imageSrc = "images/egovframework/mbl/hyb/zip.png";
                linkVal = "javascript:fn_egov_unzip_dialogue('" + subject + "', '압축해제');";
            } else {
                brief = "File";
            }
            
        } else {
            linkVal = "javascript:fn_egov_chdir('" + entries[i].name + "');";
            imageSrc = "images/egovframework/mbl/hyb/folder.png";
            subject = entries[i].name;
            brief = "Directory";
            imageClass = "ui-li-thumb";
        }
        
        if (dirEntry.fullPath != rootDirEntry.fullPath) {
            chboxHtml = '<input type="checkbox" name="checkboxes" class="ui-checkbox" value="'+ subject +'" />'
        }
        
        $('<li data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-icon-carat-r ui-li ui-li-has-thumb ui-btn-up-c ui-checkbox">'
          +'<div class="ui-btn-inner ui-li" aria-hidden="true">'
          + chboxHtml
          +'<div class="ui-btn-text" style="margin-left:25px">'
          +'<a href="' + linkVal + '" class="ui-link-inherit" data-transition="pop" ><img src="'
          + imageSrc + '" class="'+ imageClass +'" /><h3 class="ui-li-heading">'
          + subject
          + '</h3><p class="ui-li-desc">'
          + brief
          + '</p></a></div><span class="ui-icon ui-icon-arrow-r ui-icon-shadow"></span></div></li>').appendTo('#listView');
    }
    
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
 * 선택된 압축파일의 압푹풀기에 대한 다이얼로그 생성
 * @returns
 * @type
 */
function fn_egov_unzip_dialogue(subject, type) {
    
    var btmItem = [{id : 'button1', value: type}];
    
    jActionSheet('', '압축을 푸시겠습니까?', 'c', btmItem , function(r) {
                 console.log('>>>r : ' + r);
                 if(r != false){
                 fn_egov_request_unzipFile(subject);
                 }
                 });
    
}

function fn_egov_request_unzipFile(fileName){
    
    console.log("dirEntry.nativeURL:"+ dirEntry.nativeURL);
    console.log("dirEntry.fullPath:"+ dirEntry.fullPath);
    
    window.plugins.EgovZip.unzip(dirEntry.nativeURL+fileName, dirEntry.nativeURL, unzipSuccessCallback, unzipFailCallback);
    $.mobile.loading("show");
}


var unzipSuccessCallback = function(result) {
    $.mobile.loading("hide");
    fn_egov_readDirectory();
    
};

var unzipFailCallback = function(progressEvent) {
    console.log(">>> progress = "+progressEvent );
    $.mobile.loading("hide");
    fn_egov_readDirectory();
};

var chboxesCount;
var chboxes;

function fn_egov_zip_dialogue() {
    
    chboxes = document.getElementsByName("checkboxes");
    
    console.log("chboxes.length:"+ chboxes.length);
    
    var vR = false;
    for(var i=0; i < chboxes.length ; i++){
        if(chboxes[i].checked) {
            vR = true;
        
            // 이미 압축되어 있는 파일인지 체크
            var _fileName = chboxes[i].value;
            console.log(_fileName);
            // 확장자 명만 추출한 후 소문자로 변경
            var _lastDot = _fileName.lastIndexOf('.');
            var _fileLen = _fileName.length;
            var _fileExt = _fileName.substring(_lastDot, _fileLen).toLowerCase();
            console.log(_fileExt);
            if (_fileExt == ".zip") {
                alert("이미 압축되어 있습니다.");
                return;
            }
        }
    }
    
    if(vR){
        jConfirm('파일을 압축하시겠습니까?', '압축하기', 'c', function(r) {
                 if (r == true) {
                 fn_egov_request_MultizipFiles();
                 }
                 });
    }else{
        jAlert('선택된 파일이 없습니다.','Information','c',null);
    }
}

function fn_egov_request_MultizipFiles() {
    
    chboxesCount = chboxes.length - 1;
    $.mobile.loading("show");
    
    var tmpDirName = dirEntry.nativeURL.substring(0,dirEntry.nativeURL.length -1).split('/').pop().toString();
    
    console.log("dirEntry.nativeURL:" + dirEntry.nativeURL);
    console.log(">>tmpDirName:" + tmpDirName);
    
    window.resolveLocalFileSystemURL(
                                     cordova.file.cacheDirectory,
                                     
                                     function createDir(cdir) {
                                     cdir.getDirectory(tmpDirName, {create:true, exclusive: false},
                                                       function success(pEntry) {
                                                       fileCopyToProcess(pEntry);
                                                       }, failFileProcess);
                                     }, failFileProcess);
}

function fileCopyToProcess(pEntry){
    
    if(chboxesCount > -1 && chboxes[chboxesCount].checked){
        
        var fileName = chboxes[chboxesCount].value;
        console.log(">>fileName:" + fileName);
        
        window.resolveLocalFileSystemURL(dirEntry.nativeURL + fileName,
                                         function onSuccess(fEntry){
                                         fEntry.copyTo(pEntry, fileName,
                                                       function succ(s) {
                                                            console.log('copying successful ['+chboxesCount+']' );
                                                            chboxesCount = chboxesCount-1;
                                                            fileCopyToProcess(pEntry);
                                                       }, failFileProcess);
                                         }, failFileProcess);
    }else if (chboxesCount > -1 && !chboxes[chboxesCount].checked){
        chboxesCount = chboxesCount-1;
        fileCopyToProcess(pEntry);
    
    }else{
        fn_egov_request_zipDirectory(pEntry);
    }
        
}

function fn_egov_request_zipDirectory(sourcePath){
    
    /*Directory zip*/
    var zipDirName = dirEntry.nativeURL+dirEntry.nativeURL.substring(0,dirEntry.nativeURL.length -1).split('/').pop().toString()+ ".zip";
    console.log(">> zipDirName:" + zipDirName);
    
    window.plugins.EgovZip.zip(sourcePath.nativeURL, zipDirName, resultCallback, progressCallback);
    
}


function resultCallback(result) {
    removeTempZipDirectory();
    $.mobile.loading("hide");
    fn_egov_readDirectory();
    
};

function progressCallback(progressEvent) {
    $.mobile.loading("hide");
};

function removeTempZipDirectory(){
    
    var tmpDirName = dirEntry.nativeURL.substring(0,dirEntry.nativeURL.length -1).split('/').pop().toString();
    
    window.resolveLocalFileSystemURL(
                                     cordova.file.cacheDirectory,
                                     function createDir(cdir) {
                                     cdir.getDirectory(tmpDirName, {create:true, exclusive: false},
                                                       function onSuccess(entry) {
                                                       entry.removeRecursively(function() {
                                                                               console.log(">>Remove Recursively Succeeded");
                                                                               }, function fail(error) {
                                                                               console.log(">>Remove Recursively Error:"+error.code);
                                                                               });
                                                       },
                                                       function fail(error) {
                                                       console.log(">>Remove Recursively Error:"+error.code);
                                                       }
                                                       );
                                     },
                                     function fail() {
                                     console.log("Unable to locate the cache");
                                     }
                                     );
    
}



/*********************************************************
 * iScroll 컨트롤
 *********************************************************/

/** 디바이스 정보 리스트 페이지 iScroll */
var infoScroll;

/** 디바이스 정보 리스트 페이지 iScroll */
var detailScroll;

/** 디바이스 정보 리스트 페이지 iScroll */
var listScroll;


/**
 * iScroll 초기화 작업
 * @returns
 * @type
 */
function fn_egov_load_iScroll(){
    
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
               
               infoScroll = new IScroll("#infoWrapper", options);
               
               detailScroll = new IScroll("#detailWrapper", options);
               
               listScroll = new IScroll("#listWrapper", options);
               
               document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
               
               },500);
    
    
}

/*********************************************************
 * DeviceInfo VO 정의
 *********************************************************/

/** 디바이스 정보  VO */
var deviceInfoVO = {
    sn : "",
    uuid : "",
    os : "",
    telno : "",
    strgeInfo : "",
    ntwrkDeviceInfo : "",
    pgVer : "",
    deviceNm : "",
    useyn : ""
}

/*********************************************************
 * 배터리 상태 모니터링
 *********************************************************/

/**
 * 배터리 관련 이벤트 등록 함수
 * @returns
 * @type
 */
function fn_egov_regist_batteryInvent(){
    window.addEventListener("batterystatus", fn_egov_onBatteryStatus, false);
    window.addEventListener("batterylow", fn_egov_onBatteryLow, false);
    window.addEventListener("batterycritical", fn_egov_onBatteryCritical, false);
}

/**
 * 배터리 상태 정보 콜백 함수
 * @returns 
 * @type 
 */
function fn_egov_onBatteryStatus(info) {
    // Handle the online event
    console.log("DeviceAPIGuide fn_egov_onBatteryStatus Success"); 
    //navigator.notification.alert("Level: " + info.level + "%, isPlugged: " + info.isPlugged);
}

/**
 * 배터리 상태가 Low일때 호출되는 콜백 함수
 * @returns 
 * @type 
 */
function fn_egov_onBatteryLow(info) {
    // Handle the battery low event
    console.log("DeviceAPIGuide fn_egov_onBatteryLow Success"); 
    navigator.notification.alert("Battery Level Low " + info.level + "%"); 
}

/**
 * 배터리 경고 상태일 때 호출되는 콜백 함수
 * @returns 
 * @type 
 */
function fn_egov_onBatteryCritical(info) {
    // Handle the battery critical event
    console.log("DeviceAPIGuide fn_egov_onBatteryCritical Success"); 
    navigator.notification.alert("Battery Level Critical " + info.level + "%\nRecharge Soon!"); 
}

/*********************************************************
 * Network 정보 조회
 *********************************************************/

/**
 * Network 정보 조회 function.
 * @returns 
 * @type  
 */
function fn_egov_get_networkInfo() {
    var networkState = navigator.connection.type;
    
    var states = {};
    states[Connection.UNKNOWN]  = 'Unknown connection';
    states[Connection.ETHERNET] = 'Ethernet connection';
    states[Connection.WIFI]     = 'WiFi connection';
    states[Connection.CELL_2G]  = 'Cell 2G connection';
    states[Connection.CELL_3G]  = 'Cell 3G connection';
    states[Connection.CELL_4G]  = 'Cell 4G connection';
    states[Connection.NONE]     = 'No network connection';
    
    return states[networkState];
    
}

/*********************************************************
 * Custom Plug-In 결과 조회
 *********************************************************/

/**
 * 전체 메모리 조회에 대한 성공 콜백 함수
 * @returns 
 * @type 
 */
function fn_egov_totalSpace_success(result){
    
    console.log("DeviceAPIGuide totalFileSystemSize success");
    deviceInfoVO.strgeInfo = result;
    $('.deviceInfo:eq(5)').html(deviceInfoVO.strgeInfo);
    
    return result.totalSpace;
}

/**
 * 디바이스 전화번호 조회에 대한 성공 콜백 함수
 * @returns 
 * @type 
 */
function fn_egov_deviceNumber_success(result){
    
    console.log("DeviceAPIGuide fn_egov_deviceNumber success");
    deviceInfoVO.telno = result;
    $('.deviceInfo:eq(3)').html(deviceInfoVO.telno);
    
    return result.telno;
}

/**
 * Custom Plug-In 조회에 실패 콜백 함수
 * @returns 
 * @type 
 */
function fn_egov_fail(error){
    console.log("DeviceAPIGuide fn_egov_fail : " + error);
}






/*********************************************************
 * 3G 여부 체크
 *********************************************************/

/**
 * 3G 여부 체크
 * @returns 
 * @type 
 */
var  is3GConfirmed = false;

function fn_is3GConfirmed(index){
    
    if(is3GConfirmed != true){
        
        jConfirm('Wi Fi 망이 아닐경우 추가적인 비용이 발생 할 수 있습니다. \n계속 하시겠습니까?.', '알림', 'c', function(r) {
                 if (r == true) {
                 is3GConfirmed = true;
                 } else {
                 location.href=index;    
                 }
                 });
    }
}