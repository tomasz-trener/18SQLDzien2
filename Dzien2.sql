 
 select * from zawodnicy

 select * from trenerzy
  

  -- relacja jeden do wielu 

  select *
  from zawodnicy inner join trenerzy on zawodnicy.id_trenera = trenerzy.id_trenera

  select *
  from zawodnicy left join trenerzy on zawodnicy.id_trenera = trenerzy.id_trenera

   select *
  from zawodnicy right join trenerzy on zawodnicy.id_trenera = trenerzy.id_trenera

  select *
  from zawodnicy full outer join trenerzy on zawodnicy.id_trenera = trenerzy.id_trenera


  -- Wypisz zawodników, tylko tych, którzy posiadaj¹ trenera o naziwsku d³ugosci krtószej ni¿ 5

  select zawodnicy.imie, trenerzy.imie_t, zawodnicy.id_trenera
  from  zawodnicy left join trenerzy on zawodnicy.id_trenera =trenerzy.id_trenera
  where len(nazwisko_t)<7

  select z.imie, t.imie_t, z.id_trenera
  from  zawodnicy z join trenerzy t on z.id_trenera =t.id_trenera
   

  select * from zawodnicy
  select * from skocznie

  select *
  from zawodnicy z join skocznie s on z.kraj=s.kraj_skoczni

  -- wypisz pary zawodnikow i trenerów, których nazwisko zaczyna siê na tak¹ litere
  -- niekoniecznie s¹ to trenerzy tych zawodnikow 
  select *  
  from zawodnicy z join trenerzy t on LEFT(z.nazwisko,1)= LEFT(t.nazwisko_t,1)
  -- wypisz pary zawodnikow i trenerów, których nazwisko zaczyna siê na tak¹ litere
  -- oraz ustal, ¿e trener ma trenowaæ danego zawodnika 

   select *  
  from zawodnicy z join trenerzy t on LEFT(z.nazwisko,1)= LEFT(t.nazwisko_t,1) 
									  and z.id_trenera = t.id_trenera 
  
  select *  
  from zawodnicy z join trenerzy t on LEFT(z.nazwisko,1)= LEFT(t.nazwisko_t,1) 
  where z.id_trenera = t.id_trenera 

  --1) wypisz wszystkie miasta i informacje jakie skocznie siê wnich znajduj¹ 

  select m.nazwa_miasta, s.nazwa_skoczni
  from miasta m left join skocznie s on m.id_miasta = s.id_miasta

  -- 2) wypisz zawodnikow wraz z nazwami zawodów w jakich startowali 

  select * from zawodnicy

    select * from uczestnictwa

  select * from zawody

  select z.imie + ' ' + z.nazwisko + ' startowa³ w ' + zw.nazwa [raport]
  from zawodnicy z join uczestnictwa u on z.id_zawodnika = u.id_zawodnika
                   join zawody zw on zw.id_zawodow = u.id_zawodow
  order by z.nazwisko

  --3) wypisz nazwy skoczni w jaki skakli poszczególni zawodnicy

  select distinct s.nazwa_skoczni, z.imie + ' ' + z.nazwisko
  from zawodnicy z join uczestnictwa u on z.id_zawodnika = u.id_zawodnika
				   join zawody zw on u.id_zawodow = zw.id_zawodow
				   join skocznie s on zw.id_skoczni = s.id_skoczni
				
  --4) wypisz trenerów i zawodników urodzonych w tym samym miesi¹cu 

  select z.imie + ' ' + z.nazwisko,z.data_ur,
	   	t.imie_t + ' ' + t.nazwisko_t, t.data_ur_t 
  from zawodnicy z join trenerzy t on month(z.data_ur) = MONTH(t.data_ur_t)
                                    and z.id_trenera = t.id_trenera

  --5) wypisz pary zawodnikow urodzony tego samego dnia tygodnia 
     -- dzieñ tygodnia mozesz znalezc uzywajac funkcji format(data,'ddd')
	 select FORMAT(data_ur,'dddd','pl-pl')
	 from zawodnicy

	 select z1.imie + ' ' + z1.nazwisko, FORMAT(z1.data_ur,'dddd','pl-pl'), z1.id_zawodnika, 
		    z2.imie + ' ' + z2.nazwisko, FORMAT(z2.data_ur,'dddd','pl-pl'), z2.id_zawodnika
	 from zawodnicy z1 join zawodnicy z2 on FORMAT(z1.data_ur,'ddd') = FORMAT(z2.data_ur,'ddd')
										and z1.id_zawodnika <> z2.id_zawodnika  -- != lub <>
										and z1.kraj = z2.kraj
										and z1.id_zawodnika > z2.id_zawodnika

   --6) wypisz trenerów i miasta  jakie Ci trenerzy odwiedzili w swojej karierze 

   -- trener trenuje zawodnikow, ktorzy uczestnicza w zawodach, te zawody odbywaja 
   -- sie na pewnych skoczniach a te skocznie znajduja sie w pewnych miastach 

   select distinct t.imie_t + ' ' + t.nazwisko_t, m.nazwa_miasta
   from trenerzy t join zawodnicy z on z.id_trenera = t.id_trenera
	               join uczestnictwa u on u.id_zawodnika = z.id_zawodnika
				   join zawody zw on zw.id_zawodow = u.id_zawodow
				   join skocznie s on s.id_skoczni = zw.id_skoczni
				   join miasta m on m.id_miasta =s.id_miasta
   --7) wypisz trenerów, którzy nikogo nie trenuja 

   select t.*
   from trenerzy t left join zawodnicy z on z.id_trenera = t.id_trenera
   where z.id_zawodnika is null
   --8) wypisz zawodnikow, ktorzy nie maja trenera 

   select z.*
   from zawodnicy z left join trenerzy t on z.id_trenera = t.id_trenera 
   where z.id_trenera  is null

   select * 
   from zawodnicy where id_trenera is null

   --9) wypisz pary zawodnikow takiego, ze jeden jest wyzszy od drugiego o co najmniej 2 cm 
   select z1.imie + ' ' + z1.nazwisko , z2.imie + ' ' +z2.nazwisko , z1.wzrost - z2.wzrost [roznica w cm]
   from zawodnicy z1 join zawodnicy z2 on z1.wzrost > z2.wzrost+2
   order by [roznica w cm]


   -- grupowanie danych
   select distinct kraj from zawodnicy

   select kraj, SUM(wzrost), AVG(wzrost), MIN(wzrost), MAX(wzrost), STDEV(wzrost), 
				COUNT(wzrost), COUNT(id_trenera), COUNT(id_zawodnika), COUNT(*)
   from zawodnicy
   group by kraj

   --1) podaj ilu mamy zawodnikow w poszczegolnych krajach wyzszych niz 180 cm 

   select kraj, COUNT(*), max(wzrost)
   from zawodnicy
   where wzrost>180
   group by kraj
   
   --2) podaj ekipy uporzadkowane wg. sredniego wzrostu 

   select kraj, AVG(wzrost) [sredni]
   from zawodnicy 
   group by kraj
   order by [sredni]

   --3) Napisz zapytanie, ktore zwroci dla kazdego kraju ilosc zawodnikow wyzszych niz 180 cm
       -- w kolumnie wysocy, i ilosc zawodnikow nizszych niz 175 cm w kolumnie niscy 

	   select kraj, sum(IIF(wzrost>180,1,0)) [wys], SUM(IIF(wzrost<175,1,0)) [nis]
	   from zawodnicy
	   group by kraj

	   select kraj, count(IIF(wzrost>180,1,null)) [wys], count(IIF(wzrost<175,1,null)) [nis]
	   from zawodnicy
	   group by kraj


	   -- gdy grupujemy po kolumnie 'X' to tê kolumnê 'X' mo¿emy w select normlanie 
	   -- wyœwietliæ ale pozosta³e kolumny ¿eby wyœwietliæ musze zagregowaæ 

	   select kraj, waga, SUM(wzrost), COUNT(*) [ile]
	   from zawodnicy
	   group by kraj, waga
	   order by [ile] desc


	   select kraj, avg(wzrost)
	   from zawodnicy
	   group by rollup(kraj)

	   select AVG(wzrost) from zawodnicy

	   select kraj ,AVG(wzrost)
	   from zawodnicy
	   group by kraj

	   -- dla kazdego zawodnika, wypisz pore roku w jakiej sie urodzil 
	   -- pory roku ustal na podstawie numerów miesiecy :
	   -- zima: 12,1,2 wisona: 3,4,5, lato: 6,7,8 jesien: 9,10,11

	   select imie, nazwisko, 
		case
			when MONTH(data_ur) in (12,1,2) then 'zima'
			when month(data_ur) between 3 and 5 then 'wiosna'
			when month(data_ur) between 6 and 8 then 'lato'
			when month(data_ur) between 9 and 11 then 'jesien'
			else null
		end
	   from zawodnicy


	   -- 2)   sprawdz ilu zawodników urodzi³o siê w danej porze roku 
	   select  kraj, 
		case
			when MONTH(data_ur) in (12,1,2) then 'zima'
			when month(data_ur) between 3 and 5 then 'wiosna'
			when month(data_ur) between 6 and 8 then 'lato'
			when month(data_ur) between 9 and 11 then 'jesien'
			else null
		end [pora roku], COUNT(id_zawodnika) [ile]
	   from zawodnicy
	   group by cube(kraj, case
			when MONTH(data_ur) in (12,1,2) then 'zima'
			when month(data_ur) between 3 and 5 then 'wiosna'
			when month(data_ur) between 6 and 8 then 'lato'
			when month(data_ur) between 9 and 11 then 'jesien'
			else null
		end)
		order by 2 desc--[ile] desc


		-- 1) podaj ilosci zawodnikow wyzszych niz 175 w poszczególnych krajach 
		-- 2) podaj ilosci zawodnikow w poszczegolnych krajach, gdzie srednia wzrostu jest wyzsza niz 175 cm

		-- where to filtorwanie PRZED grupowanie. to filtorwanie dziala na poszczególnych rekordach
		-- having to filtrowanie PO grupowanie. to filtorwanie dziala na poszczegolnych grupach 

		--1)
		select kraj, AVG(wzrost)
		from zawodnicy
		where wzrost>175
		group by kraj
		--2) 
		select kraj, AVG(wzrost)
		from zawodnicy
		--where wzrost>175
		group by kraj
		having AVG(wzrost)>180

		--1) wypisz liste trenerów, wraz z informacj¹ ilu zawodników dany trener trenuje 

		select t.imie_t + ' ' + t.nazwisko_t, COUNT(z.id_zawodnika)
		from trenerzy t join zawodnicy z on z.id_trenera = t.id_trenera
		group by t.imie_t + ' ' + t.nazwisko_t, t.id_trenera

		 
		--2) wypisz zaowdnikow wraz z informacja ile razy startowali w zawodach

		select z.imie + ' ' + z.nazwisko, COUNT(u.id_zawodnika)
		from zawodnicy z join uczestnictwa u on z.id_zawodnika = u.id_zawodnika
		group by z.id_zawodnika, z.imie , z.nazwisko	
		
		--3) wypisz tylko te miasta, w których startowa³o przynjamniej 5 zawodników

		select m.nazwa_miasta, COUNT(z.id_zawodnika)
		from zawodnicy z join uczestnictwa u on z.id_zawodnika = u.id_zawodnika
						 join zawody zw on zw.id_zawodow = u.id_zawodow
						 join skocznie s on s.id_skoczni = zw.id_skoczni
						 join miasta m on m.id_miasta = s.id_miasta
	    group by m.nazwa_miasta
		having  COUNT(z.id_zawodnika)>4

		--4) wypisz trenrów, którzy trenuj¹ przynajmniej 2 zawodników, których wzrost wynosi ponizej 175cm

		select t.imie_t + ' ' + t.nazwisko_t, count(z.id_zawodnika)
		from trenerzy t join zawodnicy z on z.id_trenera = t.id_trenera
		where z.wzrost<175
		group by t.id_trenera, t.imie_t , t.nazwisko_t
		having  count(z.id_zawodnika)>1

		--5) zrób zestawienie w którym wyswietlisz dla kazdego kraju
		-- maksymalny punkt k skoczni oraz informacje jaki jest maksymalny 
		-- punkt k dla wszystkich krajów jednosnie 
		-- nie uwzgledniaj pustych wierszy 


		select kraj_skoczni, MAX(k)
		from skocznie
		where id_skoczni is not null and k is not null
		group by rollup(kraj_skoczni)

		-- 6) sprawdz ile razy trener polakow odzwiedzi³ miasta, które nie zawieraj¹ litery 'o'

		select t.nazwisko_t, COUNT(*)
		from trenerzy t  join zawodnicy z on z.id_trenera=t.id_trenera
						 join uczestnictwa u on u.id_zawodnika = z.id_zawodnika
						 join zawody zw on zw.id_zawodow= u.id_zawodow
						 join skocznie s on s.id_skoczni = zw.id_skoczni
						 join miasta m on m.id_miasta = s.id_miasta
		where z.kraj = 'pol' and m.nazwa_miasta not like '%o%'
		group by t.id_trenera, t.nazwisko_t

		--7) podaj ile skoczni znajduje sie sie w danym miescie, miasta wyswietl bez cudzys³owów

		 select SUBSTRING(m.nazwa_miasta,2,len(m.nazwa_miasta)-2), COUNT(s.id_skoczni)
		 from miasta m join skocznie s on s.id_miasta = m.id_miasta
		 group by m.nazwa_miasta


		




		 select SUBSTRING('xala max',2,LEN('xala max')-2)
		          --       123456789 dlugosc = 8
				          --12345678


 --1) join 2) group 3) podzapytania 

   select imie, nazwisko, w from 
	(select imie, nazwisko,  kraj, waga +1 w
	from zawodnicy) p
   where w>60

   -- stworz zapytanie, ktore wyswietla imie ,nazwisko i bmi
   -- przefiltruj dane po bmi > 20. (wykorzystaj podzapytania) 

