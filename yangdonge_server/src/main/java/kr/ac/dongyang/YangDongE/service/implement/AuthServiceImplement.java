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

import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthServiceImplement implements AuthService {

    private final UserRepository userRepository;
    private final CertificationRepository certificationRepository;
    private final EmailProvider emailProvider;
    private final JwtProvider jwtProvider;
    private PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();



    @Override
    public ResponseEntity<? super IdCheckResponseDto> idCheck(IdCheckRequestDto dto) {
        try {
            String userId = dto.getId();
            boolean isExistId = userRepository.existsById(userId);
            if(isExistId) return IdCheckResponseDto.duplicateId();

        } catch (Exception exception){
            exception.printStackTrace();
            return IdCheckResponseDto.databaseError();
        }

        return IdCheckResponseDto.success();
    }


    @Override
    public ResponseEntity<? super EmailCertificationResponseDto> emailCertification(EmailCertificationRequestDto dto) {

        try{
            String userId = dto.getId();
            String email = dto.getEmail();

            boolean isExistId = userRepository.existsById(userId);
            if(isExistId) return EmailCertificationResponseDto.duplicateId();

            String certificationNumber = CertificationNumber.getCertificationNumber();

            boolean isSuccess = emailProvider.sendCertificationMail(email,certificationNumber);
            if(!isSuccess) return EmailCertificationResponseDto.mailSendFail();

            CertificationEntity certificationEntity = new CertificationEntity(userId, email, certificationNumber);
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
            String userId = dto.getId();
            String email = dto.getEmail();
            String certificationNumber = dto.getCertificationNumber();

            Optional<CertificationEntity> certificationEntity = certificationRepository.findById(userId);
            if(certificationEntity.isEmpty()){
                return CheckCertificationResponseDto.certificationFail();
            }else {
                boolean isMatched = certificationEntity.get().getEmail().equals(email) &&
                        certificationEntity.get().getCertificationNumber().equals(certificationNumber);
                log.info("requeset: email : {} , certificationNumber : {}",email,certificationNumber);
                log.info("repository: email : {} , certificationNumber : {}",certificationEntity.get().getEmail(),certificationEntity.get().getCertificationNumber());
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
            String userId = dto.getId();
            boolean isExistId = userRepository.existsById(userId);
            if(isExistId) return SignUpResponseDto.duplicateId();

            String email = dto.getEmail();
            String certificationNumber = dto.getCertificationNumber();
            Optional<CertificationEntity> certificationEntity = certificationRepository.findById(userId);

            if (certificationEntity.isPresent()){
                boolean isMatched = certificationEntity.get().getEmail().equals(email) &&
                        certificationEntity.get().getCertificationNumber().equals(certificationNumber);
                if(!isMatched) return SignUpResponseDto.certificationFail();
            }

            String password = dto.getPassword();
            String encodedPassword = passwordEncoder.encode(password);
            dto.setPassword(encodedPassword);

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

        String token = null;

        try{

            String userId = dto.getId();
            Optional<UserEntity> userEntity = userRepository.findById(userId);
            if (userEntity.isPresent()){
                String password = dto.getPassword();
                String encodedPassword = userEntity.get().getPassword();
                boolean isMatched = passwordEncoder.matches(password,encodedPassword);
                if(!isMatched) return SignInResponseDto.signInFail();

                token = jwtProvider.create(userId);

            }else return SignInResponseDto.signInFail();

        } catch (Exception exception){
            exception.printStackTrace();
            return ResponseDto.databaseError();
        }

        return SignInResponseDto.success(token);
    }
}
