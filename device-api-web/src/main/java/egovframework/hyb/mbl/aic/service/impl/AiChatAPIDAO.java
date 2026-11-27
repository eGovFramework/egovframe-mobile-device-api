package egovframework.hyb.mbl.aic.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.EgovMapper;

import java.util.List;


import egovframework.hyb.mbl.aic.service.AiChatAPIVO;

@EgovMapper("AiChatAPIDAO")
public interface AiChatAPIDAO {

    public int insertAiChatInfo(AiChatAPIVO vo);


    public int deleteAiChatInfo(AiChatAPIVO vo);


    public List<AiChatAPIVO> selectAiChatInfoList(AiChatAPIVO searchVO);

}
