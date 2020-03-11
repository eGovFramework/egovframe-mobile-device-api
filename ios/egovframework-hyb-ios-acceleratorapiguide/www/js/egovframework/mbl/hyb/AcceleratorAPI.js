/** 
 * @fileoverview 모바일 전자정부 하이브리드 앱 Accelerator API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 서형주
 * @version 1.0 
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2012. 8. 14.   서준식		iOS 플랫폼에 적용
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

/** 서버에 저장된 가속도 정보 */
var acceleratorInfoListCount;

/**
 * 3D 도형 초기화 function.
 * @returns 화면에 3D 도형을 초기화 한다.
 * @type  
*/
function fn_egov_initCube() {
	
	var $container = $('#container');

	scene = new THREE.Scene();

	camera = new THREE.PerspectiveCamera( 70, window.innerWidth / window.innerHeight, 1, 1000 );
	camera.position.x = 0;
	camera.position.y = 200;
	camera.position.z = 500;
	scene.add( camera );
	
    
    // 빨간 선으로 출력
    //geometry = new THREE.CubeGeometry( 200, 200, 200 );
    //material = new THREE.MeshBasicMaterial( { color: 0xff0000, wireframe: true } );
	//cube = new THREE.Mesh( geometry, material);
    
    var materials = [];
    
    for ( var i = 0; i < 6; i ++ ) {
        
        materials.push( new THREE.MeshBasicMaterial( { color: Math.random() * 0xffffff } ) );
        
    }
    
    cube = new THREE.Mesh( new THREE.CubeGeometry( 120, 120, 120, 1, 1, 1, materials ), new THREE.MeshFaceMaterial() );
    
    
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
function fn_egov_animateCube() {

	requestAnimationFrame( fn_egov_animateCube );

	fn_egov_render();

}

/**
 * 3D 도형 렌더링 함수.
 * @returns 화면에 3D 도형 설정값을 변경한다.
 * @type  
*/
function fn_egov_render() {

	xMovement = fn_egov_movementFlag(xaxis, accInitX);
	yMovement = fn_egov_movementFlag(yaxis, accInitY);

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
function fn_egov_movementFlag (xy, initxy){
	if (Math.abs(xy - initxy) > accThreshold)
		if (xy < initxy)
			return -1;
		else
			return 1;
	return 0;
}



/**
 * Accelerator Info 화면 이동 function.
 * @returns 디바이스 내 Accelerator 정보를 볼 수 있는 화면으로 이동.
 * @type
*/
function fn_egov_InquireAccelerationInfo() {
	
	$.mobile.changePage('#acceleratorInfo');

}

/**
 * Accelerator Info List 화면 이동 function.
 * @returns 서버에 저장된 Accelerator 정보를 요청받아 리스트 반환한다.
 * @type  
*/
function fn_egov_InquireAccelerationInfoList()
{
    if(!fn_egov_network_check(false)){
        return false;
    }
    
	var url = "/acl/acceleratorInfoList.do";
    
    
    //iOS용 플러그인 적용
    var params = {};
    
    EgovInterface.submitAsynchronous([params, url],
                                     function(data){
                             
                                     
                                        if(data.resultState == "OK"){
                                            fn_egov_dispatch_acceleratorInfoList(data);
                                            
                                        }else{
                                        $("#alert_dialog").click( function() {
                                                            jAlert('데이터 전송 중 오류가 발생 했습니다.', '전송 오류', 'c');
                                                        });
                                        }
                                     },
                                        function(error) {
                                            $("#alert_dialog").click( function() {
                                                              jAlert('데이터 삭제 중 오류가 발생 했습니다.', '삭제 오류', 'c');
                                                            });
                                     }
                                );
}


/**
 * Accelerator Info List 화면 이동 function.
 * @returns 서버에 저장된 디바이스 정보를 요청받아 리스트 반환한다.
 * @type
 */
function fn_egov_dispatch_acceleratorInfoList(data){
    
    var list_html = "";
    acceleratorInfoListCount = data.acceleratorInfoList.length;
    
    for (var i = 0; i < acceleratorInfoListCount; i++) {
        result = data.acceleratorInfoList[i];

        
        list_html += "<li><h3>UUID : " + result.uuid + "</h3>";
        list_html += "<p><strong>xaxis : " + result.xaxis + "</strong></p>";
        list_html += "<p><strong>yaxis : " + result.yaxis + "</strong></p>";
        list_html += "<p><strong>zaxis : " + result.zaxis + "</strong></p>";
        list_html += "<p>timestamp : " + result.timestamp + "</p></li>";
        
    }
    
    var theList = $('#theList');
    theList.html(list_html);
    $.mobile.changePage("#AccelratorInfoList");
    theList.listview("refresh");
    if(myScroll != null) {
        myScroll.refresh();
    }
    if (acceleratorInfoListCount < 1) {
        jAlert('서버에 저장된 가속도\n 정보가 없습니다.','알림','b');
    }
    console.log("[DeviceAPIGuide] fn_egov_dispatch_acceleratorInfoList : Completed");
                                         
}

/**
 * Accelerator Info 서버 전송 function.
 * @returns 화면에 표시된 Accelerator 정보를 서버에 저장 요청한다.
 * @type  
*/
function fn_egov_registAcceleratorInfo() {
    if(!fn_egov_network_check(false)){
        return false;
    }
	useYn = "Y";
			
	var url = "/acl/addAcceleratorInfo.do"; 
	var accept_type = "json";
	var params = {uuid :  device.uuid,
			xaxis: xaxis + '', 
			yaxis: yaxis + '', 
			zaxis: zaxis + '', 
			timestamp: timeStamp + '', 
			useYn:  useYn};	
    

    //iOS용 플러그인 적용
    EgovInterface.submitAsynchronous([params, url],
                                     function(data){
                                     
                                        if(data.resultState == "OK"){
                                            navigator.notification.alert("전송 완료");
                                            console.log("[DeviceAPIGuide] fn_egov_registAcceleratorInfo : Completed");
                                            fn_egov_InquireAccelerationInfoList();
                                        }else{
                                            $("#alert_dialog").click( function() {
                                                            jAlert('데이터 전송 중 오류가 발생 했습니다.', '전송 오류', 'c');
                                                        });
                                        }
                                     },
                                     function(error) {
                                        $("#alert_dialog").click( function() {
                                                            jAlert('데이터 삭제 중 오류가 발생 했습니다.', '삭제 오류', 'c');
                                                        });
                                        }
                                     );
     
	
    
}

/**
 * Accelerator Info List 삭제 요청 function.
 * @returns 서버에 저장된 Accelerator 정보를 삭제 요청한다.
 * @type  
*/
function fn_egov_DelAccelerationInfoList() {
	
  
    //iOS용 플러그인 적용
    var params = {};
    EgovInterface.submitAsynchronous([params, "/acl/withdrawal.do"],
                                function(data){
                                     
                                     if(data.resultState == "OK"){
                                        $.mobile.changePage("#acceleratorInfo");
                                        console.log("[DeviceAPIGuide] fn_egov_DelAccelerationInfoList : Completed");
                                     }else{
                                        $("#alert_dialog").click( function() {
                                                            jAlert('데이터 전송 중 오류가 발생 했습니다.', '전송 오류', 'c');
                                                        });
                                }
                            },
                                function(error) {
                                        $("#alert_dialog").click( function() {
                                                            jAlert('데이터 삭제 중 오류가 발생 했습니다.', '삭제 오류', 'c');
                                                        });
                                });
    
	
	    
}

/**
 * Accelerator Info 전송 확인 function.
 * @returns Accelerator 정보를 서버에 전송전 사용자 확인을 수행한다.
 * @type  
*/
function fn_egov_confirm_registAcceleratorInfo(){
	jConfirm('Accelerator 정보를 서버로 전송 하시겠습니까?', '알림', 'c', function(r){
		if(r == true){
			fn_egov_registAcceleratorInfo();
		}else{
			
		}
		
	});	
	
}

/**
 * Accelerator Info List 삭제 확인 function.
 * @returns Accelerator 정보 삭제 전 사용자 확인을 수행한다.
 * @type  
*/
function fn_egov_confirm_DelAccelerationInfoList(){
	if (acceleratorInfoListCount < 1) {
        jAlert('서버에 저장된 가속도\n 정보가 없습니다.','알림','b');
    } else {
        jConfirm('정말삭제하시겠습니까?', '알림', 'c', function(r){
            if(r == true){
                fn_egov_DelAccelerationInfoList();
            }else{
                
            }
            
        });
    }
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
    //console.log("(Debug) fn_egov_update_Acceleration"+html);
    
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
        console.log("[DeviceAPIGuide] fn_egov_get_acceleration : start");
        var options = {};
        options.frequency = 1000;
        accelInsertCheck = true;
        accelerationWatch = navigator.accelerometer.watchAcceleration(fn_egov_update_Acceleration, 
                                                                    function(ex) 
                                                                    {
                                                                          console.log("(Error) accel fail (" + ex.name + ": " + ex.message + ")");
                                                                    },
                                                                    options);
    } 
    else 
    {
        console.log("[DeviceAPIGuide] fn_egov_get_acceleration : stop");
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
	
	$(document).on('pageshow','#AccelratorInfoList' ,function(event, ui) {
    	console.log('I will read iscroll !!');
    	
    	//objBody.removeChild(myScroll);	
    	if(myScroll != null) {
    		
    		myScroll.refresh();
    	}
	});

	$('#btnSaveAcceleratorInfo').click(function () {
    	// 가속도 정보 저장
		fn_egov_confirm_registAcceleratorInfo();
    });   
	
	$('#btnMoveAccelratorInfoList').click(function () {
    	// 가속도 정보 리스트 화면 이동
		fn_egov_InquireAccelerationInfoList();
    }); 
	
	$('#btnInquireAccelerationInfo').click(function () {
    	// 가속도 정보 화면 이동
		fn_egov_InquireAccelerationInfo();
    }); 
	
	$('#btnDelAccelerationInfo').click(function () {
    	// 가속도 정보 삭제
		fn_egov_confirm_DelAccelerationInfoList();
    }); 
	
});

/* ********************************************************
 * iScroll settion
 ******************************************************** */
var myScroll;
function fn_egov_loaded() {

    myScroll = new IScroll('#wrapper', {
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
