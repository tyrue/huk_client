#===============================================================================
# ** Network - Manages network data.
#-------------------------------------------------------------------------------
# Author    Me™ and Mr.Mo
# Version   1.0
# Date      11-04-06
#===============================================================================
SDK.log("Network", "Mr.Mo and Me™", "1.0", " 11-04-06")

p "TCPSocket script not found (class Network)" if not SDK.state('TCPSocket')
#-------------------------------------------------------------------------------
# Begin SDK Enabled Check
#-------------------------------------------------------------------------------
if SDK.state('TCPSocket') == true and SDK.state('Network')

module Network
  
class Main
  
  #--------------------------------------------------------------------------
  # * Attributes
  #-------------------------------------------------------------------------- 
  attr_accessor :socket
  attr_accessor :pm

  #--------------------------------------------------------------------------
  # * Initialiation
  #-------------------------------------------------------------------------- 
  def self.initialize
    @players    = {}
    @mapplayers = {}
    @netactors  = {}
    @pm = {}
    @pm_lines = []
    @user_test  = false
    @user_exist = false
    @socket     = nil
    @nooprec    = 0
    @id         = -1
    @name       = ""
    @group      = ""
    @status     = ""
    @oldx       = -1
    @oldy       = -1
    @oldd       = -1
    @oldp       = -1
    @oldid      = -1
    @value      = 0
    @login      = false
    @pchat_conf = false
    @send_conf  = false
    @trade_conf = false
    @servername = ""
    @pm_getting = false
    @self_key1 = nil
    @self_key2 = nil
    @self_key3 = nil
    @self_value = nil
    @trade_compelete = false
    @trading = false
    @trade_id = -1
    @ani_id = -1
    @ani_map = -1
    @ani_number = 0
    @ani_event = -1
    $ani_character = {}
  end
  #--------------------------------------------------------------------------
  # * Returns Servername
  #-------------------------------------------------------------------------- 
  def self.servername
    return @servername.to_s
  end
  #--------------------------------------------------------------------------
  # * Returns Socket
  #-------------------------------------------------------------------------- 
  def self.socket
    return @socket
  end
  #--------------------------------------------------------------------------
  # * Returns UserID
  #-------------------------------------------------------------------------- 
  def self.id
    return @id
  end
  #--------------------------------------------------------------------------
  # * Returns UserName
  #-------------------------------------------------------------------------- 
  def self.name
    return @name
  end  
  #--------------------------------------------------------------------------
  # * Returns current Status
  #-------------------------------------------------------------------------- 
  def self.status
    return "" if @status == nil or @status == []
    return @status
  end
  #--------------------------------------------------------------------------
  # * Returns Group
  #-------------------------------------------------------------------------- 
  def self.group
    if @group.downcase.include?("adm")
      group = "admin"
    elsif @group.downcase.include?("mod")
      group = "mod"
    else
      group = "standard"
    end
    return group
  end
  #--------------------------------------------------------------------------
  # * Returns Mapplayers
  #-------------------------------------------------------------------------- 
  def self.mapplayers
    return {} if @mapplayers == nil
    return @mapplayers
  end
  #--------------------------------------------------------------------------
  # * Returns NetActors
  #-------------------------------------------------------------------------- 
  def self.netactors
    return {} if @netactors == nil
    return @netactors
  end
  #--------------------------------------------------------------------------
  # * Returns Players
  #-------------------------------------------------------------------------- 
  def self.players
    return {} if @players == nil
    return @players
  end
  #--------------------------------------------------------------------------
  # * Destroys player
  #-------------------------------------------------------------------------- 
  def self.destroy(id)
    @players[id.to_s] = nil rescue nil
    @mapplayers[id.to_s] = "" rescue nil
    for player in @mapplayers
      @mapplayers.delete(id.to_s) if player[0].to_i == id.to_i
    end
    for player in @players
      @players.delete(id.to_s) if player[0].to_i == id.to_i
    end
    if $scene.is_a?(Scene_Map)
      begin
        $scene.spriteset[id].dispose unless $scene.spriteset[id].disposed?
      rescue
        nil
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Create A socket
  #-------------------------------------------------------------------------- 
  def self.start_connection(host, port)
    @socket = TCPSocket.new(host, port)
  end
  #--------------------------------------------------------------------------
  # * Asks for Id
  #-------------------------------------------------------------------------- 
  def self.get_id
    @socket.send("<1>'req'</1>\n")
  end
  #--------------------------------------------------------------------------
  # * Asks for name
  #-------------------------------------------------------------------------- 
  def self.get_name
    @socket.send("<2>'req'</2>\n")
  end
  #--------------------------------------------------------------------------
  # * Asks for Group
  #-------------------------------------------------------------------------- 
  def self.get_group
    #@socket.send("<3>'req'</3>\n")
    @socket.send("<check>#{self.name}</check>\n")
  end
  #--------------------------------------------------------------------------
  # * Registers (Attempt to)
  #-------------------------------------------------------------------------- 
  def self.send_register(user,pass)
    # Register with User as name, and Pass as password
    @socket.send("<reges #{user}>#{pass}</reges>\n")
    # Start Loop for Retrival
    loop = 0
      loop do
      loop += 1
      self.update
      # Break If Registration Succeeded
      break if @registered
      # Break if Loop reached 10000
      break if loop == 10000
    end
  end
  #--------------------------------------------------------------------------
  # * 닉네임 서버 보내기
  #-------------------------------------------------------------------------- 
  def self.send_nickname(username, id, pass)
    @socket.send("<nickname>#{username},#{id},#{pass}</nickname>\n")
  end
  #--------------------------------------------------------------------------
  # * Send Gold
  #-------------------------------------------------------------------------- 
  def self.send_gold
    gold = $game_party.gold
  end

  #--------------------------------------------------------------------------
  # * Asks for Network Version Number
  #-------------------------------------------------------------------------- 
  def self.retrieve_version
    @socket.send("<versione>'request'</versione>\n")
  end
  #--------------------------------------------------------------------------
  # * Asks for Message of the day
  #-------------------------------------------------------------------------- 
  def self.retrieve_mod
    @socket.send("<mod>'request'</mod>\n")
  end
  #--------------------------------------------------------------------------
  # * Asks for Login (and confirmation)
  #-------------------------------------------------------------------------- 
  def self.send_login(user,pass)
    @socket.send("<login #{user}>#{pass}</login>\n")
  end
  #--------------------------------------------------------------------------
  # * Send Errors
  #-------------------------------------------------------------------------- 
  def self.send_error(lines)
    if lines.is_a?(Array)
      for line in lines
        @socket.send("<err>#{line}</err>\n")
      end
    elsif lines.is_a?(String)
      @socket.send("<err>#{lines}</err>\n")
    end
  end  
  #--------------------------------------------------------------------------
  # * Authenfication
  #-------------------------------------------------------------------------- 
  def self.amnet_auth
    # Send Authenfication
    @socket.send("<0>'e'</0>\n")
    @auth = false
    # Set Try to 0, then start Loop
    try = 0
    loop do
      # Add 1 to Try
      try += 1
      loop = 0
      # Start Loop for Retrieval
      loop do
        loop += 1
        self.update
        # Break if Authenficated
        break if @auth
        # Break if loop reaches 20000
        break if loop == 20000
      end
      # If the loop was breaked because it reached 10000, display message
      p "#{User_Edit::NOTAUTH}, Try #{try} of #{User_Edit::CONNFAILTRY}" if loop == 20000
      # Stop everything if try mets the maximum try's
      break if try == User_Edit::CONNFAILTRY
      # Break loop if Authenficated
      break if @auth
    end
    # Go to Scene Login if Authenficated
    $scene = Scene_Login.new if @auth
  end
  #--------------------------------------------------------------------------
  # * Send Start Data
  #-------------------------------------------------------------------------- 
  def self.send_start
    send = ""
    # Send Username And character's Graphic Name
    send += "@username = '#{self.name}'; @character_name = '#{$game_player.character_name}'; "
    # Sends Map ID, X and Y positions
    send += "@map_id = #{$game_map.map_id}; @x = #{$game_player.x}; @y = #{$game_player.y};"
    # Sends Name
    send += "@name = '#{$game_party.actors[0].name}';" if User_Edit::Bandwith >= 1
    # Sends Direction
    send += "@direction = #{$game_player.direction};" if User_Edit::Bandwith >= 2
    # Sends Move Speed
    send += "@move_speed = #{$game_player.move_speed};" if User_Edit::Bandwith >= 3
    # Sends Requesting start
    send += "@weapon_id = #{$game_party.actors[0].weapon_id};"
    send += "@armor1_id = #{$game_party.actors[0].armor1_id};"
    send += "@armor2_id = #{$game_party.actors[0].armor2_id};"
    send += "@armor3_id = #{$game_party.actors[0].armor3_id};"
    send += "@armor4_id = #{$game_party.actors[0].armor4_id};"
    send += "@guild = '#{$guild}';"
    send+= "start(#{self.id});"
    @socket.send("<5>#{send}</5>\n")
    self.send_newstats
    #send_actor_start
  end
  #--------------------------------------------------------------------------
  # * Return PMs
  #-------------------------------------------------------------------------
  def self.pm
    return @pm
  end
  #--------------------------------------------------------------------------
  # * Get PMs
  #-------------------------------------------------------------------------- 
  def self.get_pms
    @pm_getting = true
    @socket.send("<22a>'Get';</22a>\n")
  end
  #--------------------------------------------------------------------------
  # * Update PMs
  #-------------------------------------------------------------------------- 
  def self.update_pms(message)
   #Starts all the variables
   @pm = {}
   @current_Pm = nil
   @index = -1
   @message = false
   #Makes a loop to look thru the message
   for line in message
     #If the line is a new PM
     if line == "$NEWPM"
      @index+=1
      @pm[@index] = Game_PM.new(@index)
      @message = false
      #if the word has $to_from
     elsif line == "$to_from" and @message == false
       to_from = true
      #if the word has $subject
     elsif line == "$Subject" and @message == false
       subject = true
      #if the word has $message
     elsif line == "$Message" and @message == false
       @message = true
     elsif @message
       @pm[@index].message += line+"\n"
     elsif to_from
       @pm[@index].to_from = line
       to_from = false
     elsif subject
       @pm[@index].subject = line
       subject = false
     end
   end
   @pm_getting = false
 end
  #--------------------------------------------------------------------------
  # * Checks if the PM is still not get.
  #-------------------------------------------------------------------------- 
  def self.pm_getting
    return @pm_getting
  end
  #--------------------------------------------------------------------------
  # * Write PMs
  #-------------------------------------------------------------------------- 
  def self.write_pms(message)
    send = message
    @socket.send("<22d>#{send}</22d>\n")
  end
  #--------------------------------------------------------------------------
  # * Delete All PMs
  #-------------------------------------------------------------------------- 
  def self.delete_all_pms
    @socket.send("<22e>'delete'</22e>\n")
    @pm = {}
  end
  #--------------------------------------------------------------------------
  # * Delete pm(id)
  #-------------------------------------------------------------------------- 
  def self.delete_pm(id)
    @pm.delete(id)
  end
  #--------------------------------------------------------------------------
  # * Delete MapPlayers
  #-------------------------------------------------------------------------- 
  def self.mapplayers_delete
    @mapplayers = {}
  end
  #--------------------------------------------------------------------------
  # * Send Requested Data
  #-------------------------------------------------------------------------- 
  def self.send_start_request(id)
    send = ""
    # Send Username And character's Graphic Name
    send += "@username = '#{self.name}'; @character_name = '#{$game_player.character_name}'; "
    # Sends Map ID, X and Y positions
    send += "@map_id = #{$game_map.map_id}; @x = #{$game_player.x}; @y = #{$game_player.y}; "
    # Sends Name
    send += "@name = '#{$game_party.actors[0].name}'; " if User_Edit::Bandwith >= 1
    # Sends Direction
    send += "@direction = #{$game_player.direction}; " if User_Edit::Bandwith >= 2
    # Sends Move Speed
    send += "@move_speed = #{$game_player.move_speed};" if User_Edit::Bandwith >= 3 
    #@socket.send("<6a>#{id.to_i}</6a>\n")
    send += "@weapon_id = #{$game_party.actors[0].weapon_id};"
    send += "@armor1_id = #{$game_party.actors[0].armor1_id};"
    send += "@armor2_id = #{$game_party.actors[0].armor2_id};"
    send += "@armor3_id = #{$game_party.actors[0].armor3_id};"
    send += "@armor4_id = #{$game_party.actors[0].armor4_id};"
    send += "@guild = '#{$guild}';"
    @socket.send("<5>#{send}</5>\n")
    #self.send_map
  end
  #--------------------------------------------------------------------------
  # * Send Map Id data
  #-------------------------------------------------------------------------- 
  def self.send_map
    send = ""
    # Send Username And character's Graphic Name
    send += "@username = '#{self.name}'; @character_name = '#{$game_player.character_name}'; "
    # Sends Map ID, X and Y positions
    send += "@map_id = #{$game_map.map_id}; @x = #{$game_player.x}; @y = #{$game_player.y}; "
    # Sends Direction
    send += "@direction = #{$game_player.direction};" if User_Edit::Bandwith >= 2
    send += "@guild = '#{$guild}';"
    send += "@weapon_id = #{$game_party.actors[0].weapon_id};"
    send += "@armor1_id = #{$game_party.actors[0].armor1_id};"
    send += "@armor2_id = #{$game_party.actors[0].armor2_id};"
    send += "@armor3_id = #{$game_party.actors[0].armor3_id};"
    send += "@armor4_id = #{$game_party.actors[0].armor4_id};"
    @socket.send("<5>#{send}</5>\n")
    for player in @players.values
      next if player.netid == -1
      # If the Player is on the same map...
      if player.map_id == $game_map.map_id and self.in_range?(player)
        # Update Map Players
        self.update_map_player(player.netid, nil)
      elsif @mapplayers[player.netid.to_s] != nil
        # Remove from Map Players
        self.update_map_player(player.netid, nil, true)
      end
    end
  end

  #--------------------------------------------------------------------------
  # * 채팅 데이터 보냄
  #-------------------------------------------------------------------------- 
  def self.send_chat
    return if @mapplayers == {}
    send = ""
    send += "@username = '#{self.name}'; @character_name = '#{$game_player.character_name}'; "
    @socket.send("<5>#{send}</5>\n")
    for player in @players.values
      next if player.netid == -1
      # 플레이어가 같은 맵에 있을 경우
      if player.map_id == $game_map.map_id and self.in_range?(player)
        # 맵 플레이어 업데이트
        self.update_map_player(player.netid, nil)
      elsif @mapplayers[player.netid.to_s] != nil
        # 해당 플레이어 삭제
        self.update_map_player(player.netid, nil, true)
      end
    end
  end
    #--------------------------------------------------------------------------
  # * 방향 보냄
  #-------------------------------------------------------------------------- 
  def self.send_direction
    return if @mapplayers == {}
    send = ""
    # Increase Steps if the oldx or the oldy do not match the new ones
    if User_Edit::Bandwith >= 1
      send += "ic;"  if @oldx != $game_player.x or @oldy != $game_player.y
    end
    if @oldd != $game_player.direction 
      send += "@direction = #{$game_player.direction};"  
      @oldd = $game_player.direction
    end
    # Send everything that needs to be sended
    @socket.send("<5>#{send}</5>\n")
  end
  #--------------------------------------------------------------------------
  # * Send Move Update
  #-------------------------------------------------------------------------- 
  def self.send_move_change
    return if @oldx == $game_player.x and @oldy == $game_player.y
    return if @mapplayers == {}
    send = ""
    # Increase Steps if the oldx or the oldy do not match the new ones
    if User_Edit::Bandwith >= 1
      send += "ic;"  if @oldx != $game_player.x or @oldy != $game_player.y
    end
    # New x if x does not mathc the old one
    if @oldx != $game_player.x
      send += "@x = #{$game_player.x}; @tile_id = #{$game_player.tile_id};"
      @oldx = $game_player.x
    end
    # New y if y does not match the old one
    if @oldy != $game_player.y
      send += "@y = #{$game_player.y}; @tile_id = #{$game_player.tile_id};"
      @oldy = $game_player.y
    end
    # Send the Direction if it is different then before
    if User_Edit::Bandwith >= 2
      if @oldd != $game_player.direction 
        send += "@direction = #{$game_player.direction};"  
        @oldd = $game_player.direction
      end
    end
    # Send everything that needs to be sended
    @socket.send("<5>#{send}</5>\n") if send != ""
  end
  #--------------------------------------------------------------------------
  # * Send Stats
  #-------------------------------------------------------------------------- 
  def self.send_newstats
    hp = $game_party.actors[0].hp
    sp = $game_party.actors[0].sp
    agi = $game_party.actors[0].agi
    eva = $game_party.actors[0].eva
    pdef = $game_party.actors[0].pdef
    mdef = $game_party.actors[0].mdef
    level = $game_party.actors[0].level
    a = $game_party.actors[0]
    maxhp = $game_party.actors[0].maxhp
    maxsp = $game_party.actors[0].maxsp
    pci = $game_party.actors[0]
    c = "["
    m = 1
    for i in a.states
      next if $data_states[i] == nil
      c += i.to_s
      c += ", " if m != a.states.size
      m += 1
    end
    c += "]"
    stats = "@hp = #{hp}; @sp = #{sp}; @agi = #{agi}; @eva = #{eva}; @pdef = #{pdef}; @mdef = #{mdef}; @states = #{c}; @level = #{level}; @maxhp = #{maxhp}"
    @socket.send("<5>#{stats}</5>\n")
  end
  #--------------------------------------------------------------------------
  # *게임을 종료 할경우
  #-------------------------------------------------------------------------- 
  def self.close_socket
    return if @socket == nil
    자동저장
    @socket.send("<9>#{self.id}</9>\n")
    @socket.close
    @socket = nil
    end
  #--------------------------------------------------------------------------
  # * Change Messgae of the Day
  #-------------------------------------------------------------------------- 
  def self.change_mod(newmsg)
    @socket.send("<11>#{newmsg}</11>\n")
  end

  #--------------------------------------------------------------------------
  # * Check if the user exists on the network..
  #--------------------------------------------------------------------------
  def self.user_exist?(username)
    # Enable the test
    @user_test  = true
    @user_exist = false
    # Send the data for the test
    self.send_login(username.to_s,"*test*")
    # Check for how to long to wait for data (Dependent on username size)
    if username.size <= 8
      # Wait 1.5 seconds if username is less then 8
      for frame in 0..(1.5*40)
        self.update
      end
    elsif username.size > 8 and username.size <= 15
      # Wait 2.3 seconds if username is less then 15
      for frame in 0..(2.3*40)
        self.update
      end
    elsif username.size > 15
      # Wait 3 seconds if username is more then 15
      for frame in 0..(3*40)
        self.update
      end
    end
    # Start Retreival Loop
    loop = 0
    loop do
      loop += 1
      self.update
      # Break if User Test was Finished
      break if @user_test == false
      # Break if loop meets 10000
      break if loop == 10000
    end
    # If it failed, display message
    p User_Edit::USERTFAIL if loop == 10000
    # Return User exists if failed, or if it exists
    return true if @user_exist or loop == 10000
    return false
  end

  #--------------------------------------------------------------------------
  # * Send Result
  #-------------------------------------------------------------------------- 
  def self.send_result(id)
    @socket.send("<result_id>#{id}</result_id>\n")
    @socket.send("<result_effect>#{self.id}</result_effect>\n")
  end
  #--------------------------------------------------------------------------
  # * Send Dead
  #-------------------------------------------------------------------------- 
  def self.send_dead
    @socket.send("<9>#{self.id}</9>\n")
  end
  #--------------------------------------------------------------------------
  # * Update Net Players
  #-------------------------------------------------------------------------- 
  def self.update_net_player(id, data)
    # Turn Id in Hash into Netplayer (if not yet)
    @players[id] ||= Game_NetPlayer.new 
    # Set the Global NetId if it is not Set yet
    @players[id].do_id(id) if @players[id].netid == -1
    # Refresh -> Change data to new data
    @players[id].refresh(data)      
    # Return if the Id is Yourself
    return if id.to_i == self.id.to_i
    # Return if you are not yet on a Map
    return if $game_map == nil
    # If the Player is on the same map...
    if @players[id].map_id == $game_map.map_id
      # Update Map Players
      self.update_map_player(id, data)
    elsif @mapplayers[id] != nil
      # Remove from Map Players
      self.update_map_player(id, data, true)
    end
  end
  #--------------------------------------------------------------------------
  # * Update Map Players
  #-------------------------------------------------------------------------- 
  def self.update_map_player(id, data, kill=false)
    # Return if the Id is Yourself
    return if id.to_i == self.id.to_i
    # If Kill (remove) is true...
    if kill and @mapplayers[id] != nil
      # Delete Map Player
      @mapplayers.delete(id.to_i) rescue nil
      if $scene.is_a?(Scene_Map)
         $scene.spriteset.delete(id.to_i) rescue nil
      end
      $game_temp.spriteset_refresh = true
      return
    end
    g = @mapplayers[id]
    @mapplayers[id] ||= @players[id] if @players[id] != nil
    # Turn Id in Hash into Netplayer (if not yet)
    @mapplayers[id] ||= Game_NetPlayer.new
    # Set the Global NetId if it is not Set yet
    @mapplayers[id].netid = id if @mapplayers[id].netid == -1
    # Refresh -> Change data to new data
    @mapplayers[id].refresh(data)
    #Send the player's new stats
    self.send_newstats if g == nil
  end
  #--------------------------------------------------------------------------
  # * Update Net Actors
  #-------------------------------------------------------------------------- 
  def self.update_net_actor(id,data,actor_id)
    return
    return if id.to_i == self.id.to_i
    # Turn Id in Hash into Netplayer (if not yet)
    @netactors[id] ||= Game_NetActor.new(actor_id)
    # Set the Global NetId if it is not Set yet
    @netactors[id].netid = id if @netactors[id].netid == -1
    # Refresh -> Change data to new data
    @netactors[id].refresh(data)
  end
  #--------------------------------------------------------------------------
  # * Update
  #-------------------------------------------------------------------------- 
  def self.update
    # If Socket got lines, continue
    return unless @socket.ready?
    for line in @socket.recv(0xfff).split("\n")
      @nooprec += 1 if line.include?("\000\000\000\000") 
      return if line.include?("\000\000\000\000")
      p "#{line}" unless line.include?("<5>") or line.include?("<6>")or not $DEBUG or not User_Edit::PRINTLINES
      # Set Used line to false
      updatebool = false
      #Update Walking
      updatebool = self.update_walking(line) if @login and $game_map != nil
      # Update Ingame Protocol, if LogedIn and Map loaded
      updatebool = self.update_ingame(line)  if updatebool == false and @login and $game_map != nil
      # Update System Protocol, if command is not Ingame
      updatebool = self.update_system(line)  if updatebool == false 
      # Update Admin/Mod Protocol, if command is not System
      updatebool = self.update_admmod(line)  if updatebool == false
      # Update Outgame Protocol, if command is not Admin/Mod
      updatebool = self.update_outgame(line) if updatebool == false
    end
  end
  #--------------------------------------------------------------------------
  # * Send Message
  #-------------------------------------------------------------------------- 
  def self.send_message(message, name)
    unless name != $game_party.actors[0].name
      send = ""
      send += "@message = '#{message}';"
      @socket.send("<5>#{send}</5>\n")
    end
  end
  #--------------------------------------------------------------------------
  # * 길드 시스템
  #-------------------------------------------------------------------------- 
  def self.guild_message(guild_name, message)
    @socket.send("<Guild_Message>#{guild_name},#{message}</Guild_Message>\n")
  end
  def self.guild_system(guild_name, invite_name)
    @socket.send("<Guild_system>#{guild_name},#{invite_name}</Guild_system>\n")
  end
  #--------------------------------------------------------------------------
  # * 파티 시스템
  #-------------------------------------------------------------------------- 
  def self.party_system(party_name, message, party, invite_name)
    @socket.send("<party_system>#{party_name},#{message},#{party},#{invite_name}</party_system>\n")
  end
  #--------------------------------------------------------------------------
  # * 파티 추방 시스템
  #-------------------------------------------------------------------------- 
  def self.party_delete(party_name, name, message)
    @socket.send("<party_system2>#{party_name},#{name},#{message}</party_system2>\n")
  end
  #--------------------------------------------------------------------------
  # * 교환 시스템
  #-------------------------------------------------------------------------- 
  def self.trade_system(trade_invite, player)
    @socket.send("<trade_system>#{trade_invite},#{player}</trade_system>\n")
  end
  
  #--------------------------------------------------------------------------
  # * Update Admin and Mod Command Recievals -> 18
  #-------------------------------------------------------------------------- 
  def self.update_admmod(line)
    case line
     # Admin Command Recieval
     when /<ki>(.*),(.*),(.*)<\/ki>/
      # Kick All Command
      if $1.to_s == "모두"
        if $3.to_s != $game_party.actors[0].name
          p "운영자의 명령어로 인해 모든 플레이어가 서버에서 강퇴당하였습니다."
          self.close_socket
        end
        return true
      # Kick Command
      elsif $1.to_s == $game_party.actors[0].name
        p $2.to_s
        self.close_socket
        return true
      end
     return false
    end
    return false
  end

  #--------------------------------------------------------------------------
  # * Update all Not-Ingame Protocol Parts -> 0, login, reges
  #-------------------------------------------------------------------------- 
  def self.update_outgame(line)
    case line
     when /<0 (.*)>(.*) n=(.*)<\/0>/ 
      a = self.authenficate($1,$2)
      @servername = $3.to_s
      return true if a
     when /<reges>(.*)<\/reges>/
        if $1 == "wu"
          Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2 + 50, 200,
          ["비밀번호가 한글 이거나 이미 아이디가 있습니다."],
          ["확인"], ["Hwnd.dispose(self)"], "에러")
        else
          Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2 + 50, 200,
          ["회원가입에 성공 하셨습니다."],
          ["확인"], ["Hwnd.dispose(self)"], "성공")
          
        end
      return true
     when /<nick_name>(.*)<\/nick_name>/
       data = $1.split(',')
       if data[0].to_s != "No"
         self.send_register(data[0].to_s,data[1].to_s)
       else
          Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2 + 50, 200,
          ["이미 이 닉네임은 누군가 사용하고 있습니다."],
          ["확인"], ["Hwnd.dispose(self)"], "에러")
        end
     when /<exist1>(.*)<\/exist1>/
       data = $1.split(',')
       if data[0].to_s != "No"
         self.send_login(data[0].to_s,data[1].to_s)
       else
        Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2 + 50, 200,
        ["누군가 그 아이디를 사용하고 있습니다."],
        ["확인"], ["Hwnd.dispose(self)"], "에러")
       end
     when /<login>(.*)<\/login>/
      if not @user_test
        if $1 == "allow" and not @user_test
          @login = true
          Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2 + 50, 200,
          ["로그인에 성공 하셨습니다."],
          ["확인"], ["Hwnd.dispose(self)"], "성공")
          self.get_name
          loop = 0
          loop do
            self.update
            loop += 1
            break if loop == 10000
            break if self.name != "" and self.name != nil and self.id != -1
          end
          self.get_group
          파일확인
          
          return true
        elsif $1 == "wu" and not @user_test
              Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2 + 50, 200,
              ["아이디를 잘못 치셨습니다."],
              ["확인"], ["Hwnd.dispose(self)"], "오류")
              $scene.set_status(@status) if $scene.is_a?(Jindow_Login)
          return true
        elsif $1 == "wp" and not @user_test
              Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2 + 50, 200,
              ["비밀번호를 잘못 치셨습니다."],
              ["확인"], ["Hwnd.dispose(self)"], "오류")
              $scene.set_status(@status) if $scene.is_a?(Jindow_Login)
        elsif @user_test == true
              Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2 + 50, 200,
              ["이미 아이디가 사용되어지고 있습니다."],
              ["확인"], ["Hwnd.dispose(self)"], "오류")
          return true
        end
      else
        @user_exist = false
        if $1 == "wu"
          @user_exist = false
          @user_test = false
        elsif $1 == "wp"
          @user_exist = true
          @user_test = false
        end
        return true
      end
      return false
    end
    return false
  end


  #--------------------------------------------------------------------------
  # * Update System Protocol Parts -> ver, mod, 1, 2, 3, 10
  #-------------------------------------------------------------------------- 
  def self.update_system(line)
    case line
     # Version Recieval
     when /<versione>(.*)<\/versione>/ 
      @version = $1.to_s if $1.to_s != nil 
      if $game_temp.versione != @version
        print ("현재 클라이언트의 버전이 낮습니다.\n새로운 클라이언트를 다운 받아주십시오.")
        @socket.send("<9>#{self.id}</9>\n")
        @socket.close
        @socket = nil
        $scene = nil
      end
      return true
     # Message Of the Day Recieval
     when /<mod>(.*)<\/mod>/
      $game_temp.motd = $1.to_s
      return true
     # User ID Recieval (Session Based)
     when /<1>(.*)<\/1>/
      @id = $1.to_s
      return true
     # User Name Recieval
     when /<2>(.*)<\/2>/
      @name = $1.to_s
      return true
     # Group Recieval
     when /<3>(.*)<\/3>/
      @group = $1.to_s
      return true
     when /<check>(.*)<\/check>/
      @group = $1.to_s
      return true
     # System Update
     when /<10>(.*)<\/10>/
      eval($1)
      $game_map.need_refresh = true
      $game_map.update
      return true
      
    when /<10a>(.*)<\/10a>/
      eval($1)
      $game_map.need_refresh = true if $game_map != nil
      $game_map.update if $game_map != nil
      return true
      
     when /<10b>(.*)<\/10b>/
      eval($1)
      $game_map.need_refresh = true
      $game_map.update
      return true
      
    #-----------하우징 시스템 -----------------

     when /<housere1>(.*)<\/housere1>/
      $game_map.update
      $game_map.need_refresh = true
      $game_player.refresh
      $global_house1 += 1
      $house1 = $1.to_s if $global_house1 == 3  #이름 변수
      $game_variables[402] = $1.to_s if $global_house1 == 3 #이름 변수
      $game_map.update
      $game_map.need_refresh = true
      $game_player.refresh
      return true
      
     when /<housere2>(.*)<\/housere2>/
      $game_map.update
      $game_map.need_refresh = true
      $game_player.refresh
      $global_house2 += 1
      $house2 = $1.to_s if $global_house2 == 3
      $game_variables[403] = $1.to_s if $global_house2 == 3
      if $global_house2 == 3
        $global_house2 = 0
        end
      $game_map.update
      $game_map.need_refresh = true
      $game_player.refresh
      return true
      
    when /<housere3>(.*)<\/housere3>/
      $game_map.update
      $game_map.need_refresh = true
      $game_player.refresh
      $global_house3 += 1
      $house3 = $1.to_s if $global_house3 == 3
      $game_variables[404] = $1.to_s if $global_house3 == 3
      $game_map.update
      $game_map.need_refresh = true
      $game_player.refresh
      return true
      
     when /<housere4>(.*)<\/housere4>/
      $game_map.update
      $game_map.need_refresh = true
      $game_player.refresh
      $global_house4 += 1
      $house4 = $1.to_s if $global_house4 == 3
      $game_variables[405] = $1.to_s if $global_house4 == 3
      $game_map.update
      $game_map.need_refresh = true
      $game_player.refresh
      return true
            
   #---------------엔피씨 배치 시스템----------------       
   
    when /<npc_batch>(.*)<\/npc_batch>/ 
      data = $1.split('.')
        for npc_data in data
          npc_data2 = npc_data.split(',')
          if npc_data2[0].to_i != 0
            create_events(npc_data2[0].to_i, npc_data2[1].to_i, npc_data2[2].to_i, npc_data2[3].to_i, npc_data2[4].to_i , npc_data2[5].to_i)
          end
        end
        #return true
    when /<npc_regen>(.*)<\/npc_regen>/
      data = $1.split('.')
        for npc_data in data
          npc_data2 = npc_data.split(',')
          if npc_data2[0].to_i != 0
            if $mob_id[npc_data2[0].to_i] == $game_map.map_id
              $mob_id[npc_data2[0].to_i] = nil
              create_events(npc_data2[0].to_i, npc_data2[1].to_i, npc_data2[2].to_i, npc_data2[3].to_i, npc_data2[4].to_i , npc_data2[5].to_i)
            end
          end
        end
        return true
    when /<npc_move>(.*)<\/npc_move>/
      data = $1.split(',')
      if data[1].to_i == $game_map.map_id
        if data[5].to_s != $game_party.actors[0].name
          $game_map.events[data[0].to_i].direction = data[2].to_i
          $game_map.events[data[0].to_i].moveto(data[3].to_i, data[4].to_i)
        end
      end
      return true
    
      
      
    when /<npc_make>(.*)<\/npc_make>/
      data = $1.split('.')
        for npc_data in data
          npc_data2 = npc_data.split(',')
          if npc_data2[0].to_i != 0
          보관이벤트(npc_data2[1].to_i).moveto(npc_data2[2].to_i, npc_data2[3].to_i)
          end
        end
        
        
        
