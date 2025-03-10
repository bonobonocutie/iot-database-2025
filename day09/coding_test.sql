-- 1.
select email, mobile, names, addr
from membertbl;

-- 2.
select names as 도서명, author as 저자, isbn, price as 정가
from bookstbl
order  by isbn;

-- 3.
select names as 비대여자명, levels as 등급, addr as 주소, null as 대여일
from membertbl
where idx not in(select memberIdx from rentaltbl)
order by levels, names;

-- 4. 
select d.names as 장르, concat(format(sum(price), 0), '원') as 총합계금액
from divtbl as d join bookstbl as b on d.division = b.division
group by b.division
order by 장르;