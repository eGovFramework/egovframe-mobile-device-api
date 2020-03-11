/**
 * 모바일 전자정부 하이브리드 앱 파일관리 가이드 프로그램 JavaScript
 * JavaScript.
 *
 * @author 장성호
 * @version 1.0
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2016. 8.04.    장성호 		신규생성
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
    
    $("#btninitPage").attr("href","javascript:fn_initPage_move();");
    $("#btnFile_Explorer").attr("href","javascript:fn_egov_move_localStorage();");
    $("#btnFileMgmt_Menu").attr("href","javascript:fn_egov_fileMenu_dialogue();");
    
    runPlugin();
}


function runPlugin() {
    
    console.log(">>applicationDirectory:"+ cordova.file.applicationDirectory);
    console.log(">>documentsDirectory  :"+ cordova.file.documentsDirectory);
    
    window.requestFileSystem(LocalFileSystem.PERSISTENT, 0,
                             function(fs){ // success get file system
                             console.log('DeviceAPIGuide fn_egov_localStorageInfo Success');
                             fileSystem = fs;
                             
                             window.resolveLocalFileSystemURL(cordova.file.documentsDirectory,
                                                              function(destfs){ // success get file system
                                                              dirEntry = destfs;
                                                              rootDirEntry = destfs;
                                                              
                                                              }, null);
                             
                             }, null);
}


function fn_initPage_move(){
    
    runPlugin();
    $.mobile.changePage("#main", "slide", false, false);
}


var _dir_create = "디렉토리 생성";
var _dirfile_delete = "디렉토리/파일 삭제";
var _dirfile_copy = "디렉토리/파일 복사";
var _dirfile_move = "디렉토리/파일 이동";

function fn_egov_fileMenu_dialogue() {
    
    var btmItem = [{id : 'button1', value: _dir_create},
                   {id : 'button2', value: _dirfile_delete},
                   {id : 'button3', value: _dirfile_copy},
                   {id : 'button4', value: _dirfile_move}];
    
    
    jActionSheet('', '메뉴', 'c', btmItem , function(r) {
        if(r != false){
            fn_egov_request_Action(r);
        }
    });
    
    
    
    
}

function fn_egov_request_Action(actionResult) {
    
    console.log(">>actionResult:" + actionResult);
    
    if ( _dir_create == actionResult){
        
        jPrompt('', 'Information', 'c',  function(r){
                if(r.length > 0){
                    $.mobile.loading("show");
                    fn_egov_Directory_Create(r);
                }else{
                    jAlert('디렉토리명이 입력되지 않았습니다.','알람','c',null);
                }
                }
        );
        
    } else if ( _dirfile_delete == actionResult){
        
        fn_egov_fileDir_Delete();
     
    } else if ( _dirfile_copy == actionResult){
        fn_egov_fileDir_Copy();
        
    } else if ( _dirfile_move == actionResult){
        fn_egov_fileDir_Move();
    
    }
    
}

/*********************************************************
 * File Directory
 *********************************************************/

/** File API 관련 공통 파일시스템 인스턴스 */
var fileSystem;

/** File API 관련 공통 디렉토리 인스턴스 */
var dirEntry;

/** File API 관련 공통 디렉토리 인스턴스(Panel용) */
var panelDirEntry;

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
 * 로컬 스토리지 조회 화면 이동 함수(Panel용)
 *
 * @returns
 * @type
 */
