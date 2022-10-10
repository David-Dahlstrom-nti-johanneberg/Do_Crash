require 'gosu'

class Dont_crash_do_land < Gosu::Window
   
    def initialize
        super(1024,862)
        self.caption = "dont_crash_do_land 0.1"
        @Lander = Gosu::Image.new("../media/images/whitebox.png")
        @x = self.width/2
        @y = self.height/2
        @x_vel = 0.1
        @y_vel = 0
        @angle = 0
        @booster = 3
        @gravity = 1
    end

    def rotate_left
        @angle -= ((2*Math::PI)/100)
    end


    def rotate_right
        @angle += (2*Math::PI/100)
    end

    def accelerate

        @x_vel += (Math.sin(@angle) * @booster)
        @y_vel -= (Math.cos(@angle) * @booster)

    end

    def update

        rotate_left if Gosu.button_down? Gosu::KB_LEFT
        rotate_right if Gosu.button_down? Gosu::KB_RIGHT
        accelerate if Gosu.button_down? Gosu::KB_UP


        if @x >= 1024 - @Lander::width
            @x = @Lander::width
        elsif @x <= @Lander::width
            @x = 1024 - @Lander.width
        end

        if @y >= 862 - @Lander::height
            @aliveangle = ( @angle <= (Math::PI/4) || @angle >= -(Math::PI/4) )
            p @aliveangle
            if  @aliveangle && @y_vel < 10 && @x_vel < 10
                puts "mortaza will kiss ur feet as reward"
                @y_vel = 0
                @x_vel = 0
            else
                puts "u suck"
                @y_vel = 0
                @x_vel = 0
            end
        end


        @y_vel += @gravity
        @x += @x_vel / 60
        @y += @y_vel / 60
        
    end

    def draw
        @Lander.draw_rot(@x,@y,0,Gosu::radians_to_degrees(@angle),0.5,0.5,1,1)
    end

end

game = Dont_crash_do_land.new
game.show