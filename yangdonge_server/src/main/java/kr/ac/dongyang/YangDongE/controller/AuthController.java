package kr.ac.dongyang.YangDongE.controller;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import kr.ac.dongyang.YangDongE.dto.request.auth.*;
import kr.ac.dongyang.YangDongE.dto.response.auth.*;
import kr.ac.dongyang.YangDongE.entity.CustomOAuth2User;
import kr.ac.dongyang.YangDongE.provider.JwtProvider;
import kr.ac.dongyang.YangDongE.service.AuthService;
import kr.ac.dongyang.YangDongE.service.implement.GoogleLoginService;
import kr.ac.dongyang.YangDongE.service.implement.KakaoLoginService;
import kr.ac.dongyang.YangDongE.service.implement.NaverLoginService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Slf4j
public class AuthController {

    private final AuthService authService;

    @PostMapping("/id-check")
    public ResponseEntity<? super IdCheckResponseDto> idCheck(
            @RequestBody @Valid IdCheckRequestDto requestBody
    ){
        return authService.idCheck(requestBody);
    }

    @PostMapping("email-certification")
    public ResponseEntity<? super EmailCertificationResponseDto> emailCertification(
            @RequestBody @Valid EmailCertificationRequestDto requestBody
    ){
        return authService.emailCertification(requestBody);
    }

    @PostMapping("/check-certification")
    public ResponseEntity<? super CheckCertificationResponseDto> checkCertification(
            @RequestBody @Valid CheckCertificationRequestDto requestBody
    ){
        return authService.checkCertification(requestBody);
    }

    @PostMapping("/sign-up")
    public ResponseEntity<? super SignUpResponseDto> signUp (
            @RequestBody @Valid SignUpRequestDto requestBody
    ) {
        return authService.signUp(requestBody);
    }

//    @PostMapping("/sign-in")
//    public ResponseEntity<? super SignInResponseDto> signIn (
//            @RequestBody @Valid SignInRequestDto requestBody
//    ){
//        return authService.signIn(requestBody);
//    }

    @PostMapping("/sign-in/kakao")
    public ResponseEntity<? super SignInResponseDto> signInKakao(@RequestBody @Valid OAuthSignInRequestDto dto){
        return authService.signInKakao(dto);
    }

    @PostMapping("/sign-in/google")
    public ResponseEntity<? super SignInResponseDto> signInGoogle(@RequestBody @Valid SignInRequestDto dto){
        return authService.signInGoogle(dto);
    }
}
