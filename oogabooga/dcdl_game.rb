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
        @angle_check = 10
        @x_vel_check = 8
        @y_vel_check = 20
        @collision_points = 20 # how accurate collisions are
        @song = Gosu::Song.new("../media/music/space.mp3")
        @song.play(false)
      
        reset
    end

    def reset
        @lunar_lander = LunarLander.new((self.width/2), (self.height/2), self.width, self.height)
        @ds_lander = DSLander.new((self.width/2), (self.height/2), self.width, self.height)
        @hud = Hud.new(self, self.width/2, self.height/2)
        @floor = Floor.new(@window_width, @window_height)
    end

    def collision(lander) # returns nil if no collision, true if passed collision, false otherwise
        alive = nil
        if lander.is_a? DSLander
            points = lander.collision_points(@collision_points)
        else
            points = lander.collision_points()
        end
        
        passed_angle_check = lander.angle.abs < lander.angle_check
        passed_vel_check = lander.y_vel < @y_vel_check && lander.x_vel < @x_vel_check
        lander_x1 = lander.x - (lander.width / 2) + lander.assist_margins
        lander_x2 = lander.x + (lander.width / 2) - lander.assist_margins
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
        ds_lander_collision = collision(@ds_lander)
        lunar_lander_collision = collision(@lunar_lander)
        
        if ds_lander_collision == nil
            @ds_lander.update
        end
        
        if lunar_lander_collision == nil
            @lunar_lander.update
        end
    end

    def button_down(id)
        reset if id == Gosu::KB_SPACE
    end

    def draw
        @floor.draw
        @lander.draw
        alt = @floor.y(@lander.x) - @lander.y - (@lander.height/2)
        @hud.draw(@lander.x_vel, @lander.y_vel, @lander.angle, alt)

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
            points.each do |point|
                Gosu::draw_line(point[0], point[1], color, point[0], @floor.y(point[0]), color)
            end
        end        
    end
end

game = Dont_crash_do_land.new
game.show
