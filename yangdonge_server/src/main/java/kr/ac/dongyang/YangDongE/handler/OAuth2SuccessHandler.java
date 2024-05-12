package kr.ac.dongyang.YangDongE.handler;

import com.nimbusds.oauth2.sdk.util.JSONUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.dongyang.YangDongE.common.ResponseCode;
import kr.ac.dongyang.YangDongE.common.ResponseMessage;
import kr.ac.dongyang.YangDongE.dto.response.auth.SignInResponseDto;
import kr.ac.dongyang.YangDongE.entity.CustomOAuth2User;
import kr.ac.dongyang.YangDongE.provider.JwtProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class OAuth2SuccessHandler extends SimpleUrlAuthenticationSuccessHandler {
    private final JwtProvider jwtProvider;
    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication
    ) throws IOException, ServletException {

        CustomOAuth2User oAuth2User = (CustomOAuth2User) authentication.getPrincipal();

        String userId = oAuth2User.getName();
        String accessToken = jwtProvider.create(userId);



    }
}
