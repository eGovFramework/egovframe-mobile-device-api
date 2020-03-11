/** 
 * @fileoverview 디바이스API Network API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 이율경
 * @version 1.0 
 * @ 수정일		  수정자	       수정내용
 * @ ----------	  ---------	   -------------------------------
 * @ 2015.04.20   신용호 		   iscroll5 적용
 * @ 2019.10.15   신용호         Toast 메시지 수정
 */

/*********************************************************
 * 공통
 *********************************************************/

/** 
 * RestService를 담당할 EgovInterface 객체 생성
 * @type EgovInterface
*/
var egovHyb = new EgovInterface();

/** 서버 Context */
var context = "";

/** iscroll를 적용하기 위한 공통 */
var myScroll;

/** Media 관련 인스턴스 */
var mediaObj = null;

/** 현재 네트워크 정보 번호 */
var currentNetworkInfoSn;

/** Media 재생 위치 체크 인스턴스 */
var playTimer;

/** 날짜 포맷 형식 */
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

/** 날짜 포맷 형식 00 또는 0X */
function zeroPad(number) {
    
    return ( ( number < 10 ) ? "0" : "" ) + String(number);
    
}

/** 초 -> 시:분:초 */
function convertTime(number) {

    var hour;
    var minute;
    var second;
    
    if(parseInt(number) > -1) {
        
        hour = zeroPad(parseInt(number / 3600));
        minute = zeroPad(parseInt((number % 3600) / 60));
        second = zeroPad(parseInt(((number % 3600) % 60)));
    } else {
        
        hour = "00";
        minute = "00";
        second = "00";
    }
        
    return hour + ":" + minute + ":" + second;
}

/**
 * 안드로이드의 toast 형태의 메시지 구현
 * @returns
 * @type
 */
var toast = function(msg){
    $("<div class='ui-loader ui-overlay-shadow ui-body-e ui-corner-all'><h3>"+msg+"</h3></div>")
    .css({ display: "block",
        opacity: 0.90,
        position: "fixed",
        padding: "7px",
        "text-align": "center",
        width: "270px",
        left: ($(window).width() - 284)/2,
        top: $(window).height()/2 })
    .appendTo( $.mobile.pageContainer ).delay( 1500 )
    .fadeOut( 400, function(){
        $(this).remove();
    });
}

function popupWidget(msg) {
    $("#popupWidgetCloseRight").children("p").text(msg);
    $("#popupWidgetCloseRight").popup("open");
}


/*********************************************************
 * HTML 관련 함수
 *********************************************************/

/**
 * 디바이스 정보 출력
 * @returns 
 * @type 
 */
function fn_egov_displayDeviceInfo() {
    
    var html = "<p>Network API Guide 프로그램은 디바이스 API를 사용하여 네트워크 상태를 체크하여 Wi-Fi 가 아닐 경우에는 사용자 승인을 받아 서비스를 제공하는 가이드 프로그램.</p>";
    html += '<p>';
    html += '네트워크 상태 정보' + '<BR>';
    html += 'OS : '+ device.platform + '<BR>';
    html += 'UUID : ' + device.uuid + '<BR>';
    html += 'Network : ' + fn_egov_getDeviceInfo() + '</p>';
    
    $("#tblNetworkInfo").html(html);
}

/**
 * 목록 조회 화면 출력
 * @returns 
 * @type 
 */
function fn_egov_displayList(xmldata) {
    
    var html = "";
    var listCount = $(xmldata).find("networkInfoList").length;
    $(xmldata).find("networkInfoList").each(function(){
        
                    var sn = $(this).find("sn").text();
                    var uuid = $(this).find("uuid").text();
                    var networktype = $(this).find("networktype").text();
                    
                    html += '<li>';
                    html += '     <a href="#" onclick="javascript:fn_egov_event_selectNetworkInfo(\'' + sn + '\');">';
                    html += '         <h2>' + uuid + '</h2>';
                    html += '         <h2>' + networktype + '</h2>';
                    html += '    </a>';
                    html += '</li>';        
                });
    
    $("#lstNetworkInfo").html(html).listview("refresh");
    
    loaded('#wrapper');
    
    $.mobile.loading("hide");

    if (listCount < 1) {
        jAlert('서버에 저장된 네트워크\n 정보가 없습니다.','알림','b');
    }
}

/**
 * 네트워크 상세 페이지 표시
 * @returns
 * @type 
 */
