/** 
 * 모바일 전자정부 하이브리드 앱 Network API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 이해성
 * @version 1.0 
 * @ 수정일           수정자          수정내용
 * @ ----------    ---------    -------------------------------
 * @ 2015.06.13.   신용호         server URL EGovComModule에서 가져오도록 수정
 * @ 2019.10.14.   신용호         http://~~~/nwk/getMp3FileiOS.do 형태로 호출하는경우 서버에서 contentDisposition값을 설정하여 mp3로 인식시켜야 한다. (iOS에서 확장자를 인식하므로 주의필요, 설정하지 않으면 확장자를 .do로 인식함.)
 * @ 2019.10.15    신용호         사운드 재생 및 디바이스 정보 서버 저장시 Toast 안내 및 PopupWidget 안내 추가
 */

/** 서버 URL */
//var context = "http://192.168.100.140:8080/deviceWeb";
var context = ""; // EGovComModule.h 에서 가져온다.

/** 현재 열고 있는 페이지 넘버 */
var pageNumber = null;

/** iScroll 영역을 재설정 하기 위한 iScroll 전역 변수 */
var myScroll = null;

/** 미디어 장치 핸들 */
var mediaHandle = null;

/** 미디어 장치 타이머 */
var mediaTimer = null;

/** 재생중인지 체크 */
var audioCheck = false;

/** 네트워크 상태값 종류 */
var states = {};

/*********************************************************
 * 공통
 *********************************************************/
//document.addEventListener("deviceready", onDeviceReady, false);

function onDeviceReady()
{
    states[Connection.UNKNOWN]  = 'Unknown connection';
    states[Connection.ETHERNET] = 'Ethernet connection';
    states[Connection.WIFI]     = 'WiFi connection';
    states[Connection.CELL_2G]  = 'Cell 3G connection';
    states[Connection.CELL_3G]  = 'Cell 3G connection';
    states[Connection.CELL_4G]  = 'Cell 4G connection';
    states[Connection.NONE]     = 'No network connection';

    fn_egov_init_context();

    /** 상세 정보 화면에서 뒤로 버튼 */
    $("#btnMoveNetworkInfoListBack").click(function()
        {
           fn_egov_open_networkList();
        });
    
    /** 리스트 화면에서 뒤로 버튼 */
    $("#btnMoveNetworkInfo").click(function()
        {
           $.mobile.changePage('#vbrMain', 'slide', false, false);
        });
    
    /** 정보 삭제 버튼 */
    $("#btnDelNetworkInfo").click(function()
        {
          if(!confirm('삭제 하시겠습니까?'))
          {
              return;
          }

          fn_egov_click_deleteBtn();
        });
    
    document.addEventListener('DOMContentLoaded', function () { setTimeout(loaded, 200); }, false);
    
    fn_egov_get_deviceInfo();

    EgovInterface.geturl(function(serverContext){
        console.log("DeviceAPIGuide serverContext Config Success");
        
        context = serverContext; // EGovComModule.h 에서 가져온다.
    });
}

/**
 * 안드로이드의 toast 형태의 메시지 구현
 * @returns 현재시간
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
 * html 화면 관련 함수 
 *********************************************************/

/**
 * 디바이스 정보 표시
 *  @returns
 * @type
 */
function fn_egov_get_deviceInfo()
{
    var html = "<p>Network API Guide 프로그램은 디바이스 API를 사용하여 네트워크 상태를 체크하여 Wi-Fi 가 아닐 경우에는 사용자 승인을 받아 서비스를 제공하는 가이드 프로그램입니다.</p>";
    html += '<p>';
    html += '네트워크 상태 정보' + '<BR>';
    html += 'OS : '+ device.platform + '<BR>';
    html += 'UUID : ' + device.uuid + '<BR>';
    html += 'Network : ' + states[navigator.network.connection.type] + '</p>';
    $("#tblNetworkInfo").html(html);

    $.mobile.changePage('#vbrMain', 'slide', false, false);
}

/**
 * iscroll 이 로딩 되기전 모든 컨트롤이 다 로딩 되도록 기달려 주는 함수
 * @returns
 * @type
 */
function fn_egov_wait_iscroll(thisPage)
{
    setTimeout(function()
    {
        myScroll = new IScroll(thisPage, {
                              scrollX: true,
                              scrollbars: true,
                              mouseWheel: true,
                              interactiveScrollbars: true,
                              shrinkScrollbars: 'scale',
                              fadeScrollbars: true,
                              click: true
                              });
        myScroll.refresh();
        document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
               
    },
    500);
}

/**
 * 네트워크 목록 페이지 표시
 * @returns
 * @type 
 */
