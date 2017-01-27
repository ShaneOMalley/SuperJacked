local collision = {}

-- returns true if the first argument intersects with any of the other arguments
function collision.intersecting (...)

	for i=2,#arg do
		if arg[1].x + arg[1].width > arg[i].x and
		arg[1].x < arg[i].x + arg[i].width and
		arg[1].y + arg[1].height > arg[i].y and
		arg[1].y < arg[i].y + arg[i].height then
			return true
		end
	end

	return false

	--[[
	-- return true if there is an intersction
	return rect1.x + rect1.width > rect2.x and
		   rect1.x < rect2.x + rect2.width and
		   rect1.y + rect1.height > rect2.y and
		   rect1.y < rect2.y + rect2.height
	--]]

end

return collision