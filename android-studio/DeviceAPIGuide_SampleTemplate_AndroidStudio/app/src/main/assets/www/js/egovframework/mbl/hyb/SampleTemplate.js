/** 
 * 표준 샘플 템플릿 주요 데이터베이스 관련 로직 구현 js
 * JavaScript. 
 *
 * @author 이율경
 * @version 1.0 
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2015. 4. 20.   신용호 		iscroll5 적용 
 */


/*********************************************************
 * 표준 샘플 템플릿 SQLLite를 이용하기 위한 설정 및 Query String
 *********************************************************/

/** 데이터베이스 연결 인스턴스 */
var db;

/** Table Id 맵핑을 위한 JSON 데이터 */
var tableIdTable;

/** Table Id */
var tableId;

/** 테이블 생성을 위한 Query String JSON 데이터 */
var tableCreateQueryString;


/*********************************************************
 * 성공 및 실패 관련 Function
 *********************************************************/

/**
 * 데이터베이스 관련 성공 callback 함수
 * @returns 
 * @type 
 */
function fn_egov_databaseSuccess() {
    console.log("DeviceAPIGuide fn_egov_databaseSuccess Success");
}

/**
 * 데이터베이스 관련 실패 callback 함수
 * @returns 
 * @type 
 */
function fn_egov_databaseError(err) {
    
    console.log("DeviceAPIGuide fn_egov_databaseError Error");
    return true;
}


/*********************************************************
 * 데이터베이스 관련 초기화 Function
 *********************************************************/

/**
 * 데이터베이스 연결 및 테이블 초기화, 
 * @returns 
 * @type 
 */
function fn_egov_initDatabase() {
    
    fn_egov_initTableId();
    fn_egov_initTableCreateQueryString();
    
    db = window.openDatabase("deviceAPI", "1.0", "Sample Template", 2000000);
    
    db.transaction(fn_egov_createTable, fn_egov_databaseError, fn_egov_databaseSuccess);
}

/**
 * 테이블 생성
 * @returns 
 * @type 
 */
function fn_egov_createTable(tx) {
    
    tx.executeSql(tableCreateQueryString["ACCELERATOR"]);
    tx.executeSql(tableCreateQueryString["GPS"]);
    tx.executeSql(tableCreateQueryString["VIBRATOR"]);
    tx.executeSql(tableCreateQueryString["CAMERA"]);
    tx.executeSql(tableCreateQueryString["MEDIA"]);
    tx.executeSql(tableCreateQueryString["CONTACTS"]);
    tx.executeSql(tableCreateQueryString["COMPASS"]);
    tx.executeSql(tableCreateQueryString["FILE"]);
    tx.executeSql(tableCreateQueryString["NETWORK"]);
    tx.executeSql(tableCreateQueryString["DEVICE"]);
}

/**
 * TableId 맵핑을 위한 JSON 데이터 초기화
 * @returns 
 * @type 
 */
function fn_egov_initTableId() {
    
    tableIdTable = new Object();
    
    tableIdTable = {
                "accelerator" : "ACCELERATOR",
                "gps" : "GPS",
                "vibrator" : "VIBRATOR",
                "camera" : "CAMERA",
                "media" : "MEDIA",
                "contacts" : "CONTACTS",
                "compass" : "COMPASS",
                "file" : "FILE",
                "network" : "NETWORK",
                "device" : "DEVICE"
            };
}


/*********************************************************
 * 데이터베이스 관련 Quert String Function
 *********************************************************/

/**
 * 테이블 생성을 위한 Query String 생성
 * @returns 
 * @type 
 */
