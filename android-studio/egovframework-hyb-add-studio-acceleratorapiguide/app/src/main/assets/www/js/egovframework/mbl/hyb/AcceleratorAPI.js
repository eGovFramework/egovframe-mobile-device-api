/** 
 * @fileoverview 모바일 전자정부 하이브리드 앱 Accelerator API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 서형주
 * @version 1.0 
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2015. 4. 20.   신용호 		iscroll5 적용
 * @ 2019.10. 16.   이정은       알림메시지 추가
 */

/*********************************************************
 * three.js
 *********************************************************/
/** 도형을 출력할 DOM을 담는 컨테이너 */
var container;

/** 도형 출력 설정 변수 */
var camera, scene, renderer;

/** 도형 */
var cube;

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
 * 3D 도형 초기화 function.
 * @returns 화면에 3D 도형을 초기화 한다.
 * @type  
*/
function initCube() {
    
    var $container = $('#container');

    scene = new THREE.Scene();

    camera = new THREE.PerspectiveCamera( 70, window.innerWidth / window.innerHeight, 1, 1000 );
    camera.position.x = 0;
    camera.position.y = 200;
    camera.position.z = 500;
    scene.add( camera );
    
    //ambientLight = new THREE.AmbientLight( 0x222222 );
    //scene.add( ambientLight );

    //directionalLight = new THREE.DirectionalLight( 0xffeedd, 1 );
    //directionalLight.position.set( 1, -1, 1 ).normalize();
    //scene.add( directionalLight );
            
    material = new THREE.MeshBasicMaterial( { map: THREE.ImageUtils.loadTexture( 'images/egovframework/mbl/hyb/accelerator_img.png' ) });
    geometry = new THREE.CubeGeometry( 200, 200, 200, 1, 1, 1, material  );

    cube = new THREE.Mesh( geometry, new THREE.MeshFaceMaterial());
    cube.position.x = -10;
    cube.position.y = 350;
    scene.add( cube );

    renderer = new THREE.CanvasRenderer();
    renderer.setSize( window.innerWidth, window.innerHeight );

    $container.append(renderer.domElement);

}

//
/**
 * 3D 도형 애니메이션 함수.
 * @returns 화면에 3D 도형을 움직이도록 한다.
 * @type  
*/
function animateCube() {

    requestAnimationFrame( animateCube );

    render();

}

/**
 * 3D 도형 렌더링 함수.
 * @returns 화면에 3D 도형 설정값을 변경한다.
 * @type  
*/
function render() {

    xMovement = movementFlag(xaxis, accInitX);
    yMovement = movementFlag(yaxis, accInitY);

    if(xMovement>0 /*&& xrotateSpeed > -3.14/2*/){
        xrotateSpeed = xrotateSpeed - 0.05;
    }else if(xMovement<0/* && xrotateSpeed < 3.14/2*/){
        xrotateSpeed = xrotateSpeed + 0.05;
    }else{
        xrotateSpeed = xrotateSpeed;
    }
    
    if(yMovement>0/* && yrotateSpeed > -3.14/2*/){
        yrotateSpeed = yrotateSpeed - 0.05;
    }else if(yMovement<0/* && yrotateSpeed < 3.14/2*/){
        yrotateSpeed = yrotateSpeed + 0.05;
    }else{
        yrotateSpeed = yrotateSpeed;
    }
    
    cube.rotation.y += ( xrotateSpeed - cube.rotation.y ) * 0.05;
    cube.rotation.x += ( -yrotateSpeed - cube.rotation.x ) * 0.05;
    renderer.render( scene, camera );

}

/**
 * 가속도 값 변경 함수.
 * @returns 가속도 값에 따른 변화에 대한 결과를 반영한다.
 * @type  
*/
function movementFlag (xy, initxy){
    if (Math.abs(xy - initxy) > accThreshold)
        if (xy < initxy)
            return -1;
        else
            return 1;
    return 0;
}

/** 
 * RestService를 담당할 EgovHybrid 객체 생성(서버 주소를 파라미터로 전달하여 초기화한다.
 * @type EgovHybrid
*/
var egovHyb = new EgovInterface();

