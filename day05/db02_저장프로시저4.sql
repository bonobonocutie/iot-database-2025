-- 5-4 Order 테이블의 판매도서에 대한 이익금을 계산하는 프로시저
delimiter //
create procedure GetInterest(

)
begin
	-- 변수 선언
    declare myInterest float default 0.0;
    declare price integer;
    declare endOfRow boolean default false;
    declare InterestCursor cursor for
		select salePrice from Orders;
	declare continue handler 
		for not found set endOfRow = true;
        
	-- 커서 오픈
    open InterestCursor;
    cursor_loop: loop
        -- select saleprice from Orders 테이블 한 행씩 읽어서 값을 price에 집어넣는다.
        fetch InterestCursor into price; 
		if endOfRow then leave cursor_loop; -- python break;
        end if;
        if price >= 30000 then -- 판매가가 3만원 이상이면 10% 이윤을 챙이고, 그 이하면 5% 이윤을 챙기자.
			set myInterest = myInterest + price * 0.1;
		else
			set myInterest = myInterest + price * 0.05;
        end if;
    end loop cursor_loop;
    close InterestCursor; -- 커서 종료
    
    -- 결과 출력
    select concat('전체 이익 금액 = ', myInterest) as Interrest;
end;

-- 저장프로시저 실행
call GetInterest();