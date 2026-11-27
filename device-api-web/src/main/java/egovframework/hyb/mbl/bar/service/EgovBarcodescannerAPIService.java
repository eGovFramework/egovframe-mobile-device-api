package egovframework.hyb.mbl.bar.service;

import java.util.List;

public interface EgovBarcodescannerAPIService {

    int insertBarcodeInfo(BarcodescannerAPIVO vo);

    List<BarcodescannerAPIVO> selectBarcodeInfoList(BarcodescannerAPIVO searchVO);

    int deleteBarcodeInfo(BarcodescannerAPIVO vo);
}
