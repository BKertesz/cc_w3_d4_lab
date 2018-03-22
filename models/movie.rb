require_relative("../db/sql_runner")
require_relative('star')
require('pry')

class Movie

  attr_reader :id
  attr_accessor :title, :genre, :rating

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @rating = options['rating'].to_i
    @budget = options['budget'].to_i
  end

  def save()
    sql = "INSERT INTO movies
    (
      title,
      genre,
      rating
    )
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id"
    values = [@title,@genre,@rating]
    location = SqlRunner.run( sql, values ).first
    @id = location['id'].to_i
  end

  def update()
    sql = 'UPDATE movies SET title=$1, genre=$2, rating=$3 WHERE id=$4'
    values = [@title,@genre,@rating,@id]
    SqlRunner.run(sql,values)
  end

  def self.all()
    sql = "SELECT * FROM movies"
    movies = SqlRunner.run(sql)
    return movies.map{ |x| Movie.new(x)}
  end

  def self.delete_all()
    sql = "DELETE FROM movies"
    SqlRunner.run(sql)
  end

  def stars()
    sql = "SELECT stars.*
    FROM stars
    INNER JOIN castings
    ON castings.star_id = stars.id
    WHERE movie_id = $1"
    values = [@id]
    stars = SqlRunner.run(sql, values)
    return stars.map{|x| Star.new(x)}
  end

  def remaining_budget()
    spend = 0

    sql = 'SELECT castings.* FROM castings
    INNER JOIN movies
    ON movies.id = castings.movie_id
    WHERE movie_id = $1;
    '
    values = [@id]
    fees = SqlRunner.run(sql,values)

    spending = fees.map{|x| Casting.new(x)}

    spending.each{|x| spend += x.fee}

    return @budget - spend
  end


end
