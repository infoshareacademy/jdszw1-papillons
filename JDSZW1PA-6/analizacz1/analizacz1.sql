-- 1 Operatorzy

-- 1.1 Liczba  wnioskow na danego operatora
-- 1.2  Liczba wyplaconych wnioskow na operatora
-- 1.3  Liczba odrzuconych wnioskow na operatora

select count(wnioski.id) as ilosc_wnioskow, identyfikator_operatora
from wnioski
inner join podroze p on wnioski.id = p.id_wniosku
inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
--where stan_wniosku = 'wyplacony'
-- where stan_wniosku ilike '%odrzu%'
group by  identyfikator_operatora
order by ilosc_wnioskow desc;

-- suma tych wnioskow jest niewiele większa od ogolnej liczby  wnioskow - prawdopodobnie z powodu przypisania dwoch operatorow do jednego wniosku (np. z powodu przesiadki)

--1.4 liczba wyplaconych i odrzuconych wnioskow na operatora
select
   identyfikator_operatora,
  sum(case when stan_wniosku ilike '%wyplacony%' then 1 else 0 end) as liczba_wyplaconych_wnioskow,
  sum(case when stan_wniosku ilike '%odrzu%' then 1 else 0 end) as liczba_odrzuconych_wnioskow
from wnioski
inner join podroze p on wnioski.id = p.id_wniosku
inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
where (stan_wniosku ilike '%odrz%') or (stan_wniosku ilike '%wyplacony%')
group by identyfikator_operatora
order by liczba_wyplaconych_wnioskow desc;

-- 1.5 Ile procent stanowią wyplacone wnioski w porownaniu z odrzuconymi na danego operatora


select identyfikator_operatora, liczba_wyplaconych_wnioskow, liczba_odrzuconych_wnioskow, wszystkie_wnioski,
       round(liczba_wyplaconych_wnioskow* 100.0 / wszystkie_wnioski , 2) as "ilość_odrzucanych_wnioskow %"
from (
    select
   identyfikator_operatora,
  sum(case when stan_wniosku ilike '%wyplacony%' then 1 else 0 end) as liczba_wyplaconych_wnioskow,
  sum(case when stan_wniosku ilike '%odrzu%' then 1 else 0 end) as liczba_odrzuconych_wnioskow,
  sum(case when stan_wniosku is not null then 1 else 0 end) as wszystkie_wnioski
  from wnioski
inner join podroze p on wnioski.id = p.id_wniosku
inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
where (stan_wniosku ilike '%odrz%') or (stan_wniosku ilike '%wyplacony%')
group by identyfikator_operatora) t
order by liczba_wyplaconych_wnioskow desc;



-- 2. Miesiące
-- na których miesiącach firma skupiona jest najbardziej, a na których powinna być ?

-- 2.1  Analiza i porownanie wynikow z wykresami przedstawiającymi liczbę opoźnień w danych miesiącach
-- Hipotezy :
             -- 1.Firma opiera się na rocznych celach ilościowych, przez co może skupiać się na niewłaściwych miesiącach zaczynając "ostro" na początku roku i próbując "nadrobić" swoje roczne cele na koniec roku.
             -- Może się to skończyć ignorowaniem "najbardziej opóźnionych" miesięcy w roku i skupiać się na tych, w których jest znacznie mniej opóźnień - to trochę jakby puszczać najwięcej reklam lodów Algida w grudniu...
             -- 2. Są operatorzy, którzy w danych miesiącach mają stosunkowo więcej wypłacanych wniosków np. ponieważ kursują na poszczególnych trasach, które w danym miesiącu są "bardziej opóźnione" niż inne trasy

