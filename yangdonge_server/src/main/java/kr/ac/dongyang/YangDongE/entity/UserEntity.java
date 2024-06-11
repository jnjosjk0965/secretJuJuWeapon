package kr.ac.dongyang.YangDongE.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import kr.ac.dongyang.YangDongE.common.Role;
import kr.ac.dongyang.YangDongE.dto.request.auth.SignUpRequestDto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "PRIVACY")
public class UserEntity {
    // 검색용 아이디
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // 가입 관리용 아이디 형식 : ( 가입 서비스_서비스에서 제공한 식별자)
    @Column(name = "user_id", unique = true, nullable = false) // 이름이 같다면 굳이 필요 x
    private String userId;

    // 학교 이메일
    @Column(name = "email", unique = true)
    private String email;

    // 연락용 sns email
    @Column(name = "sns_email", nullable = false)
    private String snsEmail;

    // 학교 코드
    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "college_code")
    private DomainList collegeCode;

    // 사용자 이름
    @Column(nullable = false)
    private String name;

    // 프로필 이미지 url
    @Size(max = 255)
    @Column(name = "profilea_url")
    private String profileUrl;

    // 사용자 권한
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    @NotNull
    @Column(name = "grade")
    private Byte grade;

    @NotNull
    @ColumnDefault("0")
    @Column(name = "user_point", nullable = false)
    private Integer userPoint;

    @NotNull
    @Column(name = "signup_date", nullable = false)
    private Instant signupDate;

    @NotNull
    @Column(name = "last_date", nullable = false)
    private Instant lastDate;

    @NotNull
    @Column(name = "last_ip")
    private Integer lastIp;

    @NotNull
    @ColumnDefault("true")
    @Column(name = "account_status", nullable = false)
    private Boolean accountStatus;

    @PrePersist
    protected void onCreate() {
        Instant now = Instant.now();
        this.signupDate = now;
        this.lastDate = now;
    }

    @PreUpdate
    protected void onUpdate() {
        this.lastDate = Instant.now();
    }

    // Oauth2 처리 이후 이름 등 사용자 정보 받아야함
    public UserEntity (String userId, String name, String snsEmail, String profileUrl){
        this.userId = userId;
        this.name = name;
        this.snsEmail = snsEmail;
        this.profileUrl = profileUrl;
        this.role = Role.USER;
    }

    // 추가정보 입력시
    public UserEntity (SignUpRequestDto dto){
        this.userId = dto.getUserId();
        this.email = dto.getEmail();
    }
}
