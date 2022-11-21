require 'gosu'
require './landers'

class DSLander < Landers

    def initialize(x, y, window_width, window_height)
        color = Gosu::Color.argb(0xff_ffffff)
        super(x, y, window_width, window_height, color)
        @image = Gosu::Image.new("../media/images/death_star.png")
        @image_scale = 0.3
        @width = @image.width * @image_scale
        @height = @image.height * @image_scale
        @rotation_speed = 2
        @booster_acc = 0.7
        @assist_margins = 4
    end

    def collision_points(points_amount)
        points = []
        x = @x + (@width / 2)
        y = @y
        points << [x, y]
        points << [@x - (@x - x), y]

        for i in 1...(points_amount / 2) + 1
            angle = Math::PI / (points_amount + 1) * i
            x = @x + (Math::cos(angle) * @width / 2)
            y = @y + (Math::sin(angle) * @width / 2)
            points << [x, y]
        end

        other_side = []
        points.each do |point|
            x = @x - (point[0] - @x)
            y = point[1]
            other_side << [x, y]
        end

        if points_amount % 2 == 1
            y = @y + ( @width / 2 )
            x = @x
            points << [x, y]
        end

        other_side.reverse_each do |point|
            points << point
        end

        return points
    end

end
