package kr.ac.dongyang.YangDongE.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "certification")
public class CertificationEntity {
    @Id
    private String userId;
    private String schoolEmail;
    private String certificationNumber;
    private LocalDateTime sentTime;
}