/**
 * Accelerator Info 화면 이동 function.
 * @returns 디바이스 내 네트워크 정보를 볼 수 있는 화면으로 이동.
 * @type
*/
function fn_InquireAccelerationInfo() {
    
    $.mobile.changePage('#acceleratorInfo', 'slide', false, false);

}

/**
 * Accelerator Info List 화면 이동 function.
 * @returns 서버에 저장된 네트워크 정보를 요청받아 XML 리스트 반환한다.
 * @type  
*/
function fn_InquireAccelerationInfoListXml()
{
    if(!fn_egov_network_check(false)){
        return;
    }
    
    var url = "/acl/xml/acceleratorInfoList.do";
    var accept_type = "xml";
    // get the data from server
    window.plugins.EgovInterface.get(url,accept_type, null, function(xmldata) {
        var list_html = "";
        var listLength = xmldata.length;

        console.log("listLength >>>>>" +listLength);

        if (listLength == "85") {
                        jAlert('저장된 가속도 정보가 없습니다.', 'info', 'c');
                        return;
                    }

        $(xmldata).find("acceleratorInfoList").each(function(){
            var uuid = $(this).find("uuid").text();
            var x = $(this).find("xaxis").text();
            var y = $(this).find("yaxis").text();
            var z = $(this).find("zaxis").text();
            var t = $(this).find("timestamp").text();

            list_html += "<li><h3>UUID : " + uuid + "</h3>";
            list_html += "<p><strong>xaxis : " + x + "</strong></p>";
            list_html += "<p><strong>yaxis : " + y + "</strong></p>";
            list_html += "<p><strong>zaxis : " + z + "</strong></p>";
            list_html += "<p>timestamp : " + t + "</p></li>";
        });
        var theList = $('#theList');
        theList.html(list_html);
        $.mobile.changePage("#accelratorInfoList", "slide", false, false);
        theList.listview("refresh");
        
    });

    console.log("DeviceAPIGuide fn_InquireAccelerationInfoListXml request Completed");
}

/**
 * Accelerator Info 서버 전송 function.
 * @returns 화면에 표시된 네트워크 정보를 서버에 저장 요청한다.
 * @type  
*/
function fn_registAcceleratorInfo() {
    
    useYn = "Y";
            
    var url = "/acl/xml/addAcceleratorInfo.do"; 
    var accept_type = "json";
    var params = {uuid :  device.uuid,
            xaxis: xaxis + '', 
            yaxis: yaxis + '', 
            zaxis: zaxis + '', 
            timestamp: timeStamp + '', 
            useYn:  useYn};    
    
    // send the data
    egovHyb.post(url, accept_type, params, function(jsondata) {
        var data = JSON.parse(jsondata);
        
        if(data.useYn == "OK"){
            fn_InquireAccelerationInfoListXml();
        }else{
            $("#alert_dialog").click( function() {
                jAlert('데이터 전송 중 오류가 발생 했습니다.', '전송 오류', 'c');
                });
        }            
        
    });

    console.log("DeviceAPIGuide fn_registAcceleratorInfo request Completed");
    
}

/**
 * Accelerator Info List 삭제 요청 function.
 * @returns 서버에 저장된 네트워크 정보를 삭제 요청한다.
 * @type  
*/
function fn_DelAccelerationInfoList() {
    var url = "/acl/xml/withdrawal.do";
    var accept_type = "json";
    // send the data
    egovHyb.post(url, accept_type, null, function(jsondata) {
        var data = JSON.parse(jsondata);
        
        if(data.useYn == "OK"){
        	$.mobile.changePage($("#acceleratorInfo"), {reverse: true});
        }else{
            $("#alert_dialog").click( function() {
                jAlert('데이터 삭제 중 오류가 발생 했습니다.', '삭제 오류', 'c');
                });
        }
        
    });

    console.log("DeviceAPIGuide fn_DelAccelerationInfoList request Completed");
        
}

