require 'gosu'
require './landers'

class DSLander < Landers

    #attr_reader :width, :height

    def initialize(x,y,window_width,window_height)
        super(x,y,window_width,window_height)
        @image = Gosu::Image.new("../media/images/Death_star.png")
        @width = @image.width
        @height = @image.height
        @image_scale = 0.2
        @rotation_speed = 2
        @boosterAcc = 0.7
    end

    def lowest_point
        return (@y - ( @width / 2 ))
    end

end
