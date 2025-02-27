-- 내장함수
-- 4-1 -78과 78의 절대값을 구하시오
select abs(-78), abs(78);

-- 4-2 4.875를 소수점 첫번째 자리까지 반올림 하시오.
select round(4.875, 1) as 결과;

-- 4-3 고객별 평균 주문 금액을 100원 단위로 반올림한 값을 구하시오.
select custid, round(avg(saleprice), -2)
from Orders
group by custid;

-- 문자열 내장함수
-- 4-4 도서 제목에서 야구가 포함된 도서명을 농구로 변경한 후 출력하시오.
select bookid,
		replace(bookname, '야구', '농구') as bookname,
        publisher,
        price
from Book;

-- 추가
select 'Hello' 'MySQL';

select concat('Hello', 'MySQL', 'wOW');

-- 4-5 굿스포츠에서 출판한 도서의 제목과 제목의 문자수, 바이트수를 구하시오.
select bookname as '제목',
		char_length(bookname) as '제목 문자수', -- 글자 길이를 구할때
        length(bookname) as '제목 바이트수' -- utf8에서 한글 한글자의 바이트수는 3bytes
from Book
where publisher = '굿스포츠';

-- 4-6 고객 중 성이 같은 사람이 몇 명이나 되는지 성(姓)별 인원수를 구하시오.
-- substr(자를원본문자열, 시작인덱스, 길이)
-- DB는 인덱스를 1부터 시작!!
select substr('Hello MySQL',7,2);

select substr(name, 1, 1) as '성씨 구분',
		count(*) as '인원 수'
from Customer
group by substr(name, 1, 1);

-- 추가. trim(), Python strip()과 동일
select concat('--', trim('     Hello!     '), '--');
select concat('--', ltrim('     Hello!     '), '--');
select concat('--', rtrim('     Hello!     '), '--');

-- 새롭게 추가된 trim() 함수
select trim('=' from '=== Hello- ===');

-- 날짜시간 함수
select sysdate(); -- Docker 서버시간을 따라서 GMT(그리니치 표준시)를 따름 + 9hour

select adddate(sysdate(), interval 9 hour) as 한국시간;

-- 4-7 마당서점은 주문일로부터 10일 후에 매출을 확정합니다. 각 주문의 확정일자를 구하시오.
select orderid as 주문번호,
		orderdate as 주문일자,
        adddate(orderdate, interval 10 day) as 확정일자
from Orders;

-- 추가, 나라별 날짜,시간을 표현하는 포맷이 다름
select sysdate() as '기본날짜/시간',
		date_format(sysdate(), '%M/%d/%Y %H:%i:%s');

-- 4-8 2014년 7월 7일에 주문받은 도서의 주문번호, 주문일, 고객번호, 도서번호를 모두 나타내시오.
-- 단, 주문일은 %Y-%m-%d 형태로 표시한다.
-- %Y = 년도전체, %y = 년도 뒤 2자리, %M = July(월이름), %b = Jul(월약어) %m = 07(월숫자)
-- %d = 일, %H = 16, %h = 04(오후도), %W = Monday, %w = 1(요일은 일요일 0)
-- %p = am/pm
select orderid as '주문번호',
		date_format(orderdate, '%Y/%b/%d') as '주문일',
        custid as '고객번호',
        bookid as '도서번호'
from Orders;

-- datediff: D-day
select datediff(sysdate(), '2025-02-03');

-- formatting, 1000 단위마다 , 넣기
select bookid,
		format(price, 0) as price
from MyBook;

-- null = Python None 동일. 다른 프로그래밍 언어에서는 전부 Null, nul
-- 추가. 금액이 null일때 발생되는 현상
select price - 5000
from MyBook
where bookId = 3;

-- 핵심. 집계함수가 다 꼬임
select sum(price) as '합산은 그닥 문제없음',
		avg(price) as '평균은 null이 빠져서 꼬임',
        count(*) as '모든 행의 개수는 일치',
        count(price) as 'null 값은 개수에서 빠짐'
from MyBook;
        
-- null 값 확인
select *
from MyBook
where price is null; -- 반대는 is not null

select *
from MyBook
where bookname = " ";

-- ifnull 함수
select bookid,
		bookname,
        ifnull(price, 0) as price
from MyBook;