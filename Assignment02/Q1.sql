use mydb;
create table test_table(
RecordNumber Int(3) AUTO_INCREMENT PRIMARY KEY,
CurrentDate Date
);
show tables;
select * from test_table;

delimiter //
create procedure insert_record()
begin
    declare i int default 1;
    while i <= 50 Do
       insert into test_table(RecordNumber, CurrentDate)
       values( i, curdate());
       set i = i+1;
	end while;
end;
//

delimiter ;

call insert_record();