function fn_egov_initTableCreateQueryString() {
    
    tableCreateQueryString = {
                                "ACCELERATOR" : "CREATE TABLE IF NOT EXISTS ACCELERATOR " +
                                        "(no integer primary key autoincrement, x_axis text not null, y_axis text not null, z_axis text not null, comment text, log_date text)",
                                        
                                "GPS" : "CREATE TABLE IF NOT EXISTS GPS " +
                                        "(no integer primary key autoincrement, latitude, longitude, comment text, log_date text)",
                                        
                                "VIBRATOR" : "CREATE TABLE IF NOT EXISTS VIBRATOR " +
                                        "(no integer primary key autoincrement, comment text, log_date text)",
                                        
                                "CAMERA" : "CREATE TABLE IF NOT EXISTS CAMERA " +
                                        "(no integer primary key autoincrement, image_uri text, comment text, log_date text)",
                                        
                                "MEDIA" : "CREATE TABLE IF NOT EXISTS MEDIA " +
                                        "(no integer primary key autoincrement, play_list text, comment text, log_date text)",
                                        
                                "CONTACTS" : "CREATE TABLE IF NOT EXISTS CONTACTS " +
                                        "(no integer primary key autoincrement, contact_total integer, comment text, log_date text)",
                                        
                                "COMPASS" : "CREATE TABLE IF NOT EXISTS COMPASS " +
                                        "(no integer primary key autoincrement, heading text, comment text, log_date text)",
                                        
                                "FILE" : "CREATE TABLE IF NOT EXISTS FILE " +
                                        "(no integer primary key autoincrement, file_list text, comment text, log_date text)",
                                        
                                "NETWORK" : "CREATE TABLE IF NOT EXISTS NETWORK " +
                                        "(no integer primary key autoincrement, network text, comment text, log_date text)",
                                        
                                "DEVICE" : "CREATE TABLE IF NOT EXISTS DEVICE " +
                                        "(no integer primary key autoincrement, os text, version text, uuid text, comment text, log_date text)",
                            };
}

/**
 * 데이터 저장을 위한 Query
 * @returns 디바이스API별 데이터 저장을 위한 Query String
 * @type JSON
 */
function fn_egov_getInsertAPIInfo(data) {
    
    var sql;
    data.log_date = new Date().format("YYYY-MM-DD hh:mm:ss");
    
    switch(tableId) {
    
        case "ACCELERATOR" :
            sql = "INSERT INTO ACCELERATOR (x_axis, y_axis, z_axis, log_date) " +
                    "VALUES ('" + data.x_axis + "', '" + data.y_axis + "', '" + data.z_axis + "', '" + data.log_date + "')";
            break;
        case "GPS" : 
            sql = "INSERT INTO GPS (latitude, longitude, log_date) " +
                    "VALUES ('" + data.latitude + "', '" + data.longitude + "', '" + data.log_date + "')";
            break;    
        case "VIBRATOR" : 
            sql = "INSERT INTO VIBRATOR (log_date) " +
                        "VALUES ('" + data.log_date + "')";
            break;            
        case "CAMERA" : 
            sql = "INSERT INTO CAMERA (image_uri, log_date) " +
                        "VALUES ('" + data.image_uri + "', '" + data.log_date + "')";
            break;            
        case "MEDIA" : 
            sql = "INSERT INTO MEDIA (play_list, log_date) " +
                        "VALUES ('" + data.play_list + "', '" + data.log_date + "')";
            break;            
        case "CONTACTS" : 
            sql = "INSERT INTO CONTACTS (contact_total, log_date) " +
                        "VALUES ('" + data.contact_total + "', '" + data.log_date + "')";
            break;            
        case "COMPASS" : 
            sql = "INSERT INTO COMPASS (heading, log_date) " +
                        "VALUES ('" + data.heading + "', '" + data.log_date + "')";
            break;            
        case "FILE" : 
            sql = "INSERT INTO FILE (file_list, log_date) " +
                        "VALUES ('" + data.file_list + "', '" + data.log_date + "')";
            break;            
        case "NETWORK" : 
            sql = "INSERT INTO NETWORK (network, log_date) " +
                        "VALUES ('" + data.network + "', '" + data.log_date + "')";
            break;            
        case "DEVICE" : 
            sql = "INSERT INTO DEVICE (os, version, uuid, log_date)" +
                        "VALUES ('" + data.os + "', '" + data.version + "', '" + data.uuid + "', '" + data.log_date + "')";
            break;
    }
    
    db.transaction(function(tx){
        tx.executeSql(sql);
    }, fn_egov_databaseError);
    
}

/**
 * 데이터 변경을 위한 Query String 생성
 * @returns 디바이스API별 데이터 변경을 위한 Query String
 * @type integer, String
 */
