--------------------------------------------
--UPDATE - Verileri Güncelleme
--------------------------------------------

update personel 
set maas = 2800 
where personel_id = 5012

--------------------------------------------

update personel 
set giris_tarihi = to_date('01.01.2012', 'DD.MM.YYYY') 
where yonetici_id = 919

--------------------------------------------

update personel set 
maas  = (select maas  from personel where personel_id = 5004),
unvan = (select unvan from personel where personel_id = 5004)
where personel_id = 5005

--------------------------------------------

update personel set 
(maas, unvan)
=
(select maas, unvan from personel where personel_id = 5004)
where personel_id = 5005


--------------------------------------------
--DELETE - Verileri Silme
--------------------------------------------

delete from mudurluk where mudurluk_kodu = 62

--------------------------------------------

delete from mudurluk_sube 
where mudurluk_kodu in 
(
  select mudurluk_kodu from mudurluk 
  where il_adi = ‘HATAY’
)
