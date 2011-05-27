
/* question2a.pl */

/* Using ALL the requirements as stated above, create a Prolog 
program which captures the logic of this part of the separation 
standard. Try to write your program to reflect the logic of the 
requirements. */

/* Facts: three flight profiles */

belongs(ba202-test,ba202).
belongs(ba202-test2,ba202).
belongs(ba202-1,ba202). 
belongs(ba202-2,ba202). 
belongs(ba202-3,ba202). 
belongs(vgn902-1,vgn902). 
belongs(vgn902-2,vgn902).
belongs(afr300-1,afr300). 
belongs(afr300-2,afr300). 
belongs(afr300-3,afr300).

time(ba202-test, t(8,24)).
time(ba202-test2, t(8,24)).
time(ba202-1, t(8,23)).
time(ba202-2, t(8,53)).
time(ba202-3, t(9,20)).
time(vgn902-1, t(8,23)). 
time(vgn902-2, t(8,49)). 
time(afr300-1, t(7,59)).
time(afr300-2, t(8,37)).
time(afr300-3, t(8,53)).

fl(ba202-test,380).
fl(ba202-test2,380).
fl(ba202-1,370). 
fl(ba202-2,370). 
fl(ba202-3,380). 
fl(vgn902-1,370). 
fl(vgn902-2,370). 
fl(afr300-1,420). 
fl(afr300-2,370). 
fl(afr300-3,370). 

long(ba202-test,20).
long(ba202-test2,18).
long(ba202-1,21). 
long(ba202-2,23). 
long(ba202-3,29). 
long(vgn902-1,20). 
long(vgn902-2,24). 
long(afr300-1,18). 
long(afr300-2,21). 
long(afr300-3,24). 

lat(ba202-test,65).
lat(ba202-test2,55).
lat(ba202-1,65).  
lat(ba202-2,61).  
lat(ba202-3,55).  
lat(vgn902-1,65). 
lat(vgn902-2,60). 
lat(afr300-1,70).  
lat(afr300-2,65).  
lat(afr300-3,60).  

speed(ba202-test, 0.4).
speed(ba202-test2, 0.4).
speed(ba202-1, 0.9). 
speed(ba202-2, 0.9). 
speed(ba202-3, 0.8). 
speed(vgn902-1, 0.9). 
speed(vgn902-2, 0.9). 
speed(afr300-1, 1.5). 
speed(afr300-2, 1.2). 
speed(afr300-3, 0.95). 


/* Rules */

/* 1. Two Flight Profiles X and Y are in Conflict if there exists a 
segment point Xp of X and a segment point Yp of Y which are not separated. */
conflict(X,Y) :- belongs(Xp,X), belongs(Yp,Y), \+separated(Xp,Yp).

/* 2. Two segment points A and B are Separated if they are Vertically 
Separated or Horizontally Separated or Time Separated. */
separated(A,B) :- vertically_separated(A,B).
separated(A,B) :- horizontally_separated(A,B).
separated(A,B) :- time_separated(A,B).

/* 3. Two segment points are Horizontally Separated if the longitude of 
one point is not equal to the longitude of the other point. */
horizontally_separated(A,B) :- long(A,Along), long(B,Blong), \+(Along=Blong).

/* 4. Two segment points are Horizontally Separated if the latitude of 
one point is not equal to the latitude of the other point. */
horizontally_separated(A,B) :- lat(A,Alat), lat(B,Blat), \+(Alat=Blat).

/* 5. Two segment points are Vertically Separated if the Flight Level of one 
point is at least 2000 feet less than or greater than the flight level of the 
other point. */
vertically_separated(A,B) :- fl(A,Afl), fl(B,Bfl), ((Afl-20)>=Bfl).
vertically_separated(A,B) :- fl(A,Afl), fl(B,Bfl), ((Afl+20)=<Bfl).

/* 6. Two segment points are Time Separated if the time of one point is at 
least 10 mins different from the time of another where both aircraft are 
flying subsonic. If one or more of the aircraft are flying at supersonic 
speeds then this difference must be at least 15 minutes. */
find_difference(P,Q,Diff) :- (P>=Q), Diff is (P-Q). 
find_difference(P,Q,Diff) :- (P<Q), Diff is (Q-P).

convert_to_minutes(Timehours,Timemins,Mins) :- Mins is ((Timehours*60)+Timemins).

time_separated(A,B) :- 
	speed(A,Aspeed), speed(B,Bspeed), 
	(Aspeed=<1), (Bspeed=<1), 
	time(A,t(Ahours,Amins)), time(B,t(Bhours,Bmins)),
	convert_to_minutes(Ahours,Amins,Atime),
	convert_to_minutes(Bhours,Bmins,Btime),
	find_difference(Atime,Btime,Timediff), !, (Timediff>=10).	

time_separated(A,B) :- 
	time(A,t(Ahours,Amins)), time(B,t(Bhours,Bmins)),
	convert_to_minutes(Ahours,Amins,Atime),
	convert_to_minutes(Bhours,Bmins,Btime),
	find_difference(Atime,Btime,Timediff), !, (Timediff>=15).

