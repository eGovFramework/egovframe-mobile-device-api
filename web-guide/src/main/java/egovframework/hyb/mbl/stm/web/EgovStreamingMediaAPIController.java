package egovframework.hyb.mbl.stm.web;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.view.AbstractView;

import egovframework.hyb.ios.dvc.service.DeviceiOSAPIVO;
import egovframework.hyb.mbl.stm.service.EgovStreamingMediaAPIService;
import egovframework.hyb.mbl.stm.service.StreamingMediaAPIDefaultVO;
import egovframework.hyb.mbl.stm.service.StreamingMediaAPIFileVO;
import egovframework.hyb.mbl.stm.service.StreamingMediaAPIVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;

/**  
 * @Class Name : EgovStreamingMediaAPIController.java
 * @Description : EgovStreamingMediaAPIController Class
 * @Modification Information  
 * @
 * @ 수정일               수정자              수정내용
 * @ ----------   ---------   -------------------------------
 *   2016.07.14   장성호              최초생성
 *   2020.09.16   신용호              Swagger 적용
 * 
 * @author 디바이스 API 실행환경 팀
 * @since 2016. 7. 14.
 * @version 1.0
 * @see
 * 
 */
@Controller
public class EgovStreamingMediaAPIController {

	/** EgovStreamingMediaAPIService */
	@Autowired
	private EgovStreamingMediaAPIService egovStreamingMediaAPIService;

	/** propertiesService */
	@Autowired
	protected EgovPropertyService propertiesService;

	@Autowired
	ServletContext servletContext;
	
	
	/**
	 * 미디어 목록을 조회한다.
	 * @param VO - 조회할 정보가 담긴 StreamingMediaAPIVO
	 * @return 조회 목록
	 * @exception Exception
	 */
    @ApiOperation(value="StreamingMedia 정보 목록조회", notes="StreamingMedia 정보 목록을 조회한다.", response=StreamingMediaAPIVO.class, responseContainer="List")
	@RequestMapping("/stm/mediaInfoList.do")
	public @ResponseBody
	ModelAndView selectMediaInfoList(StreamingMediaAPIDefaultVO vo) throws Exception {
		
		ModelAndView jsonView = new ModelAndView("jsonView");
		
		List<?> streamingMediaAPIVO = egovStreamingMediaAPIService.selectMediaInfoList(vo);
		
		jsonView.addObject("resultSet", streamingMediaAPIVO);
		jsonView.addObject("resultState","OK");
		
		return jsonView;
	}

    @ApiOperation(value="StreamingMedia 재생횟수 증가", notes="StreamingMedia 재생횟수를 증가한다.", response=DeviceiOSAPIVO.class)
    @ApiImplicitParams({
        @ApiImplicitParam(name = "sn", value = "일련번호", required = true, dataType = "int", paramType = "query"),
    })
	@RequestMapping("/stm/updateMediaInfoRevivCo.do")
	public ModelAndView updateMediaInfoRevivCo(@RequestParam("sn") String sn) throws Exception {

		if (sn != null && "".equals(sn) == false) {

			StreamingMediaAPIVO vo = new StreamingMediaAPIVO();
			vo.setSn(sn);

			egovStreamingMediaAPIService.updateMediaInfoRevivCo(vo);
		}
		
		ModelAndView jsonView = new ModelAndView("jsonView");
		
		jsonView.addObject("resultState","OK");
		
		return jsonView;
	}

    @ApiOperation(value="StreamingMedia 파일 수신", notes="StreamingMedia 파일을 수신한다.", response=DeviceiOSAPIVO.class)
    @ApiImplicitParams({
        @ApiImplicitParam(name = "sn", value = "일련번호", required = true, dataType = "int", paramType = "query"),
    })
	@RequestMapping("/stm/getMediaStreaming.do")
	public ModelAndView getMediaStreaming(@RequestParam("sn") final String sn, HttpServletResponse response) throws Exception {

		View streamView = new AbstractView() {
	        @Override
	        protected void renderMergedOutputModel(Map model, HttpServletRequest request, HttpServletResponse response) throws Exception {
	            
	        	StreamingMediaAPIFileVO resultVO = null;
	    		if (sn != null && "".equals(sn) == false) {

	    			StreamingMediaAPIFileVO vo = new StreamingMediaAPIFileVO();
	    			vo.setSn(Integer.parseInt(sn));	    			
	    			resultVO = egovStreamingMediaAPIService.selectMediaFileURL(vo);	    			
	    		}
	    		
	    		RandomAccessFile rf = new RandomAccessFile(new File(resultVO.getFileStreCours().toString() + resultVO.getStreFileNm().toString()), "r");
	    		
	    		long rangeStart = 0;
	    		long rangeEnd = 0;
	    		boolean isPart = false;
	    		
	    		try{
	    			long movieSize = rf.length();
	    			String range = request.getHeader("range");
	    		
	    			if(range != null){
	    				if(range.endsWith("-")){
	    					range = range + (movieSize -1);
	    				}
	    				
	    				int idxm = range.trim().indexOf("-");
	    				rangeStart = Long.parseLong(range.substring(6,idxm));
	    				rangeEnd = Long.parseLong(range.substring(idxm +1));
	    				if(rangeStart > 0){
	    					isPart = true;
	    				}
	    			}else{
	    				rangeStart = 0;
	    				rangeEnd = movieSize -1;
	    			}
	    			
	    			long partSize = rangeEnd - rangeStart +1;
	    			
	    			response.reset();	    			
	    			response.setStatus(isPart ? 206 : 200);	
	    			response.setContentType("video/"+ resultVO.getFileExtsn());
	    			response.setHeader("Content-Disposition:", "attachment; filename=" + new String(resultVO.getOrignlFileNm().getBytes(), "UTF-8"));
	    			response.setHeader("Content-Transfer-Encoding", "binary");
	    			response.setHeader("Content-Range", "bytes"+rangeStart+"-"+rangeEnd+"/"+movieSize);
	    			response.setHeader("Accept-Range", "bytes");
	    			response.setHeader("Content-Length", ""+partSize);
	    			
	    			OutputStream out = response.getOutputStream();
	    			rf.seek(rangeStart);
	    			
	    			int bufferSize = 8*1024;
	    			byte[] buf = new byte[bufferSize];
	    			do{
	    				int block = partSize > bufferSize ? bufferSize : (int)partSize;
	    				int len = rf.read(buf, 0, block);
	    				out.write(buf, 0, len);
	    				partSize -= block;
	    				
	    			}while(partSize > 0);
	    			
	    		}catch(IOException e){
	    			e.getStackTrace();
	    		}finally{
	    			rf.close();
	    		}
	    		
	        }
	    };
	    
	    return new ModelAndView(streamView);	    
		
	}
	
	
}
