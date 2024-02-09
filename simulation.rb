def setup
  @weezing = 334
  @weedle = 26
  @poison_stings = 35
  @string_shots = 40
  @sleep_turns = 0
  @history = []
end

def weedle_turn
  moves = []
  moves << :poison_sting if @poison_stings > 0
  moves << :string_shot if @string_shots > 0

  is_critical = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1].sample == 1 # 1/16 chance of critical

  case moves.sample
  when :poison_sting
    damage = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2].sample # 1 damage, 1/16 2 damage
    damage += 2 if is_critical
    @weezing -= damage
    @poison_stings -= 1
    @history << "Weedle #{is_critical ? 'critically ' : ''}hit Weezing for #{damage} damage"
  when :string_shot
    @string_shots -= 1
    @history << "Weedle string shot Weezing. It probably did nothing"
  when nil
    # struggle
    damage = [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3].sample # 2 damage, 1/16 3 damage
    damage += 3 if is_critical
    @weezing -= damage
    @weedle -= 1
    @history << "Weedle is out of moves. Weedle #{is_critical ? 'critically ' : ''}hit Weezing for #{damage} damage"
    @history << "Weedle took 1 recoil damage"
  end
end

def weezing_turn
  if @sleep_turns > 1
    @sleep_turns -= 1
    @history << "Weezing is fast asleep" if @sleep_turns > 0
    return if @sleep_turns > 0

    @history << "Weezing woke up"
  end

  chance = rand(0.0..100.0)
  if chance < 28.9
    @sleep_turns = [1, 2, 3, 4, 5].sample
    @history << "Weezing decided to take a nap"
  elsif chance < 28.9 + 32.9
    @history << "Weezing is loafing around"
  elsif chance < 28.9 + 32.9 + 28.9
    damage = [26, 26, 26, 27, 27, 27, 28, 28, 28, 29, 29, 29, 30, 30, 30, 31].sample
    @weezing -= damage
    @history << "Weezing hit itself in confusion (for #{damage} damage)"
  else
    @weezing = 0
    @history << "Weezing exploded as instructed. It was messy"
  end
end

wins = 0
losses = 0

1_000_000.times do
  setup
  while @weedle > 0 && @weezing > 0
    weezing_turn
    weedle_turn
  end

  losses += 1 if @weezing <= 0
  wins += 1 if @weedle <= 0
end

puts "Wins #{wins} / Losses #{losses}"