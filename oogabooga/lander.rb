require 'gosu'

class Lander

    attr_reader :x, :y, :x_vel, :y_vel, :angle, :width, :height

    def initialize(x,y,window_width,window_height)
        @window_width = window_width
        @window_height = window_height
        @image = Gosu::Image.new("../media/images/sprite_fake_png.jpg")
        @width = @image.width
        @height = @image.height
        # position: pixels; velocity: pixels per second; angle: degrees;
        # rotation_speed: degrees per second ;acceleration: pixels per second^2
        @x = x
        @y = y
        @x_vel = 0          # initial velocity
        @y_vel = 0
        @angle = 0          # right is positive; left is negative
        # adjustment attributes
        @boosterAcc = 1.3
        @gravityAcc = 0.5
        @rotation_speed = 1.2
    end

    def rotate_left
        @angle -= @rotation_speed
    end

    def rotate_right
        @angle += @rotation_speed
    end

    def accelerate
        angle_radians = Gosu::degrees_to_radians(@angle)
        @x_vel += (Math.sin(angle_radians) * @boosterAcc)
        @y_vel -= (Math.cos(angle_radians) * @boosterAcc)
    end

    def update
        rotate_left if Gosu.button_down? Gosu::KB_LEFT
        rotate_right if Gosu.button_down? Gosu::KB_RIGHT
        accelerate if Gosu.button_down? Gosu::KB_UP

        @y_vel += @gravityAcc
        @x += @x_vel / 60
        @y += @y_vel / 60

        if @x >= @window_width - @width
            @x = @width
        elsif @x <= @width
            @x = (@window_width - @width)
        end
    end

    private def deg_to_rad(degrees)
        return (Math::PI * degrees / 180)
    end

    def lowest_point()
        pi = Math::PI
        p Math.sin(Math::PI/4)
        return ( Math::sin( pi/4 ) * @width * Math::sqrt(2) ) / ( 2 * Math::sin( (pi / 2) + deg_to_rad(@angle) ) )
    end

    def draw
        blue = Gosu::Color.argb(0xff_0000ff)
        line_y = @y + lowest_point()
        Gosu::draw_line(0, line_y,blue ,@window_width, line_y,blue)
        @image.draw_rot(@x, @y, 0, @angle, 0.5, 0.5, 0.2, 0.2)
    end

end