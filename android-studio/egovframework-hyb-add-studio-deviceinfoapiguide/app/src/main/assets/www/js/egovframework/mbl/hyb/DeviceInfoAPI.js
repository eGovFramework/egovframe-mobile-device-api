/** 
 * @fileoverview 모바일 전자정부 하이브리드 앱 Network API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 서형주
 * @version 1.0 
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2015. 4. 20.   신용호 		iscroll5 적용 
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
    $("#btnDeviceInfoList").attr("href","javascript:fn_egov_confirm_deviceInfoList();");
    $("#btnregistDeviceInfo").attr("href","javascript:fn_egov_confirm_regist_deviceInfo();");
    $("#btnMoveDeviceInfo").attr("href","javascript:fn_egov_move_deviceInfo();");
    $("#btnDeviceInfo").attr("href","javascript:fn_egov_move_deviceInfo();");
    $("#btnMoveDeviceInfoList").attr("href","javascript:fn_egov_move_deviceInfoList();");
           
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
    navigator.notification.alert("Level: " + info.level + "%, isPlugged: " + info.isPlugged);
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
 * Device Info 조회
 *********************************************************/

/**
 * Device Info 페이지로 이동 function.
 * @returns 디바이스 정보를 조회한 후 조회 페이지로 이동
 * @type  
 */
function fn_egov_move_deviceInfo(){
    fn_egov_load_deviceInfo();
    $.mobile.changePage('#deviceInfo', 'slide', false, false);
    infoScroll.refresh();
}


/**
 * Device Info 로딩 function.
 * @returns 디바이스 API를 이용하여 네트워크 정보를 취득한 후 화면에 표시.
 * @type  
 */
function fn_egov_load_deviceInfo() {
    deviceInfoVO.ntwrkDeviceInfo = fn_egov_get_networkInfo();

    $('.deviceInfo:eq(0)').html(device.platform + " " + device.version);
    $('.deviceInfo:eq(1)').html(device.uuid);
    $('.deviceInfo:eq(2)').html(device.cordova);    
    DeviceNumber.getDeviceNumber(fn_egov_deviceNumber_success, fn_egov_fail, []);
    $('.deviceInfo:eq(4)').html(deviceInfoVO.ntwrkDeviceInfo);
    StorageInfo.totalFileSystemSize(fn_egov_totalSpace_success, fn_egov_fail, []);
}


/*********************************************************
 * Device Info 서버 컨트롤
 *********************************************************/

/** 
 * RestService를 담당할 EgovHybrid 객체 생성(서버 주소를 파라미터로 전달하여 초기화한다.
 * @type EgovHybrid
*/
var egovHyb = new EgovInterface();

/**
 * Device Info 서버 전송 function.
 * @returns 네트워크 정보 확인 후 화면에 표시된 디바이스 정보를 서버에 저장 요청함수를 호출한다.
 * @type
 */
function fn_egov_confirm_regist_deviceInfo(){
    
    if(navigator.network.connection.type != Connection.WIFI){
        jConfirm('Wi Fi 망이 아닐경우 추가적인 비용이 발생 할 수 있습니다. \n계속 하시겠습니까?', 'Network Info', 'a', function(r){
            if(r){
                jConfirm('Device 정보를 서버로 전송 하시겠습니까?', '알림', 'c', function(r){
                    if(r == true){
                        
                    	fn_egov_regist_deviceInfo();
                    }else{
                    
                    }
                
                });                
            }
        });
    }else{
    	jConfirm('Device 정보를 서버로 전송 하시겠습니까?', '알림', 'c', function(r){
             if(r == true){
                 
             	fn_egov_regist_deviceInfo();
             }else{
             
             }
         
         }); 
    }
    

}


/**
 * Device Info 서버 전송 function.
 * @returns 화면에 표시된 디바이스 정보를 서버에 저장 요청한다.
 * @type  
 */
function fn_egov_regist_deviceInfo() {
    
    useYn = "Y";
    
    var url = "/dvc/xml/addDeviceInfo.do"; 
    var accept_type = "json";
    
    var params = {
        uuid :  device.uuid, 
        os : device.platform + " " + device.version,
        telno :  String(deviceInfoVO.telno), 
        strgeInfo : deviceInfoVO.strgeInfo,
        ntwrkDeviceInfo :  deviceInfoVO.ntwrkDeviceInfo , 
        pgVer : device.cordova};
        
    // send the data
    egovHyb.post(url, accept_type, params, function(jsondata) {
        var data = JSON.parse(jsondata);
        
        if(data.useYn == "OK"){
            //fn_goDeviceInfoListXml();
        }else{
            $("#alert_dialog").click( function() {
                jAlert('데이터 전송 중 오류가 발생 했습니다.', '전송 오류', 'c');
                });
        }            
        
    });
    
    console.log("DeviceAPIGuide fn_egov_regist_deviceInfo request Completed");
    
    
}


/**
 * 네트워크 정보 확인 후 서버에서 반환한 디바이스 정보 리스트를 화면에 출력을 요청한다.
 * @returns
 * @type
 */
function fn_egov_confirm_deviceInfoList() {
    if(navigator.network.connection.type != Connection.WIFI){
        jConfirm('Wi Fi 망이 아닐경우 추가적인 비용이 발생 할 수 있습니다. \n계속 하시겠습니까?', 'Network Info', 'a', function(r){
            if(r){
                 fn_egov_move_deviceInfoList();
            }
        });
    }else{
        fn_egov_move_deviceInfoList();
    }
    
}

