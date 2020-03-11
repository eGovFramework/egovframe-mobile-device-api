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
package egovframework.hyb.add.cmr.service.impl;

import java.util.List;

import egovframework.com.cmm.mapper.EgovComAbstractDAO;
import egovframework.hyb.add.cmr.service.CameraAndroidAPIDefaultVO;
import egovframework.hyb.add.cmr.service.CameraAndroidAPIFileVO;
import egovframework.hyb.add.cmr.service.CameraAndroidAPIVO;

import org.springframework.stereotype.Repository;

/**  
 * @Class Name : CameraAndroidAPIDAO.java
 * @Description : CameraAndroidAPIDAO Class
 * @Modification Information  
 * @
 * @  수정일            수정자        수정내용
 * @ ---------        ---------    -------------------------------
 * @ 2012. 7. 23.        이율경        최초생성
 * 
 * @author 디바이스 API 개발환경 팀
 * @since 2012. 7. 23.
 * @version 1.0
 * @see
 * 
 */
@Repository("CameraAndroidAPIDAO")
public class CameraAndroidAPIDAO extends EgovComAbstractDAO {

    /**
     * 이미지를 등록한다.
     * @param vo - 등록할 정보가 담긴 CameraAPIVO
     * @return 등록 결과
     * @exception Exception
     */
    public int insertCameraPhotoAlbum(CameraAndroidAPIFileVO vo) throws Exception {
        return (Integer)insert("cameraAndroidAPIDAO.insertCameraPhotoAlbum", vo);
    }
    
    /**
     * 이미지 파일을 등록한다.
     * @param vo - 등록할 파일 정보가 담긴 CameraAndroidAPIFileVO
     * @return 등록 결과
     * @exception Exception
     */
    public int insertCameraPhotoAlbumFile(CameraAndroidAPIFileVO vo) throws Exception {
        return (Integer)insert("cameraAndroidAPIDAO.insertCameraPhotoAlbumFile", vo);
    }
    
    /**
     * 이미지 파일을 수정한다.
     * @param vo - 등록할 정보가 담긴 CameraAndroidAPIFileVO
     * @return 수정 결과
     * @exception Exception
     */
    public int updateCameraPhotoAlbumInfoFile(CameraAndroidAPIFileVO vo) throws Exception {
        return (Integer)update("cameraAndroidAPIDAO.updateCameraPhotoAlbumFile", vo);
    }

    /**
     * 이미지를 삭제한다.
     * @param vo - 삭제할 파일 정보가 담긴 CameraAPIVO
     * @return 삭제 결과
     * @exception Exception
     */
    public int deleteCameraPhotoAlbumInfo(CameraAndroidAPIVO vo) throws Exception {
        return (Integer)delete("cameraAndroidAPIDAO.deleteCameraPhotoAlbumInfo", vo);
    }
    
    /**
     * 이미지 파일을  삭제한다.
     * @param vo - 삭제할 파일 정보가 담긴 CameraAndroidAPIFileVO
     * @return 삭제 결과 
     * @exception Exception
     */
    public int deleteCameraPhotoAlbumInfoFile(CameraAndroidAPIVO vo) throws Exception {
        return (Integer)delete("cameraAndroidAPIDAO.deleteCameraPhotoAlbumInfoFile", vo);
    }

    /**
     * 이미지 정보를 조회한다.
     * @param vo - 조회할 정보가 담긴 CameraAPIVO
     * @return 조회한 네트워크 정보
     * @exception Exception
     */
    public CameraAndroidAPIVO selectCameraPhotoAlbumInfo(CameraAndroidAPIVO vo) throws Exception {
        return (CameraAndroidAPIVO) selectOne("cameraAndroidAPIDAO.selectCameraPhotoAlbumInfo", vo);
    }

    /**
     * 이미지 정보 목록을 조회한다.
     * @param vo - 조회할 정보가 담긴 CameraAPIDefaultVO
     * @return 이미지 정보 목록
     * @exception Exception
     */
    public List<?> selectCameraPhotoAlbumInfoList(CameraAndroidAPIDefaultVO searchVO) throws Exception {
        return selectList("cameraAndroidAPIDAO.selectCameraPhotoAlbumInfoList", searchVO);
    }
    
    /**
     * 이미지 파일 정보를 조회한다.
     * @param vo - 조회할 정보가 담긴 CameraAndroidAPIFileVO
     * @return 이미지 파일 정보
     * @exception Exception
     */
    public CameraAndroidAPIFileVO selectImageFileInfo(CameraAndroidAPIFileVO vo) throws Exception {
        return (CameraAndroidAPIFileVO) selectOne("cameraAndroidAPIDAO.selectImageFileInfo", vo);
    }
    
    /**
     * 이미지 제목 중복을 조회한다.
     * @param vo - 조회할 정보가 담긴 CameraAndroidAPIFileVO
     * @return 파일연번 정보
     * @exception Exception
     */
    public CameraAndroidAPIFileVO selectPhotoAlbumPhotoSj(CameraAndroidAPIFileVO vo) throws Exception {
        return (CameraAndroidAPIFileVO) selectOne("cameraAndroidAPIDAO.selectCameraPhotoAlbumPhotoSj", vo);
    }
}
