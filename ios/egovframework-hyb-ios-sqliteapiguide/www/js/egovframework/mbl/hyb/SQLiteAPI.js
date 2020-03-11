/**
 * @fileoverview 모바일 전자정부 하이브리드 앱 문서뷰어 API 가이드 프로그램 JavaScript
 * JavaScript.
 *
 * @author 장성호
 * @version 1.0
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2016. 7. 11.   장성호 		최초생성
 */



/*********************************************************
 * A TAG 링크 컨트롤
 *********************************************************/


/**
 * A tag의 링크 변경
 * @returns
 * @type
 */
function fn_egov_init_hrefLink(){
    // 리소스 업데이트 플러그인 테스트
    $("#btnDBTableList").attr("href","javascript:fn_egov_dbopen();");
    $("#btnTableListPage").attr("href","javascript:fn_movePage_TableList();");
    $("#btnAdd_Data").attr("href","javascript:fn_egov_addsampledata();");
    $("#btnCancel").attr("href","javascript:fn_egov_tabledata();");
    $("#btnUpdateData").attr("href","javascript:fn_egov_updateDataConfirm();");
    
}

function fn_movePage_TableList(){
    
    $.mobile.changePage("#tableInfo", "slide", false, false);
}

var db = null;

function fn_egov_dbopen(){
    console.log('dbopen start');
    
    db = window.sqlitePlugin.openDatabase({name: 'demo.db', location: 'default'}, function(db) {
                                          if(db != null){
                                          console.log('Test database(demo) has been opened successfully');
                                          fn_egov_dbtablelist();
                                          }
                                          }, function(error){
                                          console.log('Open database ERROR: ' + JSON.stringify(error));
                                          });
}

function fn_egov_dbtablelist() {
    
    if(db != null){
        
        //샘플DB(demo) 테이블 리스트 불러오기
        db.transaction(function (tx){
                       tx.executeSql("SELECT name FROM sqlite_master WHERE type='table'", [], function(tx, result){
                                     if(result.rows.length ==0){
                                     
                                     console.log('no tables: ' + result.rows.length);
                                     
                                     var strhtml="";
                                     strhtml += '<li>';
                                     strhtml += '     <a href="#" onclick="javascript:fn_egov_create_sample()">';
                                     strhtml += '         <h3> 샘플테이블 만들기</h3>';
                                     strhtml += '    </a>';
                                     strhtml += '</li>';
                                     
                                     var theList = $('#thetableList');
                                     theList.html(strhtml);
                                     $.mobile.changePage("#tableInfo", "slide", false, false);
                                     theList.listview("refresh");
                                     listScroll.refresh();
                                     
                                     }else{
                                     
                                     var strhtml="";
                                     var len = result.rows.length;
                                     for (var i=0;i<len;i++) {
                                     strhtml += '<li>';
                                     strhtml += '     <a href="#" onclick="javascript:fn_egov_tabledata()">';
                                     strhtml += '         <h3>테이블이름: '+ result.rows.item(i).name +'</h3>';
                                     strhtml += '    </a>';
                                     strhtml += '</li>';
                                     }
                                     
                                     var theList = $('#thetableList');
                                     theList.html(strhtml);
                                     $.mobile.changePage("#tableInfo", "slide", false, false);
                                     theList.listview("refresh");
                                     listScroll.refresh();
                                     
                                     console.log('3table Count: ' + result.rows.length)
                                     }
                                     });
                       }, function (error){
                       console.log('transaction error: ' + error.message);
                       }, function (){
                       console.log('db tablelist transaction OK');
                       });
        
    }else{
        console.log('SQLite DB has not been connected');
    }
    
}

function fn_egov_create_sample() {
    if(db != null){
        //샘플DB(demo) 테이블 만들기
        db.transaction(function (tx){
                       
                       tx.executeSql("CREATE TABLE IF NOT EXISTS samplet (empid integer primary key, empname text, empjob text)");
                       
                       }, function (error){
                       console.log('transaction error: ' + error.message);
                       }, function (){
                       fn_egov_dbtablelist();
                       console.log('db tablelist transaction OK');
                       });
    }
    
}

function fn_egov_tabledata() {
    if(db != null){
        //tname테이블의 데이터 조회
        db.transaction(function (tx){
                       
                       tx.executeSql("SELECT empid, empname, empjob FROM samplet", [], function(tx, result) {
                                     
                                     console.log('select start');
                                     var strhtml="";
                                     var len = result.rows.length;
                                     
                                     if(len == 0){
                                     strhtml += '<li>';
                                     strhtml += '	<h3> - No Data Found - </h3>';
                                     strhtml += '</li>';
                                     }else{
                                     for(var i=0;i<len;i++){
                                     strhtml += '<li>';
                                     strhtml += '    <a href="#" onclick="javascript:fn_egov_dataSelectMenu(\''+ result.rows.item(i).empid +'\')">';
                                     strhtml += '		<h3>RowNo: '+ (i+1) +'</h3>';
                                     strhtml += '		<h2>&nbsp;&nbsp;&nbsp;EmpID: '+ result.rows.item(i).empid +'</h2>';
                                     strhtml += '		<h2>&nbsp;&nbsp;&nbsp;EmpName: '+ result.rows.item(i).empname +'</h2>';
                                     strhtml += '		<h2>&nbsp;&nbsp;&nbsp;EmpJob: '+ result.rows.item(i).empjob +'</h2>';
                                     strhtml += '    </a>';
                                     strhtml += '</li>';
                                     }
                                     }
                                     var theList = $('#thedataList');
                                     theList.html(strhtml);
                                     $.mobile.changePage("#dataInfo", "slide", false, false);
                                     theList.listview("refresh");
                                     detailScroll.refresh();
                                     
                                     console.log('data Count: ' + result.rows.length)
                                     
                                     });
                       
                       }, function (error){
                       console.log('transaction error: ' + error.message);
                       }, function (){
                       console.log('db tablelist transaction OK');
                       });
    }
}

