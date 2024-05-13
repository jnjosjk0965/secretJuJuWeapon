package kr.ac.dongyang.YangDongE.dto.request.auth;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OAuthSIgnInRequestDto {
    @NotBlank
    private String code;

    private String state;
}
