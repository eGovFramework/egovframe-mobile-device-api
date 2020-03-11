/** 
 * @fileoverview 모바일 전자정부 하이브리드 앱 Contacts API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 이해성
 * @version 1.0 
 */

/*********************************************************
 * 초기화 관련
 *********************************************************/

/** 최초 앱 실행시 3G check 여부 */
var check3G = true;

/** iScroll 객체 생성 */
var mainScroll = null;
var listScroll = null;

/** 모바일 디바이스의 조회된 연락처 객체 */
var contactsList = null;

/** 복구된 연락처 목록 */
var recoveryParam = [];

/** 복구해야될 연락처 갯수 */
var listCount = null;

/** 연락처 목록 페이지 */
var nPageCount = null;

/** 연락처 한 페이지의 최대 갯수 */
var nPageShow = 10;

/** 현재 프로세스 정보 */
var ProcessName = null;

/** 서버쪽 연락처 개수 */
var serverListCount = 0;

document.addEventListener("deviceready", onDeviceReady, false);

function onDeviceReady() 
{
    document.addEventListener('DOMContentLoaded', function () { setTimeout(loaded, 200); }, false);
    
    fn_egov_wait_iscroll();
    
    if(fn_egov_network_check(true))        // 최초 앱 실행시 3G 사용자 승인여부 판단
    {
        check3G = false;
    }
}

/*********************************************************
 * 공통
 *********************************************************/

/** 날짜 포맷 형식 */
Date.prototype.format = function(format){
    
    var date = this;

    format = format.replace('YYYY', date.getFullYear());
    format = format.replace('MM',   zeroPad(date.getMonth() + 1));
    format = format.replace('DD',   zeroPad(date.getDate()));
    format = format.replace('hh',   zeroPad(date.getHours()));
    format = format.replace('mm',   zeroPad(date.getMinutes()));
    format = format.replace('ss',   zeroPad(date.getSeconds()));

    return format;
};

/** 날짜 포맷 형식 00 또는 0X */
function zeroPad(number) 
{
    return ( ( number < 10 ) ? "0" : "" ) + String(number);	
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

        mainScroll = new IScroll("#mainWrapper", {
            scrollX: true,
            scrollbars: true,
            mouseWheel: true,
            interactiveScrollbars: true,
            shrinkScrollbars: 'scale',
            fadeScrollbars: true,
            click: true
        });
        listScroll = new IScroll("#subWrapper", {
            scrollX: true,
            scrollbars: true,
            mouseWheel: true,
            interactiveScrollbars: true,
            shrinkScrollbars: 'scale',
            fadeScrollbars: true,
            click: true
        });
       
        document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

    },
    500);
}

/*********************************************************
 * html, 화면 관련
 *********************************************************/

/**
 * 연락처 목록 페이지 생성
 * @returns 연락처 목록에 연락처 추가
 * @type
 */
function fn_egov_showList(bFirst) 
{
    var linkVal;
    var displayName;
    var phoneNumber;
    var list_html = "";

    var nLen = contactsList.length;
    var nCntS = nLen - (nPageCount*nPageShow) - 1;
    var nCntE = nLen - ((++nPageCount)*nPageShow) - 1;

    if (nLen > 0 && nPageCount <= 0) {
        nPageCount--;
        alert("마지막입니다.");
    }

    nCntE = nCntE<0?-1:nCntE;

    for (var i=nCntS; i>nCntE; i--)
    {
        linkVal = "javascript:fn_egov_move_localContactDetail('" + i + "');";	
        var ContactName = contactsList[i].name;
        displayName = "";
        if (ContactName.formatted != null) {
            displayName = ContactName.formatted;
        }
        phoneNumber = "";
        if (contactsList[i].phoneNumbers != null) {
            for (var j=0; j<contactsList[i].phoneNumbers.length; j++) {
                if (contactsList[i].phoneNumbers[j].type == "mobile") {
                    phoneNumber = contactsList[i].phoneNumbers[j].value;
                    break;
                }
            }
        }

        list_html += '<li><a href="'
        + linkVal
        + '"><h3>'
        + displayName + '</h3><p><strong>' 
        + phoneNumber
        + '</strong></p></a></li>';
    }

    var theList = $('#listView');
    $(list_html).appendTo(theList);
    if(!bFirst) {
        theList.listview("refresh");
    }
}

/**
 * 서버에 백업된 연락처 정보 표시
 * @returns
 * @type
 */
function fn_egov_show_BackupCount(result) 
{
    serverListCount = result["totCount"];
    var html = '<div class="ui-block-a"><label align="center"><h3>' + String(contactsList.length) + '</h3></label></div>';
    html += '<div class="ui-block-b"><label align="center"><h3>' + result["totCount"] +'</h3></label></div>';
    
    if(ProcessName === "contactBackup")
    {
        $('#deviceBackupCount').html(html);
        $.mobile.changePage("#contactBackup", "slide", false, false);
    }
    else if(ProcessName === "contactRecovery")
    {
        $('#deviceRecoveryCount').html(html);
        $.mobile.changePage("#contactRecovery", "slide", false, false);
    }
}


