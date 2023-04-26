#!/bin/bash
clear
echo "Wellcome to 'TicTacToe'"
echo
echo "Controls:"
echo "q|w|e"
echo "a|s|d"
echo "z|x|c"
echo

read -p "Press Enter to Start"

valid_keys=(q w e a s d z x c)

declare -A coordinatesX
declare -A coordinatesY
declare -i counter

coordinatesX=( ["q"]=0 ["w"]=1 ["e"]=2 ["a"]=0 ["s"]=1 ["d"]=2 ["z"]=0 ["x"]=1 ["c"]=2 )
coordinatesY=( ["q"]=0 ["w"]=0 ["e"]=0 ["a"]=1 ["s"]=1 ["d"]=1 ["z"]=2 ["x"]=2 ["c"]=2 )


fill_board() {
	row0=(_ _ _)
	row1=(_ _ _)
	row2=(_ _ _)
	counter=0
}


valid_move() {
	[[ "${valid_keys[@]}" =~ "${1}" && -n "${1}" ]] && return 1 || return 0
}


check_collision() {
	eval tmp=\${"row${coordinatesY[$move]}[${coordinatesX[$move]}]"}
    if [ "$tmp" == "_" ]; then	
        return 1
    else
        return 0
    fi
}


show_board() {
	clear
	printf "|%s|%s|%s|\n" ${row0[0]} ${row0[1]} ${row0[2]}
	printf "|%s|%s|%s|\n" ${row1[0]} ${row1[1]} ${row1[2]}
	printf "|%s|%s|%s|\n" ${row2[0]} ${row2[1]} ${row2[2]}
	echo
}


get_player_move() {
	move="0"
	while valid_move $move; do
		echo -n "(q w e a s d z x c): "
		read move
	done
}


change_board() {
	eval row${coordinatesY[$move]}[${coordinatesX[$move]}]=$1
}


has_winner() {
	counter+=1

	if [[ "${row0[@]}" == "X X X" || "${row1[@]}" == "X X X" || "${row2[@]}" == "X X X" ]]; then
		echo "Player X is Winner!"
		return 0
	fi

	if [[ "${row0[@]}" == "0 0 0" || "${row1[@]}" == "0 0 0" || "${row2[@]}" == "0 0 0" ]]; then
		echo "Player 0 is Winner!"
		return 0
	fi

	if [[ "${row0[0]} ${row1[0]} ${row2[0]}" == "X X X" || "${row0[1]} ${row1[1]} ${row2[1]}" == "X X X" || "${row0[2]} ${row1[2]} ${row2[2]}" == "X X X" ]]; then
		echo "Player X is Winner!"
		return 0
	fi

	if [[ "${row0[0]} ${row1[0]} ${row2[0]}" == "0 0 0" || "${row0[1]} ${row1[1]} ${row2[1]}" == "0 0 0" || "${row0[2]} ${row1[2]} ${row2[2]}" == "0 0 0" ]]; then
		echo "Player 0 is Winner!"
		return 0
	fi

	if [[ "${row0[0]} ${row1[1]} ${row2[2]}" == "X X X" || "${row0[2]} ${row1[1]} ${row2[0]}" == "X X X" ]]; then
		echo "Player X is Winner!"
		return 0
	fi

	if [[ "${row0[0]} ${row1[1]} ${row2[2]}" == "0 0 0" || "${row0[2]} ${row1[1]} ${row2[0]}" == "0 0 0" ]]; then
		echo "Player 0 is Winner!"
		return 0
	fi

	if [ $counter == 9 ]; then
		echo "Its Tie!"
		return 0
	fi


	return 1
}


repeat() {
	echo -n "Do you want repeat Game? Y/n: "
	read answer
	if [[ $answer == "n" || $answer == "N" ]]; then
		echo "Game over."
		exit
	fi
	return 0
}

	fill_board
	show_board

while true; do
	echo -n "Player X "
	get_player_move
	while check_collision; do
		get_player_move
	done
	change_board X
	clear
	show_board
	if has_winner; then
		if repeat; then
			fill_board
		    show_board
			continue
		fi
	fi

	echo -n "Player 0 "
	while check_collision; do
		get_player_move
	done
	change_board 0
	show_board
	if has_winner; then
		if repeat; then
			fill_board
		    show_board
			continue
		fi
	fi

done


