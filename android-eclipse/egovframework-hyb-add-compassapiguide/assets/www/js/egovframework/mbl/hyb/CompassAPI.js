/** 
 * @fileoverview 모바일 전자정부 하이브리드 앱 Compass API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 서형주
 * @version 1.0 
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2015. 4. 20.   신용호 		iscroll5 적용 
 */

/*********************************************************
 * Compass 관련 함수
 *********************************************************/

/** Compass Update Handler */
var CompasswatchID = null;

/** Compass 정보 최초 한번만 기록하기 체크 */
var CompassInsertCheck = false;

/** drc */
var drc;

/** headingAccuracy */
var accrcy;

/** timestamp */
var timestamp;

/** newHeading */
var newHeading;

/** 서버에 저장된 방향 정보 */
var compassInfoListCount;

/**
 * Compass 정보 업데이트
 * @returns 
 * @type 
 */
function fn_egov_update_heading(h) 
{
    drc = h.magneticHeading;
    accrcy = h.headingAccuracy;
    timestamp=  h.timestamp;
    
    // 새로운 각도 값을 받아옴
    newHeading = Math.round(drc);    

    $("#compassMain").trigger("newHeading", newHeading);
        
    var html = "방위각 : " + drc + "<BR />";

    $("#infoDetail").html(html);
    if(CompassInsertCheck) 
    {
        CompassInsertCheck = false;
    }
    console.log("DeviceAPIGuide fn_egov_update_heading Success"); 
}

/**
 * Compass 정보 조회
 * @returns 
 * @type 
 */
function fn_egov_get_compass() 
{
    if (CompasswatchID === null) 
    {
                
        //alert("Compass start");
        //toast("Compass start");
        CompassInsertCheck = true;
        var options = { frequency: 1 };
        CompasswatchID = navigator.compass.watchHeading(fn_egov_update_heading, 
                                                        function(e) 
                                                        {
                                                        console.log("DeviceAPIGuide fn_egov_get_compass fail");
                                                        }, 
                                                        options);
    } 
    else 
    {    
        
        compassEvent();
        
        navigator.compass.clearWatch(CompasswatchID);
        CompasswatchID = null;
        fn_egov_update_heading({ drc : "Off"});
        //navigator.notification.alert("Compass stop");
        //toast("Compass stop");
    }
}

/**
 * Compass 조회 중지
 * @returns 
 * @type 
 */
function fn_egov_get_stopCompass() {
    if (CompasswatchID) {
        navigator.compass.clearWatch(CompasswatchID);
        watchID = null;
    }
}

/** setInterval을 사용하기 위한 객체 */
var objRun;

/** 현재 저장 상태를 체크하기 위한 객체 */
var isRegist = false;

/**
 * Compass Info 주기적 저장 호출 함수.
 * @returns 1초에 한번 씩 Compass Info 를 저장한다..
 * @type  
*/
function fn_startRegist(){
    objRun = setInterval("fn_registCompassInfo()", 1000);
}

function fn_stopRegist(){
    clearInterval(objRun);;
}


/**
 * Compass Info 화면 이동 function.
 * @returns 디바이스 내 네트워크 정보를 볼 수 있는 화면으로 이동.
 * @type
*/
function fn_goCompassInfo() {
    
    $.mobile.changePage($("#compassMain"), {reverse: true});
}

/**
 * Compass Info List 화면 이동 function.
 * @returns 서버에 저장된 네트워크 정보를 요청받아 XML 리스트 반환한다.
 * @type  
*/
function fn_goCompassInfoListXml()
{
    if(!fn_egov_network_check(false)){
        return;
    }
    var url = "/cps/xml/compassInfoList.do";
    var accept_type = "xml";
    // get the data from server
    window.plugins.EgovInterface.get(url,accept_type, null, function(xmldata) {
        var list_html = "";
        compassInfoListCount = $(xmldata).find("compassInfoList").length;
        $(xmldata).find("compassInfoList").each(function(){
            var uuid = $(this).find("uuid").text();
            var x = $(this).find("drc").text();
            var y = $(this).find("accrcy").text();
            var t = $(this).find("timestamp").text();

            list_html += "<li><h3>UUID : " + uuid + "</h3>";
            list_html += "<p><strong>drc : " + x + "</strong></p>";
            list_html += "<p><strong>accrcy : " + y + "</strong></p>";
            list_html += "<p>timestamp : " + t + "</p></li>";
            
        });
        var theList = $('#theList');
        theList.html(list_html);
        $.mobile.changePage($("#compassInfoList"), {reverse: true});
        theList.listview("refresh");

        if (compassInfoListCount < 1) {
            jAlert('서버에 저장된 방향\n 정보가 없습니다.','알림','b');
        }
        
    });
}

/**
 * Compass Info 전송 확인 function.
 * @returns 네트워크 정보를 서버에 전송전 사용자 확인을 수행한다.
 * @type  
*/
function confirm_registCompassInfo(){

    if(!fn_egov_network_check(false)){
        return;
    }
    
    if(isRegist==false){
        jConfirm('Compass 정보를 서버로 전송 하시겠습니까?', '알림', 'c', function(r){
            if(r == true){
                
                fn_startRegist();
                isRegist=true;
                $('#btnSaveCompassInfo').html('<span class="ui-btn-inner"><span class="ui-btn-text">방향 정보 저장 중지</span><span class="ui-icon ui-icon-gear ui-icon-shadow">&nbsp;</span></span>');                
            }else{
            
            }
        
        });    
    }else{
        jConfirm('Compass 정보 전송을 중지 하시겠습니까?', '알림', 'c', function(r){
            if(r == true){

                fn_stopRegist();
                isRegist=false;
                $('#btnSaveCompassInfo').html('<span class="ui-btn-inner"><span class="ui-btn-text">방향 정보 저장 시작</span><span class="ui-icon ui-icon-gear ui-icon-shadow">&nbsp;</span></span>');                
            }else{
                
            }
            
        });
        
    }
    
}