function fn_egov_getUpdateQueryString(no, comment) {
    
    var sql = "UPDATE " + tableId + " SET comment = '" + comment + "' WHERE no = " + no;
    
    return sql;
}

/**
 * 데이터 삭제를 위한 Query String 생성
 * @returns 디바이스API별 데이터 변경을 위한 Query String
 * @type integer, String
 */
function fn_egov_getDeleteQueryString(no) {
    
    var sql = "DELETE FROM " + tableId + " WHERE no = " + no;
    
    return sql;
}

/**
 * 데이터 조회를 위한 Query String 생성
 * @returns 디바이스API별 데이터 조회를 위한 Query String
 * @type 
 */
function fn_egov_getSelectListQueryString() {
    
    var sql = "SELECT * from " + tableId + " ORDER BY no DESC";

    return sql;
}

/**
 * 데이터 상세 조회를 위한 Query String 생성
 * @returns 디바이스API별 데이터 상세조회를 위한 Query String
 * @type integer
 */
function fn_egov_getSelectDetailQueryString(no) {
    
    var sql = "SELECT * from " + tableId + " WHERE no = " + no;
    
    return sql;
}

/** 
 * 표준 샘플 템플릿 주요 로직 구현 js
 * JavaScript. 
 *
 * @author 이율경
 * @version 1.0 
 */

/*********************************************************
 * 표준 샘플 템플릿을 위한 공통
 *********************************************************/

/** Media 제어를 위한 인스턴스 */
var mediaObj = null;

/** iscroll를 적용하기 위한 공통 */
var myScroll;

var deviceAPIDoc = "모바일 디바이스 실행환경 표준 템플릿은" + 
                    "모바일 디바이스 API 실행환경을 활용하여" +
                    "하이브리드 앱을 개발하시는 분들이 구현 시 " +
                    "참고 및 활용될 수 있도록 핵심 디바이스 API에 대한" +
                    "샘플템플릿 앱 ";

/**
 * 에러 callback 함수
 * @returns
 * @type 
 */
function fn_egov_error(message) {
    
    alert("Error!\n[" + message + "]");
    console.log("DeviceAPIGuide fn_egov_error Error");
}

/**
 * Success callback 함수공 for fn_egov_currentMediaInfo
 * @returns
 * @type
 */
function fn_egov_success(){
    console.log("DeviceAPIGuide fn_egov_success Success");
}

Date.prototype.format = function(format){
    
        var date = this;
        
        format = format.replace('YYYY', date.getFullYear());
        format = format.replace('MM',   zeroPad(date.getMonth() + 1));
        format = format.replace('DD',   zeroPad(date.getDate()));
        format = format.replace('hh',   zeroPad(date.getHours()));
        format = format.replace('mm',   zeroPad(date.getMinutes()));
        format = format.replace('ss',   zeroPad(date.getSeconds()));
        
        return format;
    };

function zeroPad(number) {
    
    return ( ( number < 10 ) ? "0" : "" ) + String(number);
    
}

/*********************************************************
 * CRUD 관련 함수
 *********************************************************/

/**
 * 로그 정보의 Comment 저장
 * @returns
 * @type 
 */
function fn_egov_saveComment() {
    
    var no = $("#comment").attr("name");
    var comment = $("#comment").val();
    
    jConfirm("저장하시겠습니까?", "알림", "b", function(result){
        
        if(result) {
            db.transaction(function(tx){
                tx.executeSql(fn_egov_getUpdateQueryString(no, comment));
            }, fn_egov_databaseError, function(result){  jAlert("저장되었습니다", "알림", "b"); });
            
            fn_egov_displayLogInfoDetail(no);
        }
    });

}

/**
 * 로그 정보의 삭제
 * @returns
 * @type 
 */
function fn_egov_deleteLogInfo(no) {
    
    jConfirm("삭제하시겠습니까?", "알림", "b", function(result){
        
        if(result) {
            db.transaction(function(tx){
                tx.executeSql(fn_egov_getDeleteQueryString(no));
            }, fn_egov_databaseError, function(){                                                 
                                                
                                                $("#listInfoDetail").empty();
                                                jAlert("삭제되었습니다", "알림", "b");
                                            });
            
            fn_egov_displayDeviceAPIInfoList();
        }
    });
}

