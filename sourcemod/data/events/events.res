"Events"
{
    // Damaged Events
	"player_hurt"
    {
        "userid"            "short"
        "health"            "short"
        "attacker"          "short"
        "damageamount"      "long" // fix damage overflow
        "custom"	        "short"
        "showdisguisedcrit" "bool"	// if our attribute specifically crits disguised enemies we need to show it on the client
        "crit"              "bool"
        "minicrit"          "bool"
        "allseecrit"        "bool"
        "weaponid"          "short"
        "bonuseffect"       "byte"
    }
    
    "npc_hurt"
	{
		"entindex"          "short"
		"health"            "short"
		"attacker_player"   "short"
		"weaponid"          "short"
		"damageamount"      "long" // fix damage overflow
		"crit"              "bool"
		"boss"              "short"		// 1=HHH 2=Monoculus 3=Merasmus
	}

    // Healing Events
    "player_healed"
    {
        "patient"   "short"
        "healer"    "short"
        "amount"    "long"  // fix healing overflow
    }
    
    "player_healonhit"
    {
        "amount"            "long" // fix healing overflow
        "entindex"          "byte"
        "weapon_def_index"  "long"
    }

    "crossbow_heal"
    {
        "healer"    "byte"
        "target"    "byte"
        "amount"    "long" // fix healing overflow
    }

    "building_healed"
    {
        "building"  "short"
        "healer"    "short"
        "amount"    "long" // fix healing overflow
    }
}