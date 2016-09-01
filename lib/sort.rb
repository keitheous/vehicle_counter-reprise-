require 'pry'
require_relative 'bound'
# require_relative 'north_bound'
require 'time'

class Sort#sort into days and first_axle pairs
  attr_reader :bound_arr

  def initialize(bound)
    @bound_arr = which_bound?(bound)
  end

  def into_pairs_by_day
    day = 0
    veh_count = 1
    bound_vehicles = {}

    bound_arr.each_with_index do |line, index|
      per_vehicle_detail = []
      # a new day has rolled in - when the line lengths drop
      day += 1 if bound_arr[index].length < bound_arr[index-1].length

      if index % 2 == 0 # process a pair at a time 0-1, 2-3, 4-5, and etc
        first_axle = convert_data_to_s(line)
        first_axle_time = Time.at(first_axle).utc
        second_axle = convert_data_to_s(bound_arr[index+1])
        # axle_two_t = Time.at(axle_two).utc ??????????
        axles_difference = (second_axle - first_axle).round(4)

        bound_vehicles[veh_count] = [day, first_axle_time, first_axle, axles_difference]

        veh_count += 1
      end
    end
    bound_vehicles
  end

  private
  def which_bound?(bound)
    bound == "nb" ? Bound.new.north : Bound.new.south
  end

  def convert_data_to_s(data_ms)
    data_ms.delete('^0-9').strip.to_i / 1000.000
  end
end

a = Sort.new("anything").into_pairs_by_day
binding.pry

# for previous revisions
# storing day, time for axle 1, data index, time for axle 2, next data index, difference between time and axle 1 data
# per_vehicle_detail << day << first_axle_t << index << axle_two_t << index+1 << axle_diff << first_axle