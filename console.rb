require_relative("models/casting")
require_relative("models/movie")
require_relative("models/star")
require('pry')

Casting.delete_all()
Movie.delete_all()
Star.delete_all()
# binding.pry
# nil

star1 = Star.new({'first_name'=>'Brad','last_name'=>'Pitt'})
star2 = Star.new({'first_name'=>'Angelina','last_name'=>'Jolie'})
star1.save()
star2.save()

movie1 = Movie.new({'title'=>'Mr.&Mrs. Smith','genre'=>'comedy','rating'=>'7','budget'=>'1000000'})
movie1.save

casting1 = Casting.new({'star_id'=>star1.id,'movie_id'=>movie1.id,'fee'=>45000})
casting2 = Casting.new({'star_id'=>star2.id,'movie_id'=>movie1.id,'fee'=>55000})
casting1.save
casting2.save

p movie1.remaining_budget


# p movie1.stars
# p star1.movies

# EOF
