-- 08 트랜잭션
-- 테이블 생성
create table Bank (
	name varchar(40) primary key,
    balance integer
);

-- 데이터 추가
insert into Bank values ('박지성', 1000000), ('김연아', 1000000);

-- 트랜잭션은 업무 논리적 단위(All or Nothing)
-- start transaction; 으로 트랜잭션 시작
-- 성공시 commit; 실패시 rollback;
start transaction;
-- 박지성 계좌를 읽어온다
select * from Bank where name = '박지성';
-- 김연아 계좌를 읽어온다
select * from Bank where name = '김연아';

-- 박지성 계좌에서 10000원 인출
update Bank
set balance = balance - 10000
where name = '박지성';

-- 김연아 계좌 10000원 입금
update Bank
set balance = balance + 10000
where name = '김연아';

-- 트랜잭션 종료
commit;
rollback;