/*********************************************************
 * 이벤트 관련
 *********************************************************/

/**
 * 로컬 연락처 조회 화면으로 이동 
 * 
 * @returns 
 * @type 
 */
function fn_egov_move_localContactList()
{
    $.mobile.loading("show");
    // 최초 실행시 사용자 승인 여부 체크
    if(check3G)
    {
        if(fn_egov_network_check(true))        // 최초 앱 실행시 3G 사용자 승인여부 판단
        {
            check3G = false;
        }
        return;
    }
    
    var obj = new ContactFindOptions();
    obj.filter = "";
    obj.multiple = true;
    var fields = ["*"];
    navigator.contacts.find(fields, fn_egov_contactListSuccess, fn_egov_fail, obj);
}

/**
 * 연락처 상세정보 화면 이동 함수
 * 
 * @returns 연락처 상세정보 화면으로 이동
 * @type 
 */
function fn_egov_move_localContactDetail(index)
{
    var displayName = "";
    var phoneNumber = "";
    var email = "";
    var ContactName = "";
    
    if(contactsList[index].name.formatted != null) 
    {
        ContactName = contactsList[index].name.formatted;
    }

    if(contactsList[index].phoneNumbers != null) 
    {
        for(var j=0; j<contactsList[index].phoneNumbers.length; j++) 
        {
        if(contactsList[index].phoneNumbers[j].type == "mobile")
            {
                phoneNumber = contactsList[index].phoneNumbers[j].value;
                break;
            }
        }
    }
    if(contactsList[index].emails != null)
    {
        for(var j=0; j<contactsList[index].emails.length; j++) 
        {
            email = contactsList[index].emails[j].value;
            break;
        }
    }
    
    document.getElementById('detailIndex').value = index;
    document.getElementById('detailName').value = ContactName;
    document.getElementById('detailPhone').value = phoneNumber;
    document.getElementById('detailEmail').value = email;
    ProcessName = "contactDetail";
    $.mobile.changePage("#contactDetail", "slide", false, false);
}

/**
 * 연락처 목록 페이지 더보기 기능
 * @returns 연락처 목록에 연락처 추가
 * @type
 */
function fn_egov_showListAdd() 
{
    fn_egov_showList(false);
    listScroll.refresh();
    listScroll.scrollToElement('li:nth-child(' + String((nPageCount-1)*nPageShow-2) + ')', 1000);
}

/**
 * 연락처 백업 화면으로 이동
 * @returns 연락처 리스트 갯수 조회
 * @type
 */
function fn_egov_move_contactBackup()
{
    if(check3G)
    {
        if(fn_egov_network_check(true))        // 최초 앱 실행시 3G 사용자 승인여부 판단
        {
            check3G = false;
        }
        return;
    }
    
    if(fn_egov_network_check(false))        // 통신 이벤트 발생시 3G 사용자 승인여부 판단
    {
        ProcessName = "contactBackup";
        $.mobile.loading("show");
        var obj = new ContactFindOptions();
        obj.filter = "";
        obj.multiple = true;
        var fields = ["*"];
        navigator.contacts.find(fields, fn_egov_contactBackupCountSuccess, fn_egov_fail, obj);
    }
}

/**
 * 연락처 복원 화면으로 이동
 * @returns 연락처 리스트 갯수 조회
 * @type
 */
function fn_egov_move_contactRecovery() 
{
    if(check3G)
    {
        if(fn_egov_network_check(true))        // 최초 앱 실행시 3G 사용자 승인여부 판단
        {
            check3G = false;
        }
        return;
    }
    
    if(fn_egov_network_check(false))        // 통신 이벤트 발생시 3G 사용자 승인여부 판단
    {
        $.mobile.loading("show");
        var obj = new ContactFindOptions();
        obj.filter = "";
        obj.multiple = true;
        var fields = ["*"];
        navigator.contacts.find(fields, fn_egov_contactRecoveryCountSuccess, fn_egov_fail, obj);
    }
}

/**
 * 연락처 복원
 * @returns 
 * @type
 */
function fn_egov_contactRecovery(result) 
{
    recoveryParam = [];
    
    var arrayContact = result["contactInfoList"];
    listCount = arrayContact.length;
    for(var i=0;i<listCount;i++)
    {
        contactRecovery(contactRecoveryCallBack(arrayContact[i]));
    }
}

function contactRecovery(callback)
{
    if(typeof callback === "function")
    {
        callback();
    }
}

