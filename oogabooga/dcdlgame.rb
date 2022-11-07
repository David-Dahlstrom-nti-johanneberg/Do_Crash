require 'gosu'
require './dsLander'
require './hud'
require './floor'

class Dont_crash_do_land < Gosu::Window
   
    def initialize
        window_width = 1500
        window_height = 700
        super(window_width, window_height)
        self.caption = "dont_crash_do_land 0.1"
        # object initialization
        @lander = DSLander.new((self.width/2), (self.height/2), self.width, self.height)
        @hud = Hud.new(self)
        @floor = Floor.new(window_width, window_height)
    end

    def update
        @lander.update

        # collision
        if @lander.y >= self.height - @lander.height
            @aliveangle = ( @lander.angle <= (360/4) || @lander.angle >= -(360/4) )
            if  @aliveangle && @lander.y_vel < 20 && @lander.x_vel < 10
                puts "mortaza says you good"
            else
                puts "u suck"
            end
        end
    end

    def draw
        @floor.draw
        @lander.draw
        @hud.draw(@lander.x_vel, @lander.y_vel,@lander.angle,(self.height - @lander.y))
    end
end

game = Dont_crash_do_land.new
game.show