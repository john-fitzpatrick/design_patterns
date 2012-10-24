module Math
	class << self
		def radians(angle)
			angle / 180.0 * Math::PI
		end

		def arc_length(angle, radius)
			x = angle / 360.0 * 2 * Math::PI * radius
		end

		def arc_angle(distance, radius)
			360 * (distance / 2.0 * Math::PI * radius)
		end

		def end_of_arc(angle, radius, start_x, start_y, start_angle, direction)
			reverse = (direction == :right ? -1 : 1)
			origin_x = start_x + radius * (-sin(start_angle))
			origin_y = start_y + radius * reverse * (cos(start_angle))
			end_x = origin_x + radius * (cos(angle-90))
			end_y = origin_y + radius * reverse * (sin(angle-90))
			[end_x, end_y]
		end
	end
end