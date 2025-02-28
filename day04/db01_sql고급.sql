-- 행번호
-- 4-11 고객목로겡서 고객번호, 이름, 전번을 앞의 2명만 출력하시오
set @seq := 0; -- 변수선언 set 시작하고 @를 붙임. 값할당이 = 아니고 :=

select @seq := @seq + 1 as '행번호',
		custid,
		name,
        phone
from Customer
where @seq < 2;

select custid,
		name,
        phone
from Customer limit 2; -- 순차적인 일부데이터 추출에는 훨씬 탁월

-- 특정범위 추출, 3번째 행부터 2개를 추출
select custid,
		name,
        phone
from Customer limit 2 offset 3;