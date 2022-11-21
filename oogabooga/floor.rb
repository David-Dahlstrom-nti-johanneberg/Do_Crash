require 'gosu'

class Floor
	# ls = Landing Spot

	def initialize(window_width, window_height)
		@color_terrain = Gosu::Color.argb(0xff_ffffff)    # For Gosu::draw_line() arg
		@color_ls = Gosu::Color.argb(0xff_ff0000)    # (0xAA_RRGGBB)
		
		@window_width = window_width
		@window_height = window_height
		@ls = []    # 2D array [[x1, x2, y, difficulty-level], ... [...]]
		@terrain_lines = [] # 2D array [[x1, x2, y1, y2], ... [...]]
		# ls generation creates divisions in window width
		# and margin tells how far from these divisions the ls have to be
		@margin = 40
		# ls widht of difficulties in pixels
		@diff_width = (Struct.new :low, :mid, :high).new 55, 45, 40
		# lowest and highest amount of ls for each difficulty    
		@diff_count = (Struct.new :low, :mid, :high).new [1, 2], [1, 2], [1, 2]
		# lowest and highest height (from bottom) ls can be in pixels
		@min_height = 10
		@max_height = window_height / 3

		generate_ls()
		generate_terrain()
	end

	# desc:
	# checks how many landing spots you can have if all landing spots are lowest difficulty (widest)
	# value depends on the width (in px) of a margin, the window, and the lowest diff ls.
	# return: [int] max amount of possible landing spots for object attributes
	private def ls_amount_check()
		# for n..infinity:
		# n divisions in window_width (calc division_width):
		# break if: (division_width - margins) <= smallest_ls_width
		
		divisions = 1
		while (@window_width / (divisions + 1)) - 2 * @margin > @diff_width.low
			divisions += 1
		end

		max_ls_count = divisions - 1

		worst_case_ls_count = @diff_count.high[1] + @diff_count.mid[1] + @diff_count.low[1]
		if max_ls_count < worst_case_ls_count
			raise "Error, not enough window width for #{worst_case_ls_count} landing spots."
		end
	end

	# desc:
	# procedurally generates the landing spot positions for this object (modifies @ls)
	# return: void
	private def generate_ls()
		# 0. check if ls will fit if maximum amount of ls is used
		ls_amount_check()

		# 1. generate amount of landing spots (for each difficulty)
		# @foo_diff_count is a range of how many ls of a diffculty there COULD be [lower_bound, upper_bound]
		high_diff_count = rand(@diff_count.high[0]..@diff_count.high[1])
		mid_diff_count = rand(@diff_count.mid[0]..@diff_count.mid[1])
		low_diff_count = rand(@diff_count.low[0]..@diff_count.low[1])
		ls_count = high_diff_count + mid_diff_count + low_diff_count

		# 2. divide window width with amount of landing spots and create margins
		division_width = @window_width / ls_count
		potential_ls_areas = []   # 2D array [[start, end], ... [...]]
		for i in 0...ls_count
			potential_ls_areas << [division_width * i + @margin, division_width * (i + 1) - @margin]
		end

		# 3. randomly place landing spots inside margins
		difficulty_count = { 1 => low_diff_count, 2 => mid_diff_count, 3 => high_diff_count}
		difficulty_widths = { 1 => @diff_width.low, 2 => @diff_width.mid, 3 => @diff_width.high}
		
		while ls_count > 0
			difficulty = rand(1..3)   # rand difficulty for ls
			if difficulty_count[difficulty] > 0   # check if not too many ls for a difficulty are created
				height = rand(@min_height..@max_height)   # rand height for ls
				
				# generate rand position (x1 and x2) for ls in potential_ls_area
				#x1
				left_bound = potential_ls_areas[ls_count - 1][0]
				right_bound = potential_ls_areas[ls_count - 1][1] - difficulty_widths[difficulty]
				x1 = rand(left_bound..right_bound)
				#x2
				x2 = x1 + difficulty_widths[difficulty]
				
				# @ls format: 2D array [[start, end, height, difficulty], ... [...]]
				@ls << [x1, x2, height, difficulty]
				
				difficulty_count[difficulty] -= 1
				ls_count -= 1
			end
		end

		@ls.reverse!
	end

	private def generate_terrain()
		# ls starts from left to right landing spot
		# @ls format: 2D array [[start, end, height, difficulty], ... [...]]
		for i in 0..@ls.length # 1 more terrain_lines than landing spots therefore .. not ...
			if i == 0
				y1 = rand(@min_height..@max_height)
				x1 = 0
			else
				y1 = @ls[i - 1][2]	# [x1, x2, ->y, d] from @ls
				x1 = @ls[i - 1][1]	# [x1, ->x2, y, d]
			end

			if i == @ls.length
				y2 = rand(@min_height..@max_height)
				x2 = @window_width
			else
				y2 = @ls[i][2]	# [x1, x2, ->y, d]
				x2 = @ls[i][0]	# [->x1, x2, y, d]
			end

			@terrain_lines << [x1, x2, y1, y2]
		end
	end

	private def draw_ls()
		# @ls format: 2D array [[start, end, height, difficulty], ... [...]]
		@ls.each do |ls|
			# Gosu::draw_line(x1, y1, color, x2, y2, color)
			Gosu::draw_line(ls[0], @window_height - ls[2], @color_ls, ls[1], @window_height - ls[2], @color_ls)
		end
	end

	private def draw_terrain()
		@terrain_lines.each do |x1, x2, y1, y2|
			# Gosu::draw_line(x1, y1, color, x2, y2, color)
			Gosu::draw_line(x1, @window_height - y1, @color_terrain, x2, @window_height - y2, @color_terrain)
		end
	end
	
	private def find_terrain_for_x(x)
		# 2D array [[x1, x2, y1, y2], ... [...]]
		for i in 0...@terrain_lines.length
			if @terrain_lines[i][0] <= x && x <= @terrain_lines[i][1]
				return i
			end
		end

		return nil
	end

	private def find_ls_for_x(x)
		# 2D array [[x1, x2, y, difficulty-level], ... [...]]
		i = 0
		@ls.each do |x1, x2|
			if x1 <= x && x <= x2
				return i
			end
			i += 1
		end

		return nil
	end

	# desc:
	# for a line defined by x1 & x2, is it inside a landing spot? (does not consider y-value)
	# return: bool
	def is_in_ls(x1, x2)
		@ls.each do |ls_x1, ls_x2|
			# ls: [x1, x2, y, d]
			if x1 > ls_x1 && x2 < ls_x2
				return true
			end
		end

		return false
	end

	# desc:
	# returns y of terrain (y = 0 on top of window)
	def y(x)
		element_in_arr = find_terrain_for_x(x)
		if element_in_arr == nil
			element_in_arr = find_ls_for_x(x)
			# ls: 2D array [[x1, x2, y, difficulty-level], ... [...]]
			return @window_height - @ls[element_in_arr][2]
		end

		# terrain_lines = [[x1, x2, y1, y2] ... [...]]
		# if over terrain
		# y = kx + m

		# finding k = dy/dx
		terrain_line = @terrain_lines[element_in_arr]

		k = (terrain_line[3] - terrain_line[2]) / (terrain_line[1] - terrain_line[0]).to_f
		# finding m = y - kx
		m = terrain_line[2] - (terrain_line[0] * k)

		return @window_height - (k * x + m)
	end
	
	def draw
		draw_ls()
		draw_terrain()
	end
end