-- 2.1.1 -  kampanie na dany miesiąc
select l.delta, kl
from
     (
  select 'January' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =1 and
           date_part('year', data_kampanii) between '2013' and '2018'
    group by  cast(date_part('month', data_kampanii) as int)
    union
    select 'February' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =2 and
          date_part('year', data_kampanii) between '2013' and '2018'
    group by  cast(date_part('month', data_kampanii) as int)
    union
    select 'March' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =3 and
          date_part('year', data_kampanii) between '2013' and '2018'
    group by   cast(date_part('month', data_kampanii) as int)
    union
    select 'April' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =4 and
          date_part('year', data_kampanii) between '2013' and '2018'
    group by  cast(date_part('month', data_kampanii) as int)
             union
    select 'May' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =5 and
          date_part('year', data_kampanii) between '2013' and '2018'
    group by  cast(date_part('month', data_kampanii) as int)
             union
    select 'June' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =6 and
          date_part('year', data_kampanii) between '2013' and '2018'
    group by  cast(date_part('month', data_kampanii) as int)
             union
    select 'July' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =7 and
          date_part('year', data_kampanii) between '2013' and '2018'
    group by  cast(date_part('month', data_kampanii) as int)
             union
    select 'August' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =8 and
          date_part('year', data_kampanii) between '2013' and '2018'
    group by  cast(date_part('month', data_kampanii) as int)
             union
    select 'September' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =9 and
          date_part('year', data_kampanii) between '2013' and '2018'
    group by  cast(date_part('month', data_kampanii) as int)
             union
    select 'October' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =10 and
          date_part('year', data_kampanii) between '2013' and '2018'
    group by  cast(date_part('month', data_kampanii) as int)
             union
    select 'November' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =11 and
          date_part('year', data_kampanii) between '2013' and '2018'
    group by  cast(date_part('month', data_kampanii) as int)
                      union
    select 'December' as delta, cast(date_part('month', data_kampanii) as int), count(id) as kl
    from m_kampanie
    where cast(date_part('month', data_kampanii) as int) =12 and
          date_part('year', data_kampanii) between '2013' and '2018'
    group by  cast(date_part('month', data_kampanii) as int)

) as l
group by l.delta, kl
order by to_date(delta, 'month');

-- 2.1.2 Suma odszkodowan w danym miesiacu