#-------------------------------------------

      
     when /<10c>(.*)<\/10c>/
      eval($1)
      $game_map.need_refresh = true
      $game_map.update
      return true
      
    when /<glows>(.*)<\/glows>/
      p $1.to_s
      $game_map.need_refresh = true
      $scene.update
      $game_map.update
      return true
      
     when /<23>(.*)<\/23>/
      eval($1)
      key = []
      key.push(@self_key1)
      key.push(@self_key2)
      key.push(@self_key3)
      $game_self_switches[key] = @self_value
      @self_key1 = nil
      @self_key2 = nil
      @self_key3 = nil
      @self_value = nil
      $game_map.need_refresh = true
      key = []
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Update Walking
  #-------------------------------------------------------------------------- 
  def self.update_walking(line)
    case line
    # Player information Processing
     when /<player id=(.*)>(.*)<\/player>/
      self.update_net_player($1, $2)
      return true
     # Player Processing
     when /<5 (.*)>(.*)<\/5>/
      # Update Player
      self.update_net_player($1, $2)
      # If it is first time connected...
      return true if !$2.include?("start")
      # ... and it is not yourself ...
      return true if $1.to_i == self.id.to_i
      # ... and it is on the same map...
      return true if @players[$1].map_id != $game_map.map_id
      # ...  Return the Requested Information
      return true if !self.in_range?(@players[$1])
      self.send_start_request($1.to_i) 
      $game_temp.spriteset_refresh = true
     return true
     # Map PLayer Processing
     when /<6 (.*)>(.*)<\/6>/
      # Return if it is yourself
      return true if $1.to_i == self.id.to_i
      # Update Map Player
      #self.update_map_player($1, $2)
      self.update_net_player($1, $2)
      # If it is first time connected...
      if $2.include?("start") or $2.include?("map")
        # ... and it is not yourself ...
        return true if $1.to_i != self.id.to_i
        # ... and it is on the same map...
        return true if @players[$1].map_id != $game_map.map_id
        # ...  Return the Requested Information
        return true if !self.in_range?(@players[$1])
        self.send_start_request($1.to_i)
        $game_temp.spriteset_refresh = true
      end
      return true
    # Map PLayer Processing
     when /<netact (.*)>data=(.*) id=(.*)<\/netact>/
      # Return if it is yourself
      return true if $1.to_i == self.id.to_i
      # Update Map Player
      self.update_net_actor($1, $2, $3)
      return true
    when /<state>(.*)<\/state>/
      $game_party.actors[0].refresh_states($1)
      
      when /<pskill>(.*),(.*),(.*),(.*)<\/pskill>/  
        
    if $party.include? ($1.to_s)
        if $4.to_i == $game_map.map_id
          $game_party.actors[0].hp += $2.to_i
          $game_player.animation_id = $3.to_i
        end
      end
      
    # Attacked!
    when /<attack_effect>dam=(.*) ani=(.*) id=(.*)<\/attack_effect>/
      $game_party.actors[0].hp -= $1.to_i if $1.to_i > 0 and $1 != "Miss"
      $game_player.jump(0, 0) if $1.to_i > 0 and $1 != "Miss"
      $game_player.animation_id = $2.to_i if $1.to_i > 0 and $1 != "Miss"
      $game_player.show_demage($1.to_i,false) if $1.to_i > 0 and $1 != "Miss"
      self.send_newstats
      if $game_party.actors[0].hp <= 0 or $game_party.actors[0].dead?
        self.send_result($3.to_i)
        self.send_dead
        $scene = Scene_Gameover.new 
      end
      return true
      # Killed
     when /<result_effect>(.*)<\/result_effect>/ 
       $ABS.netplayer_killed
       return true
    end
    return false
  end

  #--------------------------------------------------------------------------
  # * 데이터들
  #-------------------------------------------------------------------------- 
  def self.update_ingame(line)
    case line
     when /<6a>(.*)<\/6a>/
       @send_conf = true
       return true if $1.to_s ==  "'Confirmed'"
       
    when /<dataload>(.*)<\/dataload>/
      $global_x += 1
      #이름
      $name = $1.to_s if $global_x == 2
      #직업
      $game_party.actors[0].class_id = $1.to_i if $global_x == 3
      #레벨
      $game_party.actors[0].level = $1.to_i if $global_x == 4
      #경험치
      $game_party.actors[0].exp = $1.to_i if $global_x == 5
      #스텟
      $str = $1.to_i if $global_x == 6
      $dex = $1.to_i if $global_x == 7
      $agi = $1.to_i if $global_x == 8
      $int = $1.to_i if $global_x == 9
      #최대체력/마력
      $game_party.actors[0].maxhp = $1.to_i if $global_x == 10
      $game_party.actors[0].maxsp = $1.to_i if $global_x == 11
      #맵아이디 ,좌표, 방향
      $new_id = $1.to_i if $global_x == 12
      $new_x = $1.to_i if $global_x == 13
      $new_y = $1.to_i if $global_x == 14
      $new_d = $1.to_i if $global_x == 15
      $charp = $1.to_i if $global_x == 16

      #착용 장비
      $armedweapon = $1 if $global_x == 17
      $armedarmor1 = $1 if $global_x == 18
      $armedarmor2 = $1 if $global_x == 19
      $armedarmor3 = $1 if $global_x == 20
      $armedarmor4 = $1 if $global_x == 21
      
      
      # 아이템
      if $global_x == 22
        item = []
        item = $1.split('.')
       for data in item
         info = data.split(',')
         if info[0].to_i != nil or info[0].to_i != 0 or info[0].to_i != ""
           $game_party.gain_item(info[0].to_i, info[1].to_i)
         end
       end
       end
      
       #무기
      if $global_x == 23
        weapon = []
        weapon = $1.split('.')
       for data2 in weapon
         info1 = data2.split(',')
         if info1[0].to_i != nil or info1[0].to_i != 0 or info1[0].to_i != ""
           $game_party.gain_weapon(info1[0].to_i, info1[1].to_i)
         end
       end
     end
     
       
     # 방어구
      if $global_x == 24
        armor = []
        armor = $1.split('.')
       for data3 in armor
         info2 = data3.split(',')
         if info2[0].to_i != nil or info2[0].to_i != 0 or info2[0].to_i != ""
           $game_party.gain_armor(info2[0].to_i, info2[1].to_i)
         end
       end
     end
    
     #스킬 리스트
      if $global_x == 25
        skill = []
        skill = $1.split('.')
       for skill_id in skill
          if skill_id.to_i > 0
            $game_party.actors[0].skills.push(skill_id)
          end
       end
     end
     
     # 금전
      $game_party.gain_gold($1.to_i) if $global_x == 26
      
      #현재 체력
      $game_party.actors[0].hp = $1.to_i if $global_x == 27
      
      #현재 마력
      $game_party.actors[0].sp = $1.to_i if $global_x == 28  
        
      # 스위치
      if $global_x == 29
        sw = []
        sw = $1.split ","
        for i in 0..sw.size
          if sw[i] == "1"
            $game_switches[i] = true
          elsif sw[i] == "0"
            $game_switches[i] = false
          end
        end
        
        # 변수
      if $global_x == 30
        va = []
        va = $1.split ","
          for i in 0..va.size
            $game_variables[i] = va[i].to_i
          end
        end
      
      
        $game_party.actors[0].name = $name
        $game_map.setup($new_id) 
        $game_player.moveto($new_x, $new_y) 
        $game_player.direction = $new_d
        $game_party.gain_weapon($armedweapon.to_i,1)
        $game_party.gain_armor($armedarmor1.to_i,1)
        $game_party.gain_armor($armedarmor2.to_i,1)
        $game_party.gain_armor($armedarmor3.to_i,1)
        $game_party.gain_armor($armedarmor4.to_i,1)
        $game_party.actors[0].equip(0, $armedweapon.to_i)
        $game_party.actors[0].equip(1, $armedarmor1.to_i)
        $game_party.actors[0].equip(2, $armedarmor2.to_i)
        $game_party.actors[0].equip(3, $armedarmor3.to_i)
        $game_party.actors[0].equip(4, $armedarmor4.to_i)
        $game_party.lose_weapon(1,1)
        $game_party.actors[0].str = $str
        $game_party.actors[0].dex = $dex
        $game_party.actors[0].agi = $agi
        $game_party.actors[0].int = $int
        $game_player.refresh
        $game_map.autoplay
        $game_map.update 
        $scene = Scene_Map.new 
        Network::Main.send_start
        if $game_party.actors[0].name == "평민"
          p "데이터 로드에 실패했습니다. 다시 실행해주세요."
         exit
       else
      Network::Main.socket.send("<chat>[알림]:'#{$game_party.actors[0].name}'님께서 흑부엉온라인에 접속 하셨습니다.</chat>\n")      
      $nowtrade = 0
      $game_player.move_speed = 3
      $game_switches[401] = true
      a번하우징
      b번하우징
      c번하우징
      d번하우징
    end
