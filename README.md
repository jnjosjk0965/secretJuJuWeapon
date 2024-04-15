# 파일 구조

## yangdonge_client
Flutter를 사용한 client

## yangdonge_server
Spring Boot 를 사용한 Server

# Git 사용 규칙
- 각자의 브랜치를 만들어 작업

# 커밋 메시지
가능하면 아래 사항을 지켜서 작성해 주시면 좋겠습니다.
## 커밋 메시지의 7가지 규칙
      1. 제목과 본문을 빈 행으로 구분한다
      2. 제목을 50글자 내로 제한
      3. 제목 첫 글자는 대문자로 작성
      4. 제목 끝에 마침표 넣지 않기
      5. 제목은 명령문으로 사용하며 과거형을 사용하지 않는다
      6. 본문의 각 행은 72글자 내로 제한
      7. 어떻게 보다는 무엇과 왜를 설명한다
## 커밋 메시지 구조
기본적으로 commit message 는 제목, 본문, 꼬리말로 구성합니다.
제목은 필수사항이며, 본문과 꼬리말은 선택사항입니다.

```
<type>: <subject>

<body> // 선택사항

<footer> // 선택사항
```

## Type
- feat : 새로운 기능 추가, 기존의 기능을 요구 사항에 맞추어 수정
- fix : 기능에 대한 버그 수정
- build : 빌드 관련 수정
- chore : 패키지 매니저 수정, 그 외 기타 수정 ex) .gitignore
- ci : CI 관련 설정 수정
- docs : 문서(주석) 수정
- style : 코드 스타일, 포맷팅에 대한 수정
- refactor : 기능의 변화가 아닌 코드 리팩터링 ex) 변수 이름 변경
- test : 테스트 코드 추가/수정
- release : 버전 릴리즈

## Subject
Type 과 함께 헤더를 구성합니다. 예를들어, 로그인 API 를 추가했다면 다음과 같이 구성할 수 있습니다.

ex) feat: Add login api

![image](https://github.com/jnjosjk0965/secretJuJuWeapon/assets/107172985/e8c4732f-75bb-42a7-a002-d4bc43fd95bc)