select l.delta, round(sum("Suma odszkodowania"))
from
     (
    select 'January' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =1 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
    union
    select 'February' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =2 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
    union
    select 'March' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =3 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
    union
    select 'April' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =4 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'May' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =5 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'June' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =6 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'July' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =7 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'August' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =8 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'September' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =9 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'October' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =10 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'November' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =11 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'December' as delta, cast(date_part('month', data_otrzymania) as int), sum(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =12 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
) as l
group by l.delta, "Suma odszkodowania"
order by to_date(l.delta, 'month')

-- Liczba wpłyniętych wniosków w danym miesiącu / liczba wyplaconych wnioskow w danym miesiacu

select l.delta, "Liczba wnioskow"
from
     (
  select 'January' as delta, cast(date_part('month', data_utworzenia) as int), count(id)as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month', data_utworzenia) as int) =1 and
           date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by  cast(date_part('month', data_utworzenia) as int)
    union
    select 'February' as delta, cast(date_part('month', data_utworzenia) as int), count(id)as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month', data_utworzenia) as int) =2 and
          date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by  cast(date_part('month', data_utworzenia) as int)
    union
    select 'March' as delta, cast(date_part('month', data_utworzenia) as int), count(id)as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month', data_utworzenia) as int) =3 and
          date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by   cast(date_part('month', data_utworzenia) as int)
    union
    select 'April' as delta, cast(date_part('month', data_utworzenia) as int), count(id)as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month', data_utworzenia) as int) =4 and
          date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by  cast(date_part('month', data_utworzenia) as int)
             union
    select 'May' as delta, cast(date_part('month', data_utworzenia) as int), count(id)as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month', data_utworzenia) as int) =5 and
          date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by  cast(date_part('month', data_utworzenia) as int)
             union
    select 'June' as delta, cast(date_part('month', data_utworzenia) as int), count(id)as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month', data_utworzenia) as int) =6 and
          date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by  cast(date_part('month', data_utworzenia) as int)
             union
    select 'July' as delta, cast(date_part('month',data_utworzenia) as int), count(id)as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month', data_utworzenia) as int) =7 and
          date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by  cast(date_part('month', data_utworzenia) as int)
             union
    select 'August' as delta, cast(date_part('month', data_utworzenia) as int), count(id)as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month', data_utworzenia) as int) =8 and
          date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by  cast(date_part('month', data_utworzenia) as int)
             union
    select 'September' as delta, cast(date_part('month', data_utworzenia) as int), count(id)as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month', data_utworzenia) as int) =9 and
          date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by  cast(date_part('month',data_utworzenia) as int)
             union
    select 'October' as delta, cast(date_part('month', data_utworzenia) as int), count(id)as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month', data_utworzenia) as int) =10 and
          date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by  cast(date_part('month', data_utworzenia) as int)
             union
    select 'November' as delta, cast(date_part('month', data_utworzenia) as int), count(id)as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month', data_utworzenia) as int) =11 and
          date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by  cast(date_part('month', data_utworzenia) as int)
                      union
    select 'december' as delta, cast(date_part('month', data_utworzenia) as int), count(id) as "Liczba wnioskow"
    from wnioski
    where cast(date_part('month',data_utworzenia) as int) =12 and
          date_part('year', data_utworzenia) between '2016' and '2018' --and stan_wniosku ilike '%wyplacony%'
    group by  cast(date_part('month', data_utworzenia) as int)
) as l
group by l.delta, "Liczba wnioskow"
order by to_date(delta, 'month');

-- 2.1.3 Srednia kwota wyplaconego wniosku w danym miesiacu 

select l.delta, round(sum("Suma odszkodowania"))
from
     (
    select 'January' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =1 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
    union
    select 'February' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =2 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
    union
    select 'March' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =3 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
    union
    select 'April' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =4 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'May' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =5 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'June' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =6 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'July' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =7 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'August' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =8 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'September' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =9 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'October' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =10 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'November' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =11 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
             union
    select 'December' as delta, cast(date_part('month', data_otrzymania) as int), avg(kwota)   as "Suma odszkodowania"
    from szczegoly_rekompensat
    where cast(date_part('month', data_otrzymania) as int) =12 and
          date_part('year', data_otrzymania) between '2016' and '2018'
    group by  cast(date_part('month', data_otrzymania) as int)
) as l
group by l.delta, "Suma odszkodowania"
order by to_date(l.delta, 'month')



-- Liczba wpłyniętych/wyplaconych wnioskow w poszczegolnych miesiacach na danego operatora  ( trzech wiodących operatorów - 'TLK', 'Koleje malopolskie', 'InterCity' )
-- Hipoteza - Są operatorzy, którzy w danych miesiącach mają stosunkowo więcej wypłacanych wniosków np. ponieważ kursują na poszczególnych trasach, które w danym miesiącu są "bardziej opóźnione" niż inne trasy

select l.delta, "Liczba wnioskow", identyfikator_operatora as Operator
from
     (
  select 'January' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =1 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
    union
  select 'February' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =2 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
    union
      select 'March' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =3 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
    union
  select 'April' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =4 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
             union
  select 'May' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =5 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
             union
  select 'June' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =6 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
             union
  select 'July' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =7 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
             union
  select 'August' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =8 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
             union
  select 'September' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =9 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
             union
  select 'October' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =10 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
             union
  select 'November' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =11 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
                      union
  select 'December' as delta, count(wnioski.id)as "Liczba wnioskow", identyfikator_operatora
    from wnioski
  inner join podroze p on wnioski.id = p.id_wniosku
  inner join szczegoly_podrozy sp on p.id = sp.id_podrozy
    where cast(date_part('month', wnioski.data_utworzenia) as int) =12 and
           date_part('year', wnioski.data_utworzenia) between '2016' and '2018'and stan_wniosku ilike '%wyp%' and identyfikator_operatora ilike '%tlk%'
    group by  cast(date_part('month', wnioski.data_utworzenia) as int), identyfikator_operatora
) as l
group by l.delta, "Liczba wnioskow", identyfikator_operatora
order by to_date(delta, 'month');


-- 3.

--3.1 Na którym operatorze zarabiamy najwięcej na jeden wniosek ?

-- 3.2  Które wnioski są najszybsze ? Najmniejsza różnica data_zakonczenia i data utworzenia. ( starać się powiązać z czymś)
-- 3.3 Sprawdzić, czy są trasy / regiony na których ilość wypłaconych wniosków jest znacznie większa, niż na innych.

-- 4. Analiza tras. większy ruch - więcej opóźnień. sprawdzić na wykresach, na których trasach jest największy ruch i najwięcej opóźnień. Sprawdzić czy te trasy występują w naszych danych i sprawdzić, czy ilość wniosków jest większa na tych trasach. Może warto zacząć tam działalność promocyjną ?
-- 5. czy istneje związek dodatni między typem podrózy (prywatna/biznesowa) a ilością wypłacanych wniosków ?