end

    
     when /<guild_load>(.*)<\/guild_load>/
       if @value == 0 # 길드 로드.
         guild_data = $1.split(',')
         $guild = guild_data[0].to_s
         $guild_master = guild_data[1].to_s
         if guild_data[1].to_s == $game_party.actors[0].name
           $guild_group = "문파장"
         end
         @value += 1
         
       elsif @value >= 1 # 길드 멤버 설정.
         guild_data = $1.split('.')
         for data in guild_data
           guild_data2 = data.split(',')
           if guild_data2[1].to_s == $game_party.actors[0].name
             if $guild_master != $game_party.actors[0].name
               $guild_group = guild_data2[0].to_s
             end
           end
           $guild_member.push(guild_data2[0] + "," + guild_data2[1] + ".")
         end
       end
       
     when /<switches>(.*)<\/switches>/
       switches_data = $1.split('.')
       for data in switches_data
       eval(data)
       $game_map.need_refresh = true
     end
     
    when /<idsave>(.*)<\/idsave>/
     $game_variables[600] = $1.to_s


     when /<variables>(.*)<\/variables>/
       variables_data = $1.split('.')
       for data in variables_data
         eval(data)
      $game_map.need_refresh = true
    end
    
     when /<chat>(.*),(.*)<\/chat>/
       if $scene.is_a?(Scene_Map)
         if $2.to_i == 0
          $game_temp.chat_log.push($1.to_s)
          $game_temp.chat_refresh = true
        else
          $chat.write("공지 : " + $1.to_s, Color.new(0, 0, 0))
          $game_temp.chat_log.push($1.to_s)
          $game_temp.chat_refresh = true
         end
      end
      return true
      
     when /<post>(.*),(.*),(.*),(.*),(.*),(.*)<\/post>/
       if $scene.is_a?(Scene_Map)
         if $1.to_s == $game_party.actors[0].name
           case $3.to_i
           when 0#무기
             $game_party.gain_weapon($2.to_i, $5.to_i)
             $console.write_line("◎ 인벤토리에 우편물이 왔습니다.확인하여 주시길 봐랍니다.")
             $console.write_line("◎ 보낸이 : #{$4.to_s} 보낸 아이템 : #{$data_weapons[$2.to_i].name} x #{$5.to_i}")
             $console.write_line("◎ 내용 : #{$6.to_s}", Color.new(65,105, 0))
           when 1#방어구
             $game_party.gain_armor($2.to_i, $5.to_i)
             $console.write_line("◎ 인벤토리에 우편물이 왔습니다.확인하여 주시길 봐랍니다.")
             $console.write_line("◎ 보낸이 : #{$4.to_s} 보낸 아이템 : #{$data_armors[$2.to_i].name} x #{$5.to_i}")
             $console.write_line("◎ 내용 : #{$6.to_s}", Color.new(65,105, 0))
           when 2#기타
             $game_party.gain_item($2.to_i, $5.to_i)
             $console.write_line("◎ 인벤토리에 우편물이 왔습니다.확인하여 주시길 봐랍니다.")
             $console.write_line("◎ 보낸이 : #{$4.to_s} 보낸 아이템 : #{$data_items[$2.to_i].name} x #{$5.to_i}")
             $console.write_line("◎ 내용 : #{$6.to_s}", Color.new(65,105, 0))
           end
         end
       end
       return true
     when /<skill>(.*)<\/skill>/
       skill_data = $1.split(',')
       for index in 0..skill_data.size
         $game_party.actors[0].learn_skill(skill_data[index].to_i)
       end
       #return true
     when /<item>(.*)<\/item>/
       item_data = $1.split('.')
       for data in item_data
         info = data.split(',')
         if info[0].to_i != nil or info[0].to_i != 0 or info[0].to_i != ""
           $game_party.gain_item(info[0].to_i, info[1].to_i)
         end
       end
       #return true
     when /<weapon>(.*)<\/weapon>/
       weapon_data = $1.split('.')
       for data in weapon_data
         info1 = data.split(',')
         $game_party.gain_weapon(info1[0].to_i, info1[1].to_i)
       end
       #return true
     when /<armor>(.*)<\/armor>/
       armor_data = $1.split('.')
       for data in armor_data
         info2 = data.split(',')
         $game_party.gain_armor(info2[0].to_i, info2[1].to_i)
       end
       #return true
     when /<summon>(.*),([0-9]+),([0-9]+),([0-9]+)<\/summon>/
       if $1.to_s == $game_party.actors[0].name
         $console.write_line("운영자님께서 당신을 소환 하셨습니다.")
         $game_temp.player_new_map_id = $2.to_i
         $game_temp.player_new_x = $3.to_i
         $game_temp.player_new_y = $4.to_i
         $game_temp.player_new_direction = 1
         $game_temp.player_transferring = true
       end
     when /<all_summon>([0-9]+),([0-9]+),([0-9]+)<\/all_summon>/
        $console.write_line("운영자님께서 당신을 소환 하셨습니다.")
        $game_temp.player_new_map_id = $1.to_i
        $game_temp.player_new_x = $2.to_i
        $game_temp.player_new_y = $3.to_i
        $game_temp.player_new_direction = 1
        $game_temp.player_transferring = true
        
     when /<prison>(.*)<\/prison>/
    Network::Main.socket.send "<chat>'#{$1.to_s}'님께서 감옥으로 갔습니다.</chat>\n"
      if $1.to_s == $game_party.actors[0].name
         $console.write_line("운영자님께서 당신을 감옥으로 보냈습니다.")
          $game_temp.player_new_map_id = 98
          $game_temp.player_new_x = 8
          $game_temp.player_new_y = 4
          $game_temp.player_new_direction = 1
          $game_temp.player_transferring = true
        end
        
      when /<emancipation>(.*)<\/emancipation>/
    Network::Main.socket.send "<chat>'#{$1.to_s}'님께서 감옥에서 석방 되셨습니다.</chat>\n"
       if $1.to_s == $game_party.actors[0].name
          $game_temp.player_new_map_id = 2
          $game_temp.player_new_x = 3
          $game_temp.player_new_y = 5
          $game_temp.player_new_direction = 1
          $game_temp.player_transferring = true
        end
        
     when /<cashgive>(.*),(.*)<\/cashgive>/
       if $1.to_s == $game_party.actors[0].name
         if $2.to_s == "5000"
          $game_variables[213] += 5000
        end
          if $2.to_s == "3000"
          $game_variables[213] += 3000
        end
          if $2.to_s == "2000"
          $game_variables[213] += 2000
        end
            if $2.to_s == "1000"
          $game_variables[213] += 1000
        end
           if $2.to_s == "500"
          $game_variables[213] += 500
        end
        $console.write_line("#{$2.to_s}Cash 가 충전되었습니다.")
      end
      
        when /<bigsay>(.*),(.*)<\/bigsay>/
       간단메세지("[세계후] #{$1.to_s} : #{$2.to_s}")
       $chat.write("[세계후] #{$1.to_s} : #{$2.to_s}", Color.new(65, 105, 255))

        
        
     when /<Drop>(.*)<\/Drop>/
       data = $1.split(',')
       index = data[0].to_i
       if data[3].to_i == $game_map.map_id
         $Drop[index] = Drop.new
         $Drop[index].id = data[6].to_i
         $Drop[index].type = data[1].to_i
         $Drop[index].type2 = data[2].to_i
         if $Drop[index].type2 == 0
           $Drop[index].amount = data[6].to_i
         end
          if $Drop[index].type2 == 1
            if data[1].to_i == 0
              image = $data_items[$Drop[index].id].icon_name
            elsif data[1].to_i == 1
              image = $data_weapons[$Drop[index].id].icon_name
            elsif data[1].to_i == 2
              image = $data_armors[$Drop[index].id].icon_name
            end
            create_drops(data[0].to_i, 8, data[3].to_i, 2, data[4].to_i, data[5].to_i, image)
          elsif $Drop[index].type2 == 0
            create_moneys(data[0].to_i, 8, data[3].to_i, 2, data[4].to_i, data[5].to_i)
          end
       end
     when /<Drop_Get>(.*)<\/Drop_Get>/
       data = $1.split(',')
       id = data[0].to_i
       if data[1].to_i == $game_map.map_id
         if $Drop[id] != nil
           $Drop[id] = nil
           delete_events(id)
         end
       end
       
     when /<chat1>(.*),(.*)<\/chat1>/
       if $scene.is_a?(Scene_Map)
         if $2.to_i == 0
          $chat.write($1.to_s, Color.new(105, 105, 105))
          $game_temp.chat_log.push($1.to_s)
          $game_temp.chat_refresh = true
      end
    end
    
