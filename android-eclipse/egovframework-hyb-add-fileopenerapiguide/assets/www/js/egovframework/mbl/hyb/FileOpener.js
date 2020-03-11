/** 
 * @fileoverview 모바일 전자정부 하이브리드 앱 문서뷰어 API 가이드 프로그램 JavaScript
 * JavaScript. 
 *
 * @author 장성호
 * @version 1.0 
 * @  수정일			수정자		수정내용
 * @ ---------		---------	-------------------------------
 * @ 2016. 7. 11.   장성호 		iscroll5 적용 
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
    $("#btnDocumentList").attr("href","javascript:fn_egov_documentlist();");
    //$("#btnUpdate_update").attr("href","javascript:fn_egov_update_go();");
    //$("#btnUpdate_goNewPage").attr("href","javascript:fn_egov_update_goNewPage();");
    
}

var fileSN;
var fileorignlFileNm;
var filestreFileNm;
var jsonresult;

function fn_egov_documentlist() {
    
    var url = "/fop/FileOpenerDocumentList.do";
    var accept_type = "xml";
    var params = {};    
    
    window.plugins.EgovInterface.request(url, params, function(jsondata) {                                         
                                         
		 resultJson = jsondata;
		 if (resultJson.resultSet == "") {
            navigator.notification.alert("등록된 문서가 없습니다.", null, 'Info');
            return;
         }
		 if(resultJson.resultState == "OK"){
			 var strhtml="";
			 $(resultJson.resultSet).each(function(){
				 
		            var sn = this.sn;
		            var orignlFileNm = this.orignlFileNm;
		            var streFileNm = this.streFileNm;
		            var fileSize = this.fileSize;
		            var updDt = this.updDt;	    						                    
		            
		            fileorignlFileNm = this.orignlFileNm;	    						                    
		            
		            strhtml += '<li>';	    						                    
		            strhtml += '     <a href="#" onclick="javascript:fn_egov_filelist_go(\'' + sn + ';'+ orignlFileNm + ';'+ streFileNm +'\')">';
		            strhtml += '         <h3>파일명:  ' + orignlFileNm + '</h3>';
		            strhtml += '         <h3>파일크기: ' + fileSize + '</h3>';
		            strhtml += '         <h3>등록일:  ' +  updDt + '</h3>';
		            strhtml += '    </a>';
		            strhtml += '</li>';        
		            
		        });
		     									 
			    var theList = $('#theList');
		        theList.html(strhtml);	    								        
		        $.mobile.changePage("#documentInfo", "slide", false, false);
		        theList.listview("refresh");
			    infoScroll.refresh();
			     
		 }else{
		     $("#alert_dialog").click( function() {
		         jAlert('데이터 전송 중 오류가 발생 했습니다.', '전송 오류', 'c');
		       });
		 }
		 
		 }, function(result){
			 alert("error > "+result);
		 });
    
}


function fn_egov_filelist_go(input) {
	
 	console.log(">>> input: " + input);
 	
	jConfirm('파일을 뷰어로 보시겠습니까?', '알림', 'c', function(r) {
        if (r == true) {
        	fn_egov_fileDownload(input);
        }
    });
}

function fn_egov_fileDownload(input){
	
	var url = "/fop/FileOpenerfileDownload.do";
    
	var inputArray = input.split(";");	
	var inputTargetPath = cordova.file.externalDataDirectory; 
    var params = {sn : inputArray[0], orignlFileNm : inputArray[1], streFileNm : inputArray[2], targetPath : inputTargetPath};
    var fileExt = inputArray[2].split(".");
    var fileMINEType = "application/" + fileExt[fileExt.length-1];
    
    console.log('File Download Start ');
    console.log('>> inputTargetPath : ' + inputTargetPath);
    console.log('>> fileMINEType : ' + fileMINEType);
    
    window.plugins.EgovFileOpener.fileDownload(url, params, function(jsondata) {
        jsonresult = jsondata;
        console.log("jsondata > "+jsondata);
        
        console.log('File Open Start ');        
    	cordova.plugins.fileOpener2.open(
    			inputTargetPath + inputArray[1],
    			fileMINEType,
	            {
		            error : function(e) {
		            	console.log('Error status: ' + e.status + ' - Error message: ' + e.message);
		            	if(e.status == "9")
		            		alert('문서를 실행할 수 있는 뷰어가 설치되어 있지 않습니다.');
		            },
		            success : function () {
		            	console.log('file opened successfully'); 				
		            }
			        }
				);
    	
        }, function(result){
           alert("error > "+result);
        });

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