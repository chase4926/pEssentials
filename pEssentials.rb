class PuruginEssentials
  include Purugin::Plugin, Purugin::Colors
  description 'PuruginEssentials', 0.2

  def on_enable
    public_command('feed', 'Nourishes you fully', '/feed ') do |me, *|
      me.msg green('Your stomach has been filled!')
      me.food_level = 30
    end
    
    public_command('starve', 'Starve yourslef!', '/starve') do |me, *|
      me.msg red("You are now starving!")
      me.food_level = 0
    end
    
    public_command('spawn', 'Teleports you to spawn', '/spawn') do |me, *args|
      loc = me.world.get_spawn_location.to_a
      player_loc = me.location
      destination = org.bukkit.Location.new(me.world, loc[0], loc[1], loc[2], player_loc.yaw, player_loc.pitch)
      server.scheduler.schedule_sync_delayed_task(self) { me.teleport(destination) }
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
    end
    
    player_command('heal', 'Heals you fully', '/heal') do |me, *|
      me.msg "You were fully healed!"
      me.health = 20
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
      elsif me.game_mode == org.bukkit.GameMode::SURVIVAL then
        me.game_mode = org.bukkit.GameMode::CREATIVE
      end
    end
  end
end