select imie, nazwisko, FORMAT(bmi,'0.00') from
   (select imie, nazwisko, waga/power(wzrost/100.0,2) bmi
   from zawodnicy) t 
where bmi >20

-- podzapytanie zdefiniowalismy w sekcji FROM
-- mozemy takze definowac w sekcji SELECT 

--np obok kazdego zawodnika, podaj jego wzrost oraz informacje o ile jego wzrost jest mniejszy
-- od masymlanego wzrostu wszystkich zawodnikow 

select imie, nazwisko, wzrost, (select MAX(wzrost) from zawodnicy) - wzrost [roznica]
from zawodnicy
order by roznica desc

select imie, (select MAX(wzrost) from zawodnicy) [maksymalny]
from zawodnicy



select MAX(wzrost) from zawodnicy


-- mozemy takze definiowac w sekcji WHERE 

-- np: podaj zawodnikow tylko tych, którzy s¹ cie¿si od œredniej wagi zawodników 

select *
from zawodnicy
where waga > (select AVG(waga) from zawodnicy)   

-- 3 rodzaje podzapytania
-- 1) w sekcji from: w nawiasy i musze nadac alias 
-- 2) w sekcji select : w nawiasy i mozna podac alias ale nie zawsze 
-- 3) w sekcji where: w nawiasy i nie mozna podac aliasu 

