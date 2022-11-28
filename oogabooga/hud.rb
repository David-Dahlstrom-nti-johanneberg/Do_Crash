require 'gosu'

class Hud
    def initialize(var, middle_x, middle_y, width, playernum)
        @font = Gosu::Font.new(var, Gosu::default_font_name, 20)
        @color = Gosu::Color::GREEN
        @playernum = playernum
        if @playernum == 2
            @hudx = (width - 150) #magic number :)
            @finishx = (middle_x + (middle_x/2))
            @winstring = "player 2 landed safely, David is alive baby!"
            @losestring = "player 2 crashed, you killed David you stupid bastard"
        else
            @hudx = 20
            @finishx = (middle_x/2)
            @winstring = "Player 1 landed safely, Mortaza survived :)"
            @losestring = "Player 1 crashed, Mortaza died, big sad"
        end
        @middle_y = middle_y
    end

    def draw(x_vel,y_vel,angle,alt)
        @font.draw_text("Player #{@playernum}", @hudx, 5, 1, 1.0, 1.0, @color, :default)
        @font.draw_text("X axis velocity:#{(x_vel).round(0)}", @hudx, 30, 1, 1.0, 1.0, @color, :default)
        @font.draw_text("Y axis velocity:#{(y_vel).round(0)}", @hudx, 55, 1, 1.0, 1.0, @color, :default)
        @font.draw_text("Rotation:#{(angle).round(0)}°", @hudx, 80, 1, 1.0, 1.0, @color, :default)
        @font.draw_text("Altitude:#{(alt).round(0)}", @hudx, 105, 1, 1.0, 1.0, @color, :default)
    end

    def draw_win
        @font.draw_text(@winstring, @finishx, @middle_y, 1, 1.0, 1.0, @color, :default )
    end

    def draw_lose
        @font.draw_text(@losestring, @finishx, @middle_y, 1, 1.0, 1.0, @color, :default )
    end  
    
    def draw_new_game
        @font.draw_text("Click [SPACE] to restart", (@middle_x), 5, 1, 1.0, 1.0, @color, :default )
    end
end
