package kr.ac.dongyang.YangDongE.repository;

import kr.ac.dongyang.YangDongE.entity.CertificationEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CertificationRepository extends JpaRepository<CertificationEntity, String> {
}
