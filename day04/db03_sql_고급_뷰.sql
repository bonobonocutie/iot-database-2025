-- 뷰
-- ddl create로 뷰를 생성
-- 생성과 수정을 동시에 하는게 좋다!
create or replace view v_orders
as
select o.orderid, c.custid, c.name, b.bookid,
		b.bookname, b.price, o.saleprice, o.orderdate
from Customer as c, Book as b, Orders as o
where c.custid = o.custid and
		b.bookid = o.bookid;

-- 뷰 실행 - 위의 조인쿼리 실행
-- sql 테이블로 할 수 있는 쿼리는 다 실행가능
select * from v_orders where name = '장미란';

-- 4-20 주소에 '대한민국'을 포함하는 고객들로 구성된 뷰를 만들고 조회하시오
-- 뷰의 이름은 vw_Customer 설정
create or replace view vw_Customer
as
select *
from Customer
where address like '%대한민국%';

select * from vw_Customer;

-- 추가. view로 insert할 수 있음!! update, delete도 가능
-- 단, 뷰의 테이블이 하나여야함. 관계에서 자식테이블의 뷰는 insert 불가
insert into vw_Customer
values (7, '손흥민', '영국 런던', '010-9999-0099');

-- 4-23 vw_Custoemr를 삭제하라
drop view vw_Customer