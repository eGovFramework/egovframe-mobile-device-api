/** 
 * @fileoverview 모바일 전자정부 하이브리드 앱 Interface API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 이한철
 * @version 1.0 
 */


/**
 * 회원가입 화면 이동 function.
 * @returns 회원가입 화면으로 이동.
 * @type
 */
function fn_goSignUp() {
	
	console.log("Signup display change");
	$.mobile.changePage('#signUp', 'slide', false, false);
    
}

/**
 * 로그인 화면 이동 function.
 * @returns 로그인 화면으로 이동.
 * @type
 */
function fn_goLogin() {
	
	console.log("Login display change");
	$.mobile.changePage('#login', 'slide', false, false);
    
}

/**
 * 회원탈퇴 화면 이동 function.
 * @returns 회원탈퇴 화면으로 이동.
 * @type
 */
function fn_goWithdrawal() {
	
	console.log("withdrawal display change");
	$.mobile.changePage('#signDown', 'slide', false, false);
    
}

/**
 * 로그인 function.
 * @returns 로그인을 한다.
 * @type  
*/
function fn_login() {
    var params = {  uuid :  device.uuid }
	$.mobile.loading("show");
    alert('전송방식:RESTful\n전송Type:json, get\nURL:\n' + "/itf/logIniOS.do?userId=" + $("#loginId").val() + "&userPw=" + $("#loginPasswd").val());
    EgovInterface.submitAsynchronous(
                                    [params, "/itf/logIniOS.do?userId=" + $("#loginId").val() + "&userPw=" + $("#loginPasswd").val()],
                                    function(result) {
                                         console.log("InterfaceAPIGuide fn_login Completed");
                                        var str = '{resultState:'+result.resultState+',resultMessage:'+result.resultMessage+'}';
//                                        for (myKey in result){
//                                            str += myKey + ':' + result[myKey] + '\n';
//                                        }
//                                        str += '}';
                                        alert('응답방식:RESTful\n응답Type:json, post\nParam:\n' + str);
//                                        fn_goWithdrawal();
                                         $.mobile.loading("hide");
                                         window.history.back();
                                    },
                                    function(error) {
                                         console.log("InterfaceAPIGuide fn_login Failed");
                                         var str = "";
                                         for (myKey in error){
                                             str += myKey + ' : ' + error[myKey] + '\n';
                                         }
                                         alert('계정 확인 필요.\n'+'응답방식:RESTful\n전송Type:json, post\nParam:\n' + str);
                                         $.mobile.loading("hide");
                                    }
                                    );
}



/**
 * 회원가입 서버 전송 function.
 * @returns 회원가입 정보를 서버에 저장 요청한다.
 * @type  
*/
function fn_signUp() {

    var params = {  uuid :  device.uuid,
                    userId : $("#signUpId").val(), 
                    userPw : $("#signUpPasswd").val(),
                    emails : $("#signUpEmail").val()};	
	
//    $('#spaceused1').progressBar(100);
    $.mobile.loading("show");
    EgovInterface.submitAsynchronous(
                                     [params, "/itf/addInterfaceiOSInfo.do"],
                                     function(result) {
                                         console.log("InterfaceAPIGuide fn_signUp Completed");
                                        var s = JSON.stringify(result);
                                         var str = '{resultState:'+result.resultState+',resultMessage:'+result.resultMessage+'}';
//                                         for (myKey in result){
//                                             str += result[myKey];
//                                         }
                                         alert('응답방식:RESTful\n응답Type:json, post\nParam:\n' + str);
//                                        fn_goLogin();
//                                        setTimeout("fn_alert()", 1500);
                                         $.mobile.loading("hide");
                                         window.history.back();
                                     },
                                     function(error) {
                                         console.log("InterfaceAPIGuide fn_signUp Failed");
                                         var str = "";
                                         for (myKey in error){
                                             str += myKey + ' : ' + error[myKey] + '\n';
                                         }
                                         alert('응답방식:RESTful\n응답Type:json, post\nParam:\n' + str);
                                         $.mobile.loading("hide");
                                     }
                                     );
}