-- podaj zawodnikow ktorych waga jest taka sama jak waga dowolnego polaka 
select * from 
zawodnicy 
where waga in (select waga from zawodnicy where kraj = 'pol')
     and kraj <> 'pol'


select * from zawodnicy where waga in (56,63,60)

-- podaj zawodnikow, ktorych waga jest wieksza od wszystkich Wag polakow
select * from 
zawodnicy 
where waga > all (select waga from zawodnicy where kraj = 'pol')
      
select * from 
zawodnicy 
where waga > (select MAX(waga) from zawodnicy where kraj = 'pol')

-- podaj zawodnikow, ktorych waga jest wieksza od dowolnej wagi z polakow (przynajmniej jednej z)

select * from 
zawodnicy 
where waga > any (select waga from zawodnicy where kraj = 'pol')
   
 select * from 
zawodnicy 
where waga > some (select waga from zawodnicy where kraj = 'pol')
        
select * from 
zawodnicy 
where waga > (select min(waga) from zawodnicy where kraj = 'pol')

-- str 28 

-- wypisz najwyszego zawodnika

select * 
from zawodnicy
where wzrost = (select MAX(wzrost) from zawodnicy)

-- wypisz zawodnikow ciezszych niz srednia wsrod wszystkich

select * from zawodnicy
where waga > (select AVG(waga) from zawodnicy)

