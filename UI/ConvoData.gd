extends Node

# TODO i could simplify this format -- "position" isn't
# needed because it's always yuki one side, the other
# person on the other.
var dialog1 = [
	
	{"Name": "Fudai",
	"Expression": "Fake Cheerful",
	"Position": "1",
	"Text": "hi, what's up?"},
	
	{"Name": "Yuki",
	"Expression": "Disappointed",
	"Position": "2",
	"Text": "Ummmm...."},

]

# complain that he's not finishing his work
# get him to follow you to an isolated location ("I have gundam model kits /
# seafood") - costs more spoons than you have at first
# ask him about his checkered past
# talk about work ("can you help me with this bug / can you code review this PR?")

# he... doesn't particularly have any agenda towards you? other than
# maybe "warn you to stay away from digging into company secrets"

# wait seriously what does yuki see in this guy, she has terrible taste
# maybe her standards are just real low after not meeting anybody for a while
# i think i should write/draw him as younger than i used to; a little more
# punk

# yuki thinks that fudai is real cool and confident but the
# truth is he's just completely checked out and doesn't give a shit
# anymore

# Should i make it that you can kokuhaku to anyone, actually?


var a_to_b_dlog = [
	{"Name": "Yuki",
	"Expression": "Cringe",
	"Position": "2",	
	"Text": "I picked choice 1 from A"},
	
	{"Name": "Fudai",
	"Expression": "Cringe",
	"Position": "1",	
	"Text": "Going to state B"}
]

var a_to_c_dlog = [
	{"Name": "Yuki",
	"Expression": "Cringe",
	"Position": "2",	
	"Text": "I picked choice 2 from A"},
	
	{"Name": "Fudai",
	"Expression": "Cringe",
	"Position": "1",	
	"Text": "Going to state C"}
]

var b_to_a_dlog = [
	{"Name": "Yuki",
	"Expression": "Cringe",
	"Position": "2",	
	"Text": "I picked choice 1 from B"},
	
	{"Name": "Fudai",
	"Expression": "Cringe",
	"Position": "1",	
	"Text": "Going back to state A"}
]
var b_to_c_dlog = [
	{"Name": "Yuki",
	"Expression": "Cringe",
	"Position": "2",	
	"Text": "I picked choice 2 from B"},
	
	{"Name": "Fudai",
	"Expression": "Cringe",
	"Position": "1",	
	"Text": "Going to state C"}
]
var c_to_a_dlog = [
	{"Name": "Yuki",
	"Expression": "Cringe",
	"Position": "2",	
	"Text": "I picked choice 3 from C"},
	
	{"Name": "Fudai",
	"Expression": "Cringe",
	"Position": "1",	
	"Text": "Going back to state A"}
]
var c_to_end_dlog = [
	{"Name": "Yuki",
	"Expression": "Cringe",
	"Position": "2",	
	"Text": "I picked choice 4 from C"},
	
	{"Name": "Fudai",
	"Expression": "Cringe",
	"Position": "1",	
	"Text": "End of the conversation?"},
	
	{"Name": "Yuki",
	"Expression": "Cringe",
	"Position": "2",	
	"Text": "Yeah, end of conversation."}
]

var convo_map = {
	"start": [dialog1, "A"],
	"A": {"choice1": [a_to_b_dlog, "B"],
		  "choice2": [a_to_c_dlog, "C"]},
	"B": {"choice1": [b_to_a_dlog, "A"],
		  "choice2": [b_to_c_dlog, "C"]},
	"C": {"choice3": [c_to_a_dlog, "A"],
		  "choice4": [c_to_end_dlog, null]
		 }
}
# behavior: state always starts at "start".
# if state is a dict, offer those choices.
# Otherwise just do the one thing given.
# Each thing consists of dialog to play and the state to transition to.
# if the state to transition to is "null", end the convo.
