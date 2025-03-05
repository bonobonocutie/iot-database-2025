-- 트리거
-- 시작 전 설정 변경. 트리거 사용설정 on
-- 다음버전 MySQL에서는 사라질 예정(Deprecated)
set global log_bin_trust_fuction_creators = on;

-- Book_log 테이블을 생성
create table Book_log(
	bookid_l integer,
    bookname_l varchar(40),
    publisher_l varchar(40),
    price_l integer
);

-- 트리거 생성
-- update나 delete 시는 old. 라고 사용 after update on 테이블명...
-- before insert, update, delete ...

delimiter //
create trigger AfterInsertBook
	after insert on Book for each row -- Book 테이블에 데이터가 새로 추가되면 트리거가 바로 발동!
begin
	declare average integer;
    insert into Book_log
    values(new.bookid, new.bookname, new.publisher, new.price);
end;

-- Book 테이블 insert 실행
insert into Book values (40, '안드로이드는 전기양의 꿈을 꾸는가', '이상미디어', 25000);