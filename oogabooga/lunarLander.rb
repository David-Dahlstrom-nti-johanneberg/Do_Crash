require 'gosu'
require './landers'

class LunarLander < Landers

    attr_reader :width, :height

    def initialize(x, y, window_width, window_height)
        super(x, y, window_width, window_height)
        @image = Gosu::Image.new("../media/images/sprite_fake_png.jpg")
        @width = @image.width
        @height = @image.height
        @image_scale = 0.2
        @rotation_speed = 1.2
        @boosterAcc = 1.3
    end

    def lowest_point()
        pi = Math::PI
        degrees = ((@angle % 90) - 45).abs * -1 + 45
        return ( Math::sin( pi/4 ) * @width * Math::sqrt(2) * 0.2 ) / ( 2 * Math::sin( (pi / 2) + Gosu::degrees_to_radians(degrees) ) )
    end

end
