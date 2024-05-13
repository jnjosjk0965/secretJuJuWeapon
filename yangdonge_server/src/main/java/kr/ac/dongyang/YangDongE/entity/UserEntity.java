package kr.ac.dongyang.YangDongE.entity;

import jakarta.persistence.*;
import kr.ac.dongyang.YangDongE.common.Role;
import kr.ac.dongyang.YangDongE.dto.request.auth.SignInRequestDto;
import kr.ac.dongyang.YangDongE.dto.request.auth.SignUpRequestDto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity(name="user")
public class UserEntity {
    // 검색용 아이디
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    // 가입 관리용 아이디 형식 : ( 가입 서비스_서비스에서 제공한 식별자)
    @Column(name = "user_id", unique = true, nullable = false) // 이름이 같다면 굳이 필요 x
    private String userId;
    @Column
    private String name;
    @Column(name = "school_email", unique = true)
    private String schoolEmail;
    @Column
    private String email;
    @Column(name = "profile_Image")
    private String profileImage;
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    // Oauth2 처리 이후 이름 등 사용자 정보 받아야함
    public UserEntity (String userId, String name, String email, String profileImage){
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.profileImage = profileImage;
        this.role = Role.USER;
    }

    public UserEntity (SignInRequestDto dto){
//        this.userId = dto.getUserId();
//        this.email = dto.getEmail();
    }

    // 추가정보 입력시
    public UserEntity (SignUpRequestDto dto){
        this.userId = dto.getUserId();
        this.schoolEmail = dto.getSchoolEmail();
    }
}
