require 'gosu'

class Floor
    def initialize(window_width, window_height)
        @color = Gosu::Color.argb(0xff_ffffff)
        @window_width = window_width
        @window_height = window_height
        @ls_count = 0                       # ls = Landing Spot
        @ls = []                            # 2D array [[start, end, height, difficulty], ... [...]]
        @margin = 10            # ls generation creates divisions in window width
                                # and margin tells how far from these divisions the ls have to be
        @high_diff_widht = 10   # ls widht of difficulties in pixels
        @mid_diff_width = 20
        @low_diff_width = 30
        
    end

    def ls_amountCheck()
        max_ls_count = 0
        loop do
            break if (@window_width / (max_ls_count + 1)) - 2 * @margin =< @low_diff_width
            max_ls_count++
        end

        return ls_count - 1
    end

    
    def generate_ls()
        # 0. check window width with ls difficulties count, if they would all fit.

        # 1. generate amount of landing spots (for each difficulty)
        ls_diff_high = rand(1..2)
        ls_diff_med = rand(1..2)
        ls_diff_low = rand(1..2)
        @ls_count = ls_diff_high + ls_diff_med + ls_diff_low

        # 2. divide window width with amount of landing spots and create margins
        potential_ls_width = window_width / @ls_count
        potential_ls = []
        for i in 0...@ls_count
            potential_ls << [potential_ls_wdith * i + @margin, potential_ls_wdith * (i + 1) - @margin]
        end

        # 3. randomly place landing spots inside margins

        for i in 0...@landing_spots
            landing_difficulty = rand(1..3)
            if (landing_difficulty == 1)
            
        end

        return ls
    end

    def draw
        Gosu::draw_line(x1, y1, color, x2, y2, color)
    end
end
