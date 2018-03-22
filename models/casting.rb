require_relative("../db/sql_runner")
require_relative("star")
require_relative("movie")

class Casting

  attr_reader :id
  attr_accessor :star_id, :movie_id, :fee

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @star_id = options['star_id'].to_i
    @movie_id = options['movie_id'].to_i
    @fee = options['fee'].to_i
  end

  def save()
    sql = "INSERT INTO castings
    (
      star_id,
      movie_id,
      fee
    )
    VALUES
    (
      $1, $2, $3
    )
    RETURNING id"
    values = [@star_id, @movie_id, @fee]
    casting = SqlRunner.run( sql,values ).first
    @id = casting['id'].to_i
  end

  def update()
    sql = 'UPDATE castings SET star_id=$1, movie_id=$2, fee=$3 WHERE id=$4'
    values = [@star_id,@movie_id,@fee,@id]
    SqlRunner.run(sql,values)
  end


  def self.all()
    sql = "SELECT * FROM castings"
    casting = SqlRunner.run(sql)
    return casting.map{|x| Casting.new(x)}
  end

  def self.delete_all()
   sql = "DELETE FROM castings"
   SqlRunner.run(sql)
  end


end
