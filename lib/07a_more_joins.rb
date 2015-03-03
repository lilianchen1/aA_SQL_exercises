# == Schema Information
#
# Table name: albums
#
#  asin        :string       not null, primary key
#  title       :string
#  artist      :string
#  price       :float
#  rdate       :date
#  label       :string
#  rank        :integer
#
# Table name: styles
#
# album        :string       not null
# style        :string       not null
#
# Table name: tracks
# album        :string       not null
# disk         :integer      not null
# posn         :integer      not null
# song         :string

require_relative './sqlzoo.rb'

def alison_artist
  # Select the name of the artist who recorded the song 'Alison'.
  execute(<<-SQL)
    SELECT
      albums.artist
    FROM
      albums
    INNER JOIN
      tracks ON tracks.album = albums.asin
    WHERE
      tracks.song = 'Alison'
  SQL
end

def exodus_artist
  # Select the name of the artist who recorded the song 'Exodus'.
  execute(<<-SQL)
  SELECT
    albums.artist
  FROM
    albums
  INNER JOIN
    tracks ON tracks.album = albums.asin
  WHERE
    tracks.song = 'Exodus'
  SQL
end

def blur_songs
  # Select the `song` for each `track` on the album `Blur`.
  execute(<<-SQL)
  SELECT
    tracks.song
  FROM
    tracks
  INNER JOIN
    albums ON albums.asin = tracks.album
  WHERE
    albums.title = 'Blur'
  SQL
end

def heart_tracks
  # For each album show the title and the total number of tracks containing
  # the word 'Heart' (albums with no such tracks need not be shown). Order by
  # the number of such tracks.
  execute(<<-SQL)
  -- SELECT
  --   albums.title, COUNT(tracks.*)--COUNT(*)
  -- FROM
  --   albums
  -- JOIN
  --   tracks ON tracks.album = albums.asin
  -- WHERE
  --   tracks.song LIKE '%Heart%'
  -- GROUP BY
  --   albums.title
  -- ORDER BY
  --   COUNT(tracks.*) DESC  -- COUNT(*) DESC
  -- SQL

    SELECT
      albums.title, COUNT(*)
    FROM
      albums
    JOIN
      tracks ON albums.asin = tracks.album
    WHERE
      tracks.song LIKE '%Heart%'
    GROUP BY
      albums.asin
    ORDER BY
      COUNT(*) DESC
  SQL
end

def title_tracks
  # A 'title track' has a `song` that is the same as its album's `title`. Select
  # the names of all the title tracks.
  execute(<<-SQL)
  SELECT
    tracks.song
  FROM
    tracks
  JOIN
    albums ON tracks.album = albums.asin
  WHERE
    tracks.song = albums.title
  SQL
end

def eponymous_albums
  # An 'eponymous album' has a `title` that is the same as its recording
  # artist's name. Select the titles of all the eponymous albums.
  execute(<<-SQL)
  SELECT
    albums.title
  FROM
    albums
  WHERE
    albums.title = albums.artist
  SQL
end

def song_title_counts
  # Select the song names that appear on more than two albums. Also select the
  # COUNT of times they show up.
  execute(<<-SQL)
  SELECT
    tracks.song, COUNT(*)
  FROM
    tracks
  GROUP BY
    tracks.song
  HAVING
    COUNT(*) > 2

  SQL
end

def best_value
  # A "good value" album is one where the price per track is less than 50
  # pence. Find the good value albums - show the title, the price and the number
  # of tracks.
  execute(<<-SQL)
  SELECT
    albums.title, albums.price, COUNT(*)
  FROM
    albums
  JOIN
    tracks ON tracks.album = albums.asin
  -- WHERE
  --   albums.price < 50
  -- GROUP BY
  --   tracks.album
  GROUP BY
    albums.asin -- can't use tracks.album. WHY?
  HAVING
    (albums.price / COUNT(*)) < 0.5
  SQL
end

def top_track_counts
  # Wagner's Ring cycle has an imposing 173 tracks, Bing Crosby clocks up 101
  # tracks. List the top 10 albums in order of track count. Select both the
  # album title and the track count.
  execute(<<-SQL)
  SELECT
    albums.title, COUNT(*)
  FROM
    albums
  JOIN
    tracks ON tracks.album = albums.asin
  GROUP BY
    albums.asin -- NOT tracks.album
  ORDER BY
    COUNT(*) DESC
  LIMIT 10
  SQL
end

def soundtrack_wars
  # Select the artist who has recorded the most soundtracks, as well as the
  # number of albums. HINT: use LIKE '%Soundtrack%' in your query.
  # soundtrack is a style (styles.style)
  execute(<<-SQL)
  SELECT
    albums.artist, COUNT(*)
  FROM
    albums
  INNER JOIN
    styles ON albums.asin = styles.album
  WHERE
    styles.style LIKE '%Soundtrack%'
  GROUP BY
    albums.asin
  ORDER BY
    COUNT(*) DESC
  LIMIT 1
  SQL
end

def expensive_tastes
  # Select the five styles of music with the highest average price per track,
  # along with the price per track. One or more of each aggregate functions,
  # subqueries, and joins will be required.
  execute(<<-SQL)
  SELECT
      styles.style, (SUM(albums.price) / SUM(albums.count))
    FROM
      styles
    JOIN (
      SELECT
        albums.*, COUNT(*) AS count
      FROM
        albums
      JOIN
        tracks ON albums.asin = tracks.album
      WHERE
        albums.price IS NOT NULL
      GROUP BY
        albums.asin
      ) AS albums ON styles.album = albums.asin
    GROUP BY
      styles.style
    ORDER BY (SUM(albums.price) / SUM(albums.count)) DESC
    LIMIT 5
  SQL
end