/**
 * Compass Info List 삭제 확인 function.
 * @returns 네트워크 정보 삭제 전 사용자 확인을 수행한다.
 * @type  
*/
function confirm_deleteCompassInfoList(){

    if(!fn_egov_network_check(false)){
        return;
    }

    if (compassInfoListCount < 1) {
        jAlert('서버에 저장된 방향\n 정보가 없습니다.','알림','b');
    } else {
        jConfirm('정말삭제하시겠습니까?', '알림', 'c', function(r){
            if(r == true){
                fn_deleteCompassInfoList();
            }else{

            }

        });
    }
}

/*********************************************************
 * 웹 서버 Application 연계 관련 함수
 *********************************************************/

/** 
 * RestService를 담당할 EgovHybrid 객체 생성(서버 주소를 파라미터로 전달하여 초기화한다.
 * @type EgovHybrid
*/
var egovHyb = new EgovInterface();

/**
 * Compass Info 서버 전송 function.
 * @returns 화면에 표시된 네트워크 정보를 서버에 저장 요청한다.
 * @type  
*/
function fn_registCompassInfo() {
    
    useYn = "Y";
            
    var url = "/cps/xml/addCompassInfo.do"; 
    var accept_type = "json";
    var params = {uuid :  device.uuid,
            drc: drc + '', 
            accrcy: accrcy + '', 
            timestamp: timestamp + '', 
            useYn:  useYn};    
        
    /*$.ajax(
            {
                url:url,
                type:'POST',
                data:params,
                error:function(){},
                complete:function(data){alert(data.useYn)},
                dataType:'xml'
            }
        );*/
    
    // send the data
    egovHyb.post(url, accept_type, params, function(jsondata) {
        var data = JSON.parse(jsondata);
        
        if(data.useYn == "OK"){
            //fn_goCompassInfoListXml();
        }else{
            $("#alert_dialog").click( function() {
                jAlert('데이터 전송 중 오류가 발생 했습니다.', '전송 오류', 'c');
                });
        }            
        
    });

    console.log("DeviceAPIGuide fn_registCompassInfo request Completed");
    
}

/**
 * Compass Info List 삭제 요청 function.
 * @returns 서버에 저장된 네트워크 정보를 삭제 요청한다.
 * @type  
*/
function fn_deleteCompassInfoList() {
    /*
    var useYn = "";
    var compassState = navigator.compass.connection.type;
    if(compassState == Connection.NONE)
        useYn = "N";
    else
        useYn = "Y";
    var url = "/cps/deleteCompassInfo.do"; 
    var accept_type = "json";
    var params = {uuid :  device.uuid,
            compasstype: compassState, 
            useYn:  useYn};    */
    var url = "/cps/xml/withdrawal.do";
    var accept_type = "json";
    // send the data
    egovHyb.post(url, accept_type, null, function(jsondata) {
        var data = JSON.parse(jsondata);
        
        if(data.useYn == "OK"){
            $.mobile.changePage($("#compassMain"), {reverse: true});
        }else{
            $("#alert_dialog").click( function() {
                jAlert('데이터 삭제 중 오류가 발생 했습니다.', '삭제 오류', 'c');
                });
        }
        
    });

    console.log("DeviceAPIGuide fn_deleteCompassInfoList request Completed");
        
}

/*********************************************************
 * HTML 및 이벤트 관련 함수
 *********************************************************/

/** iScroll을 사용하기 위한 객체 */
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
 * 화면을 위한 관련 이벤트
 */

$(function(){
    
    var lastHeading = -1,
    // cache the jQuery selectors
    $compass = $("#compass"),
    // adjusts the rotation of the compass
    updateCompass = function (event, heading) {
        event.preventDefault();
                
        if (lastHeading === heading) return;
        lastHeading = heading;
        
        
        // to make the compass dial point the right way
        var rotation = 360 - heading,
            rotateDeg = 'rotate(' + rotation + 'deg)';
        // TODO: fix - this code only works on webkit browsers, not wp7
        $compass.css('-webkit-transform', rotateDeg);
        return;
    };

    // bind both of the event handlers to the "newHeading" event
    $("#compassMain").bind("newHeading", updateCompass);

    $(document).on('pagehide ', "#compassMain", function(event) {

        //fn_egov_get_stopCompass();
       
        //방향정보 저장 중지
        fn_stopRegist();
        isRegist=false;
    });
    
    $(document).on('pageshow', '#compassInfoList', function(event, ui) {
        
        if(myScroll != null) {
            
        	myScroll.destroy();
        }
        loaded('#wrapperList');
    });
    
    $("#btnSaveCompassInfo").attr("href","javascript:confirm_registCompassInfo();");
    $("#btnMoveCompassInfoList").attr("href","javascript:fn_goCompassInfoListXml();");
    $("#btnInquirCompassInfo").attr("href","javascript:fn_goCompassInfo();");
    $("#btnDelCompassInfo").attr("href","javascript:confirm_deleteCompassInfoList();");
    
});