/**
 * 서버에서 반환한 디바이스 정보 리스트를 화면에 출력한다.
 * @returns
 * @type  
 */
function fn_egov_move_deviceInfoList() {
    var url = "/dvc/xml/deviceInfoList.do";
    var accept_type = "xml";
    var params = {uuid : device.uuid };

    // get the data from server
    window.plugins.EgovInterface.get(url,accept_type, params, function(xmldata) {
        var list_html = "";
        var listCount = $(xmldata).find("deviceInfoList").length;
        $(xmldata).find("deviceInfoList").each(function(){
            var sn = $(this).find("sn").text();
            var uuid = $(this).find("uuid").text();
            var ntwrkDeviceInfo = $(this).find("ntwrkDeviceInfo").text();
            var os = $(this).find("os").text();

            list_html += "<li><a href='javascript:fn_egov_request_deviceInfoDetail(" + sn + ")'><h3>UUID : " + uuid + "</h3>";
            list_html += "<p><strong>Network Connection Type : " + ntwrkDeviceInfo + "</strong></p>";
            list_html += "<p>OS : " + os + "</p></a></li>";
        });

        console.log("DeviceAPIGuide fn_egov_move_deviceInfoList request Completed");

        var theList = $('#theList');
        theList.html(list_html);
        $.mobile.changePage("#deviceInfoList", "slide", false, false);
        theList.listview("refresh");
        
        listScroll.refresh();

        if (listCount < 1) {
            jAlert('서버에 저장된 디바이스 목록이\n 없습니다.','알림','b');
        }
    });
}


/**
 * Device Info 상세 화면 요청 function.
 * @returns 서버에 저장된 디바이스 상세 정보를 반환한다.
 * @type  
 */
function fn_egov_request_deviceInfoDetail(data){
    var params = {sn : String(data)};
        
    var url = "/dvc/xml/deviceInfo.do";
    var accept_type = "xml";
    
    // get the data from server
    window.plugins.EgovInterface.get(url,accept_type, params, function(xmldata) {
        
        deviceInfoVO.sn = $(xmldata).find("sn").text();
        deviceInfoVO.uuid = $(xmldata).find("uuid").text();
        deviceInfoVO.os = $(xmldata).find("os").text();
        deviceInfoVO.telno = $(xmldata).find("telno").text();
        deviceInfoVO.strgeInfo = $(xmldata).find("strgeInfo").text();
        deviceInfoVO.ntwrkDeviceInfo = $(xmldata).find("ntwrkDeviceInfo").text();
        deviceInfoVO.pgVer = $(xmldata).find("pgVer").text();
        deviceInfoVO.deviceNm = $(xmldata).find("deviceNm").text();
                
        $('.deviceInfo:eq(6)').html(deviceInfoVO.os);
        $('.deviceInfo:eq(7)').html(deviceInfoVO.uuid);
        $('.deviceInfo:eq(8)').html(deviceInfoVO.pgVer);
        $('.deviceInfo:eq(9)').html(deviceInfoVO.telno);
        $('.deviceInfo:eq(10)').html(deviceInfoVO.ntwrkDeviceInfo);
        $('.deviceInfo:eq(11)').html(deviceInfoVO.strgeInfo);
        $("#btnDelDeviceInfo").attr("href","javascript:fn_egov_confirm_delete_deviceInfo(" + deviceInfoVO.sn + ");");
                
    });

    console.log("DeviceAPIGuide fn_egov_request_deviceInfoDetail request Completed");
        
    $.mobile.changePage("#deviceInfoDetail", "slide", false, false);
    detailScroll.refresh();
}

/**
 * Device Info 삭제 확인 function.
 * @returns 디바이스 정보 삭제 전 사용자 확인을 수행한다.
 * @type  
 */
function fn_egov_confirm_delete_deviceInfo(sn){
    jConfirm('정말삭제하시겠습니까?', '알림', 'c', function(r){
        if(r == true){
            fn_egov_delete_deviceInfo(sn);
        }else{
             
        }
             
    });    
    
}

/**
 * Device Info 삭제 확인 function.
 * @returns 서버에 저장된 디바이스 정보 삭제를 요청한다.
 * @type  
 */
function fn_egov_delete_deviceInfo(data){
    var url = "/dvc/xml/withdrawal.do";
    var accept_type = "json";
    
    var params = {sn : String(data)};
    // send the data
    egovHyb.post(url, accept_type, params, function(jsondata) {
        var data = JSON.parse(jsondata);
        
        if(data.useYn == "OK"){

            console.log("DeviceAPIGuide fn_egov_delete_deviceInfo request Completed");
            fn_egov_move_deviceInfoList();
        }else{
            $("#alert_dialog").click( function() {
                jAlert('데이터 삭제 중 오류가 발생 했습니다.', '삭제 오류', 'c');
            });
        }
        
    });
        
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

function permissionSuccess(status) {
    console.log('### check permission');
    if( !status.hasPermission ) {
        permissionError();
    } else {
        console.log('### permission is OK');
    }
}

function permissionError() {
    console.warn('### permission is not turned on');
}
