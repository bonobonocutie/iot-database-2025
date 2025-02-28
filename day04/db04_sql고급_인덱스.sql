-- 인덱스
-- ddl로 인덱스 생성
-- 4-24 Book 테이블의 bookname에 인덱스 ix_Book을 생성하시오
create index ix_Book on Book(bookname);

-- 4-25 Book테이블에 publisher, price를 인덱스 ix_Book2 생성하시오
create index ix_Book2 on Book(publisher, price);

-- 추가
show index from Book;

-- 인덱스가 제대로 동작하는지 확인
-- 실행계획(Explain Current Statement)
select *
from Book
where publisher = '대한미디어' and
		price >= 30000;
        
-- 4-26 Book 테이블에 인덱스를 최적화하시오
analyze table Book;

-- 4-27 쓸모없는 인덱스는 삭제하시오
drop index ix_Book2 on Book;