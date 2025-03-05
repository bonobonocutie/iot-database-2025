start transaction;

select * from Book;

update Book set price = 40000 where bookid = 98;

commit;