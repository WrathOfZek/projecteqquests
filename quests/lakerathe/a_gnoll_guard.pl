sub EVENT_COMBAT {
	if($combat_state==1) {
		quest::emote("growls fiercely, saliva foaming around its ferocious, jagged maw, 'This is our home now!  Begone, or the legions of TomEar shall slay you all'");
	}
}

sub EVENT_DEATH {
	quest::say("My comrades will avenge my death.");
}