#----------------------------길드---------------------------------
      return true
    when /<Guild_Create>(.*),(.*)<\/Guild_Create>/ 
      if $2.to_s == "possible"
        $guild = $1.to_s
        $guild_master = $game_party.actors[0].name
        $guild_group = "문파장"
        $guild_member.push("문파장" + "," + $game_party.actors[0].name + ".")
        self.socket.send "<Guild_Create2>#{$guild},#{$guild_master}</Guild_Create2>\n"
        self.socket.send "<Guild_Member>#{$guild},문파장,#{$game_party.actors[0].name}.</Guild_Member>\n"
        $console.write_line("'#{$guild}' 문파가 만들어졌습니다.")
        
      elsif $2.to_s == "impossible"
        $console.write_line("이미 같은 이름을 가진 문파가 있습니다.")
        Jindow_Guild_Create.new
      end
    when /<Guild_Invite>(.*)<\/Guild_Invite>/ 
      data = $1.split(',')
      if data[0] == $game_party.actors[0].name
        Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 100 / 2 + 50, 280,
        ["문파 '#{data[1]}'에서 당신을 초대했습니다. 수락하시겠습니까?"],["확인", "취소"], 
        ["$guild = '#{data[1]}'; $guild_master = '#{data[2]}'; $guild_group = '문파원'; $chat.write '#{$guild} 문파에 가입하셨습니다.'; Network::Main.socket.send '<Guild_Member>#{data[1]},문파원,#{$game_party.actors[0].name}.</Guild_Member>\n'; Hwnd.dispose(self)", 
        "$chat.write '#{$guild} 문파에 가입 신청을 거절하셨습니다.'"], "문파 초대")
        end 
    when /<Guild_Member2>(.*)<\/Guild_Member2>/ 
      if $1.to_s == $guild.to_s
        $guild_member = []
      end
    when /<Guild_Member>(.*)<\/Guild_Member>/ 
      data = $1.split(',')
      if data[0].to_s == $guild.to_s
        $guild_member.push(data[1] + "," + data[2])
      end
    when /<Guild_Delete>(.*)<\/Guild_Delete>/ 
      data = $1.to_s
      self.guild_message($guild.to_s, " '#{data}'님께서 문파에서 추방 당하셨습니다.")

      
    when /<Guild_Delete2>(.*)<\/Guild_Delete2>/ 
      data = $1.to_s
      if data == $game_party.actors[0].name
        $guild = ""
        $guild_master = ""
        $guild_group = ""
        $guild_member = []
         $console.write_line("'#{data}'님께서는 문파에서 추방 당하셨습니다.")
        self.socket.send "<guild>#{$guild}</guild>\n"
      end
      
    when /<Guild_Delete3>(.*)<\/Guild_Delete3>/ 
      self.guild_message($guild.to_s, "'#{$game_party.actors[0].name}'님께서 문파를 탈퇴 하셨습니다.")
      $guild = ""
      $guild_master = ""
      $guild_group = ""
      $guild_member = []
        $console.write_line("문파를 탈퇴 하셨습니다.")
      self.socket.send "<guild>#{$guild}</guild>\n"
      
    when /<Guild_Remove>(.*)<\/Guild_Remove>/ 
        $console.write_line("" + $guild.to_s + " 문파장이 문파를 폐쇄하였습니다.")
      $guild = ""
      $guild_master = ""
      $guild_group = ""
      $guild_member = []

      self.socket.send "<guild>#{$guild}</guild>\n"
    when /<Guild_Message>(.*)<\/Guild_Message>/ 
      data = $1.split(',')
      if data[0].to_s == $guild.to_s
        $chat.write (data[1], Color.new(65,105, 0))
      end
      
    when /<whispers>(.*),(.*),(.*)<\/whispers>/ 
      if $1.to_s == $game_party.actors[0].name
        $chat.write("(귓속말) #{$2.to_s} : #{$3.to_s}", Color.new(136, 255, 50))
      elsif $2.to_s == $game_party.actors[0].name
        $chat.write("(귓속말) #{$1.to_s} <<< #{$3.to_s}", Color.new(136, 255, 50))
      end
      
      when /<partymessage>(.*),(.*),(.*),(.*)<\/partymessage>/ 
      if $npt == $4.to_s
      $chat.write("(파티말) #{$1.to_s}(#{$2.to_s}) : #{$3.to_s}", Color.new(205, 133, 63))

    end
    
      
    when /<event_animation>(.*),(.*),(.*)<\/event_animation>/
      if $3.to_i == $game_map.map_id
        $game_map.events[$1.to_i].animation_id = $2.to_i
      end
    return true
   
    when /<player_animation>(.*)<\/player_animation>/
      eval($1)
      if @ani_map == $game_map.map_id
       if @ani_id != -1
        $ani_character[@ani_id.to_i].animation_id = @ani_number if $ani_character[@ani_id.to_i]
       end
      end
     @ani_id = -1; @ani_map = -1; @ani_number = -1;
     return true
     
    when /<trade_invite>(.*),(.*)<\/trade_invite>/
      if $1.to_s == $game_party.actors[0].name
        Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 82 / 2, 250,
        ["'#{$2.to_s}'님께서 교환 신청을 하셨습니다.수락 하시겠습니까?"], ["예", "아니오"],
        ["$trade_player = '#{$2.to_s}'; Network::Main.trade_system('#{$1.to_s}', '#{$2.to_s}'); $chat.write '#{$2.to_s}님의 교환 신청을 수락 하셨습니다.'; Hwnd.dispose(self)" ,
        "$chat.write '#{$2.to_s}님의 교환 신청을 거절 하셨습니다.'; Hwnd.dispose(self)"], "교환 신청")
      end
      return true
    when /<trade_system>(.*),(.*)<\/trade_system>/
      if $2.to_s == $game_party.actors[0].name
        $trade_player = $1.to_s
        Jindow_Trade.new
      elsif $1.to_s == $game_party.actors[0].name
        Jindow_Trade.new
      end
      return true
    when /<trade_item>(.*),(.*),(.*),(.*)<\/trade_item>/
      if $1.to_s == $game_party.actors[0].name
        if $trade_item[5] != 1
          case $4.to_i
         when 0
            $item_number[2] = Jindow_Trade_Data.new
            $item_number[2].id = $2.to_i
            $item_number[2].type = 0
            $item_number[2].amount = $3.to_i
            $trade_item[2] = 1
          when 1
            $item_number[2] = Jindow_Trade_Data.new
            $item_number[2].id = $2.to_i
            $item_number[2].type = 1
            $item_number[2].amount = $3.to_i
            $trade_item[2] = 1
          when 2
            $item_number[2] = Jindow_Trade_Data.new
            $item_number[2].id = $2.to_i
            $item_number[2].type = 2
            $item_number[2].amount = $3.to_i
            $trade_item[2] = 1
          end
        end
      end
      return true
    when /<trade_money>(.*),(.*)<\/trade_money>/
      if $1.to_s == $game_party.actors[0].name
        $trade_player_money = $2.to_i
      end
      return true
    when /<trade_okay>(.*)<\/trade_okay>/
      if $1.to_s == $game_party.actors[0].name
        $trade2_ok = 1
        $console.write_line("상대방이 교환 준비 완료 상태입니다.")
      end
    when /<trade_fail>(.*),(.*)<\/trade_fail>/
      if $1.to_s == $game_party.actors[0].name
        $nowtrade = 0
        $console.write_line("교환이 취소 되었습니다.")
        Hwnd.dispose("Trade")
        $item_number.clear
        $trade_item.clear
        $trade2_ok = 0
        $trade1_ok = 0
        $trade_player_money = 0
        $trade_player = ""
      elsif $2.to_s == $game_party.actors[0].name
        $nowtrade = 0
        $console.write_line("교환이 취소 되었습니다.")
        Hwnd.dispose("Trade")
        $item_number.clear
        $trade_item.clear
        $trade2_ok = 0
        $trade1_ok = 0
        $trade_player_money = 0
        $trade_player = ""
      end
    return true  
