-- Shows all the data of covid
Select * 
From CovidDeaths
Order by 3,4

Select * 
From CovidVaccinations
Order by 3,4

Select country, date, total_cases, new_cases, total_deaths, population 
From dbo.CovidDeaths
Order by country, date

-- Total Cases and Total Deaths as of August 19, 2026
Select 
    max(total_cases) as TotalCases, 
    max(total_deaths) as TotalDeaths
From CovidDeaths

-- Total Deaths per Country
Select country, max(total_deaths) as TotalDeaths
From CovidDeaths
Where continent is not null
Group by country
Order by country

-- Total Deaths per Continent
Select continent, max(total_deaths) as TotalDeaths
From CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeaths desc

-- Total Deaths Worldwide
Select country, max(total_deaths) as TotalDeathsWorldwide
From CovidDeaths
Where country is not null
Group by country
Order by TotalDeathsWorldwide desc

-- Total Cases to Total Deaths Percentage
Select 
    country, 
    date, 
    total_cases, 
    total_deaths, 
    (CAST(total_deaths as float)/ NULLIF(total_cases, 0))*100 as DeathPercentage
from dbo.CovidDeaths
where continent is not null
order by country, date asc

-- Total Cases to Total Deaths Percentage in the Philippines
Select 
    country, 
    date, 
    total_cases, 
    total_deaths, 
    (CAST(total_deaths as float)/ NULLIF(total_cases, 0))*100 as DeathPercentage
From dbo.CovidDeaths
Where country = 'Philippines'
Order by country, date asc

-- Total Population per Country to Total Cases per Country Percentage Daily
Select 
    country, 
    date, 
    population, 
    total_cases, 
    cast(((cast(total_cases as float)/ NULLIF(population,0))*100) as decimal(18,9)) as PopulationToTotalCasesPercentage
From CovidDeaths
Where continent is not null
Order by country,date

-- Infection Rate of Countries in Country Ascending Order
Select 
    country, 
    population, 
    max(total_cases) as HighestInfectionCount,  
    MAX(CAST(total_cases as float)/NULLIF(population,0))*100 as InfectionRate
From CovidDeaths
Where continent is not null
Group by country, population
Order by country

-- Infection Rate of Countries in Highest Infection Rate Descending Order
Select 
    country, 
    population, 
    max(total_cases) as HighestInfectionCount,  
    MAX(CAST(total_cases as float)/NULLIF(population,0))*100 as InfectionRate
From CovidDeaths
Where continent is not null
Group by country, population
Order by InfectionRate desc

-- Countries with Highest Death Count
Select
    country, 
    max(total_deaths) as DeathCount
From CovidDeaths
Where continent is not null
Group by country
Order by DeathCount Desc

-- Daily World Death Percentage
Select 
    country,
    date, 
    total_cases,
    total_deaths,
    cast(total_deaths as float) / nullif(cast(total_cases as float), 0) * 100 as DeathPercentageGlobally
From CovidDeaths
Where country = 'World'
Group By date, country, total_cases, total_deaths
Order By date

--Death Percentage Globally From January 2020 to Present
Select 
    sum(total_cases) as total_cases,
    sum(total_deaths) as total_deaths,
    sum(cast(total_deaths as float)) / sum(nullif(cast(total_cases as float), 0)) * 100 as DeathPercentageGlobally
From CovidDeaths
Where country = 'World'
Order By total_cases, total_deaths

---------------------------------------------------Using Join-----------------------------------------------------
select *
from CovidVaccinations

Select *
From CovidDeaths as death
Join CovidVaccinations as vaccination
    On death.country = vaccination.country
    and death.date = vaccination.date

-- Population in each Country to People Vaccinated daily
Select death.country, death.date, death.population, vaccine.new_vaccinations as PeopleVaccinatedDaily
From CovidDeaths as death
Join CovidVaccinations as vaccine
    On death.country = vaccine.country
    and death.date = vaccine.date
