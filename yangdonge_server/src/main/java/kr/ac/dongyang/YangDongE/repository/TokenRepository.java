package kr.ac.dongyang.YangDongE.repository;

import kr.ac.dongyang.YangDongE.entity.LoginToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TokenRepository extends JpaRepository<LoginToken, Long> {
}
