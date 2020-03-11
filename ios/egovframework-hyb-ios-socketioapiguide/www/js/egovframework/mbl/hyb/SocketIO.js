/**
 * 모바일 전자정부 하이브리드 앱 파일관리 가이드 프로그램 JavaScript
 * JavaScript.
 *
 * @author 장성호
 * @version 1.0
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2016. 8.04.    장성호 		신규생성
 * @ 2019. 8.12.    신용호        버전 업데이트 적용
 */

/*********************************************************
 * A TAG 링크 컨트롤
 *********************************************************/


var server_url;
var socket_mode = '1';
var tcp_socketId;
var tcp_socketIp = "192.168.100.155";
var tcp_socketPort = 13305;
/**
 * A tag의 링크 변경
 * @returns
 * @type
 */
function fn_egov_init_hrefLink(){
    
    $("#enterBtn").click(function() { 
        connect(); 
    });
    $("#sendBtn").attr("href","javascript:send();");
    $("#exitBtn").attr("href","javascript:fn_initPage_move();");
    
    $("input[name='radioSocketType']").change(function() {
        socket_mode = $(":input:radio[name=radioSocketType]:checked").val();
        if (socket_mode == "2") {
            //var decoder = new TextDecoder("utf-8");
            //console.log("decoder"+decoder);
            if (typeof TextDecoder == "undefined") {
                $("input:radio[name=radioSocketType]:input[value='1']").prop("checked", true);
                $("input:radio[name=radioSocketType]:input[value='2']").prop("checked", false);
                //alert("이 기기는 TCP Socket을 사용하실수 없습니다.");
                jAlert("이 기기는 TCP Socket을 사용하실수 없습니다.", "알림", "b");
            }
        }
    });

    EgovInterface.geturl(function getURLString(resURL){
        console.log("resURL = "+resURL);
        server_url = resURL;
    });
}


function fn_initPage_move(){
    disconnect();
    $('#chatMessageArea').empty();
    $.mobile.changePage("#main", "slide", false, false);
}

var wsocket;

function connect() {
    socket_mode = $(":input:radio[name=radioSocketType]:checked").val();
    alert("socket_mode="+socket_mode);
    switch ( socket_mode ) {
    case '1':
        console.log("Init WebSocket Mode!");
        connectWebSocket();
        $.mobile.changePage("#chatZone", "slide", false, false);
        break;
    case '2':
        console.log("Init TCP Socket Mode!");
        connectTcpSocket(tcp_socketIp, tcp_socketPort);
        $.mobile.changePage("#chatZone", "slide", false, false);
        break;
    default:
        console.log("ERR case!");
    }

}

// conntect WebSocket
function connectWebSocket() {
    
    $('#chatMessageArea').empty();
    wsocket = new SockJS(server_url+"/websocket/chat");
    //wsocket = new SockJS("http://192.168.100.155:9700/websocket/chat");
    
    wsocket.onopen = onOpen;
    wsocket.onmessage = onMessage;
    wsocket.onclose = onClose;
    //		try {
    //			alert("stompClient. before");
    //			var stompClient = Stomp.over(wsocket);
    
    //			alert("stompClient. after");
    //			stompClient.connect({}, function(frame) {
    
    //				alert("stompClient.connect");
    //			});
    
    //		} catch (e) {
    //			alert("exception"+e);
    //		}
    
}

function disconnect() {
    wsocket.send("msg:" + $("#nickname").val() + "님이 연결을 끊었습니다.");
    wsocket.close();
}

function onOpen(evt) {
    wsocket.send("msg:"+ $("#nickname").val() +"님, 연결되었습니다.");
}

function onMessage(evt) {
    var data = evt.data;
    if (data.substring(0, 4) == "msg:") {
        appendMessage(data.substring(4));
    }
}

function onClose(evt) {
    //appendMessage("연결을 끊었습니다.");
}

function send() {
    var nickname = $("#nickname").val();
    var msg = $("#message").val();
    var sendMsg = nickname+":" + msg;

    switch ( socket_mode ) {
    case '1':
        console.log("Send WebSocket Mode!");
        wsocket.send("msg:"+sendMsg);
        break;
    case '2':
        console.log("Send TCP Socket Mode!");
        //var senddata = str2ab("abcdef_TEXT한글1");
        var senddata = str2ab(sendMsg+"\n");
        chrome.sockets.tcp.send(tcp_socketId, senddata
            ,function(resultCode) {
                console.log("Data sent to new TCP client connection.-"+resultCode);
            });
        break;
    }

    $("#message").val("");
}

function appendMessage(msg) {
    $("#chatMessageArea").append(msg+"<br>");
    var chatAreaHeight = $("#chatArea").height();
    var maxScroll = $("#chatMessageArea").height() - chatAreaHeight;
    $("#chatArea").scrollTop(maxScroll);
    
}

// conntect TCP Socket
function connectTcpSocket(tcp_ip, tcp_port) {
    // 소켓 생성
    chrome.sockets.tcp.create({}, function(createInfo) {
        // 소켓 연결 설정
        chrome.sockets.tcp.connect(createInfo.socketId
            , tcp_ip, tcp_port, function(socketInfo) {
                console.log(">>> createInfo.socketId = "+createInfo.socketId);
                console.log(">>> socketInfo = "+socketInfo);
                tcp_socketId = createInfo.socketId;

                var senddata = str2ab($("#nickname").val() +"님, 연결되었습니다.\n");
                chrome.sockets.tcp.send(createInfo.socketId, senddata
                    ,function(resultCode) {
                        debugger;
                        console.log("Data sent to new TCP client connection. = "+resultCode.resultCode);
                    });

            });
    });

    // 전문 수신
    chrome.sockets.tcp.onReceive.addListener(function(info) {
        //if (info.socketId != socketId)
        //return;
        // info.data is an arrayBuffer.
        console.log("==>> "+info.socketId);
        console.log("==>> "+info.data);

        var decoder = new TextDecoder("utf-8");
        var recvMsg = decoder.decode(new Uint8Array(info.data));
        console.log("==>> recvMsg = "+recvMsg);
        appendMessage(recvMsg);

    });
    // 수신 오류 (connect 오류 포함)
    chrome.sockets.tcp.onReceiveError.addListener(function(info) {
        debugger;
        console.log("onReceiveError ==>> "+info.message);
    });
}

// Array Buffer => String
function ab2str(buf) {
    return String.fromCharCode.apply(null, new Uint16Array(buf));
}

// String => Array Buffer
function str2ab(paramstr) {
    var encoder = new TextEncoder("utf-8");
    var unit8Array = encoder.encode(paramstr);

    //var decoder = new TextDecoder("euc-kr");
    //var strDecoded = decoder.decode(unit8Array);
    //console.log(">>>"+strDecoded);
    //var unit8ArrayDecode = encoder.encode(strDecoded);
    var ab = unit8Array.buffer;
    //var ab = new ArrayBuffer(str.length*2); // 2 bytes for each char
    //var bufView = new Uint8Array(ab);
    //for (var i=0, strLen=str.length; i < strLen; i++) {
    //    bufView[i] = str.charCodeAt(i);
    //}
    return ab;
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
    //navigator.notification.alert("Level: " + info.level + "%, isPlugged: " + info.isPlugged);
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
