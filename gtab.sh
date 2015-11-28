#!/bin/bash

# DOCUMENTATION SECTION.
:<<'CHARACTERS'
Key characters in the game
==========================

0.  Table of contents
---------------------
1.  Bosses
2.  Wise guys
3.  Lone wolves
4.  Merchants
5.  Hookers


1.  Bosses
----------
Tony Emacsio

The leader of the Gnumino family. Best known for his greed, he is nevertheless
a competent leader and has outlasted many others who have tried to depose him.
He and his organization are headquartered in the southwestern part of the
district.


Ed Vimmy

The boss of the 'Nixers. His gang is nowhere as rich as the Gnumino family, but
what they lack in firepower, they make up with their dedication. He has a short
temper, and tends to snap back at anyone who doesn't do what he wants. His
headquarters are in the northeastern block of the neighborhood.


2.  Wise guys
-------------


3.  Lone wolves
---------------


4.  Merchants
-------------


5.  Hookers
-----------
Pearl

Though she's not the prettiest girl in town, Pearl is a veteran at her job.
Though she's guaranteed to satisfy, her experience has its drawbacks - better
make sure you're protected! Her standard rate is $100.


Rubi

Hailing from the Far East, Rubi is learned in many mysterious arts. Spending a
night with her is almost guaranteed to be educational. She's not cheap though;
her standard price is $500.


Looa

Another arrival from the more distant parts of the world. For some reason she
isn't particularly popular, but there's been little complaint from her clients.
She takes $200 for a night.


CHARACTERS

# END DOCUMENTATION.

# DATA SECTION.
BANNER=' $$$$$$\  $$$$$$$$\  $$$$$$\
$$  __$$\ \__$$  __|$$  __$$\                        (press any key to continue)
$$ /  \__|   $$ |   $$ /  $$ |      $$\
$$ |$$$$\    $$ |   $$$$$$$$ |      \__|
$$ |\_$$ |   $$ |   $$  __$$ |
$$ |  $$ |   $$ |   $$ |  $$ |      $$\
\$$$$$$  |   $$ |   $$ |  $$ |      \__|
 \______/    \__|   \__|  \__|
      $$$$$$$\                      $$\                 $$\       $$\
      $$  __$$\                     $$ |                \__|      $$ |
      $$ |  $$ | $$$$$$\   $$$$$$$\ $$$$$$$\   $$$$$$$\ $$\  $$$$$$$ | $$$$$$\
      $$$$$$$\ | \____$$\ $$  _____|$$  __$$\ $$  _____|$$ |$$  __$$ |$$  __$$\
      $$  __$$\  $$$$$$$ |\$$$$$$\  $$ |  $$ |\$$$$$$\  $$ |$$ /  $$ |$$$$$$$$ |
      $$ |  $$ |$$  __$$ | \____$$\ $$ |  $$ | \____$$\ $$ |$$ |  $$ |$$   ____|
      $$$$$$$  |\$$$$$$$ |$$$$$$$  |$$ |  $$ |$$$$$$$  |$$ |\$$$$$$$ |\$$$$$$$\
      \_______/  \_______|\_______/ \__|  \__|\_______/ \__| \_______| \_______|
                 $$$$$$\    $$\                         $$\
                $$  __$$\   $$ |                        \__|
                $$ /  \__|$$$$$$\    $$$$$$\   $$$$$$\  $$\  $$$$$$\   $$$$$$$\
                \$$$$$$\  \_$$  _|  $$  __$$\ $$  __$$\ $$ |$$  __$$\ $$  _____|
                 \____$$\   $$ |    $$ /  $$ |$$ |  \__|$$ |$$$$$$$$ |\$$$$$$\
                $$\   $$ |  $$ |$$\ $$ |  $$ |$$ |      $$ |$$   ____| \____$$\
                \$$$$$$  |  \$$$$  |\$$$$$$  |$$ |      $$ |\$$$$$$$\ $$$$$$$  |
                 \______/    \____/  \______/ \__|      \__| \_______|\_______/'

MAP_BLANK="   |  |        |  |
---'S '--------'  '---
    h   Root Rd
---.a .---..---. H.---
   |r |   ||   | o|
   |e |   ||   | e|
   |  |   ||   |  |
---'S '---''---' S|
    t  Mount St  t|
---.  .--------.  |
   |  |        |  |"
# END DATA.

# DECLARATION SECTION.
declare SAVE_FNAME
declare LOOP

declare -i STAT_Strength STAT_

function showHelp {
    local -a lines=(
        "i(nv): check your inventory."
        "l(ook): take measure of your current situation."
        "s(hoot) <target>: aim and fire your weapon at the specified target."
        "t(alk) <target>: talk to the specified person."
        "w(alk) N|E|S|W: move yo azz in the respective direction."
        "map: show the map of Bashside and your current location."
        "stat: check your statistics."
        "help: display this list of commands."
    )
    
    local -i start=0
    local -i end=${#lines[*]}
    
    if (( $# == 2 )); then
        start=$1
        end=$2
    fi
    
    for (( i=$start ; $i < $end ; i += 1 )); do
        echo "  ${lines[$i]}"
    done
}

function showMap {
    clear
    #local -i indent
    local title="B a s h s i d e"
    #indent=$(( ($(tput cols) - ${#title}) / 2 ))
    
    #printf "%${indent}s" "$title"
    echo "    $title"
    echo
    echo "$MAP_BLANK"
    tput cup $(($1 + 2)) $(($2 * 2))
    echo -n "@"
    read -n 1 -s
    clear
}

function yesNo {
    read -p "(y/any)> " -n 1
    if [[ $REPLY =~ [Yy] ]]; then
        return 0
    else
        return 1
    fi
}

# END DECLARATION.

read -p "$BANNER" -n 1 -s
clear

if [[ -f $1 ]]; then
    read -n 1 -p "Attempt to read save data from \"$1\"? (y/n) "
    if [[ $REPLY -eq Y || $REPLY -eq Y ]]; then
        SAVE_FNAME=$REPLY
    fi
    echo
fi

if [[ $SAVE_FNAME -eq '' && -f ~/.gta_bashside.save ]]; then
    # Old player.
    SAVE_FNAME=~/.gta_bashside.save
    echo "'Sup, $USER?"
else
    # New player.
    echo "Yo man. Looks like you're new in Bashside?"
    read -n 1 -s -p '> ...'
    echo
    echo "Yeah man, I got ya. Well I hate to tell ya, but bein' a new kid around here"
    echo "ain't easy these days. You'd better learn the laws of the street before you"
    echo "go runnin' anywhere. So here's the deal: you gotta know some vocabulary first!"
    echo
    showHelp
    read -n 1 -s
fi

#showMap 2 10

# This is the main read-eval-print loop.
LOOP=true
while $LOOP; do
    read -p "> "
    case "$REPLY" in
      "q" | "quit")
        echo -n "Really quit? "
        if yesNo; then
            LOOP=false
        else
            echo
        fi
        ;;
      '')
        :
        ;;
      *)
        echo "'$REPLY'? What's that supposed to mean?"
        ;;
    esac
done