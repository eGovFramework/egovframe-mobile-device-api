package egovframework.hyb.utils;

import org.junit.jupiter.api.Test;

import java.util.Calendar;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * 업로드 파일명에 쓰이는 타임스탬프가 24시간제로 생성되는지 검증한다.
 *
 * <p>수정 전에는 패턴이 12시간제({@code hh})라 13시가 "01"로 포맷돼 01시와 문자열이
 * 겹쳤고, 같은 분·초에 오전/오후로 업로드된 파일이 동일한 이름을 얻어 덮어써졌다.
 * ({@code File_<타임스탬프>_<키>} 형식, 키는 요청 단위로 1부터 증가)</p>
 */
class EgovFileMngUtilTimeStampTest {

    @Test
    void getTimeStamp_오후시각을_24시간제로_포맷해_오전과_겹치지_않는다() {
        EgovFileMngUtil util = new EgovFileMngUtil();

        // JVM 기본 시간대·SimpleDateFormat이 같은 기본 시간대를 쓰므로,
        // Calendar로 만든 지역시각의 '시'와 포맷 결과의 '시'가 시간대와 무관하게 일치한다.
        // (DST 경계를 피하려고 1월 날짜를 사용한다.)
        String afternoonTs = util.getTimeStamp(localMillis(2026, Calendar.JANUARY, 2, 13, 4, 5));
        String morningTs = util.getTimeStamp(localMillis(2026, Calendar.JANUARY, 2, 1, 4, 5));

        assertThat(afternoonTs).isEqualTo("20260102130405");
        assertThat(morningTs).isEqualTo("20260102010405");
        assertThat(afternoonTs)
                .as("오후(13시) 타임스탬프는 24시간제로 포맷돼 오전(01시)과 달라야 파일 덮어쓰기가 없다")
                .isNotEqualTo(morningTs);
    }

    private static long localMillis(int year, int month, int day, int hour, int minute, int second) {
        Calendar cal = Calendar.getInstance();
        cal.clear();
        cal.set(year, month, day, hour, minute, second);
        return cal.getTimeInMillis();
    }
}