#-------------------------------------------------------------      
     when /<nptreq>(.*) (.*) (.*) (.*)<\/nptreq>/
      $nowpartyreq = 1
      $nptdt = $2.to_s
      $nptna = $4.to_s
      $nptor = $3.to_s
      if $game_party.actors[0].name == $1.to_s
        if $netparty == []
          Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 82 / 2, 130,
            ["파티 요청 : #{$3.to_s}"], ["예", "아니오"],
            ["nptreq1($nptdt); $npt = $nptna; Hwnd.dispose(self)",
            "nptnot; Hwnd.dispose(self)"], "파티 초대")
        else
          Network::Main.socket.send("<nptno>#{$3.to_s}</nptno>\n")
        end
      end
      return true
    when /<nptreq2>(.*) (.*) (.*) (.*) (.*)<\/nptreq2>/
      $nowpartyreq = 1
      $nptdta = $2.to_s
      $nptdtb = $3.to_s
      $nptna1 = $5.to_s
      $nptor = $4.to_s
      if $game_party.actors[0].name == $1.to_s
        if $netparty == []
          Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 82 / 2, 130,
            ["파티 요청 : #{$4.to_s}"], ["예", "아니오"],
            ["nptreq2($nptdta, $nptdtb); $npt = $nptna1; Hwnd.dispose(self)",
            "nptnot; Hwnd.dispose(self)"], "파티 초대")
        else
          Network::Main.socket.send("<nptno>#{$4.to_s}</nptno>\n")
        end
      end
      return true
      when /<nptreq3>(.*) (.*) (.*) (.*) (.*) (.*)<\/nptreq3>/
        $nowpartyreq = 1
        $nptdt3 = $2.to_s
        $nptdt4 = $3.to_s
        $nptdt5 = $4.to_s
        $nptna2 = $6.to_s
        $nptor = $5.to_s
        if $game_party.actors[0].name == $1.to_s
          if $netparty == []
            Jindow_Dialog.new(640 / 2 - 224 / 2, 480 / 2 - 82 / 2, 130,
             ["파티 요청 : #{$5.to_s}"], ["수락", "거절"],
             ["nptreq3($nptdt3, $nptdt4, $nptdt5); $npt = $nptna2; $now_dialog = false; Hwnd.dispose(self)",
             "nptnot; $now_dialog = false; Hwnd.dispose(self)"], "파티 초대")
          else
            Network::Main.socket.send("<nptno>#{$5.to_s}</nptno>\n")
          end
        end
       return true
      when /<nptno>(.*)<\/nptno>/
        if $game_party.actors[0].name == $1.to_s
          $nowparty = 0
          $console.write_line("[파티]:상대방이 파티에 참가할 수 없습니다.")
        end
       return true
      when /<nptyes>(.*) (.*)<\/nptyes>/
        $nptye = $2.to_s
        if $game_party.actors[0].name == $1.to_s
          nptyes1($nptye)
          $nowparty = 0
          $console.write_line("[파티]:'#{$2.to_s}'님과 파티가 되었습니다.")
        end
       return true
       when /<nptyes1>(.*) (.*) (.*)<\/nptyes1>/
        $nptye1 = $1.to_s
        $nptye2 = $2.to_s
        $nptye3 = $3.to_s
        if $game_party.actors[0].name == $1.to_s
          nptyes2($nptye2, $nptye3)
          $nowparty = 0
          $console.write_line("[파티]:#{$3.to_s}' 님과 파티가 되었습니다.")
        elsif $game_party.actors[0].name == $2.to_s
          nptyes2($nptye1, $nptye3)
          $nowparty = 0
          $console.write_line("[파티]:'#{$3.to_s}' 님과 파티가 되었습니다.")
        end
       return true
       when /<nptyes2>(.*) (.*) (.*) (.*)<\/nptyes2>/
        $nptye4 = $1.to_s
        $nptye5 = $2.to_s
        $nptye6 = $3.to_s
        $nptye7 = $4.to_s
        if $game_party.actors[0].name == $1.to_s
          nptyes3($nptye5, $nptye6, $nptye7)
          $nowparty = 0
          $console.write_line("[파티]:'#{$4.to_s}'님과 파티가 되었습니다.")
        elsif $game_party.actors[0].name == $2.to_s
          nptyes3($nptye4, $nptye6, $nptye7)
          $nowparty = 0
          $console.write_line("[파티]:'#{$4.to_s}'님과 파티가 되었습니다.")
        elsif $game_party.actors[0].name == $3.to_s
          nptyes3($nptye4, $nptye5, $nptye7)
          $nowparty = 0
          $console.write_line("[파티]:'#{$4.to_s}'님과 파티가 되었습니다.")
        end
       return true
       when /<nptout>(.*) (.*)<\/nptout>/
         $nptoutmem = $1.to_s
