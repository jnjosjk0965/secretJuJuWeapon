package kr.ac.dongyang.YangDongE.service.implement;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import kr.ac.dongyang.YangDongE.dto.OAuth2UserInfo;
import kr.ac.dongyang.YangDongE.dto.response.auth.TokenResponseDto;
import kr.ac.dongyang.YangDongE.entity.CustomOAuth2User;
import kr.ac.dongyang.YangDongE.entity.UserEntity;
import kr.ac.dongyang.YangDongE.repository.UserRepository;
import kr.ac.dongyang.YangDongE.service.LoginService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.Map;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class KakaoLoginService implements LoginService {
    @Value("${spring.security.oauth2.client.provider.kakao.token-uri}")
    private String tokenUri;
    @Value("${spring.security.oauth2.client.provider.kakao.user-info-uri}")
    private String userInfoUri;
    @Value("${spring.security.oauth2.client.registration.kakao.client-id}")
    private String clientId;
    @Value("${spring.security.oauth2.client.registration.kakao.client-secret}")
    private String clientSecret;

    private final ObjectMapper objectMapper;
    private final UserRepository userRepository;


    @Override
    public HttpEntity<MultiValueMap<String, String>> generateAuthCodeReq(String code, String state) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> requestBody = new LinkedMultiValueMap<>();
        requestBody.add("grant_type", "authorization_code");
        requestBody.add("client_id", clientId);
        requestBody.add("client_secret", clientSecret);
        requestBody.add("code", code);
        requestBody.add("redirect_uri", "kakaoca9166e0d74c074c19e17d1a19ba3c28://oauth");

        return new HttpEntity<>(requestBody,headers);
    }

    @Override
    public String getAccessToken(HttpEntity<MultiValueMap<String, String>> request) {
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<TokenResponseDto> response = restTemplate.postForEntity(tokenUri, request, TokenResponseDto.class);
        if(response.getStatusCode().is2xxSuccessful()){
            return response.getBody().getAccess_token();
        }
        else {
            return null;
        }
    }

    @Override
    public CustomOAuth2User loadUser(String accessToken) {
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.set("Authorization", "Bearer " + accessToken);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(headers);

        ResponseEntity<String> response = restTemplate.postForEntity(userInfoUri, request, String.class);
        if(response.getStatusCode().is2xxSuccessful()){
            Map<String, Object> attributes = null;
            try {
                attributes = objectMapper.readValue(response.getBody(), Map.class);
                log.info(attributes.toString());
            } catch (JsonProcessingException e) {
                throw new RuntimeException(e);
            }
            // 유저정보 dto 생성
            String oAuthClientName = "kakao";
            Optional<OAuth2UserInfo> oAuth2UserInfo = OAuth2UserInfo.of(oAuthClientName,attributes);
            // 회원 가입 및 로그인

            if(oAuth2UserInfo.isPresent()){
                UserEntity user = userRepository.findByUserId(oAuth2UserInfo.get().userId())
                        .orElse(oAuth2UserInfo.get().toUserEntity());
                return new CustomOAuth2User(userRepository.save(user));
            }
        }
        return null;
    }
}