function fn_egov_addsampledata() {
    if(db != null){
        
        db.transaction(function (tx){
                       
                       tx.executeSql("INSERT INTO samplet (empid, empname, empjob) SELECT max(empid) + 1 as empid, ? as empname, ? as empjob from samplet", ['Test','Researcher'], function(tx, result) {
                                     console.log('Insert Row Affected Count:' + result.rowsAffected);
                                     });
                       
                       }, function (error){
                       console.log('transaction error: ' + error.message);
                       }, function (){
                       fn_egov_tabledata();
                       console.log('db insert transaction OK');
                       });
    }
}

var _data_update = "데이터 수정";
var _data_delete = "데이터 삭제";

function fn_egov_dataSelectMenu(rowid){
    
    var btmItem = [{id : 'button1', value: _data_update},
                   {id : 'button2', value: _data_delete}];
    
    
    jActionSheet('', '메뉴', 'c', btmItem , function(action) {
                 if(action != false){
                 if ( _data_update == action){
                 fn_egov_moveDataUpdatePage(rowid);
                 } else if ( _data_delete == action){
                 fn_egov_dataDeleteConfirm(rowid);
                 }
                 }
                 });
}

function fn_egov_moveDataUpdatePage(rowid){
    
    if(db != null){
        
        db.transaction(function (tx){
                       
                       console.log('rowid:' + rowid);
                       tx.executeSql("SELECT empid, empname, empjob FROM samplet WHERE empid = ?", [rowid], function(tx, result) {
                                     
                                     console.log('length:' + result.rows.length);
                                     
                                     if(result.rows.length >0){
                                     
                                     console.log('empid:' + result.rows.item(0).empid);
                                     console.log('empname:' + result.rows.item(0).empname);
                                     console.log('empjob:' + result.rows.item(0).empjob);
                                     
                                     document.getElementById('empID').value = result.rows.item(0).empid;	 
                                     document.getElementById('empName').value = result.rows.item(0).empname;
                                     document.getElementById('empJob').value = result.rows.item(0).empjob;
                                     }			
                                     });
                       
                       }, function (error){
                       console.log('transaction error: ' + error.message);
                       }, function (){
                       $.mobile.changePage("#dataUpdateInfo", "slide", false, false);
                       console.log('db insert transaction OK');
                       });
    }
    
}

function fn_egov_updateDataConfirm(){
    
    jConfirm('해당 데이터를 수정하시겠습니까?', '알림', 'c', function(r) {
             if (r == true) {
             fn_egov_updateData();
             }
             });	
}
function fn_egov_updateData(){
    
    if(db != null){
        
        db.transaction(function (tx){
                       
                       var rowid = document.getElementById('empID').value;				 
                       var empName = document.getElementById('empName').value;
                       var empJob = document.getElementById('empJob').value;
                       
                       console.log('rowid:' + rowid);
                       
                       tx.executeSql("UPDATE samplet SET empname = ?, empjob = ? WHERE empid = ?", [empName, empJob, rowid], function(tx, result) {
                                     console.log('Update Row Affected Count:' + result.rowsAffected);			
                                     });
                       
                       }, function (error){
                       console.log('transaction error: ' + error.message);
                       }, function (){
                       fn_egov_tabledata();
                       console.log('db Update transaction OK');
                       });
    }
    
}


function fn_egov_dataDeleteConfirm(rowid){
    
    jConfirm('해당 데이터를 삭제하시겠습니까?', '알림', 'c', function(r) {
             if (r == true) {
             fn_egov_dataDelete(rowid);
             }
             });	
}

function fn_egov_dataDelete(rowid){
    
    if(db != null){
        
        db.transaction(function (tx){
                       
                       tx.executeSql("DELETE FROM samplet WHERE empid = ?", [rowid], function(tx, result) {
                                     console.log('Delete Row Affected Count:' + result.rowsAffected);				
                                     });
                       
                       }, function (error){
                       console.log('transaction error: ' + error.message);
                       }, function (){
                       fn_egov_tabledata();
                       console.log('db delete transaction OK');
                       });
    }
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
               
               //infoScroll = new IScroll("#infoWrapper", options);
               detailScroll = new IScroll("#detailWrapper", options);    	
               listScroll = new IScroll("#listWrapper", options);
               
               document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
               
               },500);
    
    
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