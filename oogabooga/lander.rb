require 'gosu'

class Lander

    attr_reader :x, :y, :x_vel, :y_vel, :angle, :width, :height

    def initialize(x,y,window_width,window_height)
        @window_width = window_width
        @window_height = window_height
        @image = Gosu::Image.new("../media/images/whitebox.png")
        @width = @image.width
        @height = @image.height
        # position: pixels; velocity: pixels per second;
        # angle: degrees per second ;acceleration: pixels per second^2
        @x = x
        @y = y
        @x_vel = 0          # initial velocity
        @y_vel = 0
        @angle = 0          # right is positive; left is negative
        @boosterAcc = 2
        @gravityAcc = 1  
    end

    def rotate_left
        @angle -= (360/100)
    end

    def rotate_right
        @angle += (360/100)
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

    def draw
        @image.draw_rot(@x,@y,0,@angle,0.5,0.5,1,1)
    end

end