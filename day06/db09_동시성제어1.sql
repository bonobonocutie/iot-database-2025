-- 동시성 제어
-- 자동 커밋 해제
set autocommit = 0;
start transaction;

select * from Book;

insert into Book values(98, '데이터베이스', '한빛', 25000); -- 트랜잭션이 걸린 상태

update Book set price = 30000 where bookid = 98;

commit;