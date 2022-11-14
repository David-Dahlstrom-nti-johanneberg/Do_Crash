require 'gosu'
require './lunarLander'
require './dsLander'
require './hud'
require './floor'

class Dont_crash_do_land < Gosu::Window
   
    def initialize
        @window_width = 1500
        @window_height = 700
        super(@window_width, @window_height)
        self.caption = "dont_crash_do_land 0.1"
        # object initialization
        if rand(2..2) > 1
            @lander = LunarLander.new((self.width/2), (self.height/2), self.width, self.height)
        else
            @lander = DSLander.new((self.width/2), (self.height/2), self.width, self.height)
        end
        @hud = Hud.new(self, self.width/2, self.height/2)
        @floor = Floor.new(@window_width, @window_height)
    end

    def collision
        if @lander.y >= self.height - @lander.height
            @alive_angle = @lander.angle.abs < (360/4)
            if  @aliveangle && @lander.y_vel < 30 && @lander.x_vel < 10               
                return 1
            else
                return 2
            end
        else
            return 0
        end
    end

    def update
        if collision == 0
            @lander.update
        end
    end

    def draw
        @floor.draw
        @lander.draw
        @hud.draw(@lander.x_vel, @lander.y_vel,@lander.angle,(self.height - @lander.y))

        color = Gosu::Color.argb(0xff_0000ff)
        y = @lander.y + @lander.lowest_point()
        Gosu::draw_line(0, y, color, @window_width, y, color)
        
        if collision == 1
            @hud.draw_Win
        elsif collision == 2
            @hud.draw_Lose
        end
    end
end

game = Dont_crash_do_land.new
game.show
