SELECT *
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM PortfolioProject.dbo.CovidVaccinations
WHERE continent is not null
ORDER BY 3,4

SELECT LOCATION, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- TOTAL CASES VS TOTAL DEATHS
SELECT LOCATION, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- TOTAL CASES PER DAY AND CHANCES OF GETTING COVID
SELECT LOCATION, date, total_cases, population, (total_cases/population)*100 as pop_case_percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
ORDER BY 1,2


-- HIGHEST INFECTION RATE PER COUNTRY
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 as Highest_infection_rate
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY Location, population
ORDER BY Highest_infection_rate desc

-- HIGHEST DEATH COUNT PER POPULATION
SELECT LOCATION, MAX(Cast(total_deaths as int)) AS HighestDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER BY HighestDeathCount desc

--HIGHEST DEATH COUNT PER CONTINENT
SELECT continent, MAX(Cast(total_deaths as int)) AS HighestDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY HighestDeathCount desc

--WORLD NUMBERS PER DAY

SELECT date, SUM(new_cases) as Total_cases, SUM(cast (new_deaths as int)) as Total_Deaths, SUM(CAST(New_deaths as int))/SUM(New_cases)*100 as Death_Percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2


-- VACCINATIONS PER POPULATION

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date)
as Accumulative_vaccinations
FROM PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--CTE

WITH Popvsvac (Continent, location, date, population, new_vaccinations, accumulative_vaccinations)
as (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date)
as Accumulative_vaccinations
FROM PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (accumulative_vaccinations/population)*100
FROM Popvsvac


--CREATE VIEW FOR DATA VISUALIZATION

CREATE VIEW accumulative_vaccinations as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date)
as Accumulative_vaccinations
FROM PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null