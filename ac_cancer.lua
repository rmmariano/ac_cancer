-- ############## CONSTANTES ############## 



-- ####### PROBABILIDADES ####### 

-- k1: probabilidade da celula cancerigena se multiplicar
k1_prob_reacao = 0.74 
k1 = "reacao_celula_cancerigena_se_multiplicar"

-- k2: probabilidade de ocorrer effector cell
k2_prob_reacao = 0.2 
k2 = "reacao_effector_cell"

-- probabilidade de nao ocorrencia de k1 e k2
prob_nao_acontecer_k1_e_k2 = 1 - (k1_prob_reacao + k2_prob_reacao)
nao_ocorrer_k1_e_k2 = "nao_ocorrer_k1_e_k2"


-- k3: probabilidade do complexo morrer
k3_prob_reacao = 0.4 
k3 = "reacao_celula_complexa_morrer"

-- probabilidade de nao ocorrencia de k3
prob_nao_acontecer_k3 = 1 - k3_prob_reacao
nao_ocorrer_k3 = "nao_ocorrer_k3"


-- k4: probabilidade celula morta reviver
k4_prob_reacao = 0.4 
k4 = "reacao_celula_morta_reviver"

-- probabilidade de nao ocorrencia de k4
prob_nao_acontecer_k4 = 1 - k4_prob_reacao
nao_ocorrer_k4 = "nao_ocorrer_k4"



-- ####### TIPO DE CELULA ####### 

Normal = "normal"     -- branco (vazio) - célula normal
C = "cancerigena"         -- pretos - células cancerigena (consideradas anormais)
D = "morta"                   -- verdes - células cancerigena mortas
E = "complexo"              -- vermelhos - complexos produzidos pelo processo citotóxico, 
                                    -- ou seja, substâncias que são tóxicas as células.



-- ####### DIMENSAO  E TEMPO ####### 

-- quantidade de celulas no eixo x
--XDIM = 101  -- dimensao do trabalho
XDIM = 31
-- XDIM = 11

-- quantidade de tempos que serao executados
--TEMPOS = 50  -- tempo do trabalho
-- TEMPOS = 30  
TEMPOS = 10 



-- ############## FUNCOES AUXILIARES ############## 

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