function fn_egov_displayNetworkInfoDetail(xmldata)
{
    console.log("fn_egov_displayNetworkInfoDetail");
    
    var html = "";
    
    var sn = $(xmldata).find("sn").text();
    var uuid = $(xmldata).find("uuid").text();
    var networktype = $(xmldata).find("networktype").text();
    var useYn = $(xmldata).find("useYn").text();
    
    html += '<p>';
    html += 'SN : '+ sn + '<BR/>';
    html += 'OS : '+ device.platform + '<BR/>';
    html += 'UUID : '+ uuid + '<BR/>';
    html += 'Network : '+ networktype + '<BR/>';
    html += 'useYn : '+ useYn + '</p>';
    
    $("#tblNetworkDetailInfo").html(html);
    
    $.mobile.loading("hide");
}


/*********************************************************
 * 이벤트 관련 함수
 *********************************************************/

$(function(){
    
    $(document).on("pageshow", "#nwkMain", function(event, ui){
        
        fn_egov_displayDeviceInfo();
    });
    
    $(document).on("pagehide", "#nwkMain", function(event, ui){
        
        $("#tblNetworkInfo").empty();
    });
    
    $(document).on("pageshow", "#apiListView", function(event, ui){
        
        if(fn_egov_network_check(false)) {

            fn_egov_event_selectNetworkInfoList();
        } else {

            navigator.app.backHistory();
        }
    });
    
    $(document).on("pagehide", "#apiListView", function(event, ui){
        
        $("#lstNetworkInfo").empty();
    });
    
    $(document).on("pagehide", "#networkInfoDetail", function(event, ui){
        
        currentNetworkInfoSn = "";
    });
});

/**
 * 디바이스와 PhoneGap 준비 완료 이벤트
 * @returns 
 * @type 
 */
function DeviceAPIInit() {  
    
    fn_egov_deviceConfig();
    
    fn_egov_displayDeviceInfo();
}

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

    	//document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

    },500);

}

/**
 * 어플리케이션 서버 설정
 * @returns 
 * @type 
 */
function fn_egov_deviceConfig() {
    
    $.mobile.loading("show");
    egovHyb.geturl(function(serverContext){
        
        console.log("DeviceAPIGuide fn_egov_deviceConfig Success");
        
        context = serverContext;
        
        $.mobile.loading("hide");
    });
}

/**
 * 네트워크 정보 목록 조회 페이지 이동 이벤트
 * @returns 
 * @type 
 */
function fn_egov_event_moveNetworkInfoList() {
    
    if(playTimer != null) {
        
        jAlert("Media 재생을\n정지해주십시오.", "알림", "b");
    } else {
        
        $.mobile.changePage($("#apiListView"));
    }
}

/**
 * 네트워크 정보 목록 조회 이벤트
 * @returns 
 * @type 
 */
function fn_egov_event_selectNetworkInfoList() {
    
    if(myScroll != null) {
        
        myScroll.destroy();
    }
    fn_egov_selectNetworkInfoList();
}

/**
 * 네트워크 상세 정보 조회 이벤트
 * @returns 
 * @type 
 */
function fn_egov_event_selectNetworkInfo(sn) {
    
    currentNetworkInfoSn = sn;
    
    if(fn_egov_network_check(false)) {

        fn_egov_selectNetworkInfo(sn);
    }
}

/**
 * 네트워크 상세 정보 삭제 이벤트
 * @returns 
 * @type 
 */
function fn_egov_event_deleteNetworkInfo() {
    
    if(fn_egov_network_check(false)) {

        jConfirm("삭제하시겠습니까?", "알림", "b", function(result){
            
            if(result) {
                
                fn_egov_deleteNetworkInfo();
            }
        });
    }
}

/**
 * Media 이벤트
 * @returns 
 * @type 
 */
function fn_egov_event_media() {
    
    fn_egov_mediaAPIConfig();
    
    if(playTimer == null) {
        
        if(fn_egov_network_check(true)) {

            fn_egov_mediaPlayEvent();
        }
    } else {
        
        fn_egov_mediaStop();
        
        clearInterval(playTimer);
        playTimer = null;
        
        mediaObj.release();
        mediaObj = null;
    }
}

/**
 * Media 재생 이벤트
 * @returns 
 * @type 
 */
function fn_egov_mediaPlayEvent() {
    
    fn_egov_insertNetworkInfo();
    
    fn_egov_mediaPlay();
    
    playTimer = setInterval(function(){
        mediaObj.getCurrentPosition(fn_egov_currentPositionSuccess, fn_egov_currentPositionError);
    }, 1000);
}

/*********************************************************
 * 성공/실패 관련 함수
 *********************************************************/

function fn_egov_success(r) {
    
    console.log("DeviceAPIGuide fn_egov_mediaAPIConfig Success");
}

function fn_egov_error(error) {
    
    console.log("DeviceAPIGuide fn_egov_error Error by " + error);
    
}