function contactRecoveryCallBack(ContactData)
{
    var id = ContactData["contactId"];
    var name = ContactData["name"];
    var telNo = ContactData["telNo"];
    var email = ContactData["emails"];
    
    var options = new ContactFindOptions();
    options.filter=String(id); 
    var fields = ["id"];
    navigator.contacts.find(fields, 
                            function(contacts)
                            {
                                if(contacts.length != 0) 
                                {
                                    contacts[0].remove(function(contact){},fn_egov_fail);
                                }
                            
                                var contactname = new ContactName();
                                contactname.middleName = name;
                            
                                var myContact = navigator.contacts.create({"name":contactname});
                            
                                var phoneNumbers = [2];
                                phoneNumbers[0] = new ContactField('work', telNo, false);
                                phoneNumbers[1] = new ContactField('mobile', telNo, false); 
                                phoneNumbers[2] = new ContactField('home', telNo, false); 
                                myContact.phoneNumbers = phoneNumbers;
                            
                                var emails = [2];
                                emails[0] = new ContactField('work', email, false);
                                emails[1] = new ContactField('home', email, false);
                                myContact.emails = emails;
                            
                                myContact.save(function(contact)
                                               {
                                                   recoveryParam.push({uuid:device.uuid, contactId:id, newId:contact.id});
                                                   if(listCount === recoveryParam.length)
                                                   {
                                                       $.mobile.loading("hide");
                                                       confirm(String(listCount) + '개의 연락처가 복원되었습니다. 저장된 연락처 정보를 서버와 동기화 합니다.');
                                                       $.mobile.loading("show");
                                                       fn_egov_contactIdUpdate();	
                                                   }
                                               },fn_egov_fail);
                            }, function(contactError){}, options);
}


/*********************************************************
 * Contacts API
 *********************************************************/

/**
 * 공통 fail Callback Function
 * @returns 
 * @type 
 */
function fn_egov_fail(error) 
{
    console.log("DeviceAPIGuide fn_egov_fail " + error.code);
    $.mobile.loading("hide");
}

/**
 * 연락처 목록 조회 성공 callback
 * @returns 연락처 목록 화면으로 이동
 * @type
 */
function fn_egov_contactListSuccess(contacts) 
{
    console.log("DeviceAPIGuide fn_egov_contactListSuccess");
    
    var theList = $('#listView');
    theList.html("");
    contactsList = contacts;	
    nPageCount = 0;
    fn_egov_showList(true);
    $.mobile.loading("hide");

    ProcessName = "contactList";
    $.mobile.changePage("#contactList", "slide", false, false);

    theList.listview("refresh");
    listScroll.refresh();

    if (contactsList.length < 1) {
        jAlert('저장된 연락처 목록이\n 없습니다.','알림','b');
    }
    //setTimeout(loadiScrollList, 1000);
}

/**
 * 연락처 삭제
 * @returns
 * @type
 */
function fn_egov_contactLocalDelete()
{
    var index = $("#detailIndex").val();
    contactsList[index].remove(fn_egov_removeSuccess,fn_egov_fail);
}

/**
 * 연락처 삭제 성공 callback
 * @returns
 * @type
 */
function fn_egov_removeSuccess(contact) 
{
    console.log("DeviceAPIGuide fn_egov_removeSuccess");
    alert('삭제 되었습니다.');	
    window.history.go(-2);
}


/*********************************************************
 * 통신
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
                                            if(serviceName === "/cmr/cameraPhotoAlbumListiOS.do")
                                            {  // 서버에 있는 사진 목록 리스트
                                                $.mobile.changePage($("#listPhotoAlbum"));
                                                fn_egov_add_imageList(result);
                                            }
                                            else if(serviceName === "/ctt/selectBackupCountiOS.do")
                                            {   // 서버에 백업된 연락처 갯수
                                                fn_egov_show_BackupCount(result);
                                            }
                                            else if(serviceName === "/ctt/addContactsiOSInfo.do")
                                            {   // 서버에 연락처 백업 결과
                                                jAlert(result["totCount"] + '개의 연락처가 저장되었습니다.', '정보', 'c');
                                                fn_egov_show_BackupCount(result);
                                            }
                                            else if(serviceName === "/ctt/contactsiOSInfoList.do")
                                            {   // 서버에서 백업한 연락처 받기
                                                fn_egov_contactRecovery(result);
                                                return;
                                            }
                                            else if(serviceName === "/ctt/updateContactsiOS.do")
                                            {   // 복구된 연락처를 다시 서버로 백업한 결과
                                                jAlert(result["resultMessage"] +'개의 연락처가 동기화 되었습니다.', '정보', 'c');
                                                var obj = new ContactFindOptions();
                                                obj.filter = "";
                                                obj.multiple = true;
                                                var fields = ["*"];
                                                navigator.contacts.find(fields, 
                                                                        function(contacts)
                                                                        {
                                                                            contactsList = contacts;
                                                                            fn_egov_show_BackupCount(result)
                                                                        }, 
                                                                        fn_egov_fail, obj);
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

/**
 * 연락처 리스트 조회 성공 callback
 * @returns
 * @type
 */