/**
 * 회원탈퇴 요청 function.
 * @returns 회원탈퇴 요청한다.
 * @type  
*/
function fn_withdrawal() {

    var params = {  userId : $("#signDownId").val(),
                    userPw : $("#signDownPasswd").val() };
    $.mobile.loading("show");
    EgovInterface.submitAsynchronous(
                                     [params, "/itf/withdrawaliOS.do"],
                                     function(result) {
                                         console.log("InterfaceAPIGuide fn_withdrawal Completed");
                                         var str = '{resultState:'+result.resultState+',resultMessage:'+result.resultMessage+'}';
//                                         for (myKey in result){
//                                             str += myKey + ':' + result[myKey] + '\n';
//                                         }
                                         alert('응답방식:RESTful\n응답Type:json, post\nParam:\n' + str);
//                                        fn_goSignUp();
                                         $.mobile.loading("hide");
                                         window.history.back();
                                     },
                                     function(error) {
                                         console.log("InterfaceAPIGuide fn_withdrawal Failed");
                                         var str = "계정 확인 필요.\n";
                                         for (myKey in error){
                                             str += myKey + ' : ' + error[myKey] + '\n';
                                         }
                                        alert('응답방식:RESTful\n응답Type:json, post\nParam:\n' + str);
                                         $.mobile.loading("hide");
                                     }
                                     );
}

/**
 * Network Info 전송 확인 function.
 * @returns 네트워크 정보를 서버에 전송전 사용자 확인을 수행한다.
 * @type  
*/
function confirm_signUp(){
    jConfirm('전송방식:RESTful\n전송Type:json, post\nParam:\n' + '{ uuid:'+device.uuid+', userId:'+$("#signUpId").val()+', userPw:'+$("#signUpPasswd").val()+', emails:'+$("#signUpEmail").val()+')', '알림', 'c', function(r){
        if(r == true){
            fn_signUp();
        }else{
        }
    });	
}

/**
 * 회원 탈퇴 확인 function.
 * @returns 회원 탈퇴 전 사용자 확인을 수행한다.
 * @type  
*/
function confirm_withdrawal(){
    jConfirm('전송방식:RESTful\n전송Type:json, post\nParam:\n' + '{ userId:'+$("#signDownId").val()+', userPw:'+$("#signDownPasswd").val()+'}', '알림', 'c', function(r){
        if(r == true){
            fn_withdrawal();
        }else{

        }
    });	
}



// Wait for PhoneGap to load
// 
document.addEventListener("deviceready", onDeviceReady, false);

// PhoneGap is loaded and it is now safe to make calls PhoneGap methods
//
function onDeviceReady() {
    console.log("InterfaceAPIGuide deviceready Success");
    fn_egov_network_notification();
    
    $('#goSignup').click(function () {
                             //회원가입 화면 이동
                             fn_goSignUp() ;
                             });
    $('#goLogin').click(function () {
                        //로그인 화면 이동
                        fn_goLogin();
                        });
    $('#goSigndown').click(function () {
                        //회원탈퇴 화면 이동
                        fn_goWithdrawal();
                        });
    
    $.validator.setDefaults({
                            
                            submitHandler: function() { 
                                if($.mobile.activePage.is('#login')) {
                                    if (fn_egov_network_check(false))
                                        // 로그인
                                        fn_login();
                                } else if($.mobile.activePage.is('#signUp')) {
                                    if (fn_egov_network_check(false))
                                        // 회원가입
                                        confirm_signUp();
                                } else  if($.mobile.activePage.is('#signDown')) {
                                    if (fn_egov_network_check(false))
                                        // 회원탈퇴
                                        confirm_withdrawal();
                                }
                            }
                    });
    
    // validation check
    $("#subscribeForm").validate();
    $("#loginForm").validate();
    $("#secessionForm").validate();
    
    infoiScroll();
    
    loadiScroll();

}

var myScroll;

function loadiScroll() {                

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

/**
 * iscroll setting function
 * @returns iscroll event 처리
 * @type
 */
function infoiScroll() {                

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