/*********************************************************
 * HTML 및 이벤트 관련 함수
 *********************************************************/



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
 * 화면을 위한 관련 이벤트
 */
$(function(){

    
    $.validator.setDefaults({
        
        onkeyup:false,
        onclick:false,
        onfocusout:false,
        
        submitHandler: function() { 
            
            fn_egov_saveComment();
            return false;
         },
         invalidHandler: function(form, validator) {
             
         },
         showErrors:function(errorMap, errorList){
             
             if(this.numberOfInvalids()) {
                 
                 jAlert(errorList[0].message, "알림", "b");
             }
         }
        
    });
    
    $("#commentForm").validate();


    $("#save").click(function(){

        $("#commentForm").submit();
    });

    $(document).on('pageshow', '#list', function(event, ui) {
        
        fn_egov_configList();
        
    });
    
    $(document).on('pagehide', '#list', function(event, ui) {
        
        $("#infoDetail").empty();
    });
    
    $(document).on('pageshow', '#apiListView', function(event, ui) {
        
        fn_egov_displayDeviceAPIInfoList();
        
        if(myScroll != null) {
            
            myScroll.destroy();
        }
        loaded('#wrapper_list');
    });
    
    $(document).on('pagehide', '#apiListView', function(event, ui) {
        
        $("#listInfoDetail").empty();
        fn_egov_displayComment(false);
    });
    
    $(document).on('pageshow', '#explorer', function(event, ui) {
        
        if(myScroll != null) {
            
            myScroll.destroy();
        }
        loaded('#wrapper_explorer');
    });
    
});

/**
 * 디바이스 API 준비 완료 후 기본 정보 설정
 * @returns 
 * @type 
 */
function DeviceAPIInit() {  
    fn_egov_initDatabase();
    fn_egov_configList();
    
    // file API를 이용하기 위한 setting.
    window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, gotFS, fn_egov_error);
}

/**
 * 목록 출력을 위한 기본 설정
 * @returns 
 * @type 
 */
function fn_egov_configList() {
    
    $("#infoDetail").html(deviceAPIDoc);
    if(myScroll != null) {
            
        myScroll.destroy();
    }
    
    loaded('#wrapper');
}

/**
 * 디바이스 API 정보 출력
 * @returns 
 * @type 
 */
function fn_egov_operateDevice(deviceAPI) {
    
    tableId = tableIdTable[deviceAPI];
    fn_egov_currentDeviceAPIInfo();
}

/**
 * 로그 목록 페이지로 이동
 * @returns
 * @type 
 */
function fn_egov_changePage(deviceAPI) {
    
    var id = deviceAPI.substring(1, deviceAPI.length+1);
    var name = $("#" + id).text();
    
    $("#apiTitle").text(name);
        
    tableId = tableIdTable[id];
    
    $.mobile.changePage($("#apiListView"));
}

/**
 * 로그 상세조회 데이터 Display
 * @returns 상세조회를 위한 Display HTML
 * @type 
 */
function fn_egov_displayLogInfoDetail(no) {
    
    db.transaction(function(tx){
        tx.executeSql(fn_egov_getSelectDetailQueryString(no), [], fn_egov_displayLogInfoHtml);
    }, fn_egov_databaseError);
}

/**
 * 로그 상세조회 Display HTML 생성 및 출력
 * @returns
 * @type 
 */
function fn_egov_displayLogInfoHtml(tx, results) {
    
    var data = results.rows.item(0);
    
    fn_egov_displayDeviceAPIInfoDetail(data, "listInfoDetail");
    
    fn_egov_displayComment(true);
}


/**
 * 상세조회 데이터 Display
 * @returns 상세조회를 위한 Display HTML
 * @type 
 */
