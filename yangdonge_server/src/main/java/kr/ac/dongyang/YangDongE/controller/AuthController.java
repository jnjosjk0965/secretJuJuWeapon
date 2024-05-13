package kr.ac.dongyang.YangDongE.controller;


import jakarta.validation.Valid;
import kr.ac.dongyang.YangDongE.dto.request.auth.*;
import kr.ac.dongyang.YangDongE.dto.response.auth.*;
import kr.ac.dongyang.YangDongE.entity.CustomOAuth2User;
import kr.ac.dongyang.YangDongE.provider.JwtProvider;
import kr.ac.dongyang.YangDongE.service.AuthService;
import kr.ac.dongyang.YangDongE.service.implement.KakaoLoginService;
import kr.ac.dongyang.YangDongE.service.implement.NaverLoginService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Slf4j
public class AuthController {

    private final AuthService authService;
    private final JwtProvider jwtProvider;
    private final NaverLoginService naverLoginService;
    private final KakaoLoginService kakaoLoginService;

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

    @PostMapping("/sign-in")
    public ResponseEntity<? super SignInResponseDto> signIn (
            @RequestBody @Valid SignInRequestDto requestBody
    ){
        return authService.signIn(requestBody);
    }

    @PostMapping("/sign-in/kakao")
    public ResponseEntity<? super SignInResponseDto> signInKakao(@RequestBody @Valid OAuthSIgnInRequestDto dto){
        // 프론트로부터 state와 AuthCode 받아옴
        log.info("code: {}", dto.getCode());
        String accessToken = kakaoLoginService.getAccessToken(kakaoLoginService.generateAuthCodeReq(dto.getCode(), dto.getState()));
        log.info(accessToken);
        // accessToken을 사용해 사용자 정보 가져옴
        CustomOAuth2User oAuth2User = kakaoLoginService.loadUser(accessToken);
        log.info("userid: {} , userAttr: {}, userAuth: {}", oAuth2User.getName(), oAuth2User.getUser().toString(), oAuth2User.getAuthorities().toString());
        // authentication 생성
        Authentication authentication = new UsernamePasswordAuthenticationToken(oAuth2User.getName(),"",oAuth2User.getAuthorities());
        // 자체 accessToken 생성
        String returnAccessToken = jwtProvider.generateAccessToken(authentication);
        log.info(returnAccessToken);
        return SignInResponseDto.success(returnAccessToken);
    }

    @PostMapping("/sign-in/naver")
    public ResponseEntity<? super SignInResponseDto> signInNaver(@RequestBody @Valid OAuthSIgnInRequestDto dto){
        // 프론트로부터 state와 AuthCode 받아옴
        log.info("code: {}", dto.getCode());
        String accessToken = naverLoginService.getAccessToken(naverLoginService.generateAuthCodeReq(dto.getCode(), dto.getState()));
        log.info(accessToken);
        // accessToken을 사용해 사용자 정보 가져옴
        CustomOAuth2User oAuth2User = naverLoginService.loadUser(accessToken);
        log.info("userid: {} , userAttr: {}, userAuth: {}", oAuth2User.getName(), oAuth2User.getUser().toString(), oAuth2User.getAuthorities().toString());
        // authentication 생성
        Authentication authentication = new UsernamePasswordAuthenticationToken(oAuth2User.getName(),"",oAuth2User.getAuthorities());
        // 자체 accessToken 생성
        String returnAccessToken = jwtProvider.generateAccessToken(authentication);
        log.info(returnAccessToken);
        return SignInResponseDto.success(returnAccessToken);
    }
}