Where death.continent is not null
Order By death.country, death.date

-- Total World Population to People Vaccinated
Select 
        death.country, 
        sum(death.population) as TotalPopulation, 
        sum(vaccine.new_vaccinations) as PeopleVaccinated
From CovidDeaths as death
Join CovidVaccinations as vaccine
    On death.country = vaccine.country
    and death.date = vaccine.date
Where death.country = 'World'
Group By death.country

-- Rolling People Vaccinated to Population
Select
    death.continent,
    death.country,
    death.date,
    death.population,
    vaccine.new_vaccinations,
    SUM(CAST(vaccine.new_vaccinations as bigint)) OVER (Partition By death.country Order By death.date)
    As RollingPeopleVaccinated
From CovidDeaths as death
Join CovidVaccinations as vaccine
    On death.country = vaccine.country
    and death.date = vaccine.date
Where death.continent is not null
Order By 2,3


-- Use CTE

With PopulationToVaccinated (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select
    death.continent,
    death.country,
    death.date,
    death.population,
    vaccine.new_vaccinations,
    SUM(CAST(vaccine.new_vaccinations as bigint)) OVER (Partition By death.country Order By death.date)
    As RollingPeopleVaccinated
From CovidDeaths as death
Join CovidVaccinations as vaccine
    On death.country = vaccine.country
    and death.date = vaccine.date
Where death.continent is not null
)
Select *, (RollingPeopleVaccinated/population)*100
From PopulationToVaccinated

-- Using Temp Table

Drop Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
Continent nvarchar(max),
Country nvarchar(max),
Date date,
Population bigint,
New_vaccinations float,
Rollingpeoplevaccinated float
)

Insert into PercentPopulationVaccinated
Select
    death.continent,
    death.country,
    death.date,
    death.population,
    vaccine.new_vaccinations,
    SUM(CAST(vaccine.new_vaccinations as bigint)) OVER (Partition By death.country Order By death.date)
    As RollingPeopleVaccinated
From CovidDeaths as death
Join CovidVaccinations as vaccine
    On death.country = vaccine.country
    and death.date = vaccine.date
Where death.continent is not null

Select *, (rollingPeopleVaccinated/population)*100 as PeopleVaccinatedToPopulationPercentage
From PercentPopulationVaccinated

-- Creating View to store date for later Visualization

Create View PercentPopulationVaccinated as 
Select
    death.continent,
    death.country,
    death.date,
    death.population,
    vaccine.new_vaccinations,
    SUM(CAST(vaccine.new_vaccinations as bigint)) OVER (Partition By death.country Order By death.date)
    As RollingPeopleVaccinated
From CovidDeaths as death
Join CovidVaccinations as vaccine
    On death.country = vaccine.country
    and death.date = vaccine.date
Where death.continent is not null


---------------------For Tableau Visualization----------------------------------

--1.
Select 
    SUM(new_cases) as total_cases, 
    SUM(cast(new_deaths as bigint)) as total_deaths, 
    SUM(cast(new_deaths as float))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



--2.
Select country as continent, SUM(cast(new_deaths as bigint)) as TotalDeathCount
From CovidDeaths
--Where country like '%states%'
Where continent is null 
and country in ('Europe', 'North America', 'Asia', 'South America', 'Africa', 'Oceania')
Group by country
order by TotalDeathCount desc

--3.
Select 
    country, 
    Population, 
    MAX(cast(total_cases as float)) as HighestInfectionCount,  
    Max(cast(total_cases as float)/population)*100 as PercentPopulationInfected
From CovidDeaths
Group by country, Population
order by PercentPopulationInfected desc


--4.
Select 
    country, 
    Population,
    date, 
    MAX(cast(total_cases as bigint)) as HighestInfectionCount,  
    Max(cast(total_cases as float)/population)*100 as PercentPopulationInfected
From CovidDeaths
Group by country, Population, date
order by PercentPopulationInfected desc

