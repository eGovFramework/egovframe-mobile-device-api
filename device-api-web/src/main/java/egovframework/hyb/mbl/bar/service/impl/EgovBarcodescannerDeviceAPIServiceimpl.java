package egovframework.hyb.mbl.bar.service.impl;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.hyb.mbl.bar.service.BarcodescannerAPIVO;
import egovframework.hyb.mbl.bar.service.EgovBarcodescannerAPIService;
import jakarta.annotation.Resource;

@Service("EgovBarcodescannerAPIService")
public class EgovBarcodescannerDeviceAPIServiceimpl extends EgovAbstractServiceImpl
        implements EgovBarcodescannerAPIService {

    @Resource(name = "BarcodescannerDeviceAPIDAO")
    private BarcodescannerDeviceAPIDAO barcodescannerDeviceAPIDAO;

    public int insertBarcodeInfo(BarcodescannerAPIVO vo) {
        return barcodescannerDeviceAPIDAO.insertBarcodeInfo(vo);
    }

    public List<BarcodescannerAPIVO> selectBarcodeInfoList(BarcodescannerAPIVO searchVO) {
        return barcodescannerDeviceAPIDAO.selectBarcodeInfoList(searchVO);
    }

    public int deleteBarcodeInfo(BarcodescannerAPIVO vo) {
        return barcodescannerDeviceAPIDAO.deleteBarcodeInfo(vo);
    }
}
