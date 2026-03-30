/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.hyb.mbl.nwk.service.impl;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.nwk.service.EgovNetworkAPIService;
import egovframework.hyb.mbl.nwk.service.NetworkAPIVO;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;

/**  
 * @Class Name : EgovNetworkAPIServiceImpl.java
 * @Description : 통합 Network API ServiceImpl Class
 * @Modification Information  
 * @
 * @ 수정일         수정자        수정내용
 * @ ----------   ---------   -----------------------------------------------------------
 * @ 2025.10.28   통합개발팀    Android/iOS 패키지 통합
 *           
 * @author 디바이스 API 실행환경 팀
 * @since 2025. 10. 28.
 * @version 2.0
 * @see
 * 
 */
@Service("EgovNetworkAPIService")
public class EgovNetworkAPIServiceImpl extends EgovAbstractServiceImpl implements EgovNetworkAPIService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovNetworkAPIServiceImpl.class);
    
    /** NetworkAPIDAO */
    @Resource(name="NetworkAPIDAO")
    private NetworkAPIDAO networkAPIDAO;

    /**
     * 네트워크 정보를 등록한다.
     * @param vo - 등록할 정보가 담긴 NetworkAPIVO
     * @return 등록 결과
     * @exception Exception
     */
    public int insertNetworkInfo(NetworkAPIVO vo) throws Exception {    
        return (Integer)networkAPIDAO.insertNetworkInfo(vo);  
    }

    /**
     * 네트워크 정보를 수정한다.
     * @param vo - 수정할 정보가 담긴 NetworkAPIVO
     * @return 수정 결과
     * @exception Exception
     */
    public int updateNetworkInfo(NetworkAPIVO vo) throws Exception {
        return (Integer)networkAPIDAO.updateNetworkInfo(vo);
    }

    /**
     * 네트워크 정보를 삭제한다.
     * @param vo - 삭제할 정보가 담긴 NetworkAPIVO
     * @return 삭제 결과
     * @exception Exception
     */
    public int deleteNetworkInfo(NetworkAPIVO vo) throws Exception {
        return (Integer)networkAPIDAO.deleteNetworkInfo(vo);
    }

    /**
     * 네트워크 정보를 조회한다.
     * @param vo - 조회할 정보가 담긴 NetworkAPIVO
     * @return 조회한 네트워크 정보
     * @exception Exception
     */
    public NetworkAPIVO selectNetworkInfo(NetworkAPIVO vo) throws Exception {
        NetworkAPIVO resultVO = networkAPIDAO.selectNetworkInfo(vo);
        if (resultVO == null)
            throw processException("info.nodata.msg");
        return resultVO;
    }

    /**
     * 네트워크 정보 목록을 조회한다.
     * @param vo - 조회할 정보가 담긴 VO
     * @return 네트워크 정보 목록
     * @exception Exception
     */
    public List<?> selectNetworkInfoList(Object vo) throws Exception {
        return networkAPIDAO.selectNetworkInfoList(vo);
    }
    
    /**
     * 네트워크 정보 총 갯수를 조회한다.
     * @param vo - 조회할 정보가 담긴 VO
     * @return 네트워크 정보 총 갯수
     * @exception
     */
    public int selectNetworkInfoListTotCnt(Object vo) {
        return networkAPIDAO.selectNetworkInfoListTotCnt(vo);
    }
    
    /**
     * 미디어 파일을 조회한다.
     * @param response - HTTP 응답 객체
     * @param mp3FilePath - MP3 파일 경로
     * @return 처리 결과
     * @exception Exception
     */
    public boolean selectMediaFileInf(HttpServletResponse response, String mp3FilePath) throws Exception {
        File file = null;
        FileInputStream fis = null;
    
        BufferedInputStream in = null;
        ByteArrayOutputStream bStream = null;
        
        boolean errorFlag = true;
        
        try {
            file = new File(mp3FilePath + "owlband.mp3");
            fis = new FileInputStream(file);
    
            in = new BufferedInputStream(fis);
            bStream = new ByteArrayOutputStream();
    
            int imgByte;
            while ((imgByte = in.read()) != -1) {
                bStream.write(imgByte);
            }
    
            response.setHeader("Content-Type","audio/mp3");
            response.setContentLength(bStream.size());
        
            bStream.writeTo(response.getOutputStream());
        
            response.getOutputStream().flush();
            response.getOutputStream().close();
        } catch(IOException e){
        	LOGGER.error("["+e.getClass()+"] Try/Catch...file : " , e.getMessage());
        } catch(Exception e) {
        	LOGGER.error("["+e.getClass()+"] Try/Catch... : " + e.getMessage());
            errorFlag = false;
        } finally {
            if (bStream != null) {
                try {
                    bStream.close();
                } catch(IOException e){
                	LOGGER.error("["+e.getClass()+"] Try/Catch...bStream : " , e.getMessage());
                } catch(Exception e) {
                	LOGGER.error("["+e.getClass()+"] Try/Catch... : " + e.getMessage());
                    errorFlag = false;
                }
            }
            if (in != null) {
                try {
                    in.close();
                } catch(IOException e){
                	LOGGER.error("["+e.getClass()+"] Try/Catch...in : " , e.getMessage());
                } catch(Exception e) {
                	LOGGER.error("["+e.getClass()+"] Try/Catch... : " + e.getMessage());
                    errorFlag = false;
                }
            }
            if (fis != null) {
            	try {
                    fis.close();
                } catch(IOException e){
                	LOGGER.error("["+e.getClass()+"] Try/Catch...fis : " , e.getMessage());
                } catch(Exception e) {
                	LOGGER.error("["+e.getClass()+"] Try/Catch... : " + e.getMessage());
                    errorFlag = false;
                }
            }
        }
        return errorFlag;
    }
}

