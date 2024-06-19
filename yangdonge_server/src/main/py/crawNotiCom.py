# 2024년 3학년 1학기
# 졸업작품 <시스템분석설계>
# 1. 웹 크롤링을 통해 최근 학과, 학교 공지 한 5개정도랑 학식 등을 출력
# 2. 해당 출력물을 JSON 파일로 만들기

# 웹크롤링 파이썬 코드 - 학과공지

# 주석이 없는 부분은 'clawLunch.py', 'clawNotiAll.py' 파일 참고

import requests
from lxml import html
import json

# 컴소과 학과공지 페이지의 URL
url = 'https://www.dongyang.ac.kr/dmu_23222/1797/subview.do'

response = requests.get(url)
tree = html.fromstring(response.text)

# 메인 페이지의 공지 개수 확인(상단 노출 공지 + 최근 공지 10개)
num=1
while num:
    if tree.xpath(f'/html/body/div[3]/div/div[4]/div/article/div/div[2]/div/table/tbody/tr[{num}]'):
        num+=1
    else:
        break
# print(num-1)

# 최근 공지의 첫번째 인덱스값 구하기
num-=10


# 최근 공지 정보 추출(※ 학교공지와 다르게 XPath의 text() 때문에 한줄로 줄이는 의미가 없음 - 반복문이 짧아지지 않음)
noti = {}
for i in range(5):
    noti[i+1] = [tree.xpath(f'/html/body/div[3]/div/div[4]/div/article/div/div[2]/div/table/tbody/tr[{i+num}]/td[4]/text()')[0].strip(), tree.xpath(f'/html/body/div[3]/div/div[4]/div/article/div/div[2]/div/table/tbody/tr[{i+num}]/td[2]/a/text()')[0].strip()]

print(noti)

with open("craw.json", "w") as json_file:
    json.dump(noti, json_file)



# XPath 참고
'''
상위 2개(이하규칙 같음)
제목
날짜

/html/body/div[3]/div/div[4]/div/article/div/div[2]/div/table/tbody/tr[1]/td[2]/a/text()
/html/body/div[3]/div/div[4]/div/article/div/div[2]/div/table/tbody/tr[1]/td[4]

/html/body/div[3]/div/div[4]/div/article/div/div[2]/div/table/tbody/tr[2]/td[2]/a/text()
/html/body/div[3]/div/div[4]/div/article/div/div[2]/div/table/tbody/tr[2]/td[4]
'''