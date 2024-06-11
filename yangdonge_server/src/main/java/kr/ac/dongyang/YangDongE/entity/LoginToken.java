package kr.ac.dongyang.YangDongE.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;
import java.time.temporal.ChronoUnit;

@Getter
@Setter
@Entity
@Table(name = "LOGIN_TOKEN")
public class LoginToken {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "token_id", nullable = false)
    private Long tokenId;

    @NotNull
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id", nullable = false)
    private UserEntity id;

    @Size(max = 255)
    @NotNull
    @Column(name = "refresh_token", nullable = false)
    private String refreshToken;

    @NotNull
    @Column(name = "create_date", nullable = false)
    private Instant createDate;

    @NotNull
    @Column(name = "expiration_date", nullable = false)
    private Instant expirationDate;

    @NotNull
    @ColumnDefault("true")
    @Column(name = "token_state", nullable = false)
    private Boolean tokenState;

    @PrePersist
    protected void onCreate() {
        Instant now = Instant.now();
        this.createDate = now;
        this.expirationDate = now.plus(2, ChronoUnit.WEEKS);
    }

    public LoginToken(UserEntity id, String refreshToken) {
        this.id = id;
        this.refreshToken = refreshToken;
    }
}