function fn_egov_go_networkInfoList(result)
{
    $("#dataList").html("");
    var html = "";
    var resultRows = result["networkInfoList"];
    
    if(resultRows.length > 0)
    {
        for ( var i = 0; i < resultRows.length; i++) 
        {
            html += '<li><a href="#" onClick="fn_egov_open_networkDetailInfo(\'' +resultRows[i]["sn"] + '\')">'+'UUID : '+resultRows[i]["uuid"]+'<BR />'+'Network : '+resultRows[i]["networktype"]+'</a></li>'; 
        }
    }
    $.mobile.changePage('#apiListView', 'slide', false, false);
    
    $("#lstNetworkInfo").html(html).listview('refresh');
    
    fn_egov_wait_iscroll('#wrapper');
    
     if (resultRows.length < 1) {
         jAlert('서버에 저장된 네트워크\n 정보가 없습니다.','알림','b');
     }
}

/**
 * 네트워크 상세 페이지 표시
 * @returns
 * @type 
 */
function fn_egov_go_networkInfoDetail(result)
{
    var html = "";
    var resultRows = result["networkInfo"];
    pageNumber = resultRows["sn"];

    html += '<p>';
    html += 'SN : '+ resultRows["sn"] + '<BR/>';
    html += 'OS : '+ device.platform + '<BR/>';
    html += 'UUID : '+ resultRows["uuid"] + '<BR/>';
    html += 'Network : '+ resultRows["networktype"] + '<BR/>';
    html += 'useYn : '+ resultRows["useYn"] + '</p>';

    $.mobile.changePage('#networkInfoDetail', 'slide', false, false);

    $("#tblNetworkDetailInfo").html(html);
}


/*********************************************************
 * 이벤트 관련 함수 
 *********************************************************/

/**
 * 화면 단의 각 이벤트 설정
 * @returns 현재시간
 * @type 
 */ 
$(function()
{
    $(document).on('pageshow', '#vbrMain',
        function(event, ui)
        {
         $("#tblNetworkInfo").html("");
         fn_egov_get_deviceInfo();
        });
  
    $(document).on('pageshow', '#apiListView',
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
        });
  
    $(document).on('pagehide', '#apiListView',
        function(event, ui) 
        {
            myScroll.destroy();
        });
});

/**
 * 서버 Context 정보 얻어오기
 * @returns 
 * @type 
 */
function fn_egov_init_context() 
{
    if(fn_egov_network_check(true))
    {
        var params = {};
        
        $.mobile.loading("show");
        // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
        setTimeout(function()
                   {
                       fn_egov_sendto_server("/nwk/htmlLoadiOS.do",params);
                   }, 
                   500);
    }
}

/**
 *  Network 정보 목록 열기
 * @returns
 * @type 
 */
function fn_egov_open_networkList()
{
    if(context === null)    // 최초 앱 실행시 3G 사용자 승인 여부 판단
    {
        fn_egov_init_context();
        return;
    }
    
    if(fn_egov_network_check(false))     // 통신 이벤트 발생시 3G 사용자 승인여부 판단
    {
        var params = {
            uuid :  device.uuid,
            networktype : states[navigator.network.connection.type]
        };

         $.mobile.loading("show");
        // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
        setTimeout(function()
                   {
                       fn_egov_sendto_server("/nwk/networkiOSInfoList.do",params);
                   }, 
                   500);
    }        
}

/**
 *  Network 상세 정보 열기
 * @returns
 * @type 
 */
function fn_egov_open_networkDetailInfo(selectedId)
{
    if(fn_egov_network_check(false))        // 통신 이벤트 발생시 3G 사용자 승인여부 판단
    {
        var params = { sn : selectedId };
        
        $.mobile.loading("show");
        // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
        setTimeout(function()
        {
            fn_egov_sendto_server("/nwk/networkiOSInfo.do",params);
        },
        500);
    }
}

/**
 * Media Play Button Click
 * @returns
 * @type 
 */
function fn_egov_click_mediaBtn()
{
    if(context === null)
    {
        fn_egov_init_context();
        return;
    }
    if(audioCheck)      // 이미 재생중이라면 음악만 정지
    {
        fn_egov_stop_audio();
        audioCheck = false;
    }
    else
    {
        // 오디오, 동영상 스트리밍의 경우 매번 네트워크 체크를 하여 사용자 승인 물어보기
        if(fn_egov_network_check(true))
        {
            $.mobile.loading("show");
            // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
            setTimeout(function()
                       {
                           fn_egov_play_audio();
                       
                           var params = {
                               uuid :  device.uuid,
                               networktype : states[navigator.network.connection.type],
                               useYn : "Y"
                           };
                       
                           fn_egov_sendto_server("/nwk/addNetworkiOSInfo.do",params);
                       }, 
                       500);
        }
    }
}

