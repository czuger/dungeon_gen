# dungeon_gen

Yes, another dungeon generator. This is a very basic dungeon generator in which you can navigate.

## Thanks to 

Great thanks to @adonaac most of the dungeon generation is based on his work there : http://www.gamasutra.com/blogs/AAdonaac/20150903/252889/Procedural_Dungeon_Generation_Algorithm.php

## TODO

Add alternative connections between rooms. At this moment this is a pure Minimum Spanning Tree.

## Environment

I worked with Linux Mint xfce, ruby 2.3.0 and Risretto as an image viewer.
Could work with other environment, but could be hard (especially Windows because of RMagick).

**Only people with strong knowledge in ruby and in computers in general should try to use this tool. It is the exact opposite of user friendly tool ;)** 

## Purpose 

I wanted a very basic dungeon generator and explorer in order to use it with FantasyGround (https://www.fantasygrounds.com/home/home.php).
So i wanted something that allows me to navigate into the dungeon and produce a bitmap that can be readed by FantasyGround.

Finally the script only modify a bitmap into the out directory. In order to see the move you have to watch the bitmap with a viewing tool like Risretto.

The biggest problem was to put the bitmap from linux to the campain/pic directory. I used samba + a script which is not really comfortable.
A best solution would have been to play under linux.

## Setup and run

```sh
git clone https://github.com/czuger/dungeon_gen
cd dungeon_gen
bundle install
ruby dungeon.rb
```

## Commands

* Use the arrow keys to move in the dungeon.
* k to mark a monster as killed.
* d to mark a trap as disarmed.

## Output

* Show you a grid : white is room, purple is wall.
* The small plain red circle is you.
* The big red circle is how far you detect monsters.
* If you see a M then you meet a monster, create an encounter and resolve it.
* If you see a T then you have a trap.
* If you see a H then you have found the treasure. Give a hoard to the party, yeah ^^.
* If you see a C then you have a trapped chest. Resolve the trap and then (if they are still alive) treat it as a H.