/**
 * Accelerator Info 전송 확인 function.
 * @returns 네트워크 정보를 서버에 전송전 사용자 확인을 수행한다.
 * @type  
*/
function confirm_registAcceleratorInfo(){
    
    if(!fn_egov_network_check(false)){
        return;
    }
    
    jConfirm('Accelerator 정보를 서버로 전송 하시겠습니까?', '알림', 'c', function(r){
        if(r == true){
            fn_registAcceleratorInfo();
        }else{
            
        }
        
    });    
    
}

/**
 * Accelerator Info List 삭제 확인 function.
 * @returns 네트워크 정보 삭제 전 사용자 확인을 수행한다.
 * @type  
*/
function confirm_DelAccelerationInfoList(){
    
    if(!fn_egov_network_check(false)){
        return;
    }    
    
    jConfirm('정말삭제하시겠습니까?', '알림', 'c', function(r){
        if(r == true){
            fn_DelAccelerationInfoList();
        }else{
            
        }
        
    });    
}

/*********************************************************
 * Accelerator
 *********************************************************/

/** 센서 업데이트 타이머 */
var accelerationWatch = null;

/** 한번만 기록 */
var accelInsertCheck = false;

/** x좌표 */
var xaxis = 0;
var accInitX = 0;

/** y좌표 */
var yaxis = 0;
var accInitY = 0;

/** z좌표 */
var zaxis = 0;
var accInitZ = 0;

/** 최초 가속도 값 플래그 */
var firstRefresh = true;

var accThreshold = 0.5;

/** 도형의 이동 속도 */
var xrotateSpeed = 0;
var yrotateSpeed = 0;

/** time stamp */
var timeStamp;

/**
 * 주기적으로 화면에 Accelerator 정보 표출
 * @returns 
 * @type
 */
function fn_egov_update_Acceleration(accelInfo) 
{
    xaxis = accelInfo.x;
    yaxis = accelInfo.y;
    zaxis = accelInfo.z;
    timeStamp = accelInfo.timestamp;
    
    var html = "X : " + xaxis + "<BR />" + "Y : " +  yaxis + "<BR />" + "Z : "  + zaxis;
    
    $("#infoDetail").css("text-align", "center");
    $("#infoDetail").css("margin-left", "1px");    
    
    html += ""
    $("#infoDetail").html(html);
    
    if (firstRefresh)
    {
        accInitX = xaxis;
        accInitY = yaxis;
        accInitZ = zaxis;
        firstRefresh = false;
    }

    console.log("DeviceAPIGuide fn_egov_update_Acceleration Success"); 
    
}

/**
 * Accelerator 장치 가동 및 업데이트 타이머 설정
 * @returns 
 * @type
 */
function fn_egov_get_acceleration() 
{
    if (accelerationWatch == null) 
    {
        var options = {};
        options.frequency = 1000;
        accelInsertCheck = true;
        accelerationWatch = navigator.accelerometer.watchAcceleration(fn_egov_update_Acceleration, 
                                                                      function(ex) 
                                                                      {
                                                                          console.log("DeviceAPIGuide fn_egov_get_acceleration fail");
                                                                      },
                                                                      options);
    } 
    else 
    {
        navigator.notification.alert("acceleration stop");
        navigator.accelerometer.clearWatch(accelerationWatch);
        accelerationWatch = null;
    }
};

/*********************************************************
 * HTML 및 이벤트 관련 함수
 *********************************************************/

/**
 * 화면을 위한 관련 이벤트
 */

$(function(){
	
	$(document).on('pageshow', '#accelratorInfoList', function(event, ui) {
	    
	    if(myScroll != null) {
	        
	    	myScroll.destroy();
	    }
	    loaded('#wrapper');
	});
    
    $('#btnSaveAcceleratorInfo').click(function () {
        // 가속도 정보 저장
        confirm_registAcceleratorInfo();
    });   
    
    $('#btnMoveAccelratorInfoList').click(function () {
        // 가속도 정보 리스트 화면 이동
        fn_InquireAccelerationInfoListXml();
    }); 
    
    $('#btnInquireAccelerationInfo').click(function () {
        // 가속도 정보 화면 이동
        fn_InquireAccelerationInfo();
    }); 
    
    $('#btnDelAccelerationInfo').click(function () {
        // 가속도 정보 삭제
        confirm_DelAccelerationInfoList();
    }); 
    
});