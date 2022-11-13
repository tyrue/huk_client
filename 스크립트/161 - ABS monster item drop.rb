class MrMo_ABS
	#--------------------------------------------------------------------------
	# * 아이템의 처리
	#--------------------------------------------------------------------------
	def take_item2(item_index)
		return if $map_chat_input.active # 채팅이 활성화 되면 먹지 않기
		if $game_switches[296] # 죽었으면 못 먹음
			$console.write_line("귀신은 할 수 없습니다.") 
			return
		end
		
		$state_trans = false # 투명 풀림
		Audio.se_play("Audio/SE/줍기", $game_variables[13])
		Network::Main.ani(Network::Main.id, 198)
		
		if $Drop[item_index] != nil
			id = $Drop[item_index].id
			type = $Drop[item_index].type
			type2 = $Drop[item_index].type2
			num = $Drop[item_index].amount
			
			if type2 == 1 # 일반 아이템
				if type == 0 # 아이템
					n = $game_party.item_number(id)
					if n >= $item_maximum
						$console.write_line("더 이상 가질 수 없습니다.")
						return
					end
					
					$game_party.gain_item(id, num)
				elsif type == 1 # 무기
					n = $game_party.weapon_number(id)
					if n >= $item_maximum
						$console.write_line("더 이상 가질 수 없습니다.")
						return
					end
					
					$game_party.gain_weapon(id, num)
				elsif type == 2 # 장비
					n = $game_party.armor_number(id)
					if n >= $item_maximum
						$console.write_line("더 이상 가질 수 없습니다.")
						return
					end
					
					$game_party.gain_armor(id, num)
				end
				
			elsif type2 == 0 # 돈
				$game_party.gain_gold($Drop[item_index].amount)
				$console.write_line("#{$Drop[item_index].amount}전 획득 ")
			end
			
			event = $game_map.events[item_index]
			event.erase # 이벤트 삭제
			event = nil
			$game_map.events.delete(event)
			Network::Main.socket.send "<Drop_Get>#{item_index},#{$game_map.map_id}</Drop_Get>\n"
			자동저장
			$Drop[item_index] = nil
		end
	end
	
	#--------------------------------------------------------------------------
	# * 몬스터마다의 템 줄 확률 설정
	#--------------------------------------------------------------------------
	def drop_enemy(e)
		id = e.id.to_i
		
		if ITEM_DROP_DATA[id] != nil
			r = rand(100)
			i_id = []
			temp = []
			num = ITEM_DROP_DATA[id][0][0].to_i
			
			# 확률에 맞는 아이템 id를 넣는다.
			for d in ITEM_DROP_DATA[id]
				next if d.size == 1
				type = d[0]
				id = d[1]
				take_num = rand(d[2]) + 1
				chance = d[3] * $drop_event
				sw = d[4]
				
				if r <= chance
					if sw != nil and $game_switches[sw] == true
						temp.push([type, id, take_num]) 
					elsif sw == nil
						temp.push([type, id, take_num]) 
					end
				end
			end
			
			return if temp.size == 0 
			# 최대 드랍될 아이템 종류 개수 랜덤 생성
			pick_num = num
			pick_num = temp.size if num == -1 or temp.size <= num
			pick_num = rand(pick_num) + 1 # 1개 이상 추출
			
			# 랜덤으로 temp에 있는 것 중에 num개를 추출한다.
			for i in 0...pick_num
				r = rand(temp.size).to_i
				i_id.push(temp[r])
				temp.delete_at(r)
			end
			
			for item in i_id
				next if item == nil
				if item[0] == 3 # 돈 드랍
					create_moneys(item[1], e.event.x, e.event.y)
				else
					create_drops(item[0], item[1], e.event.x, e.event.y, item[2])
				end
			end
		end
	end
	
	# 드랍율 이벤트
	$drop_event = 1
	
	# 아이템 드랍 데이터
	# [몬스터 아이디] = [[최대 드랍될 아이템 개수], [타입(아이템 0, 무기 1, 장비 2, 돈 3), 아이템 id or money, 최대 나올 개수, 드랍 확률, (조건스위치)], ...] 
	ITEM_DROP_DATA = {}
	# 초보사냥터
	ITEM_DROP_DATA[1] = [[-1], [0, 74, 1, 80], [2, 10, 1, 10]] # 토끼 : 토끼고기, 토끼화서
	ITEM_DROP_DATA[2] = [[-1], [0, 3, 10, 70], [2, 9, 1, 10]] # 다람쥐 : 도토리, 다람쥐화서
	ITEM_DROP_DATA[3] = [[-1], [0, 5, 1, 70]] # 암사슴 : 사슴고기
	ITEM_DROP_DATA[4] = [[-1], [0, 6, 1, 50]] # 숫사슴 : 녹용
	ITEM_DROP_DATA[5] = [[-1], [3, 100, 1, 40]] # 늑대 : 100전
	ITEM_DROP_DATA[6] = [[-1], [0, 7, 1, 60]] # 소 : 쇠고기
	ITEM_DROP_DATA[7] = [[-1], [0, 8, 1, 70]] # 돼지 : 돼지고기
	
	# 쥐굴
	ITEM_DROP_DATA[8] = [[-1], [0, 9, 1, 70]] # 쥐 : 쥐고기
	ITEM_DROP_DATA[9] = [[-1], [0, 9, 1, 70], [3, 100, 1, 20]] # 병든쥐 : 쥐고기, 100전
	ITEM_DROP_DATA[10] = [[-1], [3, 100, 1, 30]] # 시궁창쥐 : 100전
	ITEM_DROP_DATA[11] = [[-1], [0, 10, 1, 80]] # 박쥐 : 박쥐고기
	ITEM_DROP_DATA[12] = [[-1], [0, 10, 1, 80], [3, 100, 1, 10]] # 보라박쥐 : 박쥐고기, 100전
	ITEM_DROP_DATA[40] = [[-1], [3, 200, 1, 60]] # 자생원 : 200전
	
	# 곰굴
	ITEM_DROP_DATA[13] = [[-1], [0, 11, 1, 70]] # 평웅 : 웅담
	ITEM_DROP_DATA[14] = [[-1], [2, 2, 1, 5]] # 진웅 : 지력의투구1
	ITEM_DROP_DATA[15] = [[-1], [0, 12, 1, 50]] # 호랑이 : 호랑이고기
	ITEM_DROP_DATA[16] = [[-1], [0, 12, 1, 70]] # 평호 : 호랑이고기
	ITEM_DROP_DATA[17] = [[-1], [0, 12, 1, 40], [2, 2, 1, 50]] # 진호 : 호랑이고기, 지력의투구1
	ITEM_DROP_DATA[75] = [[-1], [2, 2, 1, 50]] # 청진웅 : 지력의투구1
	
	# 돼지굴
	ITEM_DROP_DATA[21] = [[-1], [0, 19, 1, 60], [0, 28, 1, 10]] # 산돼지 : 산돼지고기, 돼지의뿔
	ITEM_DROP_DATA[22] = [[-1], [0, 20, 1, 60], [0, 28, 1, 10]] # 숲돼지 : 숲돼지고기, 돼지의뿔
	ITEM_DROP_DATA[77] = [[-1], [0, 59, 1, 70], [1, 23, 1, 10]] # 청산숲돼지: 청산돼지뿔, 철도
	
	# 사슴굴
	ITEM_DROP_DATA[23] = [[-1], [0, 5, 1, 80]] # 주홍사슴 : 사슴고기
	ITEM_DROP_DATA[25] = [[-1], [0, 6, 1, 80], [1, 22, 1, 5]] # 흑/백순록 : 녹용, 비철단도
	ITEM_DROP_DATA[76] = [[2], [0, 6, 1, 60], [0, 29, 1, 40], [1, 22, 1, 20]] # 청순록 : 녹용, 호박, 비철단도
	
	# 자호굴
	ITEM_DROP_DATA[26] = [[-1], [0, 22, 1, 60]] # 자호 : 짙은호랑이고기
	ITEM_DROP_DATA[27] = [[-1], [0, 22, 1, 60], [3, 100, 1, 20]] # 천자호 : 짙은호랑이고기, 100전
	ITEM_DROP_DATA[28] = [[-1], [0, 22, 1, 60], [3, 100, 1, 30]] # 구자호 : 짙은호랑이고기, 100전
	ITEM_DROP_DATA[29] = [[-1], [0, 22, 1, 30], [3, 500, 1, 20], [1, 23, 1, 30]] # 적호 : 짙은호랑이고기, 500전, 철도
	
	# 해골굴
	ITEM_DROP_DATA[30] = [[-1], [0, 29, 1, 60]] # 해골 : 호박
	ITEM_DROP_DATA[31] = [[-1], [0, 29, 1, 60]] # 날쌘해골 : 호박
	ITEM_DROP_DATA[32] = [[1], [0, 29, 1, 60], [0, 30, 1, 10]] # 자해골 : 호박, 진호박
	ITEM_DROP_DATA[33] = [[-1], [0, 30, 1, 50]] # 흑해골 : 진호박
	ITEM_DROP_DATA[78] = [[1], [1, 107, 1, 40], [1, 120, 1, 40], [1, 137, 1, 40], [1, 25, 1, 40]] # 마령해골 : 불의영혼봉, 흑철중검, 영혼죽장, 흑월도
	ITEM_DROP_DATA[79] = [[1], [1, 107, 1, 60], [1, 120, 1, 60], [1, 137, 1, 60], [1, 25, 1, 60]] # 청철해골 : 불의영혼봉, 흑철중검, 영혼죽장, 흑월도
	
	# 흉가
	ITEM_DROP_DATA[34] = [[-1], [0, 29, 1, 30], [0, 30, 1, 70]] # 달걀귀신 : 호박, 진호박
	ITEM_DROP_DATA[35] = [[-1], [0, 29, 1, 30], [0, 30, 1, 70]] # 몽달귀신 : 호박, 진호박
	ITEM_DROP_DATA[39] = [[-1], [0, 30, 1, 40], [0, 31, 1, 30], [0, 37, 1, 10]] # 불귀신 : 진호박, 불의혼, 불의결정
	ITEM_DROP_DATA[36] = [[-1], [0, 116, 1, 20]] # 처녀귀신 : 황금호박
	
	# 기타 
	ITEM_DROP_DATA[37] = [[1], [0, 74, 500, 100], [0, 92, 1, 1]] # 무적토끼 : 토끼고기, 최고급상자
	ITEM_DROP_DATA[38] = [[-1], [0, 41, 1, 40]] # 짚단 : 짚단
	ITEM_DROP_DATA[41] = [[-1], [0, 38, 1, 70], [0, 39, 1, 30], [0, 92, 1, 1]] # 청자다람쥐 : 작은상자, 고급상자, 최고급상자
	ITEM_DROP_DATA[49] = [[-1], [0, 38, 1, 90], [0, 39, 1, 60], [0, 92, 1, 30]] # 고래 :  작은상자, 고급상자, 최고급상자
	
	# 도깨비굴
	ITEM_DROP_DATA[47] = [[-1], [0, 29, 1, 40], [0, 30, 1, 20]] # 도깨비 : 호박, 진호박
	ITEM_DROP_DATA[48] = [[-1], [0, 29, 1, 40], [0, 30, 1, 20]] # 도깨비불 : 호박, 진호박
	ITEM_DROP_DATA[80] = [[-1], [2, 33, 1, 10]] # 청명도깨비 : 도깨비부적
	
	# 여우굴
	ITEM_DROP_DATA[51] = [[-1], [0, 50, 1, 40]] # 흑여우 : 여우고기
	ITEM_DROP_DATA[52] = [[-1], [0, 50, 1, 60], [3, 100, 1, 20]] # 서여우 : 여우고기
	ITEM_DROP_DATA[53] = [[-1], [0, 50, 1, 60], [3, 100, 1, 20]] # 백여우 : 여우고기
	ITEM_DROP_DATA[54] = [[-1], [0, 50, 1, 60]] # 불여우 : 여우고기
	ITEM_DROP_DATA[82] = [[-1], [0, 60, 1, 60]] # 구미호 : 쇠조각
	ITEM_DROP_DATA[83] = [[-1], [0, 61, 2, 60]] # 불구미호 : 수정의조각
	
	# 전갈굴
	ITEM_DROP_DATA[55] = [[-1], [0, 29, 1, 30]] # 전갈 : 호박
	ITEM_DROP_DATA[56] = [[-1], [0, 30, 1, 30]] # 전갈장 : 진호박
	ITEM_DROP_DATA[81] = [[1], [1, 105, 1, 40], [1, 106, 1, 40], [1, 133, 1, 40], [1, 24, 1, 40]] # 현랑전갈 : 영혼마령봉, 현철중검, 해골죽장, 야월도
	
	# 2차
	ITEM_DROP_DATA[58] = [[1], [0, 90, 1, 98], [0, 52, 2, 2]] # 수룡 : 용의비늘, 수룡의비늘
	ITEM_DROP_DATA[59] = [[1], [0, 90, 1, 98], [0, 53, 2, 2]] # 화룡 : 용의비늘, 화룡의비늘
	ITEM_DROP_DATA[86] = [[-1], [0, 90, 1, 20]] # 용 : 용의비늘
	
	# 산적굴
	ITEM_DROP_DATA[60] = [[-1], [0, 67, 1, 40]] # 청비 : 갈색시약
	ITEM_DROP_DATA[85] = [[-1], [0, 68, 1, 20]] # 녹비 : 초록시약
	ITEM_DROP_DATA[107] = [[-1], [0, 70, 1, 20]] # 적비 : 빨간시약
	ITEM_DROP_DATA[108] = [[-1], [0, 70, 1, 30], [1, 125, 1, 10]] # 겁살수 : 빨간시약, 일월대도
	ITEM_DROP_DATA[111] = [[3], [0, 70, 3, 60], [1, 125, 1, 20], [1, 129, 1, 15], [2, 44, 1, 10], [1, 130, 1, 10]] # 산적왕 : 빨간시약, 일월대도, 도깨비방망이, 황혼의활복, 산적왕의칼
	
	# 3차
	ITEM_DROP_DATA[61] = [[-1], [0, 54, 1, 60]] # 주작 : 주작의깃
	ITEM_DROP_DATA[62] = [[-1], [0, 55, 1, 60]] # 백호 : 백호의발톱
	
	# 4차
	ITEM_DROP_DATA[102] = [[-1], [0, 119, 1, 100]] # 반고 : 반고의심장
	ITEM_DROP_DATA[112] = [[-1], [0, 117, 1, 100]] # 청룡 : 청룡의보옥
	ITEM_DROP_DATA[113] = [[-1], [0, 118, 1, 100]] # 현무 : 현무의보옥
	
	# 일본세작
	ITEM_DROP_DATA[100] = [[1], [0, 29, 1, 70], [0, 30, 1, 60]] # 일본세작 : 호박, 진호박
	ITEM_DROP_DATA[101] = [[-1], [0, 116, 1, 40]] # 일본세작대장 : 황금호박
	
	# 뱀굴
	ITEM_DROP_DATA[104] = [[-1], [2, 53, 1, 30]] # 왕구렁이 : 힘의투구1
	ITEM_DROP_DATA[106] = [[-1], [0, 104, 1, 70]] # 뱀 : 뱀고기
	
	# 극지방
	ITEM_DROP_DATA[105] = [[-1], [0, 103, 3, 30], [0, 116, 1, 40]] # 에메랄드인형 : 얼음, 황금호박
	ITEM_DROP_DATA[109] = [[-1], [0, 103, 1, 60]] # 눈괴물 : 얼음
	ITEM_DROP_DATA[110] = [[2], [0, 103, 1, 60], [0, 101, 1, 10], [0, 58, 1, 10]] # 북극사슴 : 얼음, 단단한녹용, 청녹용
	
	# 12지신
	ITEM_DROP_DATA[116] = [[-1], [0, 30, 1, 40], [0, 31, 1, 10], [1, 110, 1, 1]] # 범증 : 진호박, 불의혼, 현랑부
	ITEM_DROP_DATA[117] = [[-1], [0, 30, 1, 40], [0, 31, 1, 10], [1, 108, 1, 1]] # 범천 : 진호박, 불의혼, 백화검
	ITEM_DROP_DATA[118] = [[-1], [0, 30, 1, 40], [0, 37, 1, 15], [3, 10000, 1, 3]] # 범수 : 진호박, 불의결정, 1만전
	ITEM_DROP_DATA[119] = [[2],  [0, 120, 1, 30], [0, 121, 1, 30], [0, 106, 1, 50]] # 백호왕 : 크리스탈, 수정, 건괘
	ITEM_DROP_DATA[121] = [[-1], [0, 122, 1, 1], [0, 30, 1, 40]] # 새끼용 : 은나무가지, 진호박
	ITEM_DROP_DATA[123] = [[-1], [0, 110, 1, 30]] # 뱀왕 : 곤괘
	ITEM_DROP_DATA[124] = [[-1], [0, 111, 1, 30]] # 쥐왕 : 감괘
	ITEM_DROP_DATA[125] = [[-1], [0, 112, 1, 30]] # 양왕 : 리괘
	ITEM_DROP_DATA[126] = [[-1], [0, 107, 1, 30]] # 돼지왕 : 진괘
	ITEM_DROP_DATA[127] = [[-1], [0, 108, 1, 30]] # 말왕 : 선괘
	ITEM_DROP_DATA[128] = [[-1], [0, 109, 1, 30]] # 원숭이왕 : 태괘
	ITEM_DROP_DATA[129] = [[-1], [0, 113, 1, 2]] # 개왕 : 간괘
	
	ITEM_DROP_DATA[132] = [[1], [0, 123, 1, 70], [0, 122, 1, 30]] # 건룡 : 건룡의어금니, 은나무가지
	ITEM_DROP_DATA[133] = [[1], [0, 124, 1, 70], [0, 122, 1, 30]] # 감룡 : 감룡의어금니, 은나무가지
	ITEM_DROP_DATA[134] = [[1], [0, 125, 1, 70], [0, 122, 1, 30]] # 진룡 : 진룡의어금니, 은나무가지
	
	# 용궁
	ITEM_DROP_DATA[141] = [[-1], [0, 137, 1, 20]] # 복돌 : 복어의심장
	ITEM_DROP_DATA[142] = [[-1], [0, 137, 1, 20]] # 복순 : 복어의심장
	ITEM_DROP_DATA[145] = [[1], [0, 135, 1, 10], [0, 134, 1, 10]] # 사산게 : 게집게, 게등껍질
	ITEM_DROP_DATA[148] = [[-1], [0, 136, 1, 2]] # 해마 : 해마꼬리
	ITEM_DROP_DATA[149] = [[-1], [0, 138, 1, 20]] # 해마병사 : 해마의심장
	ITEM_DROP_DATA[151] = [[-1], [0, 139, 1, 20]] # 고양인어 : 인어의심장
	ITEM_DROP_DATA[152] = [[-1], [0, 139, 1, 20]] # 이쁜이인어 : 인어의심장
	ITEM_DROP_DATA[154] = [[-1], [0, 145, 1, 3], [0, 140, 1, 15]] # 외칼상어 : 상어의핵, 상어의심장
	ITEM_DROP_DATA[155] = [[-1], [0, 145, 1, 3], [0, 140, 1, 15]] # 쌍칼상어 : 상어의핵, 상어의심장
	ITEM_DROP_DATA[157] = [[-1], [0, 142, 1, 10], [0, 141, 1, 4, 378]] # 해파리수하 : 해파리의심장, 전략문서
	
	# 일본
	ITEM_DROP_DATA[172] = [[-1], [0, 161, 1, 30]] # 아귀 : 희귀호박
	
	ITEM_DROP_DATA[173] = [[-1], [0, 29, 1, 50], [0, 30, 1, 30]] # 백발귀 : 호박, 진호박
	ITEM_DROP_DATA[174] = [[-1], [0, 29, 1, 50], [0, 30, 1, 30]] # 적발귀 : 호박, 진호박
	ITEM_DROP_DATA[175] = [[-1], [0, 29, 1, 50], [0, 30, 1, 30]] # 녹발귀 : 호박, 진호박
	ITEM_DROP_DATA[176] = [[-1], [0, 161, 1, 35]] # 백향 : 희귀호박
	
	ITEM_DROP_DATA[177] = [[-1], [0, 152, 1, 20]] # 하선녀 : 하선녀의실타래
	ITEM_DROP_DATA[178] = [[1], [0, 29, 1, 70], [0, 30, 1, 60]] # 단선녀 : 호박, 진호박
	ITEM_DROP_DATA[179] = [[1], [0, 29, 1, 70], [0, 30, 1, 60]] # 파선녀 : 호박, 진호박
	ITEM_DROP_DATA[180] = [[-1], [0, 162, 1, 30]] # 견귀 : 희귀진호박
	
	ITEM_DROP_DATA[181] = [[-1], [0, 29, 1, 70], [0, 30, 1, 60]] # 맹오 : 호박, 진호박
	ITEM_DROP_DATA[182] = [[2], [0, 29, 1, 90], [0, 30, 1, 45], [0, 37, 1, 30]] # 문위 : 호박, 진호박, 불의결정
	
	ITEM_DROP_DATA[183] = [[1], [0, 29, 1, 70], [0, 30, 1, 60]] # 욘주겐 : 호박, 진호박
	ITEM_DROP_DATA[184] = [[1], [0, 29, 1, 70], [0, 30, 1, 60]] # 바주겐 : 호박, 진호박
	ITEM_DROP_DATA[185] = [[1], [0, 29, 1, 70], [0, 30, 1, 60]] # 나주겐 : 호박, 진호박
	ITEM_DROP_DATA[194] = [[-1], [0, 162, 1, 40], [0, 37, 1, 60]] # 문려 : 희귀진호박, 불의결정
	
	ITEM_DROP_DATA[186] = [[-1], [0, 162, 1, 45]] # 무사 : 희귀진호박
	ITEM_DROP_DATA[187] = [[1], [0, 29, 1, 70], [0, 30, 1, 60]] # 선월 : 호박, 진호박
	ITEM_DROP_DATA[188] = [[1], [0, 29, 1, 70], [0, 30, 1, 60]] # 이광 : 호박, 진호박
	ITEM_DROP_DATA[189] = [[-1], [0, 162, 2, 70]] # 주마관 : 희귀진호박
	
	ITEM_DROP_DATA[190] = [[-1], [0, 153, 1, 3]] # 망령 : 도깨비가죽
	ITEM_DROP_DATA[191] = [[-1], [0, 155, 1, 60]] # 유성지 : 유성지의보패
	ITEM_DROP_DATA[192] = [[-1], [0, 151, 1, 60]] # 해골왕 : 해골왕의뼈
	ITEM_DROP_DATA[193] = [[-1], [0, 154, 1, 80]] # 파괴왕 : 순수의강철
	
	ITEM_DROP_DATA[195] = [[-1], [0, 157, 1, 1]] # 이가닌자병 : 검조각 
	ITEM_DROP_DATA[196] = [[-1], [0, 159, 1, 1]] # 이가닌자수 : 수리검
	ITEM_DROP_DATA[197] = [[-1], [0, 160, 1, 1]] # 이가닌자마 : 이가닌자의 독
	ITEM_DROP_DATA[198] = [[-1], [0, 158, 1, 1]] # 이가닌자영 : 흑룡철심
	ITEM_DROP_DATA[199] = [[-1], [0, 156, 1, 1]] # 이가닌자화 : 이가닌자의 보패
	
	# 중국
	ITEM_DROP_DATA[202] = [[-1], [0, 170, 1, 30]] # 청인묘 : 청색구슬조각 
	ITEM_DROP_DATA[203] = [[-1], [0, 168, 1, 30]] # 자인묘 : 자색구슬조각
	ITEM_DROP_DATA[204] = [[2], [0, 169, 1, 100], [0, 167, 1, 100], [3, 30000, 1, 20]] # 인묘 : 녹색구슬조각, 갈색구슬조각
	
	ITEM_DROP_DATA[205] = [[-1], [0, 170, 1, 30]] # 청염유 : 청색구슬조각
	ITEM_DROP_DATA[206] = [[-1], [0, 168, 1, 30]] # 자염유 : 자색구슬조각 
	ITEM_DROP_DATA[207] = [[1], [0, 169, 1, 100], [0, 167, 1, 100]] # 염유장군 : 녹색구슬조각, 갈색구슬조각 
	ITEM_DROP_DATA[208] = [[-1], [0, 171, 1, 50]] # 염유왕 : 갈색보주 
	
	ITEM_DROP_DATA[209] = [[-1], [0, 170, 1, 30]] # 청기린 : 청색구슬조각
	ITEM_DROP_DATA[210] = [[-1], [0, 168, 1, 30]] # 자기린 : 자색구슬조각
	ITEM_DROP_DATA[211] = [[1], [0, 169, 1, 100], [0, 167, 1, 100]] # 흑마기린 : 녹색구슬조각, 갈색구슬조각
	ITEM_DROP_DATA[212] = [[-1], [0, 172, 1, 50]] # 기린왕 : 자색보주
	
	ITEM_DROP_DATA[213] = [[-1], [0, 190, 1, 1]] # 청악어 : 악어의피
	ITEM_DROP_DATA[214] = [[-1], [0, 190, 1, 1]] # 자악어 : 악어의피
	ITEM_DROP_DATA[215] = [[-1], [0, 173, 1, 50]] # 악어왕 : 녹색보주
	
	ITEM_DROP_DATA[216] = [[-1], [0, 170, 1, 30]] # 연청산소 : 청색구슬조각
	ITEM_DROP_DATA[217] = [[-1], [0, 168, 1, 30]] # 연자산소 : 자색구슬조각
	ITEM_DROP_DATA[218] = [[-1], [0, 170, 1, 30]] # 청산소괴 : 청색구슬조각
	ITEM_DROP_DATA[219] = [[-1], [0, 168, 1, 30]] # 황산소괴 : 자색구슬조각
	ITEM_DROP_DATA[220] = [[-1], [0, 176, 1, 60]] # 산소괴왕 : 동지패
	
	ITEM_DROP_DATA[221] = [[-1], [0, 170, 1, 30]] # 청괴성 : 청색구슬조각
	ITEM_DROP_DATA[222] = [[-1], [0, 168, 1, 30]] # 자괴성 : 자색구슬조각
	ITEM_DROP_DATA[223] = [[1], [0, 169, 1, 100], [0, 167, 1, 100]] # 동괴성 :  녹색구슬조각, 갈색구슬조각
	ITEM_DROP_DATA[224] = [[-1], [0, 174, 1, 50]] # 괴성왕 : 청색보주
	
	ITEM_DROP_DATA[225] = [[-1], [0, 170, 1, 30]] # 뇌신청 : 청색구슬조각
	ITEM_DROP_DATA[226] = [[-1], [0, 168, 1, 30]] # 뇌신자 : 자색구슬조각
	ITEM_DROP_DATA[227] = [[1], [0, 169, 1, 100], [0, 167, 1, 100]] # 뇌신태 :  녹색구슬조각, 갈색구슬조각
	ITEM_DROP_DATA[228] = [[-1], [0, 177, 1, 60]] # 뇌신왕 : 동인패
	
	ITEM_DROP_DATA[229] = [[-1], [0, 169, 1, 30]] # 연청천구 : 녹색구슬조각
	ITEM_DROP_DATA[230] = [[-1], [0, 167, 1, 30]] # 연자천구 : 갈색구슬조각
	ITEM_DROP_DATA[231] = [[-1], [0, 175, 1, 60]] # 천구왕 : 동천패
	
	# [몬스터 아이디] = [[최대 드랍될 아이템 개수], [타입(아이템 0, 무기 1, 장비 2, 돈 3), 아이템 id or money, 최대 나올 개수, 드랍 확률, (조건스위치)], ...]
	# -------
	#  환상의섬
	# -------
	# 고균도
	ITEM_DROP_DATA[50] = [[-1], [0, 44, 1, 30]] # 녹웅객 : 낡은 수리검
	ITEM_DROP_DATA[57] = [[-1], [0, 44, 1, 30], [0, 51, 3, 50, 141]] # 청웅객 : 낡은 수리검, 청웅의환
	ITEM_DROP_DATA[99] = [[2], [0, 60, 2, 20], [0, 201, 1, 60], [0, 202, 1, 10], [0, 203, 1, 10], [0, 204, 1, 10]] # 귀웅 : 쇠조각, 대지의토템, 바람의토템, 번개의토템, 화염의토템
	
	ITEM_DROP_DATA[241] = [[-1], [0, 208, 1, 40]] # 인면벌 : 인면벌의알
	ITEM_DROP_DATA[242] = [[-1], [0, 60, 1, 60]] # 문비 : 쇠조각
	
	# 난파선
	ITEM_DROP_DATA[243] = [[-1], [0, 209, 1, 10]] # 최가 : 기름자루
	ITEM_DROP_DATA[244] = [[-1], [0, 211, 1, 10]] # 백보 : 향료가루
	ITEM_DROP_DATA[245] = [[1], [0, 209, 1, 20], [0, 211, 1, 20]] # 엽춘 : 기름자루, 향료가루
	ITEM_DROP_DATA[246] = [[3], [0, 209, 1, 60], [0, 211, 1, 60], [0, 201, 1, 10], [0, 202, 1, 60], [0, 203, 1, 10], [0, 204, 1, 10], [0, 213, 1, 30]] # 선장망령 : 기름자루, 향료가루, 대지의토템, 바람의토템, 번개의토템, 화염의토템, 정령의결정
	
	# 가릉도 숲지대
	ITEM_DROP_DATA[247] = [[-1], [0, 161, 1, 5]] # 사마귀 : 희귀호박
	ITEM_DROP_DATA[248] = [[1], [0, 161, 1, 5], [0, 214, 1, 10]] # 독화 : 희귀호박, 독니
	ITEM_DROP_DATA[249] = [[2], [0, 201, 1, 10], [0, 202, 1, 10], [0, 203, 1, 60], [0, 204, 1, 10], [0, 214, 3, 40], [0, 218, 1, 20]] # 야월진랑 : 대지의토템, 바람의토템, 번개의토템, 화염의토템, 독니, 무소의뿔
	
	# 폭염도 화산굴
	ITEM_DROP_DATA[250] = [[1], [0, 162, 1, 5], [0, 215, 1, 5]] # 철보장 : 희귀진호박, 금조각
	ITEM_DROP_DATA[251] = [[1], [0, 162, 1, 5], [0, 216, 1, 5]] # 철거인 : 희귀진호박, 반짝이는돌
	ITEM_DROP_DATA[252] = [[3], [0, 201, 1, 10], [0, 202, 1, 10], [0, 203, 1, 10], [0, 204, 1, 60], [0, 206, 1, 15], [0, 207, 1, 15]] # 마려 : 대지의토템, 바람의토템, 번개의토템, 화염의토템, 자연의인'상, 자연의인'하
	
	# 한두고개
	ITEM_DROP_DATA[262] = [[1], [0, 70, 1, 10]] # 빨간토끼 : 빨간시약
	ITEM_DROP_DATA[263] = [[1], [0, 68, 1, 10]] # 초록토끼 : 초록시약
	ITEM_DROP_DATA[264] = [[1], [0, 67, 1, 10]] # 노란토끼 : 갈색시약
	ITEM_DROP_DATA[265] = [[1], [0, 16, 3, 40], [0, 81, 1, 5]] # 미친토끼 : 백세주, 속도시약
	
	ITEM_DROP_DATA[266] = [[1], [0, 81, 1, 15]] # 날쎈다람쥐 : 속도시약
	ITEM_DROP_DATA[267] = [[1], [3, 222222, 1, 1]] # 부자다람쥐 : 222222전
	ITEM_DROP_DATA[268] = [[1], [2, 96, 1, 1]] # 최강다람쥐 : 힘의반지4
	ITEM_DROP_DATA[269] = [[1], [2, 97, 1, 1]] # 무적다람쥐 : 방어의반지4
	ITEM_DROP_DATA[270] = [[1], [0, 92, 2, 100]] # 보물다람쥐 : 최고급보물상자
	ITEM_DROP_DATA[271] = [[1], [2, 88, 1, 3]] # 힘의다람쥐 : 힘의반지1
	ITEM_DROP_DATA[272] = [[1], [2, 84, 1, 3]] # 민첩의다람쥐 : 민첩의반지1 
	ITEM_DROP_DATA[273] = [[1], [2, 80, 1, 3]] # 지력의다람쥐 : 지력의반지1
	ITEM_DROP_DATA[274] = [[1], [2, 92, 1, 3]] # 손재주의다람쥐 : 손재주의반지1 
	
	ITEM_DROP_DATA[275] = [[1], [2, 89, 1, 2]] # 힘의돼지 :  힘의반지2
	ITEM_DROP_DATA[276] = [[1], [2, 85, 1, 2]] # 민첩의돼지 :  민첩의반지2
	ITEM_DROP_DATA[277] = [[1], [2, 81, 1, 2]] # 지력의돼지 :  지력의반지2 
	ITEM_DROP_DATA[278] = [[1], [2, 93, 1, 2]] # 손재주의돼지 : 손재주의반지2
	ITEM_DROP_DATA[279] = [[1], [3, 333333, 1, 1]] # 돈돈돈 : 333333전
	
	ITEM_DROP_DATA[280] = [[1], [2, 90, 1, 1]] # 힘의뱀 :   힘의반지3
	ITEM_DROP_DATA[281] = [[1], [2, 86, 1, 1]] # 민첩의뱀 :  민첩의반지3
	ITEM_DROP_DATA[282] = [[1], [2, 82, 1, 1]] # 지력의뱀 :  지력의반지3
	ITEM_DROP_DATA[283] = [[1], [2, 94, 1, 1]] # 손재주의뱀 : 손재주의반지3
	ITEM_DROP_DATA[284] = [[1], [0, 18, 44, 100]] # 주사 : 천세주
	ITEM_DROP_DATA[285] = [[1], [2, 91, 1, 10]] # 력사 : 힘의투구2
	ITEM_DROP_DATA[286] = [[1], [2, 87, 1, 10]] # 민사 : 민첩의투구2
	ITEM_DROP_DATA[287] = [[1], [2, 83, 1, 10]] # 지사 : 지력의투구2
	ITEM_DROP_DATA[288] = [[1], [2, 95, 1, 10]] # 재사 : 손재주의투구2
end
