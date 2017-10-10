%---*** The University of Texas at Dallas ***---%
%--- simple Automated driving actions using s(ASP) system ----%
%--- created by Akshay Rawat (axr162930@utdallas.edu) ---%


%--- Traffic signal lights---%
_signal(green_l,left).
_signal(green_r,right).
_signal(green_nf,not_flashing).
_signal(red, not_flashing).
_signal(red,flashing).
_signal(yellow_nf,not_flashing).
_signal(yellow_f, flashing).
_signal(green_nf, not_flashing).
_signal(yellow_l, left).
_signal(yellow_r, right).
_signal(green_l, left).
_signal(green_r, right).

%--- Signposts and Pedestrian ---%
_sign(sstop).
_sign(sschool).
_sign(syield).
_sign(pedestrian).

%--- Right and Left Lane---%
_left_lane(clear_l).
_left_lane(busy_l).
_right_lane(clear_r).
_right_lane(busy_r).

%---Weather ---%
_weather(rain).
_weather(clear).

%---Sunlight ---%
_time(dark).
_time(light).

%---Taking input through the sensors ---%
%---A = type, W = weather, T = Time, X = input for type, B = intersection, Y = result ---%
_sensor(A,W,T,X,B,Y) :- A @=< signal, _signal(X,Z), _decide(X,B,Y), car(Y), wipers(Ws, W), headlights(Ts, T).
_sensor(A,W,T,X,B,Y) :- A @=< sign, _sign(X), _decide(X,B,Y), car(Y), wipers(Ws, W), headlights(Ts, T).
_sensor(A,W,T,X,B,Y) :- A @=< right, _right_lane(X), _decide(X,B,Y), car(Y), wipers(Ws, W), headlights(Ts, T).
_sensor(A,W,T,X,B,Y) :- A @=< left, _left_lane(X), _decide(X,B,Y), car(Y), wipers(Ws, W), headlights(Ts, T).

%---Brakes-stop or slow ---%
brakes(full).
brakes(half).

%---Accelerator ---%
accelerator(applied).

%---Indicator-left or right ---%
indicator(on).

%---Steering-clockwise or anticlockwise ---%
steer(clkORanti).
%steer(anticlockwise).

%---Wipers-on incase of rain ---%
wipers(on, rain).
wipers(off, clear).

%---Headlights-on during dark ---%
headlights(on, dark).
headlights(off, light).

%---Intersection-checks if it is busy (car or pedestrian) ---%
intersection(clear).
intersection(busy).

%---Signals-red, yellow or green ---%
_decide(red, _, stop) :- _signal(red, not_flashing).
_decide(red, _, stop) :- _signal(red, flashing).
%_decide(red, _, move) :- _signal(red, flashing), intersection(clear), _decide(car,stop).
_decide(yellow_nf, _, slow) :- _signal(yellow_nf, not_flashing).
_decide(yellow_f, busy, yield) :- _signal(yellow_f, flashing), intersection(busy).
_decide(yellow_f, clear, move) :- _signal(yellow_f, flashing), intersection(clear).
_decide(green_nf, busy, yield) :- _signal(green_nf, not_flashing), intersection(busy).
_decide(green_nf, clear, move) :- _signal(green_nf, not_flashing), intersection(clear).

%---Arrow signals-left and right ---%
_decide(yellow_l, busy, yield_a) :- _signal(yellow_l, left), intersection(busy).
_decide(yellow_r, busy, yield_a) :- _signal(yellow_r, right), intersection(busy).
_decide(green_l, busy, yield_a) :- _signal(green_l, left), intersection(busy).
_decide(green_r, busy, yield_a) :- _signal(green_r, right), intersection(busy).
_decide(yellow_l, clear, move_a) :- _signal(yellow_l, left), intersection(clear).
_decide(yellow_r, clear, move_a) :- _signal(yellow_r, right), intersection(clear).
_decide(green_l, clear, move_a) :- _signal(green_l, left), intersection(clear).
_decide(green_r, clear, move_a) :- _signal(green_r, right), intersection(clear).

%---Signpost or obstruction ---%
_decide(pedestrian, _, stop) :- _sign(pedestrian).
_decide(sstop, _, stop) :- _sign(sstop).
_decide(sschool, _, slow) :- _sign(sschool).
_decide(syield, busy, yield) :- _sign(syield), intersection(busy).
_decide(syield, clear, move) :- _sign(syield), intersection(clear).

%---Lane change ---%
_decide(clear_l, _, movel) :- _left_lane(clear_l).
_decide(busy_l, _, wait) :- _left_lane(busy_l).
_decide(clear_r, _, movel) :- _right_lane(clear_r).
_decide(busy_r, _, wait) :- _right_lane(busy_r).

%---Driver's actual action in the car-accelerating, braking, steering etc. ---%
car(stop) :- _decide(_,_, stop), brakes(full).
car(move) :- _decide(_,_, move), accelerator(applied).
car(slow) :- _decide(_,_, slow), brakes(half).
car(yield) :- _decide(_,_, yield), brakes(full).
car(yield_a) :- _decide(_,_, yield_a), indicator(on), brakes(full).
car(move_a) :- _decide(_,_, move_a), indicator(on), steer(clkORanti), accelerator(applied).
car(wait) :- _decide(_,_, wait), indicator(on).
car(movel) :- _decide(_,_, movel), indicator(on), steer(clkORanti).  

#compute 1{_sensor(signal, clear, light, green_nf, clear, X) }.
%--- The End ---%