#         if $npt == $2.to_s
           for netparty in $netparty
             if netparty == $nptoutmem
               if $npt == netparty
                 $npt = ""
                 $netparty.clear
                 nptout1
                 $console.write_line("[파티]:파티장이 탈퇴하여 파티가 해체되었습니다.")
               else
                 $netparty.delete($nptoutmem)
                 nptout1
                 $console.write_line("[파티]:'#{$1.to_s}' 님이 파티를 나가셨습니다.")
#               end
             end
           end
         end
       return true
      when /<nptgain>(.*) (.*) (.*) (.*)<\/nptgain>/
        if $npt == $3.to_s
          if "#{$game_map.map_id}" == $4.to_s
              if $netparty.size > 1
            $game_variables[1010] = $game_party.actors[0].level
            expgave = $1.to_i / 10
            expgave2 = $1.to_i / $netparty.size
            expgave3 = expgave + expgave2
            $game_party.actors[0].exp += expgave3
            $game_variables[1011] = $game_party.actors[0].level
            
        if $game_variables[1011] > $game_variables[1010]
          자동저장
          $console.write_line("[정보]:레벨업!")
          $game_player.animation_id = 180
          Network::Main.socket.send "<player_animation>@ani_map = #{$game_map.map_id}; @ani_number = 180; @ani_id = #{Network::Main.id};</player_animation>\n"
        end
      if $game_party.actors[0].hp > 0  
          goldgave = $2.to_i / $netparty.size
          $game_party.gain_gold(goldgave)
          $console.write_line("[파티]:경험치:#{expgave3} 금전:#{goldgave}")
        end
      end
    end
  end
  
      return true
