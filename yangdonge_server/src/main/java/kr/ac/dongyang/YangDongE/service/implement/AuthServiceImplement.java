package kr.ac.dongyang.YangDongE.service.implement;

import kr.ac.dongyang.YangDongE.common.CertificationNumber;
import kr.ac.dongyang.YangDongE.dto.request.auth.*;
import kr.ac.dongyang.YangDongE.dto.response.ResponseDto;
import kr.ac.dongyang.YangDongE.dto.response.auth.*;
import kr.ac.dongyang.YangDongE.entity.CertificationEntity;
import kr.ac.dongyang.YangDongE.entity.CustomOAuth2User;
import kr.ac.dongyang.YangDongE.entity.LoginToken;
import kr.ac.dongyang.YangDongE.entity.UserEntity;
import kr.ac.dongyang.YangDongE.provider.EmailProvider;
import kr.ac.dongyang.YangDongE.provider.JwtProvider;
import kr.ac.dongyang.YangDongE.repository.CertificationRepository;
import kr.ac.dongyang.YangDongE.repository.TokenRepository;
import kr.ac.dongyang.YangDongE.repository.UserRepository;
import kr.ac.dongyang.YangDongE.service.AuthService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthServiceImplement implements AuthService {

    private final UserRepository userRepository;
    private final CertificationRepository certificationRepository;
    private final EmailProvider emailProvider;
    private final KakaoLoginService kakaoLoginService;
    private final GoogleLoginService googleLoginService;
    private final JwtProvider jwtProvider;
    private final TokenRepository tokenRepository;
    // private PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();



    @Override
    public ResponseEntity<? super IdCheckResponseDto> idCheck(IdCheckRequestDto dto) {
        try {
            String userId = dto.getId();
            boolean isExistId = userRepository.existsByUserId(userId);
            if(isExistId) return IdCheckResponseDto.success(true);

        } catch (Exception exception){
            exception.printStackTrace();
            return IdCheckResponseDto.databaseError();
        }

        return IdCheckResponseDto.success(false);
    }


    @Override
    public ResponseEntity<? super EmailCertificationResponseDto> emailCertification(EmailCertificationRequestDto dto) {

        try{
            String userId = dto.getUserId();
            String email = dto.getEmail();

            // 해당 아이디를 가진 사용자가 이미 있는지
            boolean isExistId = userRepository.existsByUserId(userId);
            if(isExistId) return EmailCertificationResponseDto.duplicateId();

            // 인증번호 생성
            String certificationNumber = CertificationNumber.getCertificationNumber();

            // 메일 전송
            boolean isSuccess = emailProvider.sendCertificationMail(email,certificationNumber);
            LocalDateTime sentTime = LocalDateTime.now();
            if(!isSuccess) return EmailCertificationResponseDto.mailSendFail();

            // 이전 인증 번호 삭제
            Optional<CertificationEntity> existingEntity = certificationRepository.findById(userId);
            existingEntity.ifPresent(certificationRepository::delete);
            // 인증 정보 DB에 저장
            CertificationEntity certificationEntity = new CertificationEntity(userId, email, certificationNumber, sentTime);
            certificationRepository.save(certificationEntity);
        } catch (Exception exception){
        exception.printStackTrace();
        return IdCheckResponseDto.databaseError();
    }

        return EmailCertificationResponseDto.success();
    }

    @Override
    public ResponseEntity<? super CheckCertificationResponseDto> checkCertification(CheckCertificationRequestDto dto) {
        try {
            String userId = dto.getUserId();
            String email = dto.getEmail();
            String certificationNumber = dto.getCertificationNumber();

            Optional<CertificationEntity> certificationEntity = certificationRepository.findById(userId);
            if(certificationEntity.isEmpty()){
                return CheckCertificationResponseDto.certificationFail();
            }else {
                long seconds = Duration.between(certificationEntity.get().getSentTime(), LocalDateTime.now()).getSeconds();
                boolean isMatched = certificationEntity.get().getSchoolEmail().equals(email) &&
                        certificationEntity.get().getCertificationNumber().equals(certificationNumber) &&
                        (seconds < 300);
                log.info("request: email : {} , certificationNumber : {}",email,certificationNumber);
                log.info("repository: email : {} , certificationNumber : {}",certificationEntity.get().getSchoolEmail(),certificationEntity.get().getCertificationNumber());
                log.info("pastTime: time : {}", seconds);
                log.info("isMatched : {}",isMatched);
                if(!isMatched) return CheckCertificationResponseDto.certificationFail();
            }
        }catch (Exception exception){
            exception.printStackTrace();
            return ResponseDto.databaseError();
        }

        return CheckCertificationResponseDto.success();
    }

    @Override
    public ResponseEntity<? super SignUpResponseDto> signUp(SignUpRequestDto dto) {
        try{
            String userId = dto.getUserId();
            boolean isExistId = userRepository.existsByUserId(userId);
            if(isExistId) return SignUpResponseDto.duplicateId();

            String email = dto.getEmail();
            String certificationNumber = dto.getCertificationNumber();
            Optional<CertificationEntity> certificationEntity = certificationRepository.findById(userId);

            if (certificationEntity.isPresent()){
                boolean isMatched = certificationEntity.get().getSchoolEmail().equals(email) &&
                        certificationEntity.get().getCertificationNumber().equals(certificationNumber);
                if(!isMatched) return SignUpResponseDto.certificationFail();
            }

//            String password = dto.getPassword();
//            String encodedPassword = passwordEncoder.encode(password);
//            dto.setPassword(encodedPassword);

            UserEntity userEntity = new UserEntity(dto);
            userRepository.save(userEntity);

            certificationRepository.deleteById(userId);
        }catch (Exception exception){
            exception.printStackTrace();
            return ResponseDto.databaseError();
        }

        return SignUpResponseDto.success();
    }

    @Override
    public ResponseEntity<? super SignInResponseDto> signIn(SignInRequestDto dto) {

        String accessToken = null;
        String refreshToken = null;

//        try{
//            String userId = dto.getUserId();
//            Optional<UserEntity> userEntity = userRepository.findByUserId(userId);
//            if (userEntity.isPresent()){
//                String email = dto.getEmail();
//                boolean isMatched = userEntity.get().getEmail().equals(email);
//                if(!isMatched) return SignInResponseDto.signInFail();
//            }else {
//                userRepository.save(new UserEntity(dto));
//            }
//
//
//        } catch (Exception exception){
//            exception.printStackTrace();
//            return ResponseDto.databaseError();
//        }

        return SignInResponseDto.success(accessToken,refreshToken);
    }

    @Override
    public ResponseEntity<? super SignInResponseDto> signInKakao(OAuthSignInRequestDto dto) {
        // 프론트로부터 state와 AuthCode 받아옴
        log.info("code: {}", dto.getCode());
        String accessToken = kakaoLoginService.getAccessToken(kakaoLoginService.generateAuthCodeReq(dto.getCode(), dto.getState()));
        log.info(accessToken);
        // accessToken을 사용해 사용자 정보 가져옴
        CustomOAuth2User oAuth2User = kakaoLoginService.loadUser(accessToken);
        log.info("userid: {} , userAttr: {}, userAuth: {}", oAuth2User.getName(), oAuth2User.getUser().toString(), oAuth2User.getAuthorities().toString());
        // authentication 생성
        Authentication authentication = new UsernamePasswordAuthenticationToken(oAuth2User.getUser().getId()  ,"",oAuth2User.getAuthorities());
        // 자체 Token 생성
        String returnAccessToken = jwtProvider.generateAccessToken(authentication);
        String refreshToken = jwtProvider.generateRefreshToken(authentication);
        log.info(returnAccessToken);
        // 리프레쉬 토큰 저장
        tokenRepository.save(new LoginToken(oAuth2User.getUser(), refreshToken));

        return SignInResponseDto.success(returnAccessToken,refreshToken);
    }

    @Override
    public ResponseEntity<? super SignInResponseDto> signInGoogle(SignInRequestDto dto) {
        log.info("idToken: {}", dto.getToken());
        // accessToken을 사용해 사용자 정보 가져옴
        CustomOAuth2User oAuth2User = googleLoginService.loadUser(dto.getToken());
        log.info("userid: {} , userAttr: {}, userAuth: {}", oAuth2User.getName(), oAuth2User.getUser().toString(), oAuth2User.getAuthorities().toString());
        // authentication 생성
        Authentication authentication = new UsernamePasswordAuthenticationToken(oAuth2User.getUser().getId(),"",oAuth2User.getAuthorities());
        // 자체 accessToken 생성
        String returnAccessToken = jwtProvider.generateAccessToken(authentication);
        String refreshToken = jwtProvider.generateRefreshToken(authentication);
        log.info(returnAccessToken);
        tokenRepository.save(new LoginToken(oAuth2User.getUser(), refreshToken));

        return SignInResponseDto.success(returnAccessToken, refreshToken);
    }
}
