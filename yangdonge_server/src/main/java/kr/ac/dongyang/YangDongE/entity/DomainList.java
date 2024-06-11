package kr.ac.dongyang.YangDongE.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "DOMAIN_LIST")
public class DomainList {
    @Id
    @Column(name = "college_code", nullable = false)
    private Integer collegeCode;

    @Size(max = 255)
    @NotNull
    @Column(name = "college_name", nullable = false)
    private String collegeName;

    @Size(max = 20)
    @NotNull
    @Column(name = "domain", nullable = false, length = 20)
    private String domain;

}