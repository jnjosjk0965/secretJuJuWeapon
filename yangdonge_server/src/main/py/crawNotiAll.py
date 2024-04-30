# 2024년 3학년 1학기
# 졸업작품 <시스템분석설계>
# 1. 웹 크롤링을 통해 최근 학과, 학교 공지 한 5개정도랑 학식 등을 출력
# 2. 해당 출력물을 JSON 파일로 만들기

# 웹크롤링 파이썬 코드 - 대학공지

# 주석이 없는 부분은 'clawLunch.py' 파일 참고

import requests
from lxml import html
import json

# 대학공지 페이지의 URL
url = 'https://www.dongyang.ac.kr/dongyang/129/subview.do'

response = requests.get(url)
tree = html.fromstring(response.text)

# 메인 페이지의 공지 개수 확인(상단 노출 공지 + 최근 공지 10개)
num=1
while num:
    if tree.xpath(f'/html/body/div[4]/div/div[4]/div/article/div/div[2]/form[2]/div/table/tbody/tr[{num}]'):
        num+=1
    else:
        break
# 시작값이 1이므로 1페이지의 총 공지 개수는 num-1개
# print(num-1)

# 최근 공지의 첫번째 인덱스값 구하기
num-=10

noti = {}
for i in range(5):
    noti[i+1] = [tree.xpath(f'/html/body/div[4]/div/div[4]/div/article/div/div[2]/form[2]/div/table/tbody/tr[{i+1}]/td[4]')[0].text_content(), tree.xpath(f'/html/body/div[4]/div/div[4]/div/article/div/div[2]/form[2]/div/table/tbody/tr[{i+1}]/td[2]/a/strong')[0].text_content()]

print(noti)

with open("craw.json", "w") as json_file:
    json.dump(noti, json_file)


# XPath 참고
'''
상위 2개(이하규칙 같음)
제목
날짜

/html/body/div[4]/div/div[4]/div/article/div/div[2]/form[2]/div/table/tbody/tr[1]/td[2]/a/strong
/html/body/div[4]/div/div[4]/div/article/div/div[2]/form[2]/div/table/tbody/tr[1]/td[4]

/html/body/div[4]/div/div[4]/div/article/div/div[2]/form[2]/div/table/tbody/tr[2]/td[2]/a/strong
/html/body/div[4]/div/div[4]/div/article/div/div[2]/form[2]/div/table/tbody/tr[2]/td[4]
'''