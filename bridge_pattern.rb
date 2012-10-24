require 'math_helpers'
require 'string_helpers'

module Moveable
	attr_accessor :angle
	attr_accessor :position_x
	attr_accessor :position_y
	attr_accessor :speed_adjustment

	def go(distance)
		radians = Math.radians(self.angle)
		distance = distance * speed_adjustment
		self.position_x = position_x + Math.cos(radians) * distance
		self.position_y = position_y + Math.sin(radians) * distance
		self
	end
end

module FastMover
	include Moveable
	alias_method :old_go, :go

	def go(distance)
		self.speed_adjustment = 1.50
		old_go distance
	end
end

module SlowMover
	include Moveable
	alias_method :old_go, :go

	def go(distance)
		self.speed_adjustment = 0.75
		old_go distance
	end
end

module Turnable
	attr_accessor :angle
	attr_accessor :radius
	attr_accessor :position_x
	attr_accessor :position_y

	def turn(distance, direction, angle)
		if complete_turn? distance, angle
			end_x, end_y = Math.end_of_arc(	angle, self.radius, self.position_x, 
												self.position_y, self.angle, direction)
			self.position_x = end_x
			self.position_y = end_y
			adjust_angle direction, angle
			radians = Math.radians(self.angle)
			remaining_distance = distance - Math.arc_length(angle, self.radius)
			self.position_x = self.position_x + Math.cos(radians) * remaining_distance
			self.position_y = self.position_y + Math.sin(radians) * remaining_distance
		else
			old_angle = self.angle
			adjust_angle direction, Math.arc_angle(distance, radius)
			end_x, end_y = Math.end_of_arc(	self.angle, self.radius, self.position_x,
												self.position_y, old_angle, direction)
			self.position_x = end_x
			self.position_y = end_y
		end
		self
	end

	def adjust_angle(direction, angle)
		if direction == :right
			self.angle = self.angle - angle
		else 
			self.angle = self.angle + angle
		end
		if self.angle < 0
			self.angle = self.angle + 360
		end
		if self.angle > 360
			self.angle = self.angle - 360
		end
	end

	def complete_turn?(distance, angle)
		arc_length = Math.arc_length angle, self.radius
		return true if distance >= arc_length
		false
	end
end

module TightTurner
	include Turnable
	alias_method :old_turn, :turn

	def turn(distance, direction, angle)
		self.radius = 2
		old_turn distance, direction, angle
	end
end

module WideTurner
	include Turnable
	alias_method :old_turn, :turn

	def turn(distance, direction, angle)
		self.radius = 5
		old_turn distance, direction, angle
	end
end

class Vehicle
	include Moveable, Turnable
	attr_accessor :length

	def initialize(start_x, start_y, start_angle, move, turn)
		self.extend move.to_s.camelize.constantize
 		self.extend turn.to_s.camelize.constantize
 		self.angle = start_angle
 		self.position_x = start_x
 		self.position_y = start_y 
	end

	def location
		"X = #{position_x}, Y = #{position_y}"
	end
end

class Car < Vehicle
	def after_initialize
		self.length = 16
	end
end

class Bicycle < Vehicle
	def after_initialze
		self.length = 5
	end
end


car = Car.new(0, 0, 0, :fast_mover, :wide_turner)
car.go(50)
puts "After first move: #{car.location}"
car.turn(5,:right,45)
puts "After turn: #{car.location}"
car.go(50)
puts "After second move: #{car.location}"