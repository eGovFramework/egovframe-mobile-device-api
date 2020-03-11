/************************************************************************
   파일명 : EgovZipAPI.js
   설  명 : 모바일 전자정부 하이브리드 앱 실행환경 공통 JavaScript
   수정일       수정자        Version        Function 명
  -------      ----------      ----------     -----------------
  2016.06.24   신용호         1.0              최초 생성

************************************************************************/


/**********************************************************
 * Zip API setting
 **********************************************************/ 
/** 
 * RestService를 담당할 EgovInterface 객체 생성
 * @type 
*/
var EgovZip = function() {
};


if(!window.plugins) {
    window.plugins = {};
}

if (!window.plugins.EgovZip) {
    window.plugins.EgovZip = new EgovZip();
}

