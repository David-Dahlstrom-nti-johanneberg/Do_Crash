require 'gosu'

class Landers

    attr_reader :x, :y, :x_vel, :y_vel, :angle, :width

    def initialize(x, y, window_width, window_height, color)
        @color = color
        @window_width = window_width
        @window_height = window_height
        # x & y: right -> positive & down -> positive
        # position: pixels; velocity: pixels per second; angle: degrees;
        # rotation_speed: degrees per second ;acceleration: pixels per second^2
        @x = x
        @y = y
        @x_vel = 0          # initial velocity
        @y_vel = 0
        @angle = 0          # right is positive; left is negative
        # adjustment attributes
        @gravity_acc = 0.5
    end

    private def rotate_left
        @angle -= @rotation_speed
    end

    private def rotate_right
        @angle += @rotation_speed
    end

    private def accelerate
        angle_radians = Gosu::degrees_to_radians(@angle - 90)   # - 90 to match where degrees start in unit circle
        @x_vel += (Math.cos(angle_radians) * @booster_acc)
        @y_vel += (Math.sin(angle_radians) * @booster_acc)
    end

    def update
        rotate_left if Gosu.button_down? Gosu::KB_LEFT
        rotate_right if Gosu.button_down? Gosu::KB_RIGHT
        accelerate if Gosu.button_down? Gosu::KB_UP

        @y_vel += @gravity_acc
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
        # #draw_rot(x, y, z = 0, angle = 0, center_x = 0.5, center_y = 0.5, scale_x = 1, scale_y = 1, color = 0xff_ffffff
        @image.draw_rot(@x, @y, 0, @angle, 0.5, 0.5, @image_scale, @image_scale, @color)
    end

end
