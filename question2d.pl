
/* question2d.pl */

/* In the second examples file on the website, Profiles
are represented as Lists. Change your Prolog Program
to handle lists, and test your new program using (at
least) the Profiles in the example file. */

/* Facts: three flight profiles 
 more compact list representation */

belongs(ba202, [ba202-1, ba202-2, ba202-3]). 
belongs(vgn902, [vgn902-1, vgn902-2]).
belongs(afr300, [afr300-1, afr300-2, afr300-3]).

/* ba202 */
segment_point(ba202-1, [time(8,23), fl(370), long(21), lat(65),  speed(0.9)]). 
segment_point(ba202-2, [time(8,53), fl(370), long(23), lat(61),  speed(0.9)]). 
segment_point(ba202-3, [time(9,20), fl(380), long(29), lat(55),  speed(0.8)]). 

/* vgn902 */
segment_point(vgn902-1, [time(8,23), fl(370), long(20), lat(65),  speed(0.9)]). 
segment_point(vgn902-2, [time(8,49), fl(370), long(24), lat(60),  speed(0.9)]). 

/* afr300 */
segment_point(afr300-1, [time(7,59), fl(420), long(18), lat(70),  speed(1.5)]). 
segment_point(afr300-2, [time(8,37), fl(370), long(21), lat(65),  speed(1.2)]). 
segment_point(afr300-3, [time(8,53), fl(370), long(24), lat(60),  speed(0.8)]). 


/* Rules */

inlist(Item,[Item|_]).  
inlist(Item,[_|Tail]) :- inlist(Item,Tail).

/* 1. Two Flight Profiles X and Y are in Conflict if there exists a 
segment point Xp of X and a segment point Yp of Y which are not separated. */
conflict(X,Y) :- 
	belongs(X,Xplist), 
	belongs(Y,Yplist),
	inlist(Xp,Xplist),  
	inlist(Yp,Yplist),
	\+separated(Xp,Yp).

/* 2. Two segment points A and B are Separated if they are Vertically 
Separated or Horizontally Separated or Time Separated. */
separated(A,B) :- vertically_separated(A,B).
separated(A,B) :- horizontally_separated(A,B).
separated(A,B) :- time_separated(A,B).

/* 3. Two segment points are Horizontally Separated if the longitude of 
one point is not equal to the longitude of the other point. */
horizontally_separated(A,B) :- 
	segment_point(A,Alist),
	segment_point(B,Blist),
	inlist(long(Along),Alist),
	inlist(long(Blong),Blist), 
	\+(Along=Blong).

/* 4. Two segment points are Horizontally Separated if the latitude of 
one point is not equal to the latitude of the other point. */
horizontally_separated(A,B) :- 
	segment_point(A,Alist),
	segment_point(B,Blist),
	inlist(lat(Alat),Alist),
	inlist(lat(Blat),Blist), 
	\+(Alat=Blat).

/* 5. Two segment points are Vertically Separated if the Flight Level of one 
point is at least 2000 feet less than or greater than the flight level of the 
other point. */
vertically_separated(A,B) :- 
	segment_point(A,Alist),
	segment_point(B,Blist),
	inlist(fl(Afl),Alist),
	inlist(fl(Bfl),Blist), 
	((Afl-20)>=Bfl).

vertically_separated(A,B) :- 
	segment_point(A,Alist),
	segment_point(B,Blist),
	inlist(fl(Afl),Alist),
	inlist(fl(Bfl),Blist), 
	((Afl+20)=<Bfl).

/* 6. Two segment points are Time Separated if the time of one point is at 
least 10 mins different from the time of another where both aircraft are 
flying subsonic. If one or more of the aircraft are flying at supersonic 
speeds then this difference must be at least 15 minutes. */
time_separated(A,B) :- 
	segment_point(A,Alist),
	segment_point(B,Blist),
	inlist(speed(Aspeed),Alist),
	inlist(speed(Bspeed),Blist), 
	(Aspeed=<1), (Bspeed=<1), 
	inlist(time(Ahours,Amins),Alist),
	inlist(time(Bhours,Bmins),Blist),
	convert_to_minutes(Ahours,Amins,Atime),
	convert_to_minutes(Bhours,Bmins,Btime),
	find_difference(Atime,Btime,Timediff), !, (Timediff>=10).	

time_separated(A,B) :- 
	segment_point(A,Alist),
	segment_point(B,Blist),
	inlist(time(Ahours,Amins),Alist),
	inlist(time(Bhours,Bmins),Blist),
	convert_to_minutes(Ahours,Amins,Atime),
	convert_to_minutes(Bhours,Bmins,Btime),
	find_difference(Atime,Btime,Timediff), !, (Timediff>=15).

convert_to_minutes(Timehours,Timemins,Mins) :- Mins is ((Timehours*60)+Timemins).

find_difference(P,Q,Diff) :- 
	(P>=Q), 
	Diff is (P-Q). 

find_difference(P,Q,Diff) :- 
	(P<Q), 
	Diff is (Q-P).

