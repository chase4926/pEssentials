class PuruginEssentials
  include Purugin::Plugin, Purugin::Colors
  description 'PuruginEssentials', 0.1

  def on_enable
    player_command('heal', 'Heals you fully', '/heal') do |me, *|
      me.msg "You were fully healed!"
      me.health = 20
    end
    
    public_command('feed', 'Nourishes you fully', '/feed ') do |me, *|
      me.msg green('Your stomach has been filled!')
      me.food_level = 30
    end
    
    public_command('starve', 'Starve yourslef!', '/starve') do |me, *|
      me.msg red("You are now starving!")
      me.food_level = 0
    end
    
    public_command('spawn', 'Teleports you to spawn', '/spawn') do |me, *args|
      x = 85 # Setspawn - Later
      y = 66
      z = 248
      destination = org.bukkit.Location.new(me.world, x, y, z)
      server.scheduler.schedule_sync_delayed_task(self) { me.teleport(destination) }
    end
    
    public_command('tpc', 'teleport_to_xyz', '/tpc {x} {y} {z}') do |me, *args|
      x = error? args[0].to_i, "Needs x"
      y = error? args[1].to_i, "Needs y"
      z = error? args[2].to_i, "Needs z"
      destination = org.bukkit.Location.new(me.world, x, y, z)
      server.scheduler.schedule_sync_delayed_task(self) { me.teleport(destination) }
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
