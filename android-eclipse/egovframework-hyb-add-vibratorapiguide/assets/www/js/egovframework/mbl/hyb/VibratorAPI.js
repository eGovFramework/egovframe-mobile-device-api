/** 
 * 모바일 전자정부 하이브리드 앱 Vibrator API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 이율경
 * @version 1.0 
 * @ 수정일		  수정자		 수정내용
 * @ ----------	  --------	 -------------------------------
 * @ 2015.04.20   신용호 		 iscroll5 적용
 * @ 2019.10.17   신용호 		 서버 저장이력 안내메시지 추가
 */

/*********************************************************
 * 공통
 *********************************************************/

/** 
 * RestService를 담당할 EgovInterface 객체 생성
 * @type EgovInterface
*/
var egovHyb = new EgovInterface();

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

/*********************************************************
 * 이벤트 관련 함수
 *********************************************************/

/**
 * 디바이스와 PhoneGap 준비 완료 이벤트
 * @returns 
 * @type 
 */
function DeviceAPIInit() {  
	
    $.validator.setDefaults({
        onkeyup:false,
        onclick:false,
        onfocusout:false,
        
        submitHandler: function() 
        { 
            fn_egov_save_notificationConfig();
            return false;
        },
        invalidHandler: function(form, validator) 
        {
        },
        showErrors: function(errorMap, errorList)
        {
            if(this.numberOfInvalids())
            {
                jAlert(errorList[0].message, "알림", "b");
            }
        }
        
        });

    $("#myform").validate();
    
    $(document).on("pageshow", "#apiListView", function(){
        
    });
    
    $(document).on("pagehide", "#apiListView", function(){
        
        $("#dataList").empty();
    });
    
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

    	document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

    },500);

}


/*********************************************************
 * HTML 관련 함수
 *********************************************************/

/**
 * 알림 설정 정보 열기 ( 상세 페이지 이동 )
 * @returns
 * @type 
 */
function fn_egov_go_detailPage(xmldata)
{
    var html = "";
    
    $(xmldata).find("vibratorAndroidAPIList").each(function(){
        
        var timeStamp = $(this).find("timeStamp").text();
        html += '<li>';
        html += '    ' + timeStamp;
        html += '</li>';
    });
    $.mobile.loading("hide");
    
    $("#dataList").html(html).listview("refresh");
    
    if(myScroll != null) {
        
        myScroll.destroy();
    }
    loaded('#wrapper');

    if ($(xmldata).find("vibratorAndroidAPIList").size()==0) {
        jAlert("서버에서 조회된 목록이 0건입니다.", "알림", "b");
    }
}

/*********************************************************
 * 성공/실패 관련 함수
 *********************************************************/

/**
 * 알림 설정 정보 저장 이벤트
 * @returns
 * @type 
 */
function fn_egov_insert_data_event() {
	
	if($("#swchBeep").val() === "off" && $("#swchVibration").val() === "off") {
	    jAlert("알람 설정이 off 되어 있습니다.", "알림", "b");
	} else {
		
		$("#myform").submit();
	}
}

/**
 * 알림 설정 정보 열기 이벤트
 * @returns
 * @type 
 */
function fn_egov_select_data_event() {
    
    fn_egov_select_data();
    
    $.mobile.changePage('#apiListView');
}

/*********************************************************
 * CRUD 관련 함수
 *********************************************************/

/**
 * 알림 설정 정보 저장
 * @returns
 * @type 
 */
function fn_egov_insert_data() {
    
    var url = "/vbr/addVibratorAndroidInfo.do";
    var acceptType = "xml";
    
    var setTime = new Date().format("YYYY-MM-DD hh:mm:ss");
    var params = {
                    uuid :  device.uuid,
                    timeStamp : setTime
                };
    
    $.mobile.loading("show");
    egovHyb.post(url, acceptType, params, function(xmldata) {
        
        console.log("DeviceAPIGuide fn_egov_insert_data request Completed");
        toast("서버에 알람이력을 저장하였습니다.");
        
        $.mobile.loading("hide");
    });
}

/**
 * 알림 설정 정보 열기 ( 상세 페이지 이동 )
 * @returns
 * @type 
 */
var myxmldata;
function fn_egov_select_data() {
    var url = "/vbr/VibratorAndroidInfoList.do";
    var acceptType = "xml";
    
    $.mobile.loading("show");
    egovHyb.post(url, acceptType, {}, function(xmldata) {
        
        console.log("DeviceAPIGuide fn_egov_select_data request Completed");
        fn_egov_go_detailPage(xmldata);
    });
}

/*********************************************************
 * Vibrator API 제어 함수
 *********************************************************/

/**
 * 완료 버튼 클릭시 알림 타이머 셋팅
 * @returns
 * @type 
 */
function fn_egov_save_notificationConfig() {
    
    var setTime = $("#txtNotification").val();
    if(fn_egov_network_check(true)) {

        setTimeout ( "fn_egov_set_alram()", setTime * 1000);
        jAlert("알람이 " + setTime + " 초 뒤에 설정 되었습니다.", "알림", "b");
    }
}

/**
 * 알림 동작 수행
 * @returns
 * @type 
 */
function fn_egov_set_alram() {
    
    console.log("DeviceAPIGuide fn_egov_set_alram Success");
    
    if($("#swchBeep").val() === "on") {
        navigator.notification.beep(3);
    }
    
    if($("#swchVibration").val() === "on") {
        navigator.vibrate(3000);   //(deprecated) //navigator.notification.vibrate(3000);   // 3 second
    }
    
    fn_egov_insert_data();
    
    jAlert("알람", "알림", "b");
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