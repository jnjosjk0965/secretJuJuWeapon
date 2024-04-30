# 2024년 3학년 1학기
# 졸업작품 <시스템분석설계>
# 1. 웹 크롤링을 통해 최근 학과, 학교 공지 한 5개정도랑 학식 등을 출력
# 2. 해당 출력물을 JSON 파일로 만들기

# 웹크롤링 파이썬 코드 - 학식

# 참고링크 1(웹크롤링) https://hleecaster.com/python-web-crawling-with-beautifulsoup/
# 참고링크 2(pip 업데이트/업그레이드) https://webisfree.com/2017-08-10/python-%ED%8C%A8%ED%82%A4%EC%A7%80-pip-%EC%97%85%EA%B7%B8%EB%A0%88%EC%9D%B4%EB%93%9C-upgrade-%EB%B0%A9%EB%B2%95
# 참고링크 3(파이썬으로 JSON파일 다루기 및 실행파일 만들기) https://wondangcom.tistory.com/2569
# 참고링크 4(공휴일 판단) https://developertools.tistory.com/entry/PYHTON-%ED%8C%8C%EC%9D%B4%EC%8D%AC-%EA%B3%B5%ED%9C%B4%EC%9D%BC-%ED%99%95%EC%9D%B8-%EB%B0%8F-%EC%98%A4%EB%8A%98%EC%9D%B4-%ED%8F%89%EC%9D%BC%EC%9D%B8%EC%A7%80-%EC%97%AC%EB%B6%80-%ED%99%95%EC%9D%B8-pytimekr-datetime
# 참고링크 5(JSON 파일 사용법) https://codingazua.tistory.com/4
# 참고링크 6(Open API 파싱하기 - JSON) https://velog.io/@garam0410/Java-OPEN-API-%ED%8C%8C%EC%8B%B1%ED%95%98%EA%B8%B0-JSON

# 아래 라이브러리가 동작하지 않을 경우
# pip install (라이브러리명)
# pip install --upgrade (라이브러리명)
# 으로 설치 및 업그레이드 후 사용

# HTTP 요청을 보내고 웹페이지의 내용을 가져오는 데 사용
import requests
# HTML 문서를 처리하는 데 사용
from lxml import html
# 날짜와 시간을 다루는 데 사용
from datetime import datetime, timedelta
# 한국의 공휴일을 판단하는 데 사용
from pytimekr import pytimekr
# JSON 모듈
import json

# 학식 웹 페이지의 URL
url = 'https://www.dongyang.ac.kr/dongyang/130/subview.do'

# 지정된 URL에서 HTTP GET 요청을 보내고, 해당 URL에서 가져온 내용을 반환
response = requests.get(url)
# HTTP 응답으로부터 가져온 HTML 문자열을 파싱하여 ElementTree 객체를 생성
tree = html.fromstring(response.text)

# 이번주 날짜 가져오기
# 오늘 날짜 판단
today = datetime.today()
dateformat = "%Y.%m.%d"
#이번주의 월~금 날짜 판단
dayList = []
for i in range(5):
    day = (today - timedelta(days=today.weekday() - i)).strftime(dateformat)
    dayList.append(day)

# 공휴일 판단
# 휴일 목록 받아오기
holyList = pytimekr.holidays()
# 오늘이 휴일인지 판단
# 휴일이면 True, 평일이면 False
holyday = today.strftime(dateformat) in holyList

# 휴일 판단 동작 여부 확인하기
# holyday = datetime.strptime("2024-05-05", "%Y-%m-%d").date() in holyList
# print(holyday)

# 일주일 식단 출력
lunch = {}
for i in range(5):
    # 해당 일자에 식단이 업로드 되었는지 판단
    if dayList[i] in holyList:
        lunch[str(dayList[i])] = "공휴일에는 학식당을 운영하지 않습니다."
        # 공휴일이면 다음 루프로 넘어가기
        continue
    # XPath를 사용하여 원하는 요소를 가져옴
    element = tree.xpath(f'/html/body/div[4]/div/div[4]/div/article/div/div[2]/form/div/table/tbody/tr[{i*2+1}]/td[3]')
    if not element: # 업로드 된 식단이 없을 경우
        lunch[str(dayList[i])] = "업로드 된 식단이 없습니다."
    else:
        # 요소의 텍스트를 출력
        # 예시: "백미밥, 간장파닭, 순대볶음, 콩나물무침 , 깍두기 / 요구르트, 햄듬뿍부대찌개"
        # 의 문자열로 가져옴
        # 슬래시(/)를 기준으로 자름
        # 한줄for문으로 문자 앞뒤의 공백( )을 지움
        # → '깍두기 /' 처럼 슬래시 오타가 난 부분의 해결 가능
        # meal = [[item.strip() for item in menu.split(',')] for menu in (element[0].text_content()).split('/')]
        meal = [item.strip() for item in (element[0].text_content()).split('/')]

        lunch[str(dayList[i])] = meal

# 3중리스트 - 전체[날짜별[해당날짜(0), 메뉴(i !=0)]
print(lunch)

# 오늘의 식단 출력
# 주말이거나 공휴일일 경우
if today.weekday() in (5, 6) or holyday:
    lunchToday = "오늘은 학식당을 운영하지 않습니다."
else:
    lunchToday = lunch[today.strftime(dateformat)]

print(lunchToday)

# JSON 파일에 딕셔너리를 쓰기
with open("craw.json", "w") as json_file:
    json.dump(lunch, json_file)

# XPATH 참고(월~금)
'''
위 식단 업로드 시
아래 식단 미업로드 시(휴일의 경우 포함)

/html/body/div[4]/div/div[4]/div/article/div/div[2]/form/div/table/tbody/tr[1]/td[3]
/html/body/div[4]/div/div[4]/div/article/div/div[2]/form/div/table/tbody/tr[1]/td[2]

/html/body/div[4]/div/div[4]/div/article/div/div[2]/form/div/table/tbody/tr[3]/td[3]
/html/body/div[4]/div/div[4]/div/article/div/div[2]/form/div/table/tbody/tr[3]/td[2]

/html/body/div[4]/div/div[4]/div/article/div/div[2]/form/div/table/tbody/tr[5]/td[3]
/html/body/div[4]/div/div[4]/div/article/div/div[2]/form/div/table/tbody/tr[5]/td[2]

/html/body/div[4]/div/div[4]/div/article/div/div[2]/form/div/table/tbody/tr[7]/td[3]
/html/body/div[4]/div/div[4]/div/article/div/div[2]/form/div/table/tbody/tr[7]/td[2]

/html/body/div[4]/div/div[4]/div/article/div/div[2]/form/div/table/tbody/tr[9]/td[3]
/html/body/div[4]/div/div[4]/div/article/div/div[2]/form/div/table/tbody/tr[9]/td[2]
'''