function fn_egov_contactBackupCountSuccess(contacts) 
{
    console.log("DeviceAPIGuide fn_egov_contactBackupCountSuccess");
    contactsList = contacts;

    var params = {uuid :  device.uuid};

    $.mobile.loading("show");
    // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
    setTimeout(function()
               {
                   fn_egov_sendto_server("/ctt/selectBackupCountiOS.do",params);
               }, 
               500);
}

/**
 * 연락처를 백업 한다.
 * 
 * @returns
 * @type
 */
function fn_egov_contactBackup() 
{
    if (contactsList.length < 1) {
        jAlert('백업할 연락처가 없습니다.', '알림', 'c');
        return;
    }
    
    if(fn_egov_network_check(false))        // 통신 이벤트 발생시 3G 사용자 승인여부 판단
    {
        $.mobile.loading("show");
        ProcessName = "contactBackup";   
        var param = [];	
        for(var index = 0; index < contactsList.length ; index++) 
        {
            var displayName = '';
            var phoneNumber = '';
            var email = '';
            
            if(contactsList[index].name.formatted != null) 
            {
                displayName = contactsList[index].name.formatted;
            }
            
            if(contactsList[index].phoneNumbers != null) 
            {
                for(var j=0; j<contactsList[index].phoneNumbers.length; j++) 
                {
                    if(contactsList[index].phoneNumbers[j].type == "mobile")
                    {
                        phoneNumber = contactsList[index].phoneNumbers[j].value;
                        break;
                    }
                }
            }
            if(contactsList[index].emails != null) 
            {
                for(var j=0; j<contactsList[index].emails.length; j++) 
                {
                    email = contactsList[index].emails[j].value;
                    break;
                }
            }
            
            param.push({uuid:device.uuid, contactId:contactsList[index].id, name:encodeURIComponent(displayName), telNo:phoneNumber, useYn:'Y', emails:email});
        }
        
        var params = {contactsList : {contactsList : JSON.stringify(param)}};
        // var params = {contactsList : {contactsList : param}};
        // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
        setTimeout(function()
                   {
                       fn_egov_sendto_server("/ctt/addContactsiOSInfo.do",params);
                   }, 
                   500);
    }
}

/**
 * 연락처 리스트 조회 성공 callback
 * 서버에 백업된 연락처 갯수를 조회한다.
 * @returns
 * @type
 */
function fn_egov_contactRecoveryCountSuccess(contacts) 
{
    console.log("DeviceAPIGuide fn_egov_contactRecoveryCountSuccess");
    contactsList = contacts;

    if(fn_egov_network_check(false))        // 통신 이벤트 발생시 3G 사용자 승인여부 판단
    {
        var params = {uuid :  device.uuid};
        
        ProcessName = "contactRecovery";
        // get the data from server
        
        $.mobile.loading("show");
        // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
        setTimeout(function()
                   {
                       fn_egov_sendto_server("/ctt/selectBackupCountiOS.do",params);
                   }, 
                   500);
    }
}

/**
 * 연락처를 복원한다.
 * 
 * @returns
 * @type
 */
function fn_egov_get_contactBackup() 
{
    if (serverListCount < 1) {
        jAlert('복원할 연락처가 없습니다.', '알림', 'c');
        return;
    }

    if(!confirm('경고 : 디바이스의 주소록이 삭제되고 서버에 저장된 주소록으로 대체됩니다.\n계속 하시겠습니까?'))
    {
        return;
    }

    if(fn_egov_network_check(false))        // 통신 이벤트 발생시 3G 사용자 승인여부 판단
    {
        var params = {uuid :  device.uuid};
        
        $.mobile.loading("show");
        // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
        setTimeout(function()
                   {
                       fn_egov_sendto_server("/ctt/contactsiOSInfoList.do",params);
                   }, 
                   500);
    }
}

/**
 * 복원된 연락처의 id를 서버로 업데이트 한다.
 * 
 * @returns
 * @type
 */
function fn_egov_contactIdUpdate() 
{
    if(fn_egov_network_check(false))        // 통신 이벤트 발생시 3G 사용자 승인여부 판단
    {
        var params = {contactsList : {contactsList : JSON.stringify(recoveryParam)}};
        
        $.mobile.loading("show");
        // 디바이스의 성능에 따라 PrograssDialog Show 가 완전이 로딩이 된후 다음 코드를 수행하도록 setTimeout 을 사용하여 지연시킨다.
        setTimeout(function()
                   {
                       fn_egov_sendto_server("/ctt/updateContactsiOS.do",params);
                   }, 
                   500);
    }
}