function fn_egov_displayDeviceAPIInfoDetail(data, target) {
    
    var html = "";
    var comment = "";
    switch(tableId) {
    
        case "ACCELERATOR" :
            html += "<span> X : " + data.x_axis + "<br>" + "Y : " + data.y_axis + "<br>" + "Z : "  + data.z_axis + "</span>";
            break;
        case "GPS" :
            html += "<span> 위도 : " + data.latitude + "<br>" + "경도 : " + data.longitude + "</span>";
            break;    
        case "VIBRATOR" :
            html += "<span><img src='images/egovframework/mbl/hyb/ico_vibration.png' ></span>"
            break;            
        case "CAMERA" : 
            html += '<span class="camera"><img src="' + data.image_uri + '"></span>';
            break;            
        case "MEDIA" : 
            if(target == "infoDetail") {
                html += '<span><img src=\'images/egovframework/mbl/hyb/ico_movie.png\' onclick="javascript:fn_egov_stopMediaAPI();"></span>';
            } else {
                html += "<span><img src=\'images/egovframework/mbl/hyb/ico_movie.png\'></span><br>";
                html += "<span> " + data.play_list + "</span>";
            }
            break;            
        case "CONTACTS" : 
            html += '<span class="contactus"> 검색된 연락처 총 ' + data.contact_total + '개  </span>';
            break;            
        case "COMPASS" : 
            html += "<span> 방위각 : " + data.heading + " </span>";
            break;            
        case "FILE" : 
            html += "<span> " + data.file_list + " </span>";
            break;            
        case "NETWORK" : 
            html += '<span> Network : ' + data.network + ' </span>';
            break;            
        case "DEVICE" : 
            html += '<span class="textL"> OS : ' + data.os + " " + data.version + '<br>' + 'UUID : ' + data.uuid + ' </span>';
            break;
            
    }
    
    var curTime;
    if(target == "infoDetail") {
        
        curTime = new Date().format("YYYY-MM-DD hh:mm:ss");
        
    } else {
        
        if(data.comment != null && data.comment != "") {
            
            comment += "<br>Comment: " + data.comment;
        }
        
        curTime = data.log_date;
        
        $("#comment").attr("name", data.no);
        
    }
    
    switch(tableId) {
    
        case "DEVICE" : 
            html += '<span class="textL">' + curTime + comment + ' </span>';
            break;
        case "CONTACTS" :
        case "CAMERA" :
            html += curTime + comment;
            break;
        default :
            html += "<br>" + curTime + comment;
    }
    
    $("#" + target).html(html);
}

/**
 * 목록조회 데이터 Display
 * @returns 목록조회를 위한 Display HTML
 * @type 
 */
function fn_egov_displayDeviceAPIInfoList() {
    
    fn_egov_stopMediaAPI();
    
    db.transaction(function(tx){
                    tx.executeSql(fn_egov_getSelectListQueryString(), [], fn_egov_displayListHtml);
                }, fn_egov_databaseError);
        
}

/**
 * 목록조회 Display HTML 생성 및 출력
 * @returns
 * @type 
 */
function fn_egov_displayListHtml(tx, results) {
    
    var rows = results.rows;
    var html = "";
    
    for ( var i = 0; i < rows.length; i++) {
        
        var log_date = rows.item(i).log_date;
        
        html += '<li> ' + 
                    '<a href="#" onclick="fn_egov_displayLogInfoDetail(' + rows.item(i).no + ')">' + log_date + '</a> ' +
                    '<a href="#" onclick="fn_egov_deleteLogInfo(' + rows.item(i).no + ')"></a>' +
                '</li>';
    }
    
    
    $("#dataList").html(html).listview('refresh');
    
    if(rows.length > 0) {
        
        $("#comment").attr("disabled" ,false);
        $("#save").attr("disabled" ,false);
        
        fn_egov_displayComment(false);
        
    } else if(rows.length == 0) {

        jAlert('조회된 데이터가 없습니다.', '알림', 'b');

        $("#listInfoDetail").empty();
        $("#comment").val("");
        
        $("#comment").attr("disabled" ,true);
        $("#save").attr("disabled" ,true);
        
        fn_egov_displayComment(false);
    }
    
}


function fn_egov_displayComment(display) {
    
    if(display) {
        
        $("#commentBox").show();
        $("#wrapper_list").css("top", "256px");
        
        $("#comment").val("");
    } else {
        
        $("#commentBox").hide();
        $("#wrapper_list").css("top", "200px");
    }
    
    if(myScroll != null) {
        
        myScroll.refresh();
    }
}

/*********************************************************
 * 디바이스API 제어 관련 함수
 *********************************************************/

/**
 * 디바이스 API 정보 출력 Control 
 * @returns
 * @type 
 */
