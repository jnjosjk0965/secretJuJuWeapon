package kr.ac.dongyang.YangDongE.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.ac.dongyang.YangDongE.entity.UserEntity;
import kr.ac.dongyang.YangDongE.provider.JwtProvider;
import kr.ac.dongyang.YangDongE.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Component
@RequiredArgsConstructor
@Slf4j
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtProvider jwtProvider;
    private final UserRepository userRepository;


    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        /*
        * client의 요청을 Beartoken 형식으로 받아옴
        * token 값을 받아옴 Jwtprovider에서 validate 함
        * 거기서 subject를 꺼내서 작업을 진행
        * */
        String accessToken = parseBearerToken(request);
        try {
            if(jwtProvider.validateToken(accessToken)){
                // 정상 토큰인 경우 토큰을 통해 생성한 authentication 을 SecurityContext에 저장
                Authentication authentication = jwtProvider.getAuthentication(accessToken);
                SecurityContextHolder.getContext().setAuthentication(authentication);
            } else {
                // 만료되었을 경우 accessToken 재발급
            }

        }catch (Exception exception){
            exception.printStackTrace();
        }

        filterChain.doFilter(request,response);
    }

    private String parseBearerToken(HttpServletRequest request){
        String bearerToken = request.getHeader(HttpHeaders.AUTHORIZATION);

        // Header의 Authorization 값의 유무
        boolean hasAuthorization = StringUtils.hasText(bearerToken);
        if (!hasAuthorization) return null;

        // 해당 값이 'Bearer ' 로 시작하는지
        boolean isBearer = bearerToken.startsWith("Bearer ");
        if (!isBearer) return null;

        // 'Bearer ' 빼고 가져옴
        return bearerToken.substring(7);
    }
}
