
insert into konum
values (11, 'İstanbul-Pendik', 34);

--------------------------------------------

insert into ceza_bilgi
values(5021, 'Yüz Kızartıcı Suç', NULL, NULL);

--------------------------------------------

insert into ceza_bilgi
values(6761, 'Uzaklaştırma', sysdate, to_date('31.12.2011', 'DD.MM.YYYY'));




select * from ceza_bilgi;

commit;