/**
 *  Network 정보 삭제
 * @returns
 * @type 
 */
function fn_egov_click_deleteBtn()
{
    if(fn_egov_network_check(false))        // 통신 이벤트 발생시 3G 사용자 승인여부 판단
    {
        var params = {
            sn : pageNumber
        };
        
        $.mobile.loading("show");
        // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
        setTimeout(function()
                   {
                       fn_egov_sendto_server("/nwk/deleteNetworkiOSInfo.do",params);
                   }, 
                   500);
    }
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
                 if(serviceName === "/nwk/networkiOSInfoList.do")
                 {
                     fn_egov_go_networkInfoList(result);
                 }
                 else if(serviceName === "/nwk/networkiOSInfo.do")
                 {
                     fn_egov_go_networkInfoDetail(result);
                 }
                 else if(serviceName === "/nwk/addNetworkiOSInfo.do")
                 {
                     toast("서버에 단말기 상태값을 저장 했습니다.");
                 }
                 else if(serviceName === "/nwk/deleteNetworkiOSInfo.do")
                 {
                     toast("서버의 단말기 상태값을 삭제 했습니다.");
                     fn_egov_open_networkList();
                 }
                 else if(serviceName === "/nwk/htmlLoadiOS.do")
                 {
                     //context = result["serverUrl"];
                 }
          
                 console.log("DeviceAPIGuide fn_egov_sendto_server Response Completed");
             }
             else
             {
                 console.log("DeviceAPIGuide fn_egov_sendto_server Response Failed");
                 jAlert('Select List Server Error.', '알림', 'c');
             }
             $.mobile.loading("hide");
         },
         function(error) 
         {
         //alert("3.Fail");
             $.mobile.loading("hide");
             console.log("DeviceAPIGuide fn_egov_sendto_server Request Failed");
             jAlert('Request error. 서버가 종료되었거나 \n통신이 원활하지 않습니다.', '알림', 'c');
         });
}


/*********************************************************
 * Media
 *********************************************************/

/**
 * 미디어 재생
 * @returns 
 * @type 
 */
function fn_egov_play_audio() 
{
    // Create Media object from src
    mediaHandle = new Media(context+"/nwk/getMp3FileiOS.do", fn_egov_on_audioSuccess, fn_egov_on_audioError);
    // /www/~~~에 있는 파일은 ./~~~로 호출할수 있다.
    //mediaHandle = new Media("./owlband.mp3", fn_egov_on_audioSuccess, fn_egov_on_audioError);
    
    // Play audio
    mediaHandle.play();
    popupWidget("서버에서 사운드 파일을 실시간 재생합니다.\n버튼을 다시 클릭하면 재생을 멈출수 있습니다!");

         // Update mediaHandle position every second
    if (mediaTimer == null)
    {
        audioCheck = true;
        mediaTimer = setInterval(function() 
                     {
                     // get mediaHandle position
                         mediaHandle.getCurrentPosition(
                            // success callback
                            function(position) 
                            {
                                console.log("DeviceAPIGuide fn_egov_play_audio Success");
                                if (position > -1)
                                {
                                    fn_egov_set_audioPosition((position) + " %");
                                }
                            },
                            // error callback
                            function(e) 
                            {
                                toast("서버에서 사운드 파일의 실시간 재상을 시도하는중에 오류가 발생했습니다.");
                                console.log("DeviceAPIGuide fn_egov_play_audio Error");
                                fn_egov_set_audioPosition("Error: " + e);
                            });
                     }, 
                     1000);
    }
    return true;
}

/**
 * 미디어 일시중지
 * @returns 
 * @type 
 */ 
function fn_egov_pause_audio() 
{
    if (mediaHandle) 
    {
        mediaHandle.pause();
    }
}

/**
 * 미디어 종료
 * @returns 
 * @type 
 */ 
function fn_egov_stop_audio() 
{
    if (mediaHandle)
    {
        mediaHandle.stop();
        toast("사운드 파일의 실시간 재생을 중지합니다.");
    }
    clearInterval(mediaTimer);
    mediaTimer = null;
}

/**
 * 재생 성공시 호출
 * @returns 
 * @type 
 */ 
function fn_egov_on_audioSuccess() 
{
    //alert("playAudio():Audio Success");
}

/**
 * 재생 실패시 호출
 * @returns 
 * @type 
 */ 
function fn_egov_on_audioError(error) 
{
    console.log('(Error)\n' + 'code: ' + error.code + '\n' + 'message: ' + error.message + '\n');
}

/**
 * 현재 재생 위치 표시
 * @returns 
 * @type
 */ 
function fn_egov_set_audioPosition(position) {
    //console.log("(Debug) fn_egov_set_audioPosition : " + position);
}
