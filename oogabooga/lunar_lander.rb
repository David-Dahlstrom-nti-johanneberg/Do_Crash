require 'gosu'
require './landers'

class LunarLander < Landers

    #attr_reader :width, :height

    def initialize(start_x, start_y, window_width, window_height)
        color = Gosu::Color.argb(0xff_ffffff)
        image_scale = 0.2
        image = Gosu::Image.new("../media/images/sprite_fake_png.jpg")
        rotation_speed = 1.2
        booster_acc = 1.3
        super(start_x, start_y, image, window_width, window_height, color, image_scale, rotation_speed, booster_acc)
    
        @assist_margins = 2
    end

    def collision_points()
        points = []
        for i in 0...4
            radians = Gosu::degrees_to_radians(@angle - 45 + 90 * i)   # "how many degrees lander is rotated clockwise"-ish
            #radians = Gosu::degrees_to_radians( ((@angle % 90) - 45).abs * -1 + 45 )   # "how many degrees lander is rotated clockwise"-ish
            x = @x + @width * Math::sqrt(2) * Math::cos(radians) / 2
            y = @y + @width * Math::sqrt(2) * Math::sin(radians) / 2
            points << [x, y]
        end

        return points
    end

    #def lowest_point_x()
    #    pi = Math::PI
    #    #radians_bottom_to_corner = Gosu::degrees_to_radians( (((@angle + 45) % 90) - 45).abs * -1 + 45 )    # "how many degrees lander is rotated clockwise"-ish
    #    #radians_center_to_corner = Gosu::degrees_to_radians( ((@angle % 90) - 45).abs * -1 + 45 )   # "how many degrees lander is rotated clockwise"-ish
    #    #return @width * Math::sin( (pi/4) - radians_bottom_to_corner) * Math::sqrt(2) ) / ( 2 * Math::sin( (pi/4) + radians_center_to_corner) )
    #    radians_center_to_corner = Gosu::degrees_to_radians( (( (@angle - 90) % 90) - 45).abs * -1 + 45 )   # "how many degrees lander is rotated clockwise"-ish
    #    return @width / ( 2 * Math::sin( (pi/2) + radians_center_to_corner ) )
    #end

    def lowest_point_x()
        return (Math::cos(Gosu::degrees_to_radians(@angle * 2)) * (@width / 2))
    end
end
