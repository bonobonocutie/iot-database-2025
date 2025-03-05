-- 사용자 정의함수. 내장함수 반대. 개발자가 직접만드는 함수
-- 저장프로시저와 유사. returns, return 키워드가 차이남
-- 1행 1열, 스칼라값 리턴
SET GLOBAL log_bin_trust_function_creators = 1;
select char_length('HELLO WORLD')

delimiter //
create function func_Interest(
	price integer
) returns integer
begin
	declare myInterest integer;
    -- 가격이 3만원 이상이면 10%, 아니면 5%
    if price >= 30000 then set myInterest = price * 0.1;
    else set myInterest = price * 0.05;
    end if;
    return myInterest;
end;

-- 실행
select custid, orderid, saleprice, func_Interest(saleprice) as 이익금
from Orders;