-- wypisz zawodnikow ciezszych niz srednia w danej ekipie 
-- rozw :1 
select imie, nazwisko, waga,sr  from
	(select *,  (select AVG(waga) from zawodnicy where kraj=z.kraj) [sr]
	from zawodnicy z) t
where waga>sr
-- rozw :2

select imie, nazwisko, waga,sr 
from zawodnicy z join
	(select kraj, AVG(waga) [sr]
	from zawodnicy
	group by kraj) t on z.kraj = t.kraj
where waga>sr

select * from zawodnicy


-- wypisz zawodniów, którzy startowali rzadziej ni¿ œrednia startów w ich dru¿ynie 


-- zeby policzyc srednia liczbe startow to potrzebujemy najpierw poznac 
-- jaka jest suma starów w danej druzynie

select  z.kraj, count(u.id_uczestnictwa) [liczbStartow]
from zawodnicy z join uczestnictwa u on z.id_zawodnika = u.id_zawodnika
group by kraj
-- oraz jaka jest liczba zawodnikow w danej druzynie 

select kraj, COUNT(id_zawodnika) [ileZawodnikow]
from zawodnicy
group by kraj

-- teraz ³aczymy ze soba te tabelki 
-- teraz mamy policzn¹ œredni¹ liczbe startów dla danej druzyny 
select ls.kraj, ls.liczbStartow, iz.ileZawodnikow, CONVERT(decimal,ls.liczbStartow)/iz.ileZawodnikow
from
	(select  z.kraj, count(u.id_uczestnictwa) [liczbStartow]
	from zawodnicy z join uczestnictwa u on z.id_zawodnika = u.id_zawodnika
	group by kraj) ls
