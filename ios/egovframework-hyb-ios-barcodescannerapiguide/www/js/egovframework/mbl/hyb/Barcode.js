/** 
 * @fileoverview 모바일 전자정부 하이브리드 앱 barcodescanner API 가이드 프로그램 JavaScript
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
	$("#btnBarcodescannerInfo").attr("href", "javascript:fn_egov_load_scan();");
	$("#btnBarcodescanneList").attr("href", "javascript:fn_egov_move_BarcodescanneList();");
	$("#btnBarcodescannerSave").attr("href","javascript:fn_egov_save_BarcodescannerInfo();");
	
	

};

var scanformats;
var scanContents;

function fn_egov_load_scan() {
	
	scanBarcode();
};

function scanBarcode() {

	
	cordova.plugins.barcodeScanner.scan(function(result) {

		scanformats = result.format;
		scanContents = result.text;

        if(result.cancelled == 1){
           $.mobile.changePage('#main', 'slide', false, false);
        }else{
           fn_egov_load_BarcodescannerInfo();
        }
                                        

	}, function(error) {
		console.log("Scanning failed: " + error);

	});
};

/**
 * BarcodescannerInfo 상세정보 표시 function.
 * 
 * @returns Barcodescanner API를 이용하여 정보를 화면에 표시.
 * @type
 */
function fn_egov_load_BarcodescannerInfo() {

	$('.scannerInfo:eq(0)').html(scanformats);
	$('.scannerInfo:eq(1)').html(scanContents);

	$.mobile.changePage('#BarcodescannerInfo', 'slide', false, false);
}

/**
 * BarcodescannerInfo 정보 저장 function.
 * 
 * @returns Barcodescanner API를 이용하여 정보를 서버에 저장.
 * @type
 */
function fn_egov_save_BarcodescannerInfo() {

	useYn = "Y";

	var url = "/bar/addBarcodescannerDeviceInfo.do";
	
	var formats = $(".scannerInfo:eq(0)").text();
	var contents = $(".scannerInfo:eq(1)").text();
	

	nowdate = new Date();
	var date_str = nowdate.getFullYear() + "-" + (nowdate.getMonth() + 1) + "-"
			+ nowdate.getDate();

	console.log("formats > " + formats + "\n contents >>>  " + contents + "\n date_str : >>>>" + date_str + "<<<<<<");
	
	var params = {
		codeType : formats,
		codeText : contents,
		useYn : useYn,
		sndDt : date_str		
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
		console.log("error > " + result);
	});

	console.log("BarcodescannerDevice fn_egov_save_BarcodescannerInfo request Completed");
	
	$.mobile.changePage("#main", "slide", false, false);
	listScroll.refresh();

}


/**
 * 서버에서 반환한 Barcodescanner 정보 리스트를 화면에 출력한다.
 * @returns
 * @type  
 */
function fn_egov_move_BarcodescanneList() {
    var url = "/bar/BarcodescannerInfoList.do";
    var accept_type = "json";    
    var params = {useYn : "Y" };
    
    // get the data from server
    window.plugins.EgovInterface.request(url, params, function(jsonData) {
        var list_html = "";
        var listCount = $(jsonData["BarcodescannerInfoList"]).length;
        $(jsonData["BarcodescannerInfoList"]).each(function(idx,obj){
            var sn = obj.sn;
            var codeType = obj.codeType;
            var codeText = obj.codeText;
            var sndDt = obj.sndDt;

            console.log("codeType >>>> " + codeType + "\n codeText >>>>>>> " + codeText + "\n sndDt >>> " + sndDt + "<<<<<<");
            
            list_html += "<li><h3>CodeType : " + codeType + "</h3>";
            list_html += "<p><strong>CodeText : " + codeText + "</strong></p>";
            list_html += "<p>Date : " + sndDt + "</p></li>";
        });
        
        console.log("BarcodescanneAPIGuide fn_egov_move_BarcodescanneList request Completed");
        
        var theList = $('#BarcodeInfoList');
        theList.html(list_html);
        $.mobile.changePage("#BarcodescannerList", "slide", false, false);
        theList.listview("refresh");

        if (listCount < 1) {
            jAlert('서버에 저장된 바코드\n 목록이 없습니다.','알림','b');
        } else {
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
	window.addEventListener("batterycritical", fn_egov_onBatteryCritical, false);
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
