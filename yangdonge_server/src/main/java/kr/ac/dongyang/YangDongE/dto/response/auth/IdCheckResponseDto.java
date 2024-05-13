package kr.ac.dongyang.YangDongE.dto.response.auth;

import kr.ac.dongyang.YangDongE.common.ResponseCode;
import kr.ac.dongyang.YangDongE.common.ResponseMessage;
import kr.ac.dongyang.YangDongE.dto.response.ResponseDto;
import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@Getter
public class IdCheckResponseDto extends ResponseDto {
    private final Boolean isJoin;

    private IdCheckResponseDto(Boolean isJoin){
        super();
        this.isJoin = isJoin;
    }

    public static ResponseEntity<IdCheckResponseDto> success(Boolean isJoin){
        IdCheckResponseDto responseBody = new IdCheckResponseDto(isJoin);
        return ResponseEntity.status(HttpStatus.OK).body(responseBody);
    }
}
