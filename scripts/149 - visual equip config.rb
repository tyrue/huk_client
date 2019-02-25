  #--------------------------------------------------------------------------
  # Aqui é o Método de configuração para os equips para adcionar os icones
  # relacionado ao ID da arma coloque:
  #   return ['equip\\icone_da_arma, o] if id == id_do_item_no_database
  # E a mesma coisa com armaduras, porem devem ser adcionados depois do "else"
  #   return ['equip\\Icone_defesa', 0] if id == id_do_equip_no_database
  #--------------------------------------------------------------------------
if User_Edit::VISUAL_EQUIP_ACTIVE
  def equip_character(type, id)
    
    if not $game_party.actors[0].hp == 0
      return ['(착용)목도', 2] if id == 101 #목도
      return ['(착용)목도', 2] if id == 102 #목검
      return ['(착용)목도', 2] if id == 103 #사두목도
      return ['(착용)목도', 2] if id == 104 #사두목검
      return ['(착용)목도', 2] if id == 121 #초심자의목도
      return ['(착용)연두갑주', 2] if id == 1  #초심자의갑주
      return ['(착용)연두갑주', 2] if id == 38  #연두색남자갑주
      return ['(착용)초록갑주', 2] if id == 34 #초록색남자갑주
      return ['(착용)영혼마령봉', 2] if id == 105 #영혼마령봉
      return ['(착용)현철중검', 2] if id == 106 #현철중검
      return ['(착용)현철중검', 2] if id == 120 #흑철중검
      return ['(착용)죄수복', 2] if id == 11  #죄수복
      return ['(착용)현랑부', 2] if id == 110  #현랑부
      return ['(착용)현랑부', 2] if id == 111  #이벤트현랑부
      return ['(착용)주작의검', 2] if id == 114  #주작의검
      return ['(착용)정화의방패', 2] if id == 39  #정화의방패
      return ['(착용)가릉빈가의날개옷', 2] if id == 30   #가릉빈가의날개옷
      return ['(착용)심판의낫', 2] if id == 115  #심판의낫
      return ['(착용)여신의방패', 2] if id == 40  #여신의방패
      return ['(착용)양첨목봉', 2] if id == 112  #양첨목봉
      return ['(착용)양첨목봉', 2] if id == 113  #이벤트양첨목봉
      return ['(착용)용마제팔검', 2] if id == 122  #용마제팔검
      return ['(착용)진일신검', 2] if id == 116  #진일신검
      return ['(착용)다람쥐화서', 2] if id == 9  #다람쥐화서
      return ['(착용)토끼화서', 2] if id == 10  #토끼화서
end

    #Mulher
    if $genero == 2
    if type == 2
      # GRAFICOS DA ARMA
      # Adcione aqui os equipamentos de ataque
      return ['Mulher\\Arma3', 0] if id == 1
      return ['Mulher\\Arma3', 0] if id == 2
      return ['Mulher\\Arma3', 0] if id == 3
      return ['Mulher\\Arma3', 0] if id == 4
      return ['Mulher\\arco_0', 0] if id == 17
      return ['Mulher\\arco_0', 0] if id == 18
      return ['Mulher\\arco_0', 0] if id == 19
      return ['Mulher\\arco_0', 0] if id == 20
      return ['Mulher\\spear_0', 0] if id == 5
      return ['Mulher\\spear_0', 0] if id == 6
      return ['Mulher\\spear_0', 0] if id == 7
      return ['Mulher\\spear_0', 0] if id == 8
      return ['Mulher\\weapon-stick01', 0] if id == 29
      return ['Mulher\\weapon-stick01', 0] if id == 30
      return ['Mulher\\weapon-stick01', 0] if id == 31
      return ['Mulher\\weapon-stick01', 0] if id == 32
      return ['Mulher\\mazza_0', 0] if id == 25
      return ['Mulher\\mazza_0', 0] if id == 26
      return ['Mulher\\mazza_0', 0] if id == 27
      return ['Mulher\\mazza_0', 0] if id == 28
      #return ['Mulher\\ascia_1', 0] if id == 9
      #return ['Mulher\\ascia_1', 0] if id == 10
      #return ['Mulher\\ascia_1', 0] if id == 11
      #return ['Mulher\\ascia_1', 0] if id == 12
    else
      # Armaduras, Elmos, escudos etc..
       return ['Mulher\\Bronze Shield', 0] if id == 1
       return ['Mulher\\Shield2', 0] if id == 2
     end
   end 
   
   
    return false
  end
  end