#Project Specification
###Formal Aspects of Computer Science (CIA2326): Coursework
####Background and Context
In safety critical applications of software systems it is considered good practice to develop software rigorously. This often means adopting some kind of "formal method" to the software development process. One way of ensuring that requirements are captured accurately is to adopt an approach of trying to capture requirements formally within a model, using for example a logic language, and then animating and testing the requirements model before system development. In this coursework you are required to capture some requirements of a fictional air traffic control system in first order logic, and to animate that specification using the logic languageProlog.

In an air traffic control system managing an air space, such as the North East Atlantic, flight plans (called "Flight Profiles") are logged with an Air Traffic Control Officer (ATCO) a period of time before the aircraft is due to enter that air space. At this time the system must check that all logged flight profiles are mutually conflict free.

You learn that an aircraft's Flight Profile is a sequence of 2 or more segments points. You decide to represent the name of a Profile with the aircraft's callsign, eg ba202, and the segment make up of a Profile as a set of facts. For example, if ba202 is made up of 3 segment points, it can be recorded as follows:

```prolog
belongs(ba202-1,ba202)
belongs(ba202-2,ba202)
belongs(ba202-3,ba202)
```

and another Flight Profile vgn902 made up of 2 segment points, can be recorded as follows:

```prolog
belongs(vgn902-1,vgn902)
belongs(vgn902-2,vgn902)
```

Further, each segment point is defined by

* a time (when the plane is due to fly over it), described as a tuple ```t(X,Y)```, meaning ```Y``` minutes past ```X``` o'clock on the 24 hour clock
* a flight level ```(fl)```, described as an integer ```X``` meaning ```100*X``` thousand feet above sea level
* a latitude ```(lat)```, described by an integer representing degrees north, latitude
*a longitude ```(long)```, described by an integer representing degrees west, longitude
* a speed measured in Mach units, where Mach 1.0 is the speed of sound

You decide to represent these as logical facts. For example, the time, flight level, latitude, longitude and speed of a segment point ba202-1 is be recorded as follows:

```prolog
time(ba202-1, t(8,23))
fl(ba202-1,370)
long(ba202-1,21)
lat(ba202-1,65)
speed(ba202-1, 0.9)
```

meaning that flight ba202 is intending to be at 65 degrees north, 21 degrees west (somewhere over Iceland) at 37000 feet at 23 minutes past 8 in the morning, and flying at Mach 0.9. As another example you might have a segment point of vgn902 represented as:

```prolog
time(vgn902-1, t(8,23))
fl(vgn902-1,370)
long(vgn902-1,20)
lat(vgn902-1,65)
speed(vgn02-1, 0.85)
```

After consulting Air Traffic Control Officers and studying the rule books you gather the following requirements of an aircraft "conflict probe" sub-system, concerning the logic of separation criteria, as follows:

1. Two Flight Profiles ```x``` and ```y``` are in Conflict if there exists a segment point ```xp``` of ```x``` and a a segment point ```yp``` of ```y``` which are not separated.
2. Two segment points are Separated if they are Vertically Separated or Horizontally Separated or Time Separated.
3. Two segment points are Horizontally Separated if the longitude of one point is not equal to the longitude of the other point.
4. Two segment points are Horizontally Separated if the latitude of one point is not equal to the latitude of the other point.
5. Two segment points are Vertically Separated if the Flight Level of one point is at least ```2000 feet``` less than or greater than the flight level of the other point.
6. Two segment points are Time Separated if the time of one point is at least ```10 mins``` different from the time of another where both aircraft are flying subsonic. If one or more of the aircraft are flying at supersonic speeds then this difference must be at least ```15 minutes```.

#Questions
2a) Using ALL the requirements as stated above, create a Prolog program which captures the logic of this part of the separation standard. Try to write your program to reflect the logic of the requirements.

2d) Change your Prolog Program to handle lists.