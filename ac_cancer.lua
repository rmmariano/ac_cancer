k1_prob_reacao = 0.74  -- probabilidade da celula cancerigena se multiplicar
k1 = "reacao_celula_cancerigena_se_multiplicar"

k2_prob_reacao = 0.2  -- probabilidade de ocorrer effector cell
k2 = "reacao_effector_cell"

prob_nao_acontecer_k1_e_k2 = 1 - (k1_prob_reacao + k2_prob_reacao)
nao_ocorrer_k1_e_k2 = "nao_ocorrer_k1_e_k2"


--[[
k3 = 0.4  -- same value for k3 and k4
k4 = k3

pc = 3.85
teta = 10^3 
--]]


Normal = "normal"     -- branco (vazio) - célula normal
C = "cancerigena"         -- pretos - células cancerigena (consideradas anormais)
D = "morta"                   -- verdes - células cancerigena mortas
E = "complexo"              -- vermelhos - complexos produzidos pelo processo citotóxico, 
                                    -- ou seja, substâncias que são tóxicas as células.
            
Eo = "effector_cell"          -- as chamadas efector cells (por exemplo: linfócitos), que 
                                -- são as que se ligam a uma outra causando assim a 
                                -- alteração das suas atividades celulares (processo citotóxico)

NEo = "nao_ocorrer_effector_cell" 


-- quantidade de celulas no eixo x
XDIM = 11
--XDIM = 7
--XDIM = 5

-- quantidade de tempos que serao executados
TEMPOS = 30  -- t = 50



print("\n\nk1 = ", k1)
print("k2 = ", k2)



local function table_constains_value (table, value)
    for __index__, __value__ in ipairs(table) do
        if __value__ == value then
            return true
        end
    end

    return false
end


local function size_of (table)
    local count = 0
    
    for __index__, __value__ in ipairs(table) do
        count = count + 1
    end

    return count
end

local function print_table (table)
   for i, v in ipairs(table) do print(i, v) end 
end


-- celula

