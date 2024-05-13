package kr.ac.dongyang.YangDongE.provider;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import kr.ac.dongyang.YangDongE.entity.UserEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Component
@Slf4j
public class JwtProvider {

    @Value("${secret-key}")
    private  String secretKey;
    private static final Long ACCESS_TOKEN_EXPIRED_TIME = 1000 * 60 * 60L; // 1시간
    private static final Long REFRESH_TOKEN_EXPIRED_TIME = 1000 * 60 * 60L * 24 * 7 * 2; // 2주
    private static final String KEY_ROLE = "role";

    // 엑세스토큰 발급
    public String generateAccessToken (Authentication authentication) {
        return generateToken(authentication, ACCESS_TOKEN_EXPIRED_TIME);
    }
    // 리프레쉬 토큰 발급
    public void generateRefreshToken (Authentication authentication, String accessToken){
        String refreshToken = generateToken(authentication, REFRESH_TOKEN_EXPIRED_TIME);
        // 리프레쉬 토큰 저장
        // tokenService.saveOrUpdate(user.getId(), refreshToken, accessToken);
    }
    // 토큰 생성
    private String generateToken(Authentication authentication, long time){
        Date expiredDate = Date.from(Instant.now().plusMillis(time));
        SecretKey key = Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));

        // 토큰 권한 추출
        String authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.joining());

        return Jwts.builder()
                .signWith(key)
                .subject(authentication.getName())
                .claim(KEY_ROLE,authorities)
                .issuedAt(new Date())
                .expiration(expiredDate)
                .compact();
    }

    // 토큰으로부터 정보 추출
    public Authentication getAuthentication(String token){
        Claims claims = parseClaims(token);
        List<SimpleGrantedAuthority> authorities = getAuthorities(claims);
        String userId = claims.getSubject();

        return new UsernamePasswordAuthenticationToken(userId, "",authorities);
    }

    private List<SimpleGrantedAuthority> getAuthorities(Claims claims){
        return Collections.singletonList(new SimpleGrantedAuthority(
                claims.get(KEY_ROLE).toString()));
    }

    // 엑세스토큰 유효성 확인
    public boolean validateToken (String token) {
        if(!StringUtils.hasText(token)) return false;

        Claims claims = parseClaims(token);
        return claims.getExpiration().after(new Date());
    }
    private Claims parseClaims(String token){
        SecretKey key = Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));
        try{
            return Jwts.parser().verifyWith(key).build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (ExpiredJwtException e){
            return e.getClaims();
        }
    }
}
