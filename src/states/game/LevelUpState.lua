--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelUpState = Class{__includes = BaseState}

function LevelUpState:init(battleState)
    gSounds['levelup']:play()

    self.battleState = battleState
    self.playerPokemon = self.battleState.player.party.pokemon[1]

    hp, attack, defense, speed = self.playerPokemon:getStats()
    self.playerPokemon.currentExp = self.playerPokemon.currentExp - self.playerPokemon.expToLevel
    HPIncrease, attackIncrease, defenseIncrease, speedIncrease = self.playerPokemon:levelUp()
    
    self.levelUpMenu = Menu {
        x = 16,
        y = 16,
        width = 300,
        height = 128,
        showCursor = false,
        items = {
            {
                text = 'HP: ' ..tostring(hp) .. " + " ..tostring(HPIncrease) .. ' = ' ..tostring(self.playerPokemon.HP),
                onSelect = function()
                    -- pop level up menu
                    gStateStack:pop()

                    gStateStack:push(FadeInState({
                        r = 1, g = 1, b = 1}, 1, 
                        function()
                            -- resume field music
                            gSounds['victory-music']:stop()
                            gSounds['field-music']:play()

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