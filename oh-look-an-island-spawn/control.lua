
require 'defines'

--Make sure we're in Freeplay
if remote.interfaces.freeplay then
  local function onChunkGen(vars)
    --Extract information from onChunkGenerated
    local theArea = vars.area
    local theSurf = vars.surface

    --Define an array to store the tiles we wish to replace
    local tiles = {}
    --Fill that array, adding 2 to the perimeter to avoid stenciling 
    for wx = theArea.left_top.x-2, theArea.right_bottom.x+2, 1 do
      for wy = theArea.left_top.y-2, theArea.right_bottom.y+2, 1 do
      
        --If the tiles generated are within 20 tiles of world origin (0,0) replace them with grass instead of water. (Everyone needs solid ground to stand on.)
        if wx > -21 and wx < 21 and wy > -21 and wy < 21 then
          table.insert(tiles, {name = "grass", position={wx,wy}})
        else 
          --Everything else goes to Poseidon 
          table.insert(tiles, {name="water", position={wx, wy}})
        end
      end
    end
    --Replace the generated surface with our array of tiles.
    theSurf.set_tiles(tiles)
  end
  
  --Trigger our function when the world generates a chunk.
  game.on_event(defines.events.on_chunk_generated,onChunkGen) 
  
  
  game.on_event(defines.events.on_player_created, function(event)

    local player = game.get_player(event.player_index)
    local character = player.character
    --Teleport any new players to the server to world origin. (Sorry piranhas.)
    player.teleport{0,0}
  end)
end