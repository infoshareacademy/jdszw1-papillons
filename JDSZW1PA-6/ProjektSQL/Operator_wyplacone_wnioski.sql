
select identyfikator_operatora, count(szczegoly_podrozy.identyfikator_operatora), wnioski.stan_wniosku
from szczegoly_podrozy
inner join podroze on szczegoly_podrozy.id_podrozy = podroze.id
inner join wnioski on podroze.id = wnioski.id
where stan_wniosku = 'wyplacony'
group by identyfikator_operatora,stan_wniosku
order by count(szczegoly_podrozy.identyfikator_operatora) desc;