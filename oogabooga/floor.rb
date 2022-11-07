require 'gosu'

class Floor


  # ls = Landing Spot

  def initialize(window_width, window_height)
    @color = Gosu::Color.argb(0xff_ffffff)  # For Gosu::draw_line() arg
    @color_red = Gosu::Color.argb(0xff_ff0000)  # (0xAA_RRGGBB)
    @window_width = window_width
    @window_height = window_height
    @ls_count = 0   # will be used by methods later           
    @ls = []  # 2D array [[x-start, x-end, y-height, difficulty-level], ... [...]]
    # ls generation creates divisions in window width
    # and margin tells how far from these divisions the ls have to be
    @margin = 50
    # ls widht of difficulties in pixels
    @high_diff_widht = 20
    @mid_diff_width = 30
    @low_diff_width = 50
    # lowest and highest amount of ls for each difficulty
    @high_diff_count = [1, 2]
    @mid_diff_count = [1, 2]
    @low_diff_count = [1, 2]

    @max_ls_count = @high_diff_count[1] + @mid_diff_count[1] + @low_diff_count[1]
    # lowest and highest height (from bottom) ls can be in pixels
    @min_height = 10
    @max_height = window_height / 4
    # where terrain start on y-axis on left and right of screen
    @terrain_left_y = rand(@min_height..@max_height)
    @terrain_right_y = rand(@min_height..@max_height)

    generate_ls()
  end

  # desc:
  # checks how many landing spots you can have if all landing spots are lowest difficulty (widest)
  # value depends on the width (in px) of a margin, the window, and the lowest diff ls.
  # return: [int] max amount of possible landing spots for object attributes
  private def ls_amountCheck()
    # for n..infinity:
    # n divisions in window_width (calc division_width):
    # break if: (division_width - margins) <= smallest_ls_width
  
    divisions = 1
    loop do
      break if (@window_width / (divisions + 1)) - 2 * @margin <= @low_diff_width
      divisions += 1
    end

    max_ls_count = divisions - 1
    return max_ls_count
  end

  # desc:
  # procedurally generates the landing spot positions for this object 
  # return: void
  private def generate_ls()
    # 0. check if ls will fit if maximum amount of ls is used
    if ls_amountCheck() < @max_ls_count
      raise "Error, not enough window width for #{@max_ls_count} landing spots."
    end

    # 1. generate amount of landing spots (for each difficulty)
    
    # @foo_diff_count is a range of how many ls of a diffculty there COULD be [lower_bound, upper_bound]
    high_diff_count = rand(@high_diff_count[0]..@high_diff_count[1])
    mid_diff_count = rand(@mid_diff_count[0]..@mid_diff_count[1])
    low_diff_count = rand(@low_diff_count[0]..@low_diff_count[1])
    @ls_count = high_diff_count + mid_diff_count + low_diff_count

    # 2. divide window width with amount of landing spots and create margins
    division_width = @window_width / @ls_count
    potential_ls_areas = []  # 2D array [[start, end], ... [...]]
    for i in 0...@ls_count
      potential_ls_areas << [division_width * i + @margin, division_width * (i + 1) - @margin]
    end

    # 3. randomly place landing spots inside margins
    difficulty_count = { 1 => low_diff_count, 2 => mid_diff_count, 3 => high_diff_count}
    difficulty_widths = { 1 => @low_diff_width, 2 => @mid_diff_width, 3 => @high_diff_widht}
    tmp_ls_count = @ls_count
    
    loop do
      difficulty = rand(1..3)  # rand difficulty for ls
      if difficulty_count[difficulty] > 0  # check if not too many ls for a difficulty are created
        height = rand(@min_height..@max_height)  # rand height for ls
        
        # generate rand position (x1 and x2) for ls in potential_ls_area
        #x1
        left_bound = potential_ls_areas[tmp_ls_count - 1][0]
        right_bound = potential_ls_areas[tmp_ls_count - 1][1] - difficulty_widths[difficulty]
        x1 = rand(left_bound..right_bound)
        #x2
        x2 = x1 + difficulty_widths[difficulty]
        
        # @ls format: 2D array [[start, end, height, difficulty], ... [...]]
        @ls << [x1, x2, height, difficulty]
        
        difficulty_count[difficulty] -= 1
        tmp_ls_count -= 1
      end

      break if tmp_ls_count < 1
    end

    @ls.reverse!
  end

  private def draw_ls()
    # @ls format: 2D array [[start, end, height, difficulty], ... [...]]
    for i in 0...@ls.length
        ls = @ls[i]
        Gosu::draw_line(ls[0], @window_height - ls[2], @color_red, ls[1], @window_height - ls[2], @color_red)
        # Gosu::draw_line(x1, y1, color, x2, y2, color)
    end
  end

  private def draw_terrain()
    # ls starts from right to left landing spot
    # @ls format: 2D array [[start, end, height, difficulty], ... [...]]
    for i in 0..@ls.length
        if i == 0
            y1 = @window_height - @terrain_left_y
            x1 = 0
        else
            y1 = @window_height - @ls[i - 1][2]
            x1 = @ls[i - 1][1]
        end

        if i == @ls.length
            y2 = @window_height - @terrain_right_y
            x2 = @window_width - 1
        else
            y2 = @window_height - @ls[i][2]
            x2 = @ls[i][0]
        end

        Gosu::draw_line(x1, y1, @color, x2, y2, @color)
        # Gosu::draw_line(x1, y1, color, x2, y2, color)
    end
  end
  
  def draw
    draw_ls()
    draw_terrain()
  end
end
