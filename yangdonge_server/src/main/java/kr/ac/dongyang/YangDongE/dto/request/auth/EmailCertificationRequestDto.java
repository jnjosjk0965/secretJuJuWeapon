package kr.ac.dongyang.YangDongE.dto.request.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class EmailCertificationRequestDto {
    @NotBlank
    private String userId;

    @Email
    @Pattern(regexp = "^[a-zA-Z0-9._%+-]+@m365.dongyang.ac.kr$", message = "유효하지 않은 이메일입니다.")
    @NotBlank
    private String schoolEmail;
}
