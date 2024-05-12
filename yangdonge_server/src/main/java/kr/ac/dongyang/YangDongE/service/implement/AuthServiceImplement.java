package kr.ac.dongyang.YangDongE.service.implement;

import kr.ac.dongyang.YangDongE.common.CertificationNumber;
import kr.ac.dongyang.YangDongE.dto.request.auth.*;
import kr.ac.dongyang.YangDongE.dto.response.ResponseDto;
import kr.ac.dongyang.YangDongE.dto.response.auth.*;
import kr.ac.dongyang.YangDongE.entity.CertificationEntity;
import kr.ac.dongyang.YangDongE.entity.UserEntity;
import kr.ac.dongyang.YangDongE.provider.EmailProvider;
import kr.ac.dongyang.YangDongE.provider.JwtProvider;
import kr.ac.dongyang.YangDongE.repository.CertificationRepository;
import kr.ac.dongyang.YangDongE.repository.UserRepository;
import kr.ac.dongyang.YangDongE.service.AuthService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
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
    private final JwtProvider jwtProvider;
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
            String email = dto.getSchoolEmail();

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
            String email = dto.getSchoolEmail();
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

            String email = dto.getSchoolEmail();
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

        try{
            String userId = dto.getUserId();
            Optional<UserEntity> userEntity = userRepository.findByUserId(userId);
            if (userEntity.isPresent()){
                String email = dto.getEmail();
                boolean isMatched = userEntity.get().getEmail().equals(email);
                if(!isMatched) return SignInResponseDto.signInFail();
            }else {
                userRepository.save(new UserEntity(dto));
            }
            accessToken = jwtProvider.create(userId);

        } catch (Exception exception){
            exception.printStackTrace();
            return ResponseDto.databaseError();
        }

        return SignInResponseDto.success(accessToken);
    }
}