function fn_egov_currentPositionSuccess(position) {
    
    if (position > -1) {
        
        console.log("DeviceAPIGuide fn_egov_currentPositionSuccess Success");
    }
}

function fn_egov_currentPositionError(e) {
    
    console.log("DeviceAPIGuide fn_egov_currentPositionError Error");
}

/*********************************************************
 * CRUD 관련 함수
 *********************************************************/

/**
 * 네트워크 정보 목록 조회
 * @returns 
 * @type 
 */
function fn_egov_selectNetworkInfoList() {
    
    var url = "/nwk/networkAndroidInfoList.do";
    var acceptType = "xml";
    
    var params = {};
    
    $.mobile.loading("show");
    egovHyb.post(url, acceptType, params, function(xmldata) {

        console.log("DeviceAPIGuide fn_egov_selectNetworkInfoList request Completed");
        
        fn_egov_displayList(xmldata);
    });
}

/**
 * 네트워크 상세 정보 조회
 * @returns 
 * @type 
 */
function fn_egov_selectNetworkInfo(sn) {
    
    var url = "/nwk/networkAndroidInfo.do";
    var acceptType = "xml";
    
    var params = {
                    sn : sn
                };
    
    $.mobile.loading("show");
    egovHyb.post(url, acceptType, params, function(xmldata) {
        
        console.log("DeviceAPIGuide fn_egov_selectNetworkInfo request Completed");
        
        fn_egov_displayNetworkInfoDetail(xmldata);
        
        $.mobile.changePage($("#networkInfoDetail"));
    });
}

/**
 * 네트워크 상세 정보 삭제
 * @returns 
 * @type 
 */
function fn_egov_deleteNetworkInfo() {
    
    var url = "/nwk/deleteNetworkAndroidInfo.do";
    var acceptType = "xml";
    
    var params = {
                    sn : currentNetworkInfoSn
                };
    
    $.mobile.loading("show");
    egovHyb.post(url, acceptType, params, function(xmldata) {
        
        console.log("DeviceAPIGuide fn_egov_deleteNetworkInfo request Completed");
        
        $.mobile.loading("hide");
        jAlert("삭제되었습니다", "알림", "b", function(){
            
            $.mobile.changePage($("#apiListView"), {changeHash:false});
        });
    });
}

/**
 * 네트워크 정보 저장
 * @returns 
 * @type 
 */
function fn_egov_insertNetworkInfo() {
    
    var url = "/nwk/addNetworkAndroidInfo.do";
    var acceptType = "xml";
    
    var networktype = fn_egov_getDeviceInfo();
    
    var params = {
                    uuid :  device.uuid,
                    networktype : networktype,
                    useYn : "Y"
                };
    
    $.mobile.loading("show");
    egovHyb.post(url, acceptType, params, function(xmldata) {
        
        console.log("DeviceAPIGuide fn_egov_insertNetworkInfo request Completed");

        $.mobile.loading("hide");
        toast("서버에 단말기 상태값을 저장 했습니다.");
    });
}

/*********************************************************
 * Media API 제어 함수
 *********************************************************/

/**
 * Media API 설정
 * @returns
 * @type  
 */
function fn_egov_mediaAPIConfig() {

    var src = context + "/nwk/getMp3FileAndorid.do";
    
    if(mediaObj != null) {
        
        mediaObj.release();
        mediaObj = null;
    }
    
    mediaObj = new Media(src, fn_egov_success, fn_egov_error);
}

/**
 * Media API 재생
 * @returns
 * @type  
 */
function fn_egov_mediaPlay() {
    
    mediaObj.play();
    popupWidget("서버에서 사운드 파일을 실시간 재생합니다.\n버튼을 다시 클릭하면 재생을 멈출수 있습니다!");
}

/**
 * Media API 정지
 * @returns
 * @type  
 */
function fn_egov_mediaStop() {
    
    mediaObj.stop();
    toast("사운드 파일의 실시간 재생을 중지합니다.");
}

/*********************************************************
 * Network API 제어 함수
 *********************************************************/

/**
 * 디바이스 정보 표시
 *  @returns
 * @type
 */
function fn_egov_getDeviceInfo()
{
    var states = {};
    states[Connection.UNKNOWN]  = 'Unknown connection';
    states[Connection.ETHERNET] = 'Ethernet connection';
    states[Connection.WIFI]     = 'WiFi connection';
    states[Connection.CELL_2G]  = 'Cell 3G connection';
    states[Connection.CELL_3G]  = 'Cell 3G connection';
    states[Connection.CELL_4G]  = 'Cell 4G connection';
    states[Connection.NONE]     = 'No network connection';
    
    return states[navigator.network.connection.type];
}