-- ############## CELULA ############## 

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
            
                -- ocorrer k1 e k2
                local ocorrer_reacao_k1_ou_k2 = Random{
                            reacao_celula_cancerigena_se_multiplicar = k1_prob_reacao,
                            reacao_effector_cell = k2_prob_reacao, 
                            nao_ocorrer_k1_e_k2 = prob_nao_acontecer_k1_e_k2
                    }
                
                local ocorrer_reacao_k1_ou_k2_str = ocorrer_reacao_k1_ou_k2:sample()
                
                
                -- ocorrer k3
                local ocorrer_reacao_k3 = Random{
                            reacao_celula_complexa_morrer = k3_prob_reacao,
                            nao_ocorrer_k3 = prob_nao_acontecer_k3
                    }
                
                local ocorrer_reacao_k3_str = ocorrer_reacao_k3:sample()
                
                
                -- ocorrer k4
                local ocorrer_reacao_k4 = Random{
                            reacao_celula_morta_reviver = k4_prob_reacao,
                            nao_ocorrer_k4 = prob_nao_acontecer_k4
                    }
                
                local ocorrer_reacao_k4_str = ocorrer_reacao_k4:sample()

                
                -- print("\nMe: (", self.x, ", ", self.y, ") - state: ", self.state, " - reaction: ", ocorrer_reacao_str)
                

                -- se a celula for cancerigena e houver chance de multiplicar-se
                -- k1 = "reacao_celula_cancerigena_se_multiplicar"
                if self.state == C and ocorrer_reacao_k1_ou_k2_str == k1 then                        
                        
                        -- pega a posicao dos vizinhos
                        local positions_of_neighbors = self:getPositionsOfNeighbors()

                        -- verificar se necessita sortear um novo vizinho
                        local raffle_new_neighbor = true
                        
                        -- insere os lados escolhidos aqui, para caso sorteie todos os 4 lados
                        -- e todos forem cancerigenos, entao sai do loop
                        local sides_chosen = {}
                        
                        -- quantas vezes foi gerado um lado aleatorio
                        local count_random_side = 1
                        
                        -- quantidade maxima de vezes que pode gerar um lado aleatorio
                        -- apos isso, para evitar loop infinito, gera um lado deterministico
                        local MAX_RANDOM_SIDE = 10
                        
                        local SIDES = {"top", "bottom", "left", "right"}
                        
                        -- sides_chosen.getn(sides_chosen) --> len(sides_chosen)
                        while raffle_new_neighbor and size_of(sides_chosen) < 4 do    
                                ::continue01:: 

                                local __break__ = false
                                
                                
                                local random_side = Random{"top", "bottom", "left", "right"}                                
                                
                                local random_side_chosen = random_side.sample()                                

                                
                                -- se tentar gerar mais de MAX_RANDOM_SIDE vezes um lado aleatorio
                                -- e nao conseguir, pega um valor deterministico para nao cair em loop infinito
                                if count_random_side >= MAX_RANDOM_SIDE then                                    
                                    random_side_chosen = table.remove(SIDES, 1)                                    
                                end                                
                                
                                
                                -- se o lado sorteado nao tiver sido escolhido, entao insere na lista
                                if not table_constains_value (sides_chosen, random_side_chosen) then
                                        table.insert(sides_chosen, random_side_chosen)
                                        
                                -- se o lado sorteado tiver sido escolhido, entao volta ao loop para sortear outro
                                else                                                                            
                                        count_random_side = count_random_side + 1
                                        
                                        goto continue01
                                end
                                
                                
                                -- pega um vizinho aleatorio
                                local random_neighbor = positions_of_neighbors[random_side_chosen]
                                

                                -- percorre todos os vizinhos da celula
                                forEachNeighbor(self, function(neigh)
                                        
                                        -- simula um break
                                        if __break__ == false then

                                                -- se o vizinho percorrido for igual ao sorteado
                                                if (neigh.x == random_neighbor.x and neigh.y == random_neighbor.y) then
                                                                                                        
                                                        -- se a celula vizinha for normal, infecta ela
                                                        if neigh.state == Normal then
                                                                neigh.state = C   -- celula cancerigena

                                                                -- nao precisa sortear um novo vizinho
                                                                -- pq foi possivel infectar
                                                                raffle_new_neighbor = false
                                                        end
                                                        
                                                        -- se o vizinho escolhido for normal ou outra coisa, pode quebrar o laco
                                                        __break__ = true
                                                            
                                                end
                                            
                                        end  -- __break__

                                end)  -- forEachNeighbor
                        

                        end  -- while

                -- se a celula for cancerigena, ha uma probabilidade k2 de ocorrer um effector cell
                -- entao celula cancerigena vira um complexo
                elseif  self.state == C and ocorrer_reacao_k1_ou_k2_str == k2 then
                
                        self.state = E  -- celula complexa
                                                
                        
                -- se a celula for um complexo, ha uma probabilidade k3 dela morrer
                elseif self.state == E and ocorrer_reacao_k3_str == k3 then

                        self.state = D  -- celula morta
                        
                        
                -- se a celula estiver morta, ha uma probabilidade k4 dela reviver            
                elseif self.state == D and ocorrer_reacao_k4_str == k4 then
                
                        self.state = Normal  -- celula normal


                -- se a celula for normal, faz nada com ela
                --elseif self.state == Normal then
                        --print("I'm normal")

                end
                
                            
        end
}



-- ############## CRIA O AMBIENTE ############## 

-- cria o space
space = CellularSpace{
    instance = cell,
    xdim = XDIM
}

-- escolhe o tipo de vizinhanca
space:createNeighborhood{
    strategy = "vonneumann",
    self = true
}


-- ############## INICIALIZACAO ############## 

-- inicializa todas as celulas como normais
forEachCell(space, function(cell)
        cell.state = Normal       
end)


--depois pega as 5 celulas do centro e coloca como cancerigenas
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


-- ############## CRIA O MAPA ############## 

map = Map{
    target = space,
    select = "state",
    value = {Normal, C, D, E},
    color = {"white", "black", "green", "red"}
}


-- ############## EXECUCAO ############## 

-- variavel para contar os tempos passados
t = 1

timer = Timer{
	Event{action = function()            
            
            print("\n\nTIME: ", t, "\n")            
            
            space:synchronize()
            space:execute()            
            
            t = t + 1            

	end},
	Event{action = map}
}


timer:run(TEMPOS)
