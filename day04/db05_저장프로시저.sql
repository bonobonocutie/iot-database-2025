-- 저장프로시저1
-- Book 테이블에 하나의 row를 추가하는 프로시저
delimiter //
create procedure InsertBook(
	in myBookId integer,
    in myBookName varchar(40),
    in myPublisher varchar(40),
    in myPrice integer
)
begin
	insert into Book(bookid, bookname, publisher, price)
    values(myBookId, myBookName, myPublisher, myPrice);
end;
//

-- 프로시저 호출
call InsertBook(31, 'BTS PhotoAlbum', '하이브', 300000);

select * from Book;

-- 프로시저 삭제
drop procedure InsertBook;