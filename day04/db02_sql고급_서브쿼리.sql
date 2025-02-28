-- 서브쿼리 고급
-- 4-12 Orders 테이블 평균 주문금액 이하의 주문에 대해 주문번호와 금액을 나타내시오
-- 집계함수는 group by가 없어도 테이블 전체를 집계할 수 있음
select *
from Orders
where saleprice <= (select avg(saleprice) from Orders);

-- 4-14 대한민국에 거주하는 고객에게 판매한 도서의 총판매액을 구하시오.
select sum(saleprice) as 총판매액
from Orders
where custid in (select custid
				from Customer
				where address like '%대한민국%');

-- 4-15 3번 고객이 주문한 도서의 최고 금액보다 더 비싼 도서를 구입한 주문의 
-- 주문번호와 판매금액을 보이시오
-- 비교연산자만 쓰면 서브쿼리의 값이 단일값이 되어야 함(제약사항!)
select orderid, saleprice
from Orders
where saleprice > (select max(saleprice)
					from Orders
					where custid = 3);
                    
-- all|some|any를 쓰면 서브쿼리의 값이 단일값이 아니어도 상관없음
-- all - 서브쿼리 내 결과의 모든 값보다 비교연산이 일치하는 값을 찾는 것
-- some|any - 서브쿼리 내 결과의 각각의 값과 비교연산이 일치하는 값을 찾는 것
select *
from Orders
where saleprice > some(select saleprice
					from Orders
					where custid = 3);
                    
-- 4-19 exists 연산자를 사용하여 대한민국에 거주하는 고객에게 판매한 도서의 총판매액을 구하시오.
-- exists는 유일하게 서브쿼리에 *을 쓸 수 있는 방법
select sum(saleprice) as 총판매액
from Orders as o
where exists(select *
			from Customer
			where address like '%대한민국%' and
            custid = o.custid);

-- 추가. 최신방법(서브쿼리에서 두가지 컬럼을 비교하는 법) - 튜플(파이썬과 동일)
-- 2010년 중반이후부터 사용 예상
select *
from Orders
where (custid, orderid) in(select custid,orderid
							from Orders
                            where custid = 2);
                            
-- select 서브쿼리. 스칼라값(단일행, 단일열) 한컬럼에 데이터 1개
-- 4-17 고객별 판매액을 나타내시오(고객이름과 고객별 판매액 출력)
select o.custid, 
		(select name from Customer where custid = o.custid) as 고객명,
		sum(o.saleprice) as 판매액
from Orders as o
group by o.custid;

-- from 절 서브쿼리, 인라인뷰
-- 4-19 고객번호가 2이하인 고객의 판매액을 나타내시오(고객이름, 고객별 판매액 출력)
-- 1. 이 테이블이 하나의 가상 테이블이 됨
select custid, name
from Customer
where custid <= 2;

-- 2. 위 가상테이블을 cs라고 이름짓고 from절에 넣어줌
select cs.*
from (select custid, name
		from Customer
		where custid <= 2) as cs;
        
-- 3. 가상테이블 cs와 Orders 테이블 조인
select cs.name, sum(o.saleprice) as 구매액
from (select custid, name
		from Customer
		where custid <= 2) as cs, Orders as o
where cs.custid = o.custid
group by cs.name;