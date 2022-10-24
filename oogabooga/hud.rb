require 'gosu'

class Hud
    def initialize(var)
        @font = Gosu::Font.new(var, Gosu::default_font_name, 20)
        @color = Gosu::Color::WHITE
    end

    def draw(x_vel,y_vel)
        @font.draw("X axis velocity:#{x_vel}", 20, 0, 1, 1.0, 1.0,@color)
        @font.draw("Y axis velocity:#{y_vel}", 20, 25, 1, 1.0, 1.0,@color)
    end
end