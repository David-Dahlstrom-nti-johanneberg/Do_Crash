require 'gosu'

class Hud
    def initialize(x,y,x_vel,y_vel)
        @x = x
        @y = y
        @x_vel = x_vel
        @y_vel = y_vel
        @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    end

    def draw
        @font.draw("X axis velocity:#{@x}", 0, 0, 1, 1.0, 1.0, Gosu::Color::WHITE)
    end
end