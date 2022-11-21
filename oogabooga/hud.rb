require 'gosu'

class Hud
    def initialize(var, middle_x, middle_y)
        @font = Gosu::Font.new(var, Gosu::default_font_name, 20)
        @color = Gosu::Color::GREEN
        @middle_x = middle_x
        @middle_y = middle_y
    end

    def draw(x_vel,y_vel,angle,alt)
        @font.draw_text("X axis velocity:#{(x_vel).round(0)}", 20, 5, 1, 1.0, 1.0, @color, :default)
        @font.draw_text("Y axis velocity:#{(y_vel).round(0)}", 20, 30, 1, 1.0, 1.0, @color, :default)
        @font.draw_text("Rotation:#{(angle).round(0)}°", 20, 55, 1, 1.0, 1.0, @color, :default)
        @font.draw_text("Altitude:#{(alt).round(0)}", 20, 80, 1, 1.0, 1.0, @color, :default)
    end

    def draw_win
        @font.draw_text("You win, mortaza is safe", @middle_x, @middle_y, 1, 1.0, 1.0, @color, :default )
    end

    def draw_lose
        @font.draw_text("You Lose, mortaza died, big sad", @middle_x, @middle_y, 1, 1.0, 1.0, @color, :default )
    end  
    
    def draw_new_game
        @font.draw_text("Click [SPACE] to restart", (@middle_x), (@middle_y + 25), 1, 1.0, 1.0, @color, :default )
    end
end