function fn_egov_currentDeviceAPIInfo() {
    
    fn_egov_stopMediaAPI();
    console.log("DeviceAPIGuide fn_egov_currentDeviceAPIInfo Success");
    
    switch(tableId) {
    
        case "ACCELERATOR" :
            navigator.accelerometer.getCurrentAcceleration(fn_egov_currentAcceleratorInfo, fn_egov_error);
            break;
        case "GPS" : 
            navigator.geolocation.getCurrentPosition(fn_egov_currentGPSInfo, fn_egov_error);
            break;    
        case "VIBRATOR" :
            fn_egov_currentVibratorInfo();
            break;            
        case "CAMERA" : 
            var Camera = navigator.camera;
            var cameraOption  = {
                        quality: 50,
                        destinationType : Camera.DestinationType.FILE_URI,
                        sourceType : Camera.PictureSourceType.CAMERA,
                        targetWidth: 100,
                        targetHeight: 100
                                };
            navigator.camera.getPicture(fn_egov_currentCameraInfo, fn_egov_error, cameraOption);
            break;            
        case "MEDIA" : 
            fn_egov_currentMediaInfo();
            break;            
        case "CONTACTS" : 
            var options = new ContactFindOptions();
            options.filter = "";
            options.multiple = true;
        	
        	var fields = ["id", "displayName", "name", "phoneNumbers", "emails"];
            navigator.contacts.find(fields, fn_egov_currentContactsInfo, fn_egov_error, options);
            break;            
        case "COMPASS" : 
            navigator.compass.getCurrentHeading(fn_egov_currentCompassInfo, fn_egov_error);
            break;            
        case "FILE" : 
            
            //page-params/jqm.page.params.js/////////////
            $(document).bind("pagebeforechange", function(event, data) {
                $.mobile.pageData = (data && data.options && data.options.pageData) ? data.options.pageData
                        : null;
            });
            // File 탐색기
            $(document).on('pagebeforeshow', '#explorer', function(event, ui) {
                readDirectory();
            });
            
            $.mobile.changePage($("#explorer"));
            break;            
        case "NETWORK" : 
            fn_egov_currentNetworkInfo();
            break;            
        case "DEVICE" : 
            fn_egov_currentDeviceInfo();
            break;
    }
    
}

/**
 * Media API 재생 관련 체크
 * @returns
 * @type 
 */
function fn_egov_stopMediaAPI() {
    
    if(mediaObj != null) {
        
        mediaObj.stop();
        mediaObj = null;
    }
}

/*********************************************************
 * 디바이스API 이용 및 정보 획득 함수
 *********************************************************/

/**
 * Accelerator API 정보 Control
 * @returns
 * @type 
 */

function fn_egov_currentAcceleratorInfo(acceleration) {
    
    console.log("DeviceAPIGuide fn_egov_currentAcceleratorInfo Success");
    
    var data = new Object();
    
    data = {
            x_axis : acceleration.x,
            y_axis : acceleration.y,
            z_axis : acceleration.z
            };
    
    fn_egov_displayDeviceAPIInfoDetail(data, "infoDetail");
    fn_egov_getInsertAPIInfo(data);
}

/**
 * GPS(Geolocation) API 정보 Control
 * @returns
 * @type 
 */

function fn_egov_currentGPSInfo(position) {
    
    console.log("DeviceAPIGuide fn_egov_currentGPSInfo Success");
    
    var data = new Object();
    
    data = {
            latitude : position.coords.latitude,
            longitude : position.coords.longitude
            };
    
    fn_egov_displayDeviceAPIInfoDetail(data, "infoDetail");
    fn_egov_getInsertAPIInfo(data);
}

/**
 * GPS(Geolocation) API 정보 Control
 * @returns
 * @type 
 */

function fn_egov_currentVibratorInfo() {
    
    console.log("DeviceAPIGuide fn_egov_currentVibratorInfo Success");
    
    navigator.vibrate(2000); //(deprecated) //navigator.notification.vibrate(2000);

    var data = new Object();
    data = {};
    
    fn_egov_displayDeviceAPIInfoDetail(data, "infoDetail");
    fn_egov_getInsertAPIInfo(data);
}

