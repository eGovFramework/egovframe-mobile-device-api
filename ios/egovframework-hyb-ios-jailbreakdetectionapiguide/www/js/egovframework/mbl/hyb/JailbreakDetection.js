/**
 * @fileoverview 모바일 전자정부 하이브리드 앱 JailbreakDetection API 가이드 프로그램 JavaScript
 * JavaScript.
 *
 * @author 신성학
 * @version 1.0
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2016. 7. 26.   신성학 		최초생성
 */

/*********************************************************
 * A TAG 링크 컨트롤
 *********************************************************/

/**
 * A tag의 링크 변경
 *
 * @returns
 * @type
 */

function fn_egov_init_hrefLink() {
    // 바코드 스캔
    $("#btnJailbreakDetectionInfo").attr("href", "javascript:fn_egov_detectio();");
    $("#btnregistDeviceInfo").attr("href","javascript:fn_egov_save_detectioInfo();");
    $("#btnJailbreakDetectionInfoList").attr("href", "javascript:fn_egov_move_JailbreakDetectionInfoList();");
    
    
    
    
}

/**
 * Device Info 로딩 function.
 * @returns 디바이스 API를 이용하여 정보를 취득한 후 화면에 표시.
 * @type
 */
function fn_egov_detectio(){
    
    
    var successCallback = function (result) {
        var  isJailbroken = result == 1;
        
        
        $('.deviceInfo:eq(0)').html(device.platform + " " + device.version);
        $('.deviceInfo:eq(1)').html(device.uuid);
        $('.deviceInfo:eq(2)').html(device.cordova);
        $('.deviceInfo:eq(3)').html(" " + isJailbroken);
        
    };
    var failureCallback = function (error) {
        console.error(error);
        
    };
    
     jailbreakdetection.isJailbroken(successCallback, failureCallback);
    
    $.mobile.changePage('#deviceInfo', 'slide', false, false);
    infoScroll.refresh();
}


function fn_egov_save_detectioInfo(){
    
    var url = "/jai/addJailbreakDetectionDeviceInfo.do";
    
    var d_os = $(".deviceInfo:eq(0)").text();
    var d_uuid = $(".deviceInfo:eq(1)").text();
    var d_pg_ver = $(".deviceInfo:eq(2)").text();
    var d_detection = $(".deviceInfo:eq(3)").text();
    
    console.log("os > " + d_os + "\n uuid >>>  " + d_uuid + "\n pg_ver : >>>>" + d_pg_ver + "<<<<<< \n detection >>" + d_detection + "<<<<");
    
    var params = {
        os : d_os,
        uuid : d_uuid,
        pgVer : d_pg_ver,
        detection : d_detection
    };
    
    window.plugins.EgovInterface.request(url, params, function(jsondata) {
                                         console.log("jsondata > " + jsondata);
                                         
                                         if (jsondata.resultState == "OK") {
                                         console.log("send  ok");
                                         } else {
                                         $("#alert_dialog").click(function() {
                                                                  jAlert('데이터 전송 중 오류가 발생 했습니다.', '전송 오류', 'c');
                                                                  });
                                         }
                                         
                                         }, function(result) {
                                         alert("error > " + result);
                                         });
    
    console.log("JailbreakDetectionDeviceInfo fn_egov_save_detectioInfo request Completed");
    
    $.mobile.changePage("#main", "slide", false, false);
    detailScroll.refresh();
    
}





/**
 * 서버에서 반환한 JailbreakDetectionInfoList 정보 리스트를 화면에 출력한다.
 * @returns
 * @type
 */
function fn_egov_move_JailbreakDetectionInfoList() {
    var url = "/jai/JailbreakDetectionInfoList.do";
    var accept_type = "json";
    
    var params = {
        uuid : device.uuid,
				};
    // get the data from server
    window.plugins.EgovInterface.request(url, params, function(jsonData) {
        var list_html = "";
        var listCount = $(jsonData["JailbreakDetectionDevcieList"]).length;
        $(jsonData["JailbreakDetectionDevcieList"]).each(function(idx,obj){
            var sn = obj.sn;
            var uuid = obj.uuid;
            var os = obj.os;
            var pgVer = obj.pgVer;
            var detection = obj.detection;


            console.log("uuid >>>> " + uuid + "\n os >>>>>>> " + os + "\n pgVer >>> " + pgVer + "<<<<<<" + "\n detection >>> " + detection + "<<<<<<");

            list_html += "<li><h3>UUID : " + uuid + "</h3>";
            list_html += "<p><strong>OS : " + os + "</strong></p>";
            list_html += "<p><strong>Version : " + pgVer + "</strong></p>";
            list_html += "<p>Detection : " + detection + "</p></li>";
        });

        console.log("JailbreakDetectionAPIGuide fn_egov_move_JailbreakDetectionInfoList request Completed");

        var theList = $('#JailbreakDetectionList');
        theList.html(list_html);
        $.mobile.changePage("#JailbreakDetectionInfoList", "slide", false, false);
        theList.listview("refresh");

        if (listCount < 1) {
            jAlert('서버에 저장된 인식결과\n 목록이 없습니다.','알림','b');
        } else {
            detailScroll.refresh();
            listScroll.refresh();
        }

    });
}



/*******************************************************************************
 * iScroll 컨트롤
 ******************************************************************************/

/** 디바이스 정보 리스트 페이지 iScroll */
var infoScroll;

/** 디바이스 정보 리스트 페이지 iScroll */
var detailScroll;

/** 디바이스 정보 리스트 페이지 iScroll */
var listScroll;

/**
 * iScroll 초기화 작업
 * 
 * @returns
 * @type
 */
function fn_egov_load_iScroll() {
    
    // Use this for high compatibility (iDevice + Android)
    var options = {
        scrollX : true,
        scrollbars : true
    }
    
    console.log("device.version >>> " + device.version);
    if (parseFloat(device.version) >= 4.0) {
        options["click"] = true;
    }
    
    setTimeout(function() {
               
               infoScroll = new IScroll("#infoWrapper", options);
               
               detailScroll = new IScroll("#detailWrapper", options);
               
               listScroll = new IScroll("#listWrapper", options);
               
               document.addEventListener('touchmove', function(e) {
                                         e.preventDefault();
                                         }, false);
               
               }, 500);
    
}

/*******************************************************************************
 * 배터리 상태 모니터링
 ******************************************************************************/

/**
 * 배터리 관련 이벤트 등록 함수
 * 
 * @returns
 * @type
 */
function fn_egov_regist_batteryInvent() {
    window.addEventListener("batterystatus", fn_egov_onBatteryStatus, false);
    window.addEventListener("batterylow", fn_egov_onBatteryLow, false);
    window
    .addEventListener("batterycritical", fn_egov_onBatteryCritical,
                      false);
}

/**
 * 배터리 상태 정보 콜백 함수
 * 
 * @returns
 * @type
 */
function fn_egov_onBatteryStatus(info) {
    // Handle the online event
    console.log("DeviceAPIGuide fn_egov_onBatteryStatus Success");
    navigator.notification.alert("Level: " + info.level + "%, isPlugged: "
                                 + info.isPlugged);
}

/**
 * 배터리 상태가 Low일때 호출되는 콜백 함수
 * 
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
 * 
 * @returns
 * @type
 */
function fn_egov_onBatteryCritical(info) {
    // Handle the battery critical event
    console.log("DeviceAPIGuide fn_egov_onBatteryCritical Success");
    navigator.notification.alert("Battery Level Critical " + info.level
                                 + "%\nRecharge Soon!");
}
