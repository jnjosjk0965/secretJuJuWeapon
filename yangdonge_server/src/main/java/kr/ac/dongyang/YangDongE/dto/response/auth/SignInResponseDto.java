package kr.ac.dongyang.YangDongE.dto.response.auth;

import kr.ac.dongyang.YangDongE.common.ResponseCode;
import kr.ac.dongyang.YangDongE.common.ResponseMessage;
import kr.ac.dongyang.YangDongE.dto.response.ResponseDto;
import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@Getter
public class SignInResponseDto extends ResponseDto {

    private final String accessToken;

    public SignInResponseDto(String accessToken) {
        super();
        this.accessToken = accessToken;
    }

    public static ResponseEntity<SignInResponseDto> success (String token){
        SignInResponseDto responseBody = new SignInResponseDto(token);
        return ResponseEntity.status(HttpStatus.OK).body(responseBody);
    }

    public static ResponseEntity<ResponseDto> signInFail(){
        ResponseDto responseBody = new ResponseDto(ResponseCode.SIGN_IN_FAIL, ResponseMessage.SIGN_IN_FAIL);
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(responseBody);
    }
}