cell = Cell{
        state = Random{Normal, C, D, E},
        
        getPositionsOfNeighbors = function(self)                          
                local positions_of_neighbors = {
                                                top = {x = self.x-1, y = self.y}, 
                                                bottom = {x = self.x+1, y = self.y}, 
                                                left = {x = self.x, y = self.y-1},  
                                                right = {x = self.x, y = self.y+1}
                                            }
            
                return positions_of_neighbors                  
        end,

        execute = function(self)
            
                local ocorrer_reacao = Random{
                            reacao_celula_cancerigena_se_multiplicar = k1_prob_reacao,
                            reacao_effector_cell = k2_prob_reacao, 
                            nao_ocorrer_k1_e_k2 = prob_nao_acontecer_k1_e_k2
                    }
                
                local ocorrer_reacao_str = ocorrer_reacao:sample()
                
                
                --[[
                if self.state ~= Normal then
                        print("Me: (", self.x, ", ", self.y, ")")
                        print("State: ", self.state)
                        print("Reaction: ", ocorrer_reacao:sample())
                end
                --]]
                print("\n*********************************\n")
                
                print("\nMe: (", self.x, ", ", self.y, ") - state: ", self.state, " - reaction: ", ocorrer_reacao_str)
                
                
                
                
                

                -- se a celula for cancerigena e houver chance de multiplicar-se
                -- k1 = "reacao_celula_cancerigena_se_multiplicar"
                if self.state == C and ocorrer_reacao_str == k1 then
                    
                    
                        print(">>> 0")
                        
                    
                        local positions_of_neighbors = self:getPositionsOfNeighbors()

                        local raffle_new_neighbor = true
                        
                        
                        print(">>> 1")
                        
                        
                        -- insere os lados escolhidos aqui, para caso sorteie todos os 4 lados e todos forem cancerigenos, entao sai do loop
                        local sides_chosen = {}
                        
                        -- sides_chosen.getn(sides_chosen) --> len(sides_chosen)
                        while raffle_new_neighbor and size_of(sides_chosen) < 4 do    
                                ::continue01::
                                
                                
                            
                                print(">>> 2")
                                
                                

                                local __break__ = false
                                
                                local random_side = Random{"top", "bottom", "left", "right"}                                
                                
                                local random_side_chosen = random_side.sample()
                                
                                
                                
                                --print(">>> 2.5")
                                
                                
                                
                                -- se o lado escolhido nao tiver sido sorteado, entao insere na lista
                                if not table_constains_value (sides_chosen, random_side_chosen) then
                                    table.insert(sides_chosen, random_side_chosen)
                                -- senao volta ao loop para sortear outro
                                else
                                    
                                    print("\n\n random_side_chosen: ", random_side_chosen)
                                    print("sides_chosen: ")
                                    print_table(sides_chosen)
                                    
                                    goto continue01
                                end
                                
                                
                                
                                --print(">>> 2.8")
                                
                                
                                
                                local random_neighbor = positions_of_neighbors[random_side_chosen]
                                
                                
                                
                                print(">>> 3")
                                
                                
                                
                                -- print("\n\n Me: (", self.x, ", ", self.y, ")")
                                
                                --[[
                                
                                print("State: ", self.state)
                                print("Reaction: ", ocorrer_reacao:sample(), "\n")
                                
                                print("positions_of_neighbors top: (", positions_of_neighbors["top"].x, ", ", positions_of_neighbors["top"].y, ")")
                                print("positions_of_neighbors bottom: (", positions_of_neighbors["bottom"].x, ", ", positions_of_neighbors["bottom"].y, ")")
                                print("positions_of_neighbors right: (", positions_of_neighbors["right"].x, ", ", positions_of_neighbors["right"].y, ")")
                                print("positions_of_neighbors left: (", positions_of_neighbors["left"].x, ", ", positions_of_neighbors["left"].y, ")")
                                
                                print("\n random_side_chosen: ", random_side_chosen)
                                print("random_neighbor: (", random_neighbor.x, ", ", random_neighbor.y, ")")
                                --]]
                                
                                print("\n random_side_chosen: ", random_side_chosen)

                                print("\n >>> for")
                                
                                
                                
                                forEachNeighbor(self, function(neigh)
                                        
                                        -- simula um break
                                        if __break__ == false then
                                            
                                            
                                                
                                                print("\n neigh: (", neigh.x, ", ", neigh.y, ")")
                                                print("random_neighbor: (", random_neighbor.x, ", ", random_neighbor.y, ")")
                                            
                                            
                                        
                                                -- se o vizinho percorrido for igual ao sorteado
                                                if (neigh.x == random_neighbor.x and neigh.y == random_neighbor.y) then
                                                    
                                                        
                                                        print("\n neigh (", neigh.x, ", ", neigh.y, ") was state(", neigh.state, ")")
                                                        
                                                    
                                                        -- verifica se ele eh normal, se sim infecta ele
                                                        if neigh.state == Normal then
                                                                neigh.state = C  
                                                                
                                                                
                                                                print("\n neigh (", neigh.x, ", ", neigh.y, ") now is state(", neigh.state, ")")
                                                                
                                                                
                                                                -- nao precisa sortear um novo
                                                                raffle_new_neighbor = false
                                                        end
                                                        
                                                        -- se o vizinho escolhido for normal ou outra coisa, pode quebrar o laco
                                                        __break__ = true
                                                            
                                                end
                                            
                                        end

                                end)
                        
                        
                        
                                print("\n >>> endfor \n\n")
                                
                                
                        
                        end

                -- se a celula for cancerigena e houver chances de effector cell,
                -- entao celula cancerigena vira um complexo, que depois eh morta
                -- k2 = "reacao_effector_cell"
                elseif  self.state == C and ocorrer_reacao_str == k2 then
                
                
                        print("\nstate: ", self.state)
                        

                        self.state = E
                        
                        
                        print("\nstate: ", self.state)
                        
                        
                -- se a celula for um complexo, entao ela morre
                elseif self.state == E then

                        print("\nstate: ", self.state)
                        
                        
                        self.state = D
                        
                        
                        print("\nstate: ", self.state)
                        
                -- se a celula estiver morta, o corpo regenera ela, formando uma normal
                elseif self.state == D then


                        print("\nstate: ", self.state)

                        
                        self.state = Normal


                        print("\nstate: ", self.state)


                elseif self.state == Normal then
                        print("I'm normal :D")


                end
                
                            
        end
}



-- cria o space

space = CellularSpace{
    instance = cell,
    xdim = XDIM
}

space:createNeighborhood{
    strategy = "vonneumann",
    self = true
}



-- inicializa todas as celulas como normais

forEachCell(space, function(cell)
        cell.state = Normal       
end)


-- pega as 5 celulas do centro e coloca como cancerigenas

mid = (XDIM - 1) / 2

centralCell = space:get(mid, mid)
centralCell_top = space:get(mid, mid-1)
centralCell_bottom = space:get(mid, mid+1)
centralCell_left = space:get(mid-1, mid)
centralCell_right = space:get(mid+1, mid)

centralCell.state = C
centralCell_top.state = C
centralCell_bottom.state = C
centralCell_left.state = C
centralCell_right.state = C



map = Map{
    target = space,
    select = "state",
    value = {Normal, C, D, E},
    color = {"white", "black", "green", "red"}
}



t = 1

timer = Timer{
	Event{action = function()
            
            
            print("\n\ntime: ", t, "\n")
            
            
            space:synchronize()
            space:execute()
            
            
            t = t + 1
            
            
            -- fechar problema no tempo X
            --[[
            local x = 1
            if t >= x then
                    print("\n\n")
                    os.exit(0)
            end
            --]]
            
	end},
	Event{action = map}
}


timer:run(TEMPOS)
