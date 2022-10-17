require 'gosu'
require './lander'

class Dont_crash_do_land < Gosu::Window
   
    def initialize
        super(1024,862)
        self.caption = "dont_crash_do_land 0.1"
        @lander = Lander.new((self.width/2), (self.height/2))
    end

    def update
        if @lander.x >= self.width - @lander.width
            @lander.x = @lander.width
        elsif @lander.x <= @lander.width
            @lander.x = (self.width - @lander.width)
        end

        if @lander.y >= self.height - @lander.height
            @aliveangle = ( @lander.angle <= (360/4) || @lander.angle >= -(360/4) )
            p @aliveangle
            if  @aliveangle && @lander.y_vel < 10 && @lander.x_vel < 10
                puts "mortaza will kiss ur feet as reward"
                @lander.y_vel = 0
                @lander.x_vel = 0
            else
                puts "u suck"
                @lander.y_vel = 0
                @lander.x_vel = 0
            end
        end

        @lander.update
    end

    def draw
        @lander.draw
    end
end

game = Dont_crash_do_land.new
game.show