/**
 * Camera API 정보 Control
 * @returns
 * @type 
 */

function fn_egov_currentCameraInfo(imageURI) {
    
    console.log("DeviceAPIGuide fn_egov_currentCameraInfo Success");
    
    var data = new Object();
    
    data = {
            image_uri : imageURI
            };
    
    fn_egov_displayDeviceAPIInfoDetail(data, "infoDetail");
    fn_egov_getInsertAPIInfo(data);
}

/**
 * Media API 정보 Control
 * @returns
 * @type 
 */

function fn_egov_currentMediaInfo() {
    
    console.log("DeviceAPIGuide fn_egov_currentMediaInfo Success");
    
    var sampleSrc = "/android_asset/wwwSampleTemplate/data/owlband.mp3";
    
    if( mediaObj == null ) { 
        //mediaObj = new Media(sampleSrc, null, fn_egov_error);
        mediaObj = new Media(sampleSrc, fn_egov_success, fn_egov_error);
    }
    mediaObj.play();
    
    var data = new Object();
    data = {
            play_list : sampleSrc
        };
    
    fn_egov_displayDeviceAPIInfoDetail(data, "infoDetail");
    
    
    fn_egov_getInsertAPIInfo(data);
}

/**
 * Contacts API 정보 Control
 * @returns
 * @type 
 */
function fn_egov_currentContactsInfo(contacts) {
    
    console.log("DeviceAPIGuide fn_egov_currentContactsInfo Success");
    
    var data = new Object();
    
    data = {
            contact_total : contacts.length
            };
    
    fn_egov_displayDeviceAPIInfoDetail(data, "infoDetail");
    fn_egov_getInsertAPIInfo(data);
}

/**
 * Compass API 정보 Control
 * @returns
 * @type 
 */
function fn_egov_currentCompassInfo(heading) {
    
    console.log("DeviceAPIGuide fn_egov_currentCompassInfo Success");
    
    var data = new Object();
    
    data = {
            heading : heading.magneticHeading
            };
    
    fn_egov_displayDeviceAPIInfoDetail(data, "infoDetail");
    fn_egov_getInsertAPIInfo(data);
}


/*********************************************************
 * File API 관련 함수 : PhoneGap 제공
 *********************************************************/

/** File API 관련 공통 파일시스템 인스턴스 */
var fileSystem; 
/** File API 관련 공통 디렉토리 인스턴스 */
var dirEntry;

/**
 * 파일 시스템 정보 획득
 * @returns
 * @type 
 */
function gotFS(fs) {
    fileSystem = fs;
    dirEntry = fileSystem.root;
}

/**
 * 디렉토리 정보 획득을 위한 인스턴스 생성 및 정보 획득
 * @returns
 * @type 
 */
function readDirectory() {
    var directoryReader = dirEntry.createReader();
    directoryReader.readEntries(gotDirectoryEntries, fn_egov_error);
}

/**
 * 현재 파일 시스템 내, 위치 정보 획득
 * @returns
 * @type 
 */
function chdir(dir) {
    if (dir == "../") {
        dirEntry.getParent(gotDirectory, fn_egov_error);
    } else if (dir == "") {
        dirEntry = fileSystem.root;
        readDirectory();
    } else {
        dirEntry.getDirectory(dir, {}, gotDirectory, fn_egov_error);
    }
}

/**
 * 디렉토리 위치 정보 획득
 * @returns
 * @type 
 */
function gotDirectory(directoryEntry) {
    dirEntry = directoryEntry;
    readDirectory();
}

/**
 * 디렉토리 내, 정보 획득 및 HTML 출력
 * @returns
 * @type 
 */
