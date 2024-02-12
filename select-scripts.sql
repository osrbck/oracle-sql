--------------------------------------------
--AVG ve SUM
--------------------------------------------

select round(avg(maas),2) maas_ortalaması, 
       sum(maas) toplam_maas 
from personel;

select 
    sum(freight), sum(distinct freight),
    avg(freight), avg(distinct freight)
from orders


--------------------------------------------
--MIN ve MAX
--------------------------------------------

select min(maas) en_dusuk_maas, 
       max(maas) en_yuksek_maas,
       min(giris_tarihi) ilk_ise_baslama,     
       max(giris_tarihi) son_ise_baslama 
from personel 
where unvan = 'MÜHENDİS'

--------------------------------------------
--COUNT
--------------------------------------------

select count(*) kayit_sayisi, 
       count(prim) prim_alani_null_olmayan
from personel 
where unvan = 'UZMAN'

--------------------------------------------
--DISTINCT
--------------------------------------------

select distinct unvan 
from personel 
order by unvan;

select count(*) tum_kayit_sayisi, 
       count(semt) semt_null_olmayan, 
       count(distinct semt) kac_farkli_semt
from personel;


--------------------------------------------
--GROUP BY 
--------------------------------------------

select unvan, 
       count(*) personel_sayisi,
       round(avg(maas),2) maas_ortalamasi, 
       sum(maas) toplam_maas
from personel
group by unvan
order by unvan;


select unvan, semt, 
       count(*) personel_sayisi
from personel
group by unvan, semt
order by unvan, semt;

--------------------------------------------
--HAVING
--------------------------------------------

select unvan , 
	 round(avg(maas),2) maas_ortalamasi 
from personel
group by unvan
having avg(maas) > 3000
order by unvan;

--------------------------------------------
--Inner Join (Eşiti Olan Birleştirme)
--------------------------------------------

select pr.ad, pr.soyad, pr.konum_id, kn.konum_adi 
from personel pr, konum kn
where pr.konum_id = kn.konum_id;

--------------------------------------------

select pr.ad, pr.soyad, pr.konum_id, kn.konum_adi 
from personel pr inner join konum kn 
     on pr.konum_id = kn.konum_id;

--------------------------------------------

select md.mudurluk_kodu, md.mudurluk_adı, sb.sube_adı
from mudurluk md, mudurluk_sube sb
where md.mudurluk_kodu = sb.mudurluk_kodu;

--------------------------------------------

select md.mudurluk_kodu, md.mudurluk_adı, sb.sube_adı
from mudurluk md
inner join mudurluk_sube sb 
  on md.mudurluk_kodu = sb.mudurluk_kodu;

--------------------------------------------
--Outer Join (Dış Birleştirme)
--------------------------------------------

select ad, soyad, konum_adi, kn.konum_id
from personel pr, konum kn
where pr.konum_id = kn.konum_id(+)
order by konum_adi nulls first;

--------------------------------------------

select ad, soyad, konum_adi, kn.konum_id
from personel pr left outer join konum kn 
     on pr.konum_id = kn.konum_id
order by konum_adi nulls first;


--------------------------------------------
--Eşiti Olmayan Birleştirme
--------------------------------------------

select pr.ad, pr.soyad, pr.maas, uc.derece, uc.aciklama 
from personel pr, ucret_duzey uc
where pr.maas between uc.maas_alt_limit and uc.maas_ust_limit
order by 1,2

--------------------------------------------
--Self Join - (Kendine (İç) Birleştirme)
--------------------------------------------

select pr.ad, pr.soyad, 
	 pry.ad || ' ' ||pry.soyad yönetici 
from personel pr, yonetici yn, personel pry
where pr.yonetici_id = yn.yonetici_id
      and pry.personel_id = yn.personel_id
order by 3;

--------------------------------------------
--Tek Satır Alt Sorgular
--------------------------------------------

select ad, soyad, maas, unvan 
from personel
where unvan = 
		(select unvan from personel where personel_id = 5025)

--------------------------------------------

select ad, soyad, maas, unvan 
from personel
where maas > 
		(select maas from personel where personel_id = 5007)

--------------------------------------------

select ad, soyad, maas, unvan 
from personel
where maas = (select min(maas) from personel)

--------------------------------------------
--Tek Satır Alt Sorgular - Having
--------------------------------------------

select 
   (select konum_adi from konum kn 
    where kn.konum_id=ps.konum_id) konm, 
   count(*) pers_sayisi  
from personel
group by konum_id
having count(*) > (select count(*) from personel where konum_id = 3)

--------------------------------------------
--IN Operatörü
--------------------------------------------

select * from personel
where personel_id in 
	   (select personel_id from yonetici where seviye=1)

--------------------------------------------

select * from personel 
where (yonetici_id, unvan) in
      (
         select yonetici_id, unvan
         from personel where personel_id = 5001
      )

--------------------------------------------
--ANY Operatörü
--------------------------------------------

select ad, maas from personel
where maas > any (3000, 4000, 5000)
order by 2

--------------------------------------------

select ad, maas from personel
where maas > 3000 or maas > 4000 or maas > 5000

--------------------------------------------

select ad, soyad, unvan, maas from personel
where maas < any (select maas from personel where unvan = 'UZMAN')

--------------------------------------------
--ALL Operatörü
--------------------------------------------

select ad, maas from personel
where maas > all (3000, 4000, 5000)
order by 2

--------------------------------------------

select ad, maas from personel
where maas > 3000 and maas > 4000 and maas > 5000

--------------------------------------------

select ad, soyad, unvan, izin_gunu from personel
where izin_gunu > all 
    (select izin_gunu from personel where unvan = 'GRUP MÜDÜRÜ')

--------------------------------------------
--EXISTS
--------------------------------------------

select * from personel pr
where pr.yonetici_id in  
  (
     select yn.yonetici_id from yonetici yn 
     where seviye = 1 
  )

select * from personel pr
where exists 
  (
     select 1 from yonetici yn 
     where seviye = 1 
           and yn.yonetici_id = pr.yonetici_id
  )

--------------------------------------------
--NOT EXISTS
--------------------------------------------

select * from personel pr
where not exists 
  (
     select 1 from yonetici yn 
     where seviye = 1 
           and yn.yonetici_id = pr.yonetici_id
  )

--------------------------------------------
--WITH
--------------------------------------------

with ort_maas as
(
  select yonetici_id, round(avg(maas),2) ortalama 
  from personel
  where yonetici_id is not null
  group by yonetici_id
)
select ad, soyad, maas, pr.yonetici_id 
from personel pr, ort_maas om
where pr.yonetici_id = om.yonetici_id
      and om.ortalama > 4000


