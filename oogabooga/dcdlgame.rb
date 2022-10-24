require 'gosu'
require './lander'
require './hud'

class Dont_crash_do_land < Gosu::Window
   
    def initialize
        super(1024,862)
        self.caption = "dont_crash_do_land 0.1"
        @lander = Lander.new((self.width/2), (self.height/2), self.width, self.height)
        @hud = Hud.new(self)
    end

    def update

        @lander.update

        if @lander.y >= self.height - @lander.height
            @aliveangle = ( @lander.angle <= (360/4) || @lander.angle >= -(360/4) )
            if  @aliveangle && @lander.y_vel < 20 && @lander.x_vel < 10
                puts "mortaza will kiss ur feet as reward"
            else
                puts "u suck"
            end
        end
    end

    def draw
        @lander.draw
        @hud.draw(@lander.x_vel, @lander.y_vel)
    end
end

game = Dont_crash_do_land.new
game.show