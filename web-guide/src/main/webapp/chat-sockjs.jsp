<%@ page contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true"%>
<%
  /**
  * @Class Name : chat-sockjs.jsp
  * @Description : 웹소켓 테스트 화면
  * @Modification Information
  *
  *  수정일                수정자           수정내용
  *  ----------   --------   ---------------------------
  *  2019.10.18   신용호            최초 생성
  *
  * author DeviceAPI 개발팀
  * since 2009.02.01
  *
  * Copyright (C) 2009 by MOPAS  All right reserved.
  */
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>채팅</title>
<script type="text/javascript" src="js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="js/sockjs-1.3.0.min.js"></script>
<script type="text/javascript">
	var wsocket;
	
	function connect() {
		// IP 로 등록 (localhost 지정 불가)
		var ipAddr = $("#serverUrl").val(); //"http://192.168.100.145:9700";
		wsocket = new SockJS(ipAddr+"/websocket/chat");
		
		wsocket.onopen = onOpen;
		wsocket.onmessage = onMessage;
		wsocket.onclose = onClose;
	}
	function disconnect() {
		wsocket.close();
	}
	function onOpen(evt) {
		appendMessage("연결되었습니다.");
	}
	function onMessage(evt) {
		var data = evt.data;
		if (data.substring(0, 4) == "msg:") {
			appendMessage(data.substring(4));
		}
	}
	function onClose(evt) {
		appendMessage("연결을 끊었습니다.");
	}
	
	function send() {
		var nickname = $("#nickname").val();
		var msg = $("#message").val();
		wsocket.send("msg:"+nickname+":" + msg);
		$("#message").val("");
	}

	function appendMessage(msg) {
		$("#chatMessageArea").append(msg+"<br>");
		var chatAreaHeight = $("#chatArea").height();
		var maxScroll = $("#chatMessageArea").height() - chatAreaHeight;
		$("#chatArea").scrollTop(maxScroll);
	}

	$(document).ready(function() {
		$('#message').keypress(function(event){
			var keycode = (event.keyCode ? event.keyCode : event.which);
			if(keycode == '13'){
				send();	
			}
			event.stopPropagation();
		});
		$('#sendBtn').click(function() { send(); });
		$('#enterBtn').click(function() { connect(); });
		$('#exitBtn').click(function() { disconnect(); });
	});
</script>
<style>
#chatArea {
	width: 200px; height: 100px; overflow-y: auto; border: 1px solid black;
}
</style>
</head>
<body>
	서버:<input type="text" id="serverUrl" value="http://192.168.100.155:9700">* localhost 지정 불가(반드시 IP로지정)<br/>
	이름:<input type="text" id="nickname">
	<input type="button" id="enterBtn" value="입장">
	<input type="button" id="exitBtn" value="나가기">
    
    <h1>대화 영역</h1>
    <div id="chatArea"><div id="chatMessageArea"></div></div>
    <br/>
    <input type="text" id="message">
    <input type="button" id="sendBtn" value="전송">
</body>
</html>