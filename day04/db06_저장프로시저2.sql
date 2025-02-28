-- 5-2 동일도서를 파악 후 있으면 도서가격 변경, 없으면 삽입하는 프로시저
delimiter //
create procedure BookInsertOrUpdate(
	mybookid integer,
    mybookname varchar(40),
    mypublisher varchar(40),
    myprice integer
)
begin
	/* 변수 선언 */
    declare mycount integer;
    -- 1. 데이터가 존재하는 수를 mycount 변수에 할당
    -- 데이터가 존재하는지 파악
    select count(*)
    from Book
    where bookname like concat('%', mybookname, '%');
    
    -- 2. mycount 0보다 크면 동일 도서 존재
    if mycount > 0 then
		set sql_safe_updates = 0; /* delete, update 시  safe모드 해제 */
        update Book set price = myprice
        where bookname like concat('%', mybookname, '%');
    else
		insert into Book 
        values(mybookid, mybookname, mypublisher, myprice);
    end if;
end;

-- 1번째 실행
call BookInsertOrUpdate(33,'스포츠의 즐거움', '마당과학', 25000);

select * from Book;
call BookInsertOrUpdate(33,'스포츠의 즐거움', '마당과학', 35000);