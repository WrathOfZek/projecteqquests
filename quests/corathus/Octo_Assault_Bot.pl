sub EVENT_COMBAT
{
	if($combat_state == 0)
	{
		quest::stoptimer("short_circuit");
		quest::stoptimer("annih_burn_shared");
		quest::stoptimer("missile_launch");
		quest::stoptimer("repair");	
	}
	else
	{
		my $willf = $entity_list->GetMobByNpcTypeID(365171);
		if($willf)
		{
			$willf->Shout("Ah the XZ-R980 is my latest and greatest creation! I haven't had time to properly test it yet but I suppose you will have to do!");
		}
		quest::settimer("short_circuit", 13);
		quest::settimer("annih_burn_shared", 120);
		quest::settimer("missile_launch", 45);
		quest::settimer("repair", 30);
	}
}

sub EVENT_TIMER
{
	if($timer eq "short_circuit")
	{
		quest::emote("short circuits.");
		my @eligible_targets = $npc->GetHateList();
		my $starter_target = $npc->GetHateRandom();
		my $jumps = 0;
		
		if(!$starter_target)
		{
			return;
		}
		
		#remove our main target from the list and damage them
		my $idx = 0;
		foreach $ent (@eligible_target)
		{
			my $h_ent = $ent->GetEnt();
			if($h_ent->GetID() == $starter_target->GetID())
			{
				delete(@eligible_targets[$idx]);
				last;
			}
			$idx++;
		}
		$starter_target->Damage($npc, 200, 1075, 24, 0);
		
		#while we still have targets in range on the eligible target list jump and do damage and remove them from the list
		$last_target = $starter_target;
		do
		{
			my $num = @eligible_targets;
			if($num == 0)
			{
				$last_target = 0;
			}

			$idx = 0;
			foreach $ent (@eligible_targets)
			{
				my $h_ent = $ent->GetEnt();
				my $m_dist = plugin::Dist($last_target, $h_ent);
				$last_target = 0;
				if($m_dist < 15.0)
				{
					$jumps++;
					my $dmg = 200 + (200 * (1.5 * $jumps));
					$h_ent->Damage($npc, $dmg, 1075, 24, 0);
					#add all but the target to new array and set old array to new array
					my @new_array;
					foreach $n_ent (@eligible_target)
					{
						my $n_h_ent = $n_ent->GetEnt();
						if($n_h_ent->GetID() != $h_ent->GetID())
						{
							push(@new_array, $n_ent);
						}
					}
					@eligible_targets = @new_array;
					$last_target = $h_ent;
					last;
				}
				$idx++;
			}
		} while($last_target);
	}
}

sub EVENT_DEATH
{
	quest::emote("sputters and starts to give off sparks before collapsing into a pile of broken machinery.");
	quest::spawn_condition("corathus", 11, 0);
	my $mino = $entity_list->GetMobByNpcTypeID(365004);
	my $spore = $entity_list->GetMobByNpcTypeID(365038);
	
	if(!$spore && !$mino)
	{
		quest::spawn_condition("corathus", 3, 0);
		quest::spawn_condition("corathus", 4, 0);
		quest::spawn_condition("corathus", 5, 0);
		quest::spawn_condition("corathus", 6, 1);
		quest::spawn_condition("corathus", 7, 1);
		quest::spawn_condition("corathus", 8, 1);
		my $willf = $entity_list->GetMobByNpcTypeID(365171);
		if($willf)
		{
			$willf->Shout("Fools, defeat my champions and I will simply make more, behold my wonderous behemoth!");
		}
	}
}