package egovframework.hyb.mbl.bar.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.bar.service.BarcodescannerAPIVO;

@EgovMapper("BarcodescannerDeviceAPIDAO")
public interface BarcodescannerDeviceAPIDAO {

    public int insertBarcodeInfo(BarcodescannerAPIVO vo);


    public List<BarcodescannerAPIVO> selectBarcodeInfoList(BarcodescannerAPIVO searchVO);


    public int deleteBarcodeInfo(BarcodescannerAPIVO vo);

}