join 
	(select kraj, COUNT(id_zawodnika) [ileZawodnikow]
	from zawodnicy
	group by kraj) iz
on ls.kraj = iz.kraj

-- teraz dla kazdego zawodnika musmy policzyc ile razy on startowal 

select  z.imie + ' ' +z.nazwisko [zaw], kraj ,count(u.id_uczestnictwa) [ileStartZaw]
from zawodnicy z join uczestnictwa u on z.id_zawodnika=u.id_zawodnika
group by z.id_zawodnika, z.nazwisko, z.imie, kraj

--- teraz ostatecznie laczymy obydiwe tableki 
select * from 
	(select  z.imie + ' ' +z.nazwisko [zaw], kraj ,count(u.id_uczestnictwa) [ileStartZaw]
	from zawodnicy z join uczestnictwa u on z.id_zawodnika=u.id_zawodnika
	group by z.id_zawodnika, z.nazwisko, z.imie, kraj) t1
join
	(select ls.kraj, ls.liczbStartow, iz.ileZawodnikow, CONVERT(decimal,ls.liczbStartow)/iz.ileZawodnikow [srls]
	from
		(select  z.kraj, count(u.id_uczestnictwa) [liczbStartow]
		from zawodnicy z join uczestnictwa u on z.id_zawodnika = u.id_zawodnika
		group by kraj) ls
	join 
		(select kraj, COUNT(id_zawodnika) [ileZawodnikow]
		from zawodnicy
		group by kraj) iz
	on ls.kraj = iz.kraj) t2
on t1.kraj = t2.kraj
where ileStartZaw < srls


-- funkcje (maetmatyczne, tekstowe, datowe) + sekcje (select, where, from, order by group by having )
-- grupowanie, join , podzapytania 


-- operacje teoriomnogosciowe (na zbiorach) 

select imie, nazwisko , kraj, FORMAT(wzrost,'0')
from zawodnicy 
union
select imie_t, nazwisko_t, '-' , FORMAT(data_ur_t,'dd-MM-yyyy')
from trenerzy

-- funkcje okienkowe 

































