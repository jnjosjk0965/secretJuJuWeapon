package kr.ac.dongyang.YangDongE.repository;

import kr.ac.dongyang.YangDongE.entity.UserEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, String> {
}
