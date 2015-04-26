class Event < ActiveRecord::Base
  attr_accessible :start_date, :end_date, :time_of_day, :my_location, :dog
  belongs_to :dog

  validates :start_date, :presence => {:message => "Please enter a valid start date"}
  validates :end_date, :presence => {:message => "Please enter a valid end date"}
  validates :time_of_day, :presence => {:message => "Please enter a time of day"}
  validates :dog, :presence => {:message => "Please select the dog you want to share"}

  def color
    @num = dog_id % 10
    @colours = Array['blue','orange','green','yellow','brown','pink','purple','gray','cyan','magenta']
    if @num.between?(0,9) then @colours[@num] else 'black' end

  end
end