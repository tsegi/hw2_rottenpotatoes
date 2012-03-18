class Movie < ActiveRecord::Base
  
  def self.all_ratings
    self.select(:rating).order(:rating).map(&:rating).uniq
  end
  
end
