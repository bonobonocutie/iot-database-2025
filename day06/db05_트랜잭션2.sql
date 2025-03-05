-- 트랜잭션
start transaction;
insert into Book values (99, '데이터베이스', '한빛', 25000);

select bookname as bookname1
from Book
where bookid = 99;

-- 저장포인트
savepoint a;

update Book set bookname = '데이터베이스 개론' where bookid = 99;

select bookname as bookname2 from Book where bookid = 99;

savepoint b;

update Book set bookname = '데이터베이스 개론 및 실습' where bookid = 99;

select bookname as bookname3 from Book where bookid = 99;

rollback to b;