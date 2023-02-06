#!/bin/bash

carddeck=(101 102 103 104 105 106 107 108 109 110 111 112 113 201 202 203 204 205 206 207 208 209 210 211 212 213 301 302 303 304 305 306 307 308 309 310 311 312 313 401 402 403 404 405 406 407 408 409 410 411 412 413)

discarddeck=()

#declaring the card ranks and suits

cardrank=("Ace" 2 3 4 5 6 7 8 9 10 "Joker" "Queen" "King")
cardsuit=("Spades" "Clubs" "Hearts" "Diamonds")

#declaring playerdecks and computer's decks

playerdeck=()
aideck=()
fail=false

#function that checks rank + suit of mid

checkMid() {
	let midsuit=$((($1/100)-1)) #assigns suit to value in array
	let midrank=$((($1%100)-1)) #same with suit, except rank
	if [[ $(($midrank+1)) -eq 8 || $(($midrank+1)) -eq 1 ]]; then
		echo "The card in the center is an" ${cardrank[$midrank]} "of" ${cardsuit[$midsuit]}
	else
		echo "The card in the center is a" ${cardrank[$midrank]} "of" ${cardsuit[$midsuit]}
	fi
	echo ""
}

function checkDeck {
	if [[ ${#carddeck[@]} -eq 1 ]]; then
		carddeck+=(${discarddeck[@]})
		carddeck=(${carddeck[@]/$midcard})
		discarddeck=($midcard)
	fi
} 

#function that checks card played compared to mid

#where any of the let midcard='s are, take the card out of the array

checkCard() {
  while [ true ]; do
	if [[ $answer != [Dd]"raw" ]]; then
	    if [[ $answer -gt 0 && $answer -le ${#playerdeck[@]} ]]; then
		deck=($@)
		let answer=answer-1
		let suit=$((${deck[answer]}/100))
		let rank=$((${deck[answer]}%100))
			if [[ $rank == 8 ]]; then
				echo "What suit do you want?"
				read strsuit
				case "$strsuit" in
					[Ss]"pades" )
						let midcard=108
						discarddeck+=(${playerdeck[answer]})
						playerdeck=(${playerdeck[@]/${playerdeck[answer]}})
						break
						;;
					[Cc]"lubs" )
						let midcard=208
						discarddeck+=(${playerdeck[answer]})
						playerdeck=(${playerdeck[@]/${playerdeck[answer]}})
						break
						;;
					[Hh]"earts" )
						let midcard=308
						discarddeck+=(${playerdeck[answer]})
						playerdeck=(${playerdeck[@]/${playerdeck[answer]}})
						break
						;;
					[Dd]"iamonds" )
						let midcard=408
						discarddeck+=(${playerdeck[answer]})
						playerdeck=(${playerdeck[@]/${playerdeck[answer]}})
						break
						;;
					* )
						echo "Type a suit."
						;;	
				esac
			elif [[ $suit == $(($midsuit+1)) || $rank == $(($midrank+1)) ]]; then
				let midcard=${playerdeck[answer]}
				discarddeck+=(${playerdeck[answer]})
				playerdeck=(${playerdeck[@]/$midcard})
				break
			else
				echo "That card does not work, choose another one."
				read answer
			fi
		  else
			echo "I don't understand. Try again."
			read answer  
		  fi
	else
		#draw card code here...?   
		amount=$(($RANDOM%(${#carddeck[@]}-1)))
		playerdeck+=(${carddeck[$amount]})
		carddeck=(${carddeck[@]/${carddeck[$amount]}})
		echo "You drew a card."
		checkDeck
		break
	fi
  done
}

#starting the game

echo "Welcome to crazy eights!"
echo "In order to play, you must match either the RANK or SUIT of the center card."
echo "However, with a RANK of EIGHT, you can play it whenever and decide the SUIT."
echo ""

for (( i=0; i<5; i++ )); do
	amount=$(($RANDOM%(${#carddeck[@]}-1)))
	playerdeck[$i]=${carddeck[$amount]}
	carddeck=(${carddeck[@]/${carddeck[$amount]}})
	amount=$(($RANDOM%(${#carddeck[@]}-1)))
	aideck[$i]=${carddeck[$amount]}
	carddeck=(${carddeck[@]/${carddeck[$amount]}})
done

amount=$(($RANDOM%(${#carddeck[@]}-1)))
midcard=${carddeck[$amount]}
discarddeck+=($midcard)
carddeck=(${carddeck[@]/${carddeck[$amount]}})

until [[ ${#aideck[@]} == 0 ]]; do
	checkMid $midcard
	echo ""
	echo "Your Hand:"
	for (( i=0; i<${#playerdeck[@]}; i++ )); do
		let suit=$(((${playerdeck[$i]}/100)-1))
		let rank=$(((${playerdeck[$i]}%100)-1))
		echo $(($i+1)) "-" ${cardrank[$rank]} "of" ${cardsuit[$suit]}
	done
	echo ""
	echo "Type the number of the card you wish to play or draw to draw a card."
	read answer
	echo ""
	checkCard ${playerdeck[@]}
	if [ ${#playerdeck[@]} -eq 0 ]; then
		break
	fi
	checkMid $midcard
	echo ""
	for (( i=0; i<${#aideck[@]}; i++ )); do
		let aisuit=$((${aideck[$i]}/100))
		let airank=$((${aideck[$i]}%100))
		if [[ $airank == 8 ]]; then
			chance=$(($RANDOM%4+1))
			if [ $chance -eq 1 ]; then
					midcard=108
					discarddeck+=(${aideck[$i]})
					aideck=(${aideck[@]/${aideck[$i]}})
					echo "The PC has placed an" ${cardrank[$(($airank-1))]} "of" ${cardsuit[0]}
					fail=false
					break
			elif [ $chance -eq 2 ]; then
					midcard=208
					discarddeck+=(${aideck[$i]})
					aideck=(${aideck[@]/${aideck[$i]}})
					echo "The PC has placed an" ${cardrank[$(($airank-1))]} "of" ${cardsuit[1]}
					fail=false
					break
			elif [ $chance -eq 3 ]; then
					midcard=308
					discarddeck+=(${aideck[$i]})
					aideck=(${aideck[@]/${aideck[$i]}})
					echo "The PC has placed an" ${cardrank[$(($airank-1))]} "of" ${cardsuit[2]}
					fail=false
					break
			elif [ $chance -eq 4 ]; then
					midcard=408
					discarddeck+=(${aideck[$i]})
					aideck=(${aideck[@]/${aideck[$i]}})
					echo "The PC has placed an" ${cardrank[$(($airank-1))]} "of" ${cardsuit[3]}
					fail=false
					break
			fi
		elif [[ $airank == $(($midrank+1)) || $aisuit == $(($midsuit+1)) ]]; then
			echo "The PC has placed a" ${cardrank[$(($airank-1))]} "of" ${cardsuit[$(($aisuit-1))]}
			midcard=${aideck[$i]}
			discarddeck+=(${aideck[$i]})
			aideck=(${aideck[@]/${aideck[$i]}})
			fail=false
			break
		else
			fail=true
		fi
	done
	if [[ $fail = true ]]; then
		fail=false
		#ai draws card
		amount=$(($RANDOM%(${#carddeck[@]}-1)))
		aideck+=(${carddeck[$amount]})
		carddeck=(${carddeck[@]/${carddeck[$amount]}})
		echo "The PC drew a card."
		checkDeck
	fi
	echo "The PC has ${#aideck[@]} cards left."
	echo ""
done

if [ ${#playerdeck[@]} -eq 0 ]; then
	echo "You won!"
else
	echo "You lost."
fi
