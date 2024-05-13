package kr.ac.dongyang.YangDongE.dto;

import jakarta.security.auth.message.AuthException;
import kr.ac.dongyang.YangDongE.entity.UserEntity;
import lombok.Builder;

import java.util.Map;
import java.util.Optional;

@Builder
public record OAuth2UserInfo(
        String userId,
        String name,
        String email,
        String profile
) {
    public static Optional<OAuth2UserInfo> of(String registrationId, Map<String, Object> attributes) {
        return switch (registrationId){
            case "naver" -> Optional.of(ofNaver(attributes));
            case "kakao" -> Optional.of(ofKakao(attributes));
            case "google" -> Optional.of(ofGoogle(attributes));
            default -> Optional.empty();
        };
    }

    private static OAuth2UserInfo ofNaver(Map<String, Object> attributes) {
        Map<String,Object> response = (Map<String, Object>) attributes.get("response");
        return OAuth2UserInfo.builder()
                .userId("naver" + response.get("id"))
                .name((String) response.get("name"))
                .email((String) response.get("email"))
                .profile((String) response.get("profile_image"))
                .build();
    }

    private static OAuth2UserInfo ofKakao(Map<String, Object> attributes) {
        Map<String, Object> account = (Map<String, Object>) attributes.get("kakao_account");
        Map<String, Object> profile = (Map<String, Object>) account.get("profile");
        return OAuth2UserInfo.builder()
                .userId("kakao" + attributes.get("id"))
                .name((String) profile.get("profile_nickname"))
                .email((String) account.get("account_email"))
                .profile((String) profile.get("profile_image"))
                .build();
    }

    private static OAuth2UserInfo ofGoogle(Map<String, Object> attributes){
        return OAuth2UserInfo.builder()
                .userId("google" + attributes.get("sub"))
                .name((String) attributes.get("name"))
                .email((String) attributes.get("email"))
                .profile((String) attributes.get("picture"))
                .build();
    }

    public UserEntity toUserEntity() {
        return new UserEntity(userId, name, email, profile);
    }
}
