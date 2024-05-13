package kr.ac.dongyang.YangDongE.service;

import kr.ac.dongyang.YangDongE.dto.response.auth.TokenResponseDto;
import kr.ac.dongyang.YangDongE.entity.CustomOAuth2User;
import org.springframework.http.HttpEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.util.MultiValueMap;

public interface LoginService {
    HttpEntity<MultiValueMap<String, String>> generateAuthCodeReq(String code, String state);
    String getAccessToken(HttpEntity<MultiValueMap<String, String>> request);
    CustomOAuth2User loadUser(String accessToken);

}