#-----------------------------------------------------------------------      
      when /<partyhill>(.*) (.*) (.*) (.*)<\/partyhill>/  # $1.to_s : 시전자이름  $2.to._s : 마법번호 $3.to._s : 파티크기 $4.to._s : 맵번호
       if not $game_party.actors[0].hp == 0
        if $npt == $3.to_s
          if "#{$game_map.map_id}" == $4.to_s
              if $netparty.size > 1
                if $2.to_i == 1  #바다의희원
          $game_player.animation_id = 131
          $game_party.actors[0].hp += 40
          $game_player.show_demage("40",false)
          Network::Main.socket.send "<player_animation>@ani_map = #{$game_map.map_id}; @ani_number = 131; @ani_id = #{Network::Main.id};</player_animation>\n"
          $console.write_line("'#{$1.to_i}님의 바다의희원")
        elsif $2.to_i == 2        #동해의희원
          $game_player.animation_id = 182
          $game_party.actors[0].hp += 100
          $game_player.show_demage("100",false)
          Network::Main.socket.send "<player_animation>@ani_map = #{$game_map.map_id}; @ani_number = 182; @ani_id = #{Network::Main.id};</player_animation>\n"
          $console.write_line("'#{$1.to_i}님의 동해의희원")
        elsif $2.to_i == 3         #야수수금술
          $game_switches[20] = true
          $game_player.animation_id = 157
          Network::Main.socket.send "<player_animation>@ani_map = #{$game_map.map_id}; @ani_number = 157; @ani_id = #{Network::Main.id};</player_animation>\n"
          $console.write_line("'#{$1.to_i}님의 야수수금술")
        elsif $2.to_i == 4        #천공의희원
          $game_player.animation_id = 136
          $game_party.actors[0].hp += 150
          $game_player.show_demage("150",false)
          Network::Main.socket.send "<player_animation>@ani_map = #{$game_map.map_id}; @ani_number = 136; @ani_id = #{Network::Main.id};</player_animation>\n"
          $console.write_line("'#{$1.to_i}님의 천공의희원")
        elsif $2.to_i == 5        #분량력법
          $game_switches[338] = true
          $game_player.animation_id = 159
          Network::Main.socket.send "<player_animation>@ani_map = #{$game_map.map_id}; @ani_number = 159; @ani_id = #{Network::Main.id};</player_animation>\n"
          $game_party.actors[0].str += 15
          $console.write_line("'#{$1.to_i}님의 분량력법")
        elsif $2.to_i == 6        #구름의희원
          $game_player.animation_id = 137
          $game_party.actors[0].hp += 250
          $game_player.show_demage("250",false)
          Network::Main.socket.send "<player_animation>@ani_map = #{$game_map.map_id}; @ani_number = 137; @ani_id = #{Network::Main.id};</player_animation>\n"
          $console.write_line("'#{$1.to_i}님의 구름의희원")
        elsif $2.to_i == 7       #분량방법
          $game_switches[196] = true
          $game_player.animation_id = 133
          Network::Main.socket.send "<player_animation>@ani_map = #{$game_map.map_id}; @ani_number = 133; @ani_id = #{Network::Main.id};</player_animation>\n"
          $game_party.actors[0].agi += 50
          $console.write_line("'#{$1.to_i}님의 분량방법")
        elsif $2.to_i == 8       #공력주입
          if $game_switches[405] == false
          $game_player.animation_id = 172
          Network::Main.socket.send "<player_animation>@ani_map = #{$game_map.map_id}; @ani_number = 172; @ani_id = #{Network::Main.id};</player_animation>\n"
          $game_party.actors[0].sp += $1.to_i
        else
          $game_switches[405] = false
          $console.write_line("#{$1.to_i}만큼 공력주입 시전")
        end
        elsif $2.to_i == 9       #태양의희원
          $game_player.animation_id = 147
          $game_party.actors[0].hp += 400
          $game_player.show_demage("250",false)
          Network::Main.socket.send "<player_animation>@ani_map = #{$game_map.map_id}; @ani_number = 147; @ani_id = #{Network::Main.id};</player_animation>\n"
          $console.write_line("'#{$1.to_i}님의 태양의희원") 
        elsif $2.to_i == 10       #생명의희원
          $game_player.animation_id = 148
          $game_party.actors[0].hp +=500
          Network::Main.socket.send "<player_animation>@ani_map = #{$game_map.map_id}; @ani_number = 148; @ani_id = #{Network::Main.id};</player_animation>\n"
          $console.write_line("'#{$1.to_i}님의 생명의희원")   
        end
        end
      end
    end
    end
      return true

