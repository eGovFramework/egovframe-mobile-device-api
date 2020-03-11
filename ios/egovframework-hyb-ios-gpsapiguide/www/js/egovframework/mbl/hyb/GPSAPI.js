/**
 * @Class Name : index.html
 * @Description : 모바일 전자정부 하이브리드 앱 PKIMagicXSign API 가이드 프로그램 JavaScript
 * @Modification Information
 *
 *   수정일      수정자                   수정내용
 *  -------    --------    ---------------------------
 *       07.31 이한철        최초생성
 *. 2019.07.18 김효수        DAUM API => KAKAO API 변경 적용
 *
 * Copyright (C) 2009 by MOPAS  All right reserved.
 */

var myScroll;

/*********************************************************
 * HTML 및 이벤트 관련 함수
 *********************************************************/

/**
 * 화면을 위한 관련 이벤트
 */
function init() {
	
    $('#goMyLocation').click(function () {
                               if (fn_egov_network_check(false)) {
                                   //$.mobile.changePage($(#page_id), {changeHash : false});
                                   $.mobile.changePage("#myLocation", "slide", false, false);
                                   $.mobile.loading("show");
                                   navigator.geolocation.getCurrentPosition(onSuccess, onError);
                               }
                           });
  
    $('#goGpsInfoList').click(function () {
                            if (fn_egov_network_check(false))
                                fn_egov_go_gpsInfoList();
                            });
    $('#saveBtn').click(function () {
                      if (fn_egov_network_check(false))
                          fn_egov_go_addGpsInfo();
                      });
    $('#deleteBtn').click(function () {
                        if (fn_egov_network_check(false))
                            fn_egov_go_deleteGpsInfo();
                      });
    $('#reloadBtn').click(function () {
                        if (fn_egov_network_check(false))
                            navigator.geolocation.getCurrentPosition(onSuccess, onError);
                        });
}

/**
 * iscroll setting function
 * @returns iscroll event 처리
 * @type
 */
function loadiScrollInfo() {
	
    myScroll = new IScroll('#wrapperInfo', {
        scrollX: true,
        scrollbars: true,
        mouseWheel: true,
        interactiveScrollbars: true,
        shrinkScrollbars: 'scale',
        fadeScrollbars: true,
        click: true
    });
    document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

}

/**
 * iscroll setting function
 * @returns iscroll event 처리
 * @type
 */
function loadiScrollList() {
	
    myScroll = new IScroll('#wrapperList',{
        scrollX: true,
        scrollbars: true,
        mouseWheel: true,
        interactiveScrollbars: true,
        shrinkScrollbars: 'scale',
        fadeScrollbars: true,
        click: true
    });
}

var lat;
var lon;

/**
 * gps 값을 정상적으로 읽어왔을때 callback 함수
 * @returns
 * @type
 */
function onSuccess(position) {
    console.log("GPSAPIGuide navigator.geolocation.getCurrentPosition Success");
    console.log('Latitude: ' + position.coords.latitude + '\nLongitude: ' + position.coords.longitude);
    lat = position.coords.latitude;
    lon = position.coords.longitude;
    var html = "";
    html = '위도 : ' + position.coords.latitude + '<br/>';
    html += '경도 : ' + position.coords.longitude + '';
	
    $('#latlngInfo').html(html);

    // 현재 위치 좌표*
    var latlng =  new kakao.maps.LatLng(position.coords.latitude, position.coords.longitude);
	
    // 지도 설정*
    var myOptions = {
        level: 4,
        center: latlng,
        mapTypeId: kakao.maps.MapTypeId.ROADMAP
    };
	
    // 지도 생성*
    var map = new kakao.maps.Map(document.getElementById("map"), myOptions);
    map.addControl(new kakao.maps.ZoomControl());
    
    // 현재 위치 마커 표시*
    var curMarker = new kakao.maps.Marker({
                                         position: latlng
                                         });
    curMarker.setMap(map);
	
    var infowindow = new kakao.maps.InfoWindow({
                                              content: '<font size=2>위도:'+position.coords.latitude + '<br/>' + '경도:'+position.coords.longitude+'</font>'
                                              });
    infowindow.open(map, curMarker);
    
    $.mobile.loading("hide");
//    var element = document.getElementById('geolocation');
//    element.innerHTML = 'Latitude: '           + position.coords.latitude              + '<br />' +
//    'Longitude: '          + position.coords.longitude             + '<br />' +
//    'Altitude: '           + position.coords.altitude              + '<br />' +
//    'Accuracy: '           + position.coords.accuracy              + '<br />' +
//    'Altitude Accuracy: '  + position.coords.altitudeAccuracy      + '<br />' +
//    'Heading: '            + position.coords.heading               + '<br />' +
//    'Speed: '              + position.coords.speed                 + '<br />' +
//    'Timestamp: '          +                                   position.timestamp          + '<br />';
}

/**
 * gps 값을 못 읽어왔을때 callback 함수
 * @returns
 * @type
 */
function onError(error) {
    console.log("GPSAPIGuide navigator.geolocation.getCurrentPosition Failed");
    alert('위치정보가 켜져 있는지 확인해 주십시오.');
    $.mobile.loading("hide");
    console.log('code: '    + error.code    + '\n' + 'message: ' + error.message + '\n');
}


