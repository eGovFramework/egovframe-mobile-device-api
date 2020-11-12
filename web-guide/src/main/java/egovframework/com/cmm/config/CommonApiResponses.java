package egovframework.com.cmm.config;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
@ApiResponses(value = {
        @ApiResponse(code = 200, message = "성공"), //Ok
        //@ApiResponse(code = 201, message = "Created"), //No Content
        //@ApiResponse(code = 204, message = "No Content"), //No Content
        @ApiResponse(code = 400, message = "잘못된 요청입니다."), //Bad Request
        @ApiResponse(code = 401, message = "인가가 안되어 있습니다."), //Unauthorized
        @ApiResponse(code = 403, message = "권한이 없습니다."), //Forbidden
        @ApiResponse(code = 404, message = "찾을수 없습니다."), //Not Found
        @ApiResponse(code = 500, message = "내부서버오류") //Internal Server Error
})
public @interface CommonApiResponses {
}