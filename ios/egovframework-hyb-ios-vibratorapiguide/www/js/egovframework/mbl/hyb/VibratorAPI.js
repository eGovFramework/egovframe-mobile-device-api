/** 
 * 모바일 전자정부 하이브리드 앱 Vibrator API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 이해성
 * @version 1.0 
 *
 * @ 수정일          수정자         수정내용
 * @ ----------    --------     -------------------------------
 * @ 2015.06.05    신용호         validate 명칭수정
 * @ 2019.07.18    김효수         navigator.notification.vibrate() => navigator.vibrate() 변경 적용
 * @ 2019.10.17    신용호         서버 저장이력 안내메시지 추가
 */

/** 최초 프로그램 실행시 사용자 승인 받는 변수 */
var ProgramCheck = true;

/**
 * 완료 버튼 클릭시 알림 타이머 셋팅
 * @returns
 * @type 
 */
function fn_egov_save_notificationConfig()
{    
    if($("#swchBeep").val() === "off" && $("#swchVibration").val() === "off")
    {
        jAlert("알람 설정이 off 되어 있습니다.", "알림", "b");
    }
    else
    {
        var setTime = $("#txtNotification").val();
        setTimeout ( "fn_egov_set_alram()", setTime * 1000);
        jAlert("알람이 " + setTime + " 초 뒤에 설정 되었습니다.", "알림", "b");
    }
}

/**
 * 알림 동작 수행
 * @returns
 * @type 
 */
function fn_egov_set_alram()
{
    if($("#swchBeep").val() === "on")
    {
        navigator.notification.beep(3);
    }
    
    if($("#swchVibration").val() === "on")
    {
        navigator.vibrate(3000);   // 3 second
    }
    
    if(fn_egov_network_check(false))     // 통신 이벤트 발생시 3G 사용자 승인여부 판단
    {
        var setTime = fn_egov_get_nowTime();
        var params = {
            uuid :  device.uuid,
            timeStamp : setTime
        };
        
        $.mobile.loading("show");
        // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
        setTimeout(function()
                   {
                       fn_egov_sendto_server("/vbr/addVibratoriOSInfo.do",params);
                   }, 
                   500);
    }
    
    jAlert("알람", "알림", "b");
}

/**
 * 알림 설정 정보 열기 ( 상세 페이지 이동 )
 * @returns
 * @type 
 */
function fn_egov_go_detailPage(result)
{
    $("#dataList").html("");
    var html = "";
    var resultRows = result["VibratorInfoList"];
    
    if(resultRows.length > 0)
    {
        for ( var i = 0; i < resultRows.length; i++) 
        {
            html += '<li>'+resultRows[i]["timestamp"]+'</li>'; 
        }
    }

    $.mobile.changePage('#apiListView', 'slide', false, false);
    $("#dataList").html(html).listview('refresh');

    if(resultRows.length == 0) {
        jAlert("서버에서 조회된 목록이 0건입니다.", "알림", "b");
        return;
    }
    
    apiListViewScroll.refresh();
 
}



/*********************************************************
 * 서버 통신
 *********************************************************/

/**
 *  서버로 전송
 * @returns
 * @type 
 */
function fn_egov_sendto_server(serviceName, params)
{
  EgovInterface.submitAsynchronous(
    [params, serviceName],
    function(result) 
    {
      var str = result["resultState"];
      if(str === "OK")
      {
        if(serviceName === "/vbr/VibratoriOSInfoList.do")
        {  // 서버에 있는 알림 목록 리스트
          fn_egov_go_detailPage(result);
        }
        else if(serviceName === "/vbr/addVibratoriOSInfo.do")
        {
          toast("서버에 알람이력을 저장하였습니다.");
        }
        console.log("DeviceAPIGuide fn_egov_sendto_server Response Completed");
      }
      else
      {  
        console.log("DeviceAPIGuide fn_egov_sendto_server Response Failed");
        jAlert('Server 내부 장애.', '알림', 'c');
      }
      $.mobile.loading("hide");
    },
    function(error) 
    {
      $.mobile.loading("hide");
      console.log("DeviceAPIGuide fn_egov_sendto_server Request Failed");
      jAlert('Request error. 서버가 종료되었거나 \n통신이 원활하지 않습니다.', '알림', 'c');
  });
}


/*********************************************************
 * 공통
 *********************************************************/

// Wait for PhoneGap to load
// 
document.addEventListener("deviceready", onDeviceReady, false);

/**
 * PhoneGap is loaded and it is now safe to make calls PhoneGap methods
 * @returns
 * @type 
 */
function onDeviceReady() 
{
    if(fn_egov_network_check(true))
    {
        ProgramCheck = false;
    }

    document.addEventListener('DOMContentLoaded', function () { setTimeout(loaded, 200); }, false);
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
}

/**
 * 현재 시간 정보
 * @returns 현재시간
 * @type 
 */ 
function fn_egov_get_nowTime() 
{
    var today = new Date();
    var nowTime = today.getFullYear() + "-" + (today.getMonth()+1) + "-" + today.getDate() + " " + today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
    return nowTime;
}

/** iScroll 영역을 재설정 하기 위한 iScroll 전역 변수 */
var apiListViewScroll = null;

/**
 * iscroll 이 로딩 되기전 모든 컨트롤이 다 로딩 되도록 기달려 주는 함수
 * @returns
 * @type
 */
function fn_egov_wait_iscroll(thisPage)
{
    setTimeout(function()
    {

        apiListViewScroll = new IScroll(thisPage, {
                              scrollX: true,
                              scrollbars: true,
                              mouseWheel: true,
                              interactiveScrollbars: true,
                              shrinkScrollbars: 'scale',
                              fadeScrollbars: true,
                              click: true
                              });
        //apiListViewScroll.refresh();
        
        document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
    
    },
    500);
}

/**
 * 화면 단의 각 이벤트 설정
 * @returns 현재시간
 * @type 
 */ 
$(function()
{
  $("#btnNotificationList").click(function()
    {
        if(ProgramCheck)
        {
            if(fn_egov_network_check(true))
            {
                ProgramCheck = false;
            }
        }
        else
        {
            if(fn_egov_network_check(false))
            {
                var params = {};	
    
                $.mobile.loading("show");
                // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
                setTimeout(function()
                           {
                               fn_egov_sendto_server("/vbr/VibratoriOSInfoList.do",params);
                           }, 
                           500);
            }
        }
    });
  
  $("#btnNotification").click(function()
    {
        if(ProgramCheck)
        {
            if(fn_egov_network_check(true))
            {
                ProgramCheck = false;
            }
        }
        else
        {
            $("#myform").submit();
        }
    });
  
  $(document).on('pageshow', "#apiListView",
     function(event, ui) 
     {
         /*
         $(document).on('touchmove', "#apiListView",
                                function (e) 
                                { 
                                    e.preventDefault(); 
                                }, 
                                false);
         */
         fn_egov_wait_iscroll('#wrapper');
     });
  
  $(document).on('pagehide', "#apiListView",
     function(event, ui) 
     {
         apiListViewScroll.destroy();
     });
});

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
