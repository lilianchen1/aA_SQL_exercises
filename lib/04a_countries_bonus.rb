# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

# BONUS QUESTIONS: These problems require knowledge of aggregate
# functions. Attempt them after completing section 05.

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
    SELECT
      name
    FROM
      countries
    WHERE
      gdp > (
        SELECT
          MAX(gdp)
        FROM
          countries
        WHERE
          continent = 'Europe'
        -- ORDER BY gdp DESC LIMIT 1 --> Why didn't this work?
      )
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
    SELECT
      c.continent, c.name, c.area
    FROM
      countries AS c
    WHERE
      c.area = (
        SELECT
          MAX(c2.area)
        FROM
          countries AS c2
        WHERE
          c2.continent = c.continent
      )
    -- GROUP BY --> collapse it and can only use continent but not any other columns
    -- continent
      -- name
    -- ORDER BY --> can't use because order by expects line before to return rows.
    -- GROUP BY doesn't return rows.
    --   area DESC
    -- LIMIT 1
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
    SELECT
      c1.name, c1.continent
    FROM
      countries AS c1
    WHERE
      c1.population > (
        SELECT
          MAX(3 * c2.population)
        FROM
          countries AS c2
        WHERE
          c1.continent = c2.continent AND c2.population < (
            SELECT
              MAX(c3.population)
            FROM
              countries AS c3
            WHERE
              c3.continent = c2.continent
          )
      )

  SQL
end
