require 'gosu'

class Landers

    attr_reader :x, :y, :x_vel, :y_vel, :angle, :width, :height

    def initialize(x, y, window_width, window_height)
        @window_width = window_width
        @window_height = window_height
        # position: pixels; velocity: pixels per second; angle: degrees;
        # rotation_speed: degrees per second ;acceleration: pixels per second^2
        @x = x
        @y = y
        @x_vel = 0          # initial velocity
        @y_vel = 0
        @angle = 0          # right is positive; left is negative
        # adjustment attributes
        @gravityAcc = 0.5
    end

    private def rotate_left
        @angle -= @rotation_speed
    end

    private def rotate_right
        @angle += @rotation_speed
    end

    private def accelerate
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

    def draw
        # blue = Gosu::Color.argb(0xff_0000ff)
        # line_y = @y + lowest_point()
        # Gosu::draw_line(0, line_y,blue ,@window_width, line_y,blue)

        # draw_rot(x, y, z, angle, center_x, center_y, factor-x, factor-y)
        @image.draw_rot(@x, @y, 0, @angle, 0.5, 0.5, @image_scale, @image_scale)
    end

end
