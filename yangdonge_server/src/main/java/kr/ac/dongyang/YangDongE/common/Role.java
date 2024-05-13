package kr.ac.dongyang.YangDongE.common;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum Role {

    ADMIN("ROLE_ADMIN", "관리자"),
    USER("ROLE_USER","일반 사용자");

    private final String name;
    private final String desc;
}