function fn_egov_move_localStorage_PanelMenu(){
    
    console.log("Open PanelMenu Start");
    
    panelDirEntry = dirEntry;
    
    fn_egov_readDirectory_Panel();
    
    $.mobile.activePage.find('#componentMenu').panel("open");
    
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
 * 디렉토리 정보 획득을 위한 인스턴스 생성 및 정보 획득(Panel용)
 * @returns
 * @type
 */
function fn_egov_readDirectory_Panel() {
    
    var directoryReader = panelDirEntry.createReader();
    directoryReader.readEntries(fn_egov_listDir_Panel, fn_egov_fileError);
}

/**
 * 디렉토리 위치 정보 획득 (
 * @returns
 * @type
 */
function fn_egov_goDirectory(directoryEntry) {
    console.log('DeviceAPIGuide fn_egov_readDirectory Success');
    dirEntry = directoryEntry;
    fn_egov_readDirectory();
}

function fn_egov_goDirectory_Panel(directoryEntry) {
    console.log('DeviceAPIGuide fn_egov_readDirectory_Panel Success');
    panelDirEntry = directoryEntry;
    fn_egov_readDirectory_Panel();
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

function fn_egov_chdir_Panel(dir) {
    if (dir == "../") {
        panelDirEntry.getParent(fn_egov_goDirectory_Panel, fn_egov_fileError);
    } else if (dir == "/") {
        panelDirEntry = fileSystem.root;
        fn_egov_readDirectory_Panel();
    } else {
        panelDirEntry.getDirectory(dir, {}, fn_egov_goDirectory_Panel, fn_egov_fileError);
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
       
        $('<li data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-icon-carat-r ui-li ui-li-has-thumb ui-btn-up-c ui-checkbox">'
          +'<div class="ui-btn-inner ui-li" aria-hidden="true">'
          +'<input type="checkbox" name="checkboxes" class="ui-checkbox" value="'+ subject +'" />'
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
 * 디렉토리 정보 조회 성공 후 파싱(Panel용)
 * @returns
 * @type
 */
function fn_egov_listDir_Panel(entries){
    console.log('DeviceAPIGuide fn_egov_listDir_Panel Success');
    
    $('#componentlistView').empty();
    
    $('<li data-theme="z" data-icon="delete" style="height: 2.8em;" class="ui-first-child">'
      +'<a href="#" data-rel="close" data-ajax="false" style="color:rgb(255, 255, 255);" class="ui-btn ui-btn-z ui-btn-icon-right ui-icon-delete">Close menu</a></li>').appendTo('#componentlistView');
    
    var linkVal = "";
    var imageSrc = "";
    var subject = "";
    var brief = "";
    var imageClass = "ui-li-thumb";
    var chboxHtml = "";
    
    
    if (panelDirEntry.fullPath != rootDirEntry.fullPath) {
        linkVal = "javascript:fn_egov_chdir_Panel('../');";
        imageSrc = "images/egovframework/mbl/hyb/folder.png";
        subject = "../";
        brief = "Go Up";
        
        $('<li data-theme="z"  style="height: 2.8em;" class="ui-last-child">'
          +'<a href="'+linkVal+'" data-ajax="true" style="color:#2649C5;" class="ui-btn ui-btn-g ui-btn-icon-right ui-icon-minus">'+ subject+ ' (' + brief+')</a></li>').appendTo('#componentlistView');
        
    }
    
    for ( var i = 0; i < entries.length; i++) {
        
        if (entries[i].isDirectory) {
            
            linkVal = "javascript:fn_egov_chdir_Panel('" + entries[i].name + "');";
            imageSrc = "images/egovframework/mbl/hyb/folder.png";
            subject = entries[i].name;
            brief = "Directory";
            imageClass = "ui-li-thumb";
            var sltlink = "javascript:fn_egov_request_selectedDirectory('" + entries[i].name + "');";

            $('<li data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-icon-plus ui-li ui-li-has-thumb ui-btn-up-c ui-checkbox">'
              +'<div class="ui-btn-inner ui-li" aria-hidden="true">'
              +'<input type="button" style="width:40px;" value="선택" onclick="'+sltlink+'" />'
              +'<div class="ui-btn-text" style="margin-left:60px;">'
              +'<a href="' + linkVal + '" class="ui-link-inherit" data-transition="pop" >'
              +'<h3 class="ui-li-heading">'
              + subject
              + ' (폴더)</h3>'
              + '</a></div><span class="ui-icon ui-icon-arrow-r ui-icon-shadow"></span></div></li>').appendTo('#componentlistView');
            
        }
        
    }
    
}


function fn_egov_request_selectedDirectory(dir){
    console.log(">>Selected Directory:"+ dir);
    
    console.log(">>processType:"+ processType);
    
    if(processType == _pType_Copy){
        jConfirm('선택된 폴더로 복사하시겠습니까?', '파일/폴더 복사', 'c', function(r) {
                 if (r == true) {
                 $.mobile.loading("show");
                 window.resolveLocalFileSystemURL(panelDirEntry.nativeURL + dir
                                                  , fn_egov_request_fileDir_Copy
                                                  , failFileProcess);
                 }
                 });
        
    }else if (processType == _pType_Move){
        jConfirm('선택된 폴더로 이동하시겠습니까?', '파일/폴더 이동', 'c', function(r) {
                 if (r == true) {
                 $.mobile.loading("show");
                 window.resolveLocalFileSystemURL(panelDirEntry.nativeURL + dir
                                                  , fn_egov_request_fileDir_Move
                                                  , failFileProcess);
                 }
                 });
        
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


function fn_egov_Directory_Create(tDirName){
    
    console.log(">>> fn_egov_Directory_Create Start <<<");
    console.log("dirEntry.nativeURL:" + dirEntry.nativeURL);
    console.log(">>tDirName:" + tDirName);
    
    window.resolveLocalFileSystemURL(dirEntry.nativeURL,
                                function createDir(cdir) {cdir.getDirectory(tDirName,
                                    {create:true, exclusive: false},
                                    function success(re) {
                                        console.log(">>CreateDirectory Success!!");
                                        $.mobile.loading("hide");
                                        fn_egov_readDirectory();
                                    }, failFileProcess);
                                  }, failFileProcess);
    
}

var chboxesCount;
var chboxes;
var processType;
var _pType_Copy = "_pType_Copy";
var _pType_Move = "_pType_Move"

function fn_egov_fileDir_Delete() {
    
    console.log(">>> fn_egov_fileDir_Delete Start <<<");
    
    chboxes = document.getElementsByName("checkboxes");
    
    console.log("chboxes.length:"+ chboxes.length);
    
    var vR = false;
    for(var i=0; i < chboxes.length ; i++){
        if(chboxes[i].checked) vR = true;
    }
    
    if(vR){
        jConfirm('선택된 파일(폴더)를 삭제하시겠습니까?', '파일/폴더 삭제', 'c', function(r) {
                 if (r == true) {
                    chboxesCount = chboxes.length -1;
                    $.mobile.loading("show");
                    fn_egov_request_fileDir_Delete();
                 }
                 });
    }else{
        jAlert('선택된 파일(폴더)이 없습니다.','Information','c',null);
    }
    
}

function fn_egov_request_fileDir_Delete() {
    
    if(chboxesCount > -1 && chboxes[chboxesCount].checked){
        var fileName = chboxes[chboxesCount].value;
        console.log(">>fileName:" + fileName);
        
        window.resolveLocalFileSystemURL(dirEntry.nativeURL + fileName,
                                         function onSuccess(fEntry){
                                         
                                            if(fEntry.isDirectory){
                                                fEntry.removeRecursively(function() {
                                                                            console.log(">>Remove Directory Succeeded");
                                                                        }, failFileProcess);
                                            }else {
                                                fEntry.remove(function() {
                                                              console.log(">>Remove File Succeeded");
                                                       }, failFileProcess);
                                            }
                                            chboxesCount = chboxesCount-1;
                                            fn_egov_request_fileDir_Delete();
                                         
                                         }, failFileProcess);
        
    }else if (chboxesCount > -1 && !chboxes[chboxesCount].checked){
        chboxesCount = chboxesCount-1;
        fn_egov_request_fileDir_Delete();
        
    }else{
        $.mobile.loading("hide");
        fn_egov_readDirectory();
    }

}

function fn_egov_fileDir_Copy() {
    
    console.log(">>> fn_egov_fileDir_Copy Start <<<");
    
    chboxes = document.getElementsByName("checkboxes");
    console.log("chboxes.length:"+ chboxes.length);
    
    var vR = false;
    for(var i=0; i < chboxes.length ; i++){
        if(chboxes[i].checked) vR = true;
    }
    
    if(vR){
        chboxesCount = chboxes.length -1;
        processType = _pType_Copy;
        fn_egov_move_localStorage_PanelMenu();
        
    }else{
        jAlert('선택된 파일(폴더)이 없습니다.','Information','c',null);
    }
    
}

function fn_egov_request_fileDir_Copy(pEntry) {
    
    if(chboxesCount > -1 && chboxes[chboxesCount].checked){
        
        var fileName = chboxes[chboxesCount].value;
        console.log(">>fileName:" + fileName);
        
        window.resolveLocalFileSystemURL(dirEntry.nativeURL + fileName,
                                         function onSuccess(fEntry){
                                         fEntry.copyTo(pEntry, fileName,
                                                       function succ(s) {
                                                       console.log('copying successful ['+chboxesCount+']' );
                                                       chboxesCount = chboxesCount-1;
                                                       fn_egov_request_fileDir_Copy(pEntry);
                                                       }, failFileProcess);
                                         }, failFileProcess);
    }else if (chboxesCount > -1 && !chboxes[chboxesCount].checked){
        chboxesCount = chboxesCount-1;
        fn_egov_request_fileDir_Copy(pEntry);
        
    }else{
        $.mobile.loading("hide");
        $.mobile.activePage.find('#componentMenu').panel("close");
        fn_egov_readDirectory();
    }
    
    
}

function fn_egov_fileDir_Move() {
    
    console.log(">>> fn_egov_fileDir_Move Start <<<");
    
    chboxes = document.getElementsByName("checkboxes");
    console.log("chboxes.length:"+ chboxes.length);
    
    var vR = false;
    for(var i=0; i < chboxes.length ; i++){
        if(chboxes[i].checked) vR = true;
    }
    
    if(vR){
        chboxesCount = chboxes.length -1;
        processType = _pType_Move;
        
        fn_egov_move_localStorage_PanelMenu();
        
    }else{
        jAlert('선택된 파일(폴더)이 없습니다.','Information','c',null);
    }
    
}

function fn_egov_request_fileDir_Move(pEntry) {
    
    if(chboxesCount > -1 && chboxes[chboxesCount].checked){
        
        var fileName = chboxes[chboxesCount].value;
        console.log(">>fileName:" + fileName);
        
        window.resolveLocalFileSystemURL(dirEntry.nativeURL + fileName,
                                         function onSuccess(fEntry){
                                         fEntry.moveTo(pEntry, fileName,
                                                       function succ(s) {
                                                       console.log('moveing successful ['+chboxesCount+']' );
                                                       chboxesCount = chboxesCount-1;
                                                       fn_egov_request_fileDir_Copy(pEntry);
                                                       }, failFileProcess);
                                         }, failFileProcess);
    }else if (chboxesCount > -1 && !chboxes[chboxesCount].checked){
        chboxesCount = chboxesCount-1;
        fn_egov_request_fileDir_Move(pEntry);
        
    }else{
        $.mobile.loading("hide");
        $.mobile.activePage.find('#componentMenu').panel("close");
        fn_egov_readDirectory();
    }
    
    
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