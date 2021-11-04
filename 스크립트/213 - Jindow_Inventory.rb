#==============================================================================
# ■ Jindow_Inventory
#------------------------------------------------------------------------------
#   캐릭터 인벤토리 창
#------------------------------------------------------------------------------
$trade_num = 1

class Jindow_Inventory < Jindow
	def initialize
		$game_system.se_play($data_system.decision_se)
		super(0, 0, 220, 200)
		self.name = "아이템"
		@head = true
		@mark = true
		@drag = true
		@close = true
		self.refresh("Inventory")
		self.x = 360
		self.y = 95
		@old_item_size = -1
		@inventory_size = 100
		@margin = 10
		
		@data = []
		sort
	end
	
	def sort
		for i in @item
			i.dispose if !i.disposed?
		end
		@item.clear
		
		for i in 1..$data_items.size
			if $game_party.item_number(i) > 0
				if i != nil
					J::Item.new(self).set(true).refresh($data_items[i].id, 0)
				end
			end
		end
		
		for i in 1..$data_weapons.size
			if $game_party.weapon_number(i) > 0
				if i != nil
					J::Item.new(self).set(true).refresh($data_weapons[i].id, 1)
				end
			end
		end
		
		for i in 1..$data_armors.size
			if $game_party.armor_number(i) > 0
				if i != nil
					J::Item.new(self).set(true).refresh($data_armors[i].id, 2)
				end
			end
		end
		
		for i in @item
			i.x = (i.id % 6) * 36
			i.y = (i.id / 6) * 36 + 18
		end
		@old_item_size = @item.size 
	end	
	
	def update
		data = []
		# Add item
		for i in 1...$data_items.size
			if $game_party.item_number(i) > 0
				data.push($data_items[i])
			end
		end
		for i in 1...$data_weapons.size
			if $game_party.weapon_number(i) > 0
				data.push($data_weapons[i])
			end
		end
		for i in 1...$data_armors.size
			if $game_party.armor_number(i) > 0
				data.push($data_armors[i])
			end
		end
		
		if @data != data
			@data = data 
			sort
		end
		
		if not Hwnd.include?('Trade')
			for i in @item
				i.item? ? 0 : next
				i.double_click ? 0 : next
				
				case i.type
				when 0 # 아이템
					$game_party.actors[0].item_effect(i.item)
					$game_system.se_play(i.item.menu_se)
					if i.item.consumable
						$game_party.lose_item(i.item.id, 1)
					end
					
					if i.item.common_event_id > 0
						# Command event call reservation
						$game_temp.common_event_id = i.item.common_event_id
						# Play item use SE
						$game_system.se_play(i.item.menu_se)
					end	
					sort if i.num == 0
					
				when 1 # 무기
					if $game_party.actors[0].equippable?(i.item)
						$game_party.actors[0].equip(0, i.item.id)
						Audio.se_play("Audio/SE/장비", $game_variables[13])
					end
					sort
				when 2 # 방어구
					if $game_party.actors[0].equippable?(i.item)
						$game_party.actors[0].equip(i.item.kind + 1, i.item.id)
						Audio.se_play("Audio/SE/장비", $game_variables[13])
					end
					sort
				end
			end	
			
		else # 교환창이 열린 상태인가?
			for i in @item
				i.item? ? 0 : next
				i.double_click ? 0 : next
				check(i)
			end
		end
		
		super
	end	
	
	def check(i)
		if $trade_num <= $MAX_TRADE
			if $Abs_item_data.is_trade_ok(i.item.id, i.type)
				Jindow_Trade2.new(i.item.id, i.type, $trade_num) 
			else
				$console.write_line("[교환]: 교환 불가 아이템입니다.")
			end
		else
			Hwnd.dispose("Trade2")
			$console.write_line("[교환]: 더이상 아이템을 올릴수 없습니다.")
		end
	end
end
