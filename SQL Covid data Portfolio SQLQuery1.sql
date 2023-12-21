select * from 
portfolio_project_1..CovidDeaths
order by 1,2

select * from 
portfolio_project_1..Covidvaccinations
order by 1,2


--Looking at total cases vs total deaths

select location,date,total_cases,total_deaths, round((total_deaths/total_cases)*100,4) as death_percentage
from  portfolio_project_1..CovidDeaths
where location like '%india%'
order by 1,2

--Looking at total cases vs population
--Shows what percentage of population got covid

select location,date,total_cases,population,round((total_cases/population)*100,4) as percentage_of_population_infected
from  portfolio_project_1..CovidDeaths
where location like '%india%'
order by 1,2


--Looking at countries with highes infection rate compared to population

select location,population,max(total_cases) as Highest_Infection_Count, max(round((total_cases/population)*100,4)) as percentage_of_population_infected
from  portfolio_project_1..CovidDeaths
--where location like '%india%'
group by location, population
order by  percentage_of_population_infected desc, Highest_Infection_Count desc,location


--Showing countries with highest death counts per population

select location,max(cast (total_deaths as int)) as Highest_Death_Count
from  portfolio_project_1..CovidDeaths
--where location like '%india%'
where continent is not null
group by location
order by  Highest_Death_Count desc		


--Showing the continents with the highest death count per population

select continent,max(cast (total_deaths as int)) as Highest_Death_Count
from  portfolio_project_1..CovidDeaths
--where location like '%india%'
where continent is not null
group by continent
order by  Highest_Death_Count desc		


--GLOBAL NUMBERS
--Showing the number of new cases and no. of deaths around the world daily. Also showing the Every Day Death Percentage


select date, sum(cast(new_cases as int)) as NewCases, sum(cast(new_deaths as int)) as NewDeaths,round(sum(cast(new_deaths as int))/sum(new_cases)*100,2) as EverydayDeathPercentage       
from  portfolio_project_1..CovidDeaths
where continent is not null
group by date
order by 1,2,3


--Join both the tables

select *
from portfolio_project_1..covidDeaths cd
join portfolio_project_1..covidvaccinations cv on cd.location=cv.location
and cd.date=cv.date


--Show the population, the no. of people vaccinated and no. of new vaccinations for each day in India

select cd.location,cd.date, cd.population, cv.new_vaccinations, cv.people_vaccinated
from portfolio_project_1..covidDeaths cd
join portfolio_project_1..covidvaccinations cv on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
and cd.location like '%india%'
order by cd.location, cd.date



--New vaccinations vs no. of people vaccinated till date

select cd.location,cd.date, cd.population, cv.new_vaccinations,
sum(cast(cv.new_vaccinations as int)) over(partition by cd.location order by cd.location, cd.date) as TotalVaccinations_TillDate,
from portfolio_project_1..covidDeaths cd
join portfolio_project_1..covidvaccinations cv on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
order by cd.location, cd.date


--New vaccinations vs % of population vaccinated

with PopVsVacc as 
(select cd.location,cd.date, cd.population, cv.new_vaccinations,
sum(cast(cv.new_vaccinations as int)) over(partition by cd.location order by cd.location, cd.date) as TotalVaccinations_TillDate
from portfolio_project_1..covidDeaths cd
join portfolio_project_1..covidvaccinations cv on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
)

select location, date, population, new_vaccinations,TotalVaccinations_TillDate, round((TotalVaccinations_TillDate/population)*100,2)
from PopVsVacc



--TEMP Table


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
TotalVaccinations_TillDate numeric
)

Insert into #PercentPopulationVaccinated
select cd.continent, cd.location,cd.date, cd.population, cv.new_vaccinations,
sum(cast(cv.new_vaccinations as int)) over(partition by cd.location order by cd.location, cd.date) as TotalVaccinations_TillDate
from portfolio_project_1..covidDeaths cd
join portfolio_project_1..covidvaccinations cv on cd.location=cv.location
and cd.date=cv.date


select *, round((TotalVaccinations_TillDate/population)*100,2) as PercentOfPopVaccinated
from #PercentPopulationVaccinated




--Creating views for later visualisations

Create View PercentagePopulationVaccinated as
select cd.location,cd.date, cd.population, cv.new_vaccinations,
sum(cast(cv.new_vaccinations as int)) over(partition by cd.location order by cd.location, cd.date) as TotalVaccinations_TillDate
from portfolio_project_1..covidDeaths cd
join portfolio_project_1..covidvaccinations cv on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null


select * from
PercentagePopulationVaccinated