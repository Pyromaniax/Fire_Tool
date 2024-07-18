TOOL.Category		= "Construction"
TOOL.Name			= "#tool.fire.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.Information = {
	{name = "left0", stage = 0, icon = "gui/lmb.png"},
	{name = "right0", stage = 0, icon = "gui/rmb.png"},
	{name = "reload0", stage = 0, icon = "gui/r.png"},
}

if CLIENT then
language.Add("tool.fire.name", "Fire")
language.Add("tool.fire.left0", "Create fire")
language.Add("tool.fire.right0", "Ignite target")
language.Add("tool.fire.reload0", "Extinguish target")
language.Add("tool.fire.desc", "Create fire entities and ignite objects")
end

TOOL.ClientConVar["Length"] = 1
TOOL.ClientConVar["Size"] = 1
TOOL.ClientConVar["Damage"] = 1
TOOL.ClientConVar["Ignlength"] = 1

function TOOL:LeftClick( trace )
	
	if ( CLIENT ) then return true end
	
	local _health	= math.Max( self:GetClientNumber( "Length" ), 2 )
	local _size		= math.Max( self:GetClientNumber( "Size" ), 2 )
	local _damage	= math.Max( self:GetClientNumber( "Damage" ), 2 )
	

    local ent = ents.Create( "env_fire" )
    if ( !ent:IsValid() ) then return end
   		 ent:SetPos( trace.HitPos )
	       ent:SetKeyValue("health",tostring(_health))
             ent:SetKeyValue("firesize",tostring(_size))
             ent:SetKeyValue("fireattack","1")
             ent:SetKeyValue("damagescale",tostring(_damage))
             ent:SetKeyValue("spawnflags","128")

             ent:Spawn()
             ent:Activate()
             ent:Fire("StartFire","",0)

	undo.Create("Fire")
	undo.AddEntity(ent)
	undo.SetPlayer(self:GetOwner())
	undo.Finish()	

	return true
end

function TOOL:RightClick( trace )

	if (!trace.Entity) then return false end
	if (!trace.Entity:IsValid() ) then return false end
	if (trace.Entity:IsPlayer()) then return false end
	if (trace.Entity:IsWorld()) then return false end
	
	if ( CLIENT ) then return true end
	
	local _ignlength	= math.Max( self:GetClientNumber( "length" ), 2 )
	
	trace.Entity:Extinguish()
	trace.Entity:Ignite( _ignlength, 0 )
	
	return true
	
end

function TOOL:Reload(trace)

	if (!trace.Entity) then return false end
	if (!trace.Entity:IsValid() ) then return false end
	if (trace.Entity:IsPlayer()) then return false end
	if (trace.Entity:IsWorld()) then return false end
	
	// Client can bail out now
	if ( CLIENT ) then return true end

	trace.Entity:Extinguish()
	
	return true

end

function TOOL.BuildCPanel( panel )	
		panel:AddControl("Header", {
		Text = "Fire Tool",
		Description = "#tool.fire.desc"
	})
		
		panel:AddControl("Slider", {
		Label = "Fire Size:",
		Type = "Float",
		Min = "1",
		Max = "200",
		Command = "fire_size"
	})
	
		panel:AddControl("Slider", {
		Label = "Fire Duration:",
		Type = "Float",
		Min = "1",
		Max = "1000",
		Command = "fire_length"
	})

		panel:AddControl("Slider", {
		Label = "Fire Damage:",
		Type = "Float",
		Min = "1",
		Max = "100",
		Command = "fire_damage"
	})
	
		panel:AddControl( "Slider", { 
		Label = "Ignition Length:", 
		Type = "Float",
		Min = "1",
		Max = "1000",
		Command = "fire_ignlength"
	})
end
