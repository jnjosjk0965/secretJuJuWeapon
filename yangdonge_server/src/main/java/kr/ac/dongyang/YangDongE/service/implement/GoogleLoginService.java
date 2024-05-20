package kr.ac.dongyang.YangDongE.service.implement;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import kr.ac.dongyang.YangDongE.dto.OAuth2UserInfo;
import kr.ac.dongyang.YangDongE.entity.CustomOAuth2User;
import kr.ac.dongyang.YangDongE.entity.UserEntity;
import kr.ac.dongyang.YangDongE.repository.UserRepository;
import kr.ac.dongyang.YangDongE.service.LoginService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class GoogleLoginService implements LoginService {
    @Value("${spring.security.oauth2.client.provider.google.user-info-uri}")
    private String userInfoUri;

    private final ObjectMapper objectMapper;
    private final UserRepository userRepository;
    // flutter 의 Google_sign_in 패키지 사용 -> authcode 제공 x 바로 token 제공
    @Override
    public HttpEntity<MultiValueMap<String, String>> generateAuthCodeReq(String code, String state) {
        return null;
    }

    @Override
    public String getAccessToken(HttpEntity<MultiValueMap<String, String>> request) {
        return "";
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
            String oAuthClientName = "google";
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