#-----------------------------------------------------------------    
                            
                        #맵아이디, 이벤트 아이디, x좌표, y좌표               
                        
      when /<drop_create>(.*) (.*) (.*) (.*)<\/drop_create>/
          if $1.to_i == $game_map.map_id
            보관이벤트($2.to_i).moveto($3.to_i, $4.to_i)
          end
          
        when /<drop_del>(.*) (.*)<\/drop_del>/    #맵아이디, 이벤트 아이디
          if $1.to_i == $game_map.map_id and $game_map.events[$2.to_i] != nil
            $game_map.events[$2.to_i].erase
          end
          
#-----------------------------------------------------------------      
      return true  
      when /<System_Message>(.*)<\/System_Message>/
         $console.writeline("#{$1.to_s}",Color.new(155, 20, 150))
       
       return true       
     # Chat Recieval
     when /<chat>(.*)<\/chat>/ 
       if $scene.is_a?(Scene_Map)
         if $2.to_i == 0
          $chat.write($1.to_s, Color.new(105, 105, 105))
          $game_temp.chat_log.push($1.to_s)
          $game_temp.chat_refresh = true
         end
      end
      return true
      

      
    when /<27>(.*)<\/27>/
      eval($1)
      if @ani_map == $game_map.map_id
       if @ani_id != -1
        $ani_character[@ani_id.to_i].animation_id = @ani_number if $ani_character[@ani_id.to_i] # 캐릭터 애니 공유
       elsif @ani_event >= 0
        $game_map.events[@ani_event].animation_id = @ani_number # 이벤트 애니 공유
       else
        $game_player.animation_id = @ani_number # 각각의 플레이어에게만 보이는 애니메이션 공유.
       end
     end
     @ani_id = -1; @ani_map = -1; @ani_number = -1; @ani_event = -1
     return true
     
     # Remove Player ( Disconnected )
     when /<9>(.*)<\/9>/
      # Destroy Netplayer and MapPlayer things
      self.destroy($1.to_i)
      # Redraw Mapplayer Sprites
      $game_temp.spriteset_refresh = true
      $game_temp.spriteset_renew = true
    end
    return false
  end

  #--------------------------------------------------------------------------
  # * Authenficate <0>
  #-------------------------------------------------------------------------- 
  def self.authenficate(id,echo)
    if echo == "'e'"
      # If Echo was returned, Authenficated
      @auth = true
      @id = id
      return true
    end  
    return false
  end
  #--------------------------------------------------------------------------
  # * Checks the object range
  #--------------------------------------------------------------------------
  def self.in_range?(object)
    screne_x = $game_map.display_x 
    screne_x -= 256
    screne_y = $game_map.display_y
    screne_y -= 256
    screne_width = $game_map.display_x 
    screne_width += 2816
    screne_height = $game_map.display_y
    screne_height += 2176
    return false if object.real_x <= screne_x
    return false if object.real_x >= screne_width
    return false if object.real_y <= screne_y
    return false if object.real_y >= screne_height
    return true
  end
end
#-------------------------------------------------------------------------------
# End Class
#-------------------------------------------------------------------------------
class Base
  #--------------------------------------------------------------------------
  # * Updates Default Classes
  #-------------------------------------------------------------------------- 
  def self.update
    # Update Input
    Input.update
    # Update Graphics
    Graphics.update
    # Update Mouse
    $chat = Chat.new
    # Update Main (if Connected)
    Main.update if Main.socket != nil
  end
end
#-------------------------------------------------------------------------------
# End Class
#-------------------------------------------------------------------------------
class Test
  attr_accessor :socket
  #--------------------------------------------------------------------------
  # * Returns Testing Status
  #-------------------------------------------------------------------------- 
  def self.testing
    return true if @testing
    return false
  end
  #--------------------------------------------------------------------------
  # * Tests Connection
  #-------------------------------------------------------------------------- 
  def self.test_connection(host, port)
    # We are Testing, not Complted the Test
    @testing = true
    @complete = false
    # Start Connection
    @socket = TCPSocket.new(host, port)
    if not @complete
      # If the Test Succeeded (did not encounter errors...)
      self.test_result(false)
      @socket.send("<20>'Test Completed'</20>")
      begin
        # Close Connection
        @socket.close rescue @socket = nil
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Set Test Result
  #-------------------------------------------------------------------------- 
  def self.test_result(value)
    # Set Result to value, and Complete Test
    @result = value
    @complete = true
  end
  #--------------------------------------------------------------------------
  # * Returns Test Completed Status
  #-------------------------------------------------------------------------- 
  def self.testcompleted
    return @complete
  end
  #--------------------------------------------------------------------------
  # * Resets Test
  #-------------------------------------------------------------------------- 
  def self.testreset
    # Reset all Values
    @complete = false
    @socket = nil
    @result = nil
    @testing = false
  end
  #--------------------------------------------------------------------------
  # * Returns Result
  #-------------------------------------------------------------------------- 
  def self.result
    return @result
  end
end
#-------------------------------------------------------------------------------
# End Class
#-------------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # * Module Update
  #-------------------------------------------------------------------------- 
  def self.update
  end
end
#-------------------------------------------------------------------------------
# End Module
#-------------------------------------------------------------------------------
end
#-------------------------------------------------------------------------------
# End SDK Enabled Test
#-------------------------------------------------------------------------------