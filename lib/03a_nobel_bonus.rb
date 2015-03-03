# == Schema Information
#
# Table name: nobels
#
#  yr          :integer
#  subject     :string
#  winner      :string

require_relative './sqlzoo.rb'

# BONUS PROBLEM: requires sub-queries or joins. Attempt this after completing
# sections 04 and 07.

def physics_no_chemistry
  # In which years was the Physics prize awarded, but no Chemistry prize?
  execute(<<-SQL)
  SELECT DISTINCT -- Use distinct because there are multiple winners in one yr, so it will return a year for each winner
    n1.yr
  FROM
    nobels n1
  WHERE
    'Chemistry' NOT IN (
      SELECT
        n2.subject
      FROM
        nobels n2
      WHERE
        n1.yr = n2.yr
    ) AND
    'Physics' IN (
      SELECT
        n2.subject
      FROM
        nobels n2
      WHERE
        n2.yr = n1.yr
    )

  SQL
end
