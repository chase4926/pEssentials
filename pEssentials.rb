class PuruginEssentials
  include Purugin::Plugin, Purugin::Colors
  description 'PuruginEssentials', 0.2
  
  def warps_path()
    @path ||= File.join getDataFolder, 'warps.data'
  end
  
  def save_warps()
    File.open(warps_path, 'wb') do |io| 
      Marshal.dump(@warps_hash, io)
    end
  end
  
  def load_warps()
    @warps_hash = {}
    if File.exist?(warps_path) then
      File.open(warps_path, 'rb') do |io| 
        @warps_hash = Marshal.load(io)
      end
    end
  end
  
  def on_enable
    load_warps()
    
    public_player_command('feed', 'Nourishes you fully', '/feed ') do |me, *|
      me.msg green('Your stomach has been filled.')
      me.food_level = 30
    end
    
    public_player_command('starve', 'Starve yourself!', '/starve') do |me, *|
      me.msg red('You are now starving!')
      me.food_level = 0
    end
    
    public_player_command('spawn', 'Teleports you to spawn', '/spawn') do |me, *args|
      loc = me.world.get_spawn_location.to_a
      player_loc = me.location
      destination = org.bukkit.Location.new(me.world, loc[0], loc[1], loc[2], player_loc.yaw, player_loc.pitch)
      server.scheduler.schedule_sync_delayed_task(self) { me.teleport(destination) }
      me.msg('You have been teleported to spawn.')
    end
    
    public_player_command('clear', 'Clears your inventory', '/clear') do |me, *|
      me.inventory.clear
      me.msg('Inventory cleared.')
    end
    
    public_player_command('setwarp', 'Creates a new warp', '/setwarp {warpname} {password}') do |me, *args|
      if args[0] != nil then
        location = me.location.to_a
        location_hash = {}
        location_hash[:x] = location[0].to_f
        location_hash[:y] = location[1].to_f
        location_hash[:z] = location[2].to_f
        location_hash[:pass] = args[1]
        @warps_hash[args[0].to_s] = location_hash
        #File.open(warps_path, 'wb') do |io| 
          #Marshal.dump(@warps_hash, io)
        #end
        save_warps()
        if args[1] == nil then
          me.msg green("Warp [#{args[0]}] Set")
        else
          me.msg green("Warp [#{args[0]}] Set, With Password #{args[1]}")
        end
      else
        me.msg red('You need to give it a name!')
      end
    end
    
    public_player_command('delwarp', 'Deletes a warp', '/delwarp {warpname} {password}') do |me, *args|
      if args[0] != nil then
        if @warps_hash[args[0]] != nil then
          if @warps_hash[args[0]][:pass] == args[1] or @warps_hash[args[0]][:pass] == nil then
            @warps_hash.delete(args[0])
            save_warps()
            me.msg green("Warp [#{args[0]}] deleted")
          else
            me.msg red('Incorrect password!')
          end
        else
          me.msg red("Warp [#{args[0]}] does not exist!")
        end
      else
        me.msg red('You need to specify a warp!')
      end
    end
    
    public_player_command('warp', 'Warp to a certain location', '/warp {warpname} {password}') do |me, *args|
      if args[0] != nil then
        warp = @warps_hash[args[0]]
        if warp != nil then
          if warp[:pass] == args[1] or warp[:pass] == nil then
            player_loc = me.eye_location
            destination = org.bukkit.Location.new(me.world, warp[:x], warp[:y], warp[:z], player_loc.yaw, player_loc.pitch)
            server.scheduler.schedule_sync_delayed_task(self) { me.teleport(destination) }
          else
            me.msg red('Incorrect password!')
          end
        else
          me.msg red("Warp [#{args[0]}] does not exist!")
        end
      else
        me.msg red('You need to specify a warp!')
      end
    end
    
    public_player_command('listwarps', 'Lists the existing warps', '/listwarps') do |me, *|
      me.msg(@warps_hash.keys.inspect)
    end
    
    player_command('f_warp', 'Force warp', '/f_warp {warpname}') do |me, *args|
      if args[0] != nil then
        warp = @warps_hash[args[0]]
        if warp != nil then
          player_loc = me.eye_location
          destination = org.bukkit.Location.new(me.world, warp[:x], warp[:y], warp[:z], player_loc.yaw, player_loc.pitch)
          server.scheduler.schedule_sync_delayed_task(self) { me.teleport(destination) }
          me.msg green("Force warped to warp [#{args[0]}]")
        else
          me.msg red("Warp [#{args[0]}] does not exist!")
        end
      else
        me.msg red('You need to specify a warp!')
      end
    end
    
    player_command('f_delwarp', 'Force deletes a warp', '/f_delwarp {warpname}') do |me, *args|
      if args[0] != nil then
        if @warps_hash[args[0]] != nil then
          @warps_hash.delete(args[0])
          save_warps()
          me.msg green("Force Deleted Warp [#{args[0]}]")
        else
          me.msg red("Warp [#{args[0]}] does not exist!")
        end
      else
        me.msg red('You need to specify a warp!')
      end
    end
    
    player_command('join', 'Fake join game message', '/join {name}') do |me, *args|
      if args[0] != nil then
        server.broadcast_message yellow("#{args[0]} joined the game.")
      else
        server.broadcast_message yellow("#{me.display_name} joined the game.")
      end
    end
    
    player_command('leave', 'Fake leave game message', '/leave {name}') do |me, *args|
      if args[0] != nil then
        server.broadcast_message yellow("#{args[0]} left the game.")
      else
        server.broadcast_message yellow("#{me.display_name} left the game.")
      end
    end
    
    player_command('tpc', 'teleport_to_xyz', '/tpc {x} {y} {z}') do |me, *args|
      x = error? args[0].to_i, 'Needs x'
      y = error? args[1].to_i, 'Needs y'
      z = error? args[2].to_i, 'Needs z'
      loc = me.eye_location
      destination = org.bukkit.Location.new(me.world, x, y, z, loc.yaw, loc.pitch)
      server.scheduler.schedule_sync_delayed_task(self) { me.teleport(destination) }
    end
    
    player_command('setspawn', 'Sets the world\'s spawn', '/setspawn') do |me, *|
      location = me.location.to_a
      me.world.set_spawn_location(location[0], location[1], location[2])
      me.msg yellow('Spawn changed to your current location')
    end
    
    player_command('heal', 'Heals you fully', '/heal') do |me, *|
      me.health = 20
      me.msg green('You have been fully healed.')
    end
    
    player_command('survival', 'Change gamemode to survival.', '/survival') do |me, *|
      me.game_mode = org.bukkit.GameMode::SURVIVAL
    end
    
    player_command('creative', 'Change gamemode to creative.', '/creative') do |me, *|
      me.game_mode = org.bukkit.GameMode::CREATIVE
    end
    
    player_command('mode', 'Change Gamemode to other one.' , '/mode') do |me, *|
      if me.game_mode == org.bukkit.GameMode::CREATIVE then
        me.game_mode = org.bukkit.GameMode::SURVIVAL
      else
        me.game_mode = org.bukkit.GameMode::CREATIVE
      end
    end
    
    event(:player_interact) do |e|
      me = e.player
      if e.right_click_block? then
        block = e.clicked_block
        if block.is? :sign_post or block.is? :wall_sign then
          if block.state.get_line(0) == '[warp]' then
            warp = @warps_hash[block.state.get_line(1).to_s]
            if warp != nil then
              player_loc = me.eye_location
              destination = org.bukkit.Location.new(me.world, warp[:x], warp[:y], warp[:z], player_loc.yaw, player_loc.pitch)
              server.scheduler.schedule_sync_delayed_task(self) { me.teleport(destination) }
            else
              block.state.set_line(0, '[]')
              block.state.set_line(1, 'Unknown Warp')
              block.state.update()
            end
          end
        end
      end
    end
  end
end