function gotDirectoryEntries(entries) {

    $('#listView').text("");

    var linkVal = "javascript:chdir('');";
    var imageSrc = "images/egovframework/mbl/hyb/folder.png";
    var subject = "/";
    var brief = "Go to root";

    if (dirEntry.fullPath != fileSystem.root.fullPath) {

        $(
                '<li data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-li-has-thumb ui-btn-up-c"><div class="ui-btn-inner ui-li" aria-hidden="true"><div class="ui-btn-text"><a href="'
                        + linkVal
                        + '" class="ui-link-inherit" data-transition="flip" ><img src="'
                        + imageSrc
                        + '" class="ui-li-thumb" /><h3 class="ui-li-heading">'
                        + subject
                        + '</h3><p class="ui-li-desc">'
                        + brief
                        + '</p></a></div><span class="ui-icon ui-icon-arrow-r ui-icon-shadow"></span></div></li>')
                .appendTo('#listView');

        linkVal = "javascript:chdir('../');";
        imageSrc = "images/egovframework/mbl/hyb/folder.png";
        subject = "../";
        brief = "Go Up";
        $(
                '<li data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-li-has-thumb ui-btn-up-c"><div class="ui-btn-inner ui-li" aria-hidden="true"><div class="ui-btn-text"><a href="'
                        + linkVal
                        + '" class="ui-link-inherit" data-transition="flip" ><img src="'
                        + imageSrc
                        + '" class="ui-li-thumb" /><h3 class="ui-li-heading">'
                        + subject
                        + '</h3><p class="ui-li-desc">'
                        + brief
                        + '</p></a></div><span class="ui-icon ui-icon-arrow-r ui-icon-shadow"></span></div></li>')
                .appendTo('#listView');

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
            
            linkVal = "javascript:fn_egov_goFileLogInfoList('" + dirEntry.fullPath + "/" + entries[i].name + "');";
        } else {
            linkVal = "javascript:chdir('" + entries[i].name + "');";
            imageSrc = "images/egovframework/mbl/hyb/folder.png";
            subject = entries[i].name;
            brief = "Directory";
        }

        $(
            '<li data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-li-has-thumb ui-btn-up-c"><div class="ui-btn-inner ui-li" aria-hidden="true"><div class="ui-btn-text"><a href="'
                    + linkVal
                    + '" class="ui-link-inherit" data-transition="pop" ><img src="'
                    + imageSrc
                    + '" class="ui-li-thumb" /><h3 class="ui-li-heading">'
                    + subject
                    + '</h3><p class="ui-li-desc">'
                    + brief
                    + '</p></a></div><span class="ui-icon ui-icon-arrow-r ui-icon-shadow"></span></div></li>')
                .appendTo('#listView');

    }

    myScroll.refresh();
}

/**
 * 파일 정보 획득 후 로그 목록 이동.
 * @returns
 * @type 
 */
function fn_egov_goFileLogInfoList(file_list) {
    
    var data = new Object();
    data = {
            file_list : file_list
            };
    
    fn_egov_getInsertAPIInfo(data);
    
    $.mobile.changePage($("#apiListView"));
    fn_egov_displayDeviceAPIInfoList();
    
}


/**
 * Connection(Network) API 정보 Control
 * @returns
 * @type 
 */
function fn_egov_currentNetworkInfo() {
    
    console.log("DeviceAPIGuide fn_egov_currentNetworkInfo Success");
    
    var networkState = navigator.connection.type;

    var states = {};
    states[Connection.UNKNOWN]  = 'Unknown';
    states[Connection.ETHERNET] = 'Ethernet';
    states[Connection.WIFI]     = 'WiFi';
    states[Connection.CELL_2G]  = '2G';
    states[Connection.CELL_3G]  = '3G';
    states[Connection.CELL_4G]  = '4G';
    states[Connection.NONE]     = 'disconnection';
    
    var data = new Object();
    
    data = {
            network : states[networkState]
            };
    
    fn_egov_displayDeviceAPIInfoDetail(data, "infoDetail");
    fn_egov_getInsertAPIInfo(data);
}

/**
 * Device API 정보 Control
 * @returns
 * @type 
 */
function fn_egov_currentDeviceInfo() {
    
    console.log("DeviceAPIGuide fn_egov_currentDeviceInfo Success");
    
    var data = new Object();
    
    data = {
            os : device.platform,
            version : device.version,
            uuid : device.uuid
            };
    
    fn_egov_displayDeviceAPIInfoDetail(data, "infoDetail");
    fn_egov_getInsertAPIInfo(data);
}

function permissionSuccess(status) {
    console.log('### Check Permission');
    if( !status.hasPermission ) {
        permissionError();
    } else {
        console.log('### Permission is OK');
    }
}

function permissionError() {
    console.warn('### Permission is not turned on');
}