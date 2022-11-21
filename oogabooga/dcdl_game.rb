require 'gosu'
require './lunar_lander'
require './deathstar_lander'
require './hud'
require './floor'

class Dont_crash_do_land < Gosu::Window
   

    def initialize
        @window_width = 1100
        @window_height = 700
        super(@window_width, @window_height)
        self.caption = "dont_crash_do_land 0.1"
        # object initialization
        @angle_check = 40
        @x_vel_check = 10
        @y_vel_check = 30
        @collision_points = 20 # how accurate collisions are
      
        reset
    end

    def reset
        if rand(1..2) == 1
            @lander = LunarLander.new((self.width/2), (self.height/2), self.width, self.height)
        else
            @lander = DSLander.new((self.width/2), (self.height/2), self.width, self.height)
        end
        @hud = Hud.new(self, self.width/2, self.height/2)
        @floor = Floor.new(@window_width, @window_height)
        if @lander.is_a? DSLander
            @assist_margins = 4 # how far outside of ls you can land and still win (in pixels)
        else
            @assist_margins = 2
        end
    end

    def collision() # returns nil if no collision, true if passed collision, false otherwise
        alive = nil
        if @lander.is_a? DSLander
            points = @lander.collision_points(@collision_points)
        else
            points = @lander.collision_points()
        end
        
        passed_angle_check = @lander.angle.abs < @angle_check
        passed_vel_check = @lander.y_vel < @y_vel_check && @lander.x_vel < @x_vel_check
        lander_x1 = @lander.x - @lander.width / 2 + @assist_margins
        lander_x2 = @lander.x + @lander.width / 2 - @assist_margins
        is_in_ls = @floor.is_in_ls(lander_x1, lander_x2)
        
        points.each do |x, y|
            if y >= @floor.y(x)
                if passed_angle_check && passed_vel_check && is_in_ls
                    alive = true
                else
                    return false
                end
            end
        end

        return alive
    end

    def update
        if collision() == nil
            @lander.update
        end
       
    end

    def button_down(id)
        reset if id == Gosu::KB_SPACE
    end

    def draw
        @floor.draw
        @lander.draw
        @hud.draw(@lander.x_vel, @lander.y_vel,@lander.angle,(self.height - @lander.y))

        if collision() == true
            @hud.draw_win
            @hud.draw_new_game
        elsif collision() == false
            @hud.draw_lose
            @hud.draw_new_game
        end

        # debug
        color = Gosu::Color.argb(0xff_0000ff)
        if @lander.is_a? DSLander
            points = @lander.collision_points(@collision_points)
        else
            points = @lander.collision_points()
        end
        # x
        points.each do |point|
            Gosu::draw_line(point[0], point[1], color, point[0], @floor.y(point[0]), color)
        end
        
        #x = @lander.x + @lander.lowest_point_x()
        #Gosu::draw_line(0, y, color, @window_width, y, color)
        #Gosu::draw_line(x, 0, color, x, @window_height, color)

        #if collision() == 1
        #    @hud.draw_Win
        #elsif collision() == 2
        #    @hud.draw_Lose
        #end
    end
end

game = Dont_crash_do_land.new
game.show
