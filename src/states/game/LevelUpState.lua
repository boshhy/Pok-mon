--[[
    GD50
    Pokemon

    Author: Ivan Almaraz
    Level Up pokemon and display new stats
]]

LevelUpState = Class{__includes = BaseState}

function LevelUpState:init(battleState)
    gSounds['levelup']:play()

    self.battleState = battleState
    self.playerPokemon = self.battleState.player.party.pokemon[1]

    local levelPlusOne = self.playerPokemon.level + 1
    local expToLevel = levelPlusOne * levelPlusOne * 5 * 0.75

    self.battleState.playerExpBar.max = expToLevel
    self.battleState.playerExpBar.value = 0
    
    Timer.tween(0.5, {
        [self.battleState.playerExpBar] = {value = self.playerPokemon.currentExp - self.playerPokemon.expToLevel}
    })

    -- Get current stats of pokemon before level up
    hp, attack, defense, speed = self.playerPokemon:getStats()
    self.playerPokemon.currentExp = self.playerPokemon.currentExp - self.playerPokemon.expToLevel
    -- Get how much the stats changed by
    HPIncrease, attackIncrease, defenseIncrease, speedIncrease = self.playerPokemon:levelUp()
    
    -- Show a menu for level up stats with no cursor
    self.levelUpMenu = Menu {
        x = VIRTUAL_WIDTH - 200,
        y = VIRTUAL_HEIGHT - 208,
        width = 192,
        height = 112,
        -- Do not show cursor
        showCursor = false,
        items = {
            {
                text = 'HP: ' ..tostring(hp) .. " + " ..tostring(HPIncrease) .. ' = ' ..tostring(self.playerPokemon.HP),
                onSelect = function()

                    gStateStack:push(FadeInState({
                        r = 1, g = 1, b = 1}, 1, 
                        function()
                            -- resume field music
                            gSounds['victory-music']:stop()
                            gSounds['field-music']:play()

                            -- pop level up menu
                            gStateStack:pop()

                            -- pop take turn state
                            gStateStack:pop()

                            -- pop battle state
                            gStateStack:pop()

                            gStateStack:push(FadeOutState({
                                r = 1, g = 1, b = 1
                            }, 1, function()
                                -- do nothing after fade out ends
                            end))
                        end))
                end
            },
            {
                text = 'Attack: ' ..tostring(attack) .. " + " ..tostring(attackIncrease) .. ' = ' ..tostring(self.playerPokemon.attack)
            },
            {
                text = 'Defense: ' ..tostring(defense) .. " + " ..tostring(defenseIncrease) .. ' = ' ..tostring(self.playerPokemon.defense)
            },
            {
                text = 'Speed: ' ..tostring(speed) .. " + " ..tostring(speedIncrease) .. ' = ' ..tostring(self.playerPokemon.speed)
            }
        }
    }
end

function LevelUpState:update(dt)
    self.levelUpMenu:update(dt)
end

function LevelUpState:render()
    self.levelUpMenu:render()
end