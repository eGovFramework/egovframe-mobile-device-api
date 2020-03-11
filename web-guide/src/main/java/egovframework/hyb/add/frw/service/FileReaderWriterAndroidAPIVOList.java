package egovframework.hyb.add.frw.service;

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**  
 * @Class Name : FileReaderWriterAndroidAPIVOList.java
 * @Description : FileReaderWriterAndroidAPIVOList Class
 * @Modification Information  
 * @
 * @  수정일                 수정자                 수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2012. 8. 6.  나신일                   최초생성
 * 
 * @author 디바이스 API 실행환경 개발팀
 * @since 2012. 8. 6
 * @version 1.0
 * @see
 * 
 */

@XmlRootElement
public class FileReaderWriterAndroidAPIVOList {

    private List<FileReaderWriterAndroidAPIVO> fileInfoList;

    public List<FileReaderWriterAndroidAPIVO> getFileInfoList() {
        return fileInfoList;
    }

    /**
     * @param 파라미터
     *            fileReaderWriterInfoList를 변수 fileReaderWriterInfoList에 설정한다.
     */
    @XmlElement
    public void setFileInfoList(List<FileReaderWriterAndroidAPIVO> fileInfoList) {
        this.fileInfoList = fileInfoList;
    }

}