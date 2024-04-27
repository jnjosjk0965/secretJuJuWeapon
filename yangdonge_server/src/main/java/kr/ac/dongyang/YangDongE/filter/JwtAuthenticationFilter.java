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
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
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

        try {
            String token = parseBearerToken(request);
            if (token == null){
                filterChain.doFilter(request,response);
                return;
            }

            String userId = jwtProvider.validate(token);
            if(userId == null){
                filterChain.doFilter(request,response);
                return;
            }

            Optional<UserEntity> userEntity = userRepository.findById(userId);
            if(userEntity.isPresent()){
                String role = userEntity.get().getRole(); // role : ROLE_USER or ROLE_ADMIN

                log.info(role);

                // ROLE_DEVELOPER, ROLE_BOSS 과 같아야함
                List<GrantedAuthority> authorities = new ArrayList<>();
                authorities.add(new SimpleGrantedAuthority(role));

                // 등록할 때 사용할 빈 컨텍스트
                SecurityContext securityContext = SecurityContextHolder.createEmptyContext();
                // 컨텍스트 안에 담을 토큰
                AbstractAuthenticationToken authenticationToken =
                        new UsernamePasswordAuthenticationToken(userId, null, authorities);
                authenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                securityContext.setAuthentication(authenticationToken);
                // context 등록
                SecurityContextHolder.setContext(securityContext);
            }

        }catch (Exception exception){
            exception.printStackTrace();
        }

        filterChain.doFilter(request,response);
    }

    private String parseBearerToken(HttpServletRequest request){
        String authorization = request.getHeader("Authorization");

        boolean hasAuthorization = StringUtils.hasText(authorization);
        if (!hasAuthorization) return null;

        boolean isBearer = authorization.startsWith("Bearer ");
        if (!isBearer) return null;

        // Bearer 빼고 가져옴
        return authorization.substring(7);
    }
}