/**
 * 서버에 저장된 gps 정보 목록 읽기
 * @returns
 * @type
 */
function fn_egov_go_gpsInfoList()
{
    console.log('fn_egov_go_gpsInfoList()');
    
    var params = {uuid : device.uuid, useYn: 'Y'};

    $.mobile.changePage("#gpsInfoList", "slide", false, false);
    $.mobile.loading("show");
    // get the data from server
    EgovInterface.submitAsynchronous(
                                     [params, "/gps/gpsInfoList.do"],
                                     function(result) {
                                         console.log("GPSAPIGuide fn_egov_go_gpsInfoList request Completed");
                                         var list_html = "";
                                         var totcnt = result.gpsInfoList.length;
                                     
                                     
                                     if(result.gpsInfoList.length == '0'){
                                        $.mobile.loading("hide");
                                        navigator.notification.alert("저장된 DB목록이 없습니다.", null, 'Info');
                                        return;
                                     }
                                     
                                         for (var i = 0; i < totcnt; i++) {
                                             var data = result.gpsInfoList[i];
                                             list_html += "<li><h3>UUID : " + data.uuid + "</h3>";
                                             list_html += "<p>위도 : " + data.la + "</p>";
                                             list_html += "<p>경도 : " + data.lo + "</p></li>";
                                         }
                                         var theList = $('#theLogList');
                                         theList.html(list_html);
                                         theList.listview("refresh");
                                         $.mobile.loading("hide");
                                         setTimeout(loadiScrollList, 1000);
                                     },
                                     function(error) {
                                         console.log("GPSAPIGuide fn_egov_go_gpsInfoList request Failed");
                                         var str = '{';
                                         for (var myKey in error){
                                             str += myKey + ' : ' + error[myKey] + '\n';
                                         }
                                         str += '}';
                                         alert('응답방식:RESTful\n전송Type:json, post\nParam:\n' + str);
                                         $.mobile.loading("hide");
                                     }
                                     );
    
}

/**
 * 서버에 현재 gps 정보 추가
 * @returns
 * @type
 */
function fn_egov_go_addGpsInfo()
{
    console.log('fn_egov_go_addGpsInfo()');
    
    var params = {uuid : device.uuid,
                    lat: lat,
                    lon: lon,
                    useYn: 'Y'};
    
    $.mobile.loading("show");
    alert('Http Method:POST\nAcceptType:JSON\n전송데이터:' + JSON.stringify(params));

    EgovInterface.submitAsynchronous(
                                     [params, "/gps/addGPSInfo.do"],
                                     function(result) {
                                         console.log("GPSAPIGuide fn_egov_go_addGpsInfo request Completed");
                                         var str = '{';
                                         for (myKey in result){
                                             str += myKey + ':' + result[myKey] + '\n';
                                         }
                                         str += '}';
                                         alert('응답방식:RESTful\n응답Type:json, post\nParam:\n' + str);
                                         //window.history.back();
                                         $.mobile.loading("hide");
                                         location.href = "GPSAPI.html";
                                     },
                                     function(error) {
                                         console.log("GPSAPIGuide fn_egov_go_addGpsInfo request Failed");
                                         var str = '{';
                                         for (myKey in error){
                                             str += myKey + ' : ' + error[myKey] + '\n';
                                         }
                                         str += '}';
                                         alert('응답방식:RESTful\n전송Type:json, post\nParam:\n' + str);
                                         $.mobile.loading("hide");
                                     }
                                     );
    
}

/**
 * 서버에 저장된 gps 정보들을 삭제
 * @returns
 * @type
 */
function fn_egov_go_deleteGpsInfo()
{
    console.log('fn_egov_go_deleteGpsInfo()');
    
    
    
    
    
    
    
    
    
    
    
    var params = {uuid : device.uuid};
    
    // get the data from server
    jConfirm('전송방식:RESTful\n전송Type:json, post\nParam:\n' + 'url:/gps/deleteGPSInfo.do', '알림', 'c', function(r){
             if(r == true){
                 $.mobile.loading("show");
                 EgovInterface.submitAsynchronous(
                	        [params,"/gps/deleteGPSInfo.do"],
                	        function(result) {

                	            console.log("GPSAPIGuide fn_egov_go_deleteGpsInfo request Completed");
                	            console.log("GPS Log List Request Completed");
                	            var str = '{';
                	            for (myKey in result){
                	                str += myKey + ':' + result[myKey] + '\n';
                	            }
                	            str += '}';
                	            alert('응답방식:RESTful\n응답Type:json, post\nParam:\n' + str);
                	            //window.history.back();
                	            $.mobile.loading("hide");
                	            location.href = "GPSAPI.html";
                	            
                	        },
                	        function(error) {
                	       	 
                	            console.log("GPSAPIGuide fn_egov_go_deleteGpsInfo request Failed");
                	            var str = '{';
                	            for (var myKey in error){
                	                str += myKey + ' : ' + error[myKey] + '\n';
                	            }
                	            str += '}';
                	            alert('응답방식:RESTful\n전송Type:json, post\nParam:\n' + str);
                	            $.mobile.loading("hide");
                	        }
                	    );
             }else{
                 return;
             }
	});
}
