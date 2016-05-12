def time_increase(timed)	
	if timed[1] < 59 && timed[0] < 24
		timed[1] += 1
	elsif timed[0] == 23 && timed[1] == 59
		timed[0] == 0
		timed[1] == 0
	else
		timed[0] += 1
		timed[1] = 0
	end	
end

def convert_time(x)
	if x.to_s.length == 1
		return "0" + x.to_s
	else
		return x.to_s
	end
end

def tell_time(timed)
	puts "#{convert_time(timed[0])}:#{convert_time(timed[1])}"
end

timed = [0,1]
tell_time(timed)
while timed != [23,59]
	timeu(timed)
	tell_time(timed)
end