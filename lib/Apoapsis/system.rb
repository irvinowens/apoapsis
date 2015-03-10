=begin
The Apoapsis system class will provide methods to allow interaction with the
underlying machine.
=end
module Apoapsis
  class System
    # Will return the load average, only will work on linux/unix (cygwin)
    # because it uses uptime

    def self.get_load_average
      map= { '1m' => nil, '5m' => nil, '15m' => nil }
      la_string=`uptime`
      parts=la_string.split(':')
      if parts.length > 1
        up_time_part=parts[3].lstrip.rstrip
        up_time_arr=[]
        if up_time_part.include?(',')
          up_time_arr=up_time_part.split(',')
        else
          up_time_arr=up_time_part.split(' ')
        end
      else
        return map
      end
      up_time_arr.each_with_index do |load,index|
        case index
          when 0
            map['1m']=load
          when 1
            map['5m']=load
          when 2
            map['15m']=load
        end
      end
      return map
    end
  end
end