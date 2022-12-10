#--------------------#
# 맵별로 몬스터 데이터 저장용
#--------------------#

# [[몬스터 id(22번 맵 파일에서 확인하기), 개수], []....]
MAP_MONSTER_DATA = {}
# 한두고개
MAP_MONSTER_DATA[409] = [[30, 10], [31, 10]] # 한고개입구 : 다람쥐, 토끼
MAP_MONSTER_DATA[441] = [[37, 6], [38, 6], [39, 6], [40, 6]] # 한고개4 : 빨간토끼, 노란토끼, 초록토끼, 미친토끼
MAP_MONSTER_DATA[442] = [[37, 6], [38, 6], [39, 6], [40, 6]] # 한고개5 : 빨간토끼, 노란토끼, 초록토끼, 미친토끼
MAP_MONSTER_DATA[423] = [[16, 10], [17, 10], [18, 10], [19, 10], [20, 2]] # 세고개 : 힘의돼지, 민첩의돼지, 지력의돼지, 손재주의돼지, 돈돈돈
MAP_MONSTER_DATA[424] = [[21, 7], [22, 7], [23, 7], [24, 7], [25, 2]] # 네고개1 : 힘의뱀, 민첩의뱀, 지력의뱀, 손재주의뱀, 주사
MAP_MONSTER_DATA[425] = [[21, 7], [22, 7], [23, 7], [24, 7], [26, 2]] # 네고개2 : 힘의뱀, 민첩의뱀, 지력의뱀, 손재주의뱀, 력사
MAP_MONSTER_DATA[426] = [[21, 7], [22, 7], [23, 7], [24, 7], [27, 2]] # 네고개3 : 힘의뱀, 민첩의뱀, 지력의뱀, 손재주의뱀, 민사
MAP_MONSTER_DATA[427] = [[21, 7], [22, 7], [23, 7], [24, 7], [28, 2]] # 네고개4 : 힘의뱀, 민첩의뱀, 지력의뱀, 손재주의뱀, 지사
MAP_MONSTER_DATA[428] = [[21, 7], [22, 7], [23, 7], [24, 7], [29, 2]] # 네고개5 : 힘의뱀, 민첩의뱀, 지력의뱀, 손재주의뱀, 재사
MAP_MONSTER_DATA[429] = [[21, 7], [22, 7], [23, 7], [24, 7], [25, 1], [26, 1], [27, 1], [28, 1], [29, 1]] # 네고개6 : 힘의뱀, 민첩의뱀, 지력의뱀, 손재주의뱀, 주사, 력사, 민사, 지사, 재사

MAP_MONSTER_DATA[430] = [[32, 1]] # 테스트용 : 

# 도삭산
MAP_MONSTER_DATA[432] = [[33, 7], [34, 7], [35, 7], [36, 8]] # 도삭산1 : 산신전사, 산신도사, 산신도적, 산신주술사
MAP_MONSTER_DATA[433] = [[33, 7], [34, 7], [35, 7], [36, 8]] # 도삭산2 : 산신전사, 산신도사, 산신도적, 산신주술사
MAP_MONSTER_DATA[434] = [[33, 7], [34, 7], [35, 7], [36, 8]] # 도삭산3 : 산신전사, 산신도사, 산신도적, 산신주술사
MAP_MONSTER_DATA[435] = [[33, 7], [34, 7], [35, 7], [36, 8]] # 도삭산4 : 산신전사, 산신도사, 산신도적, 산신주술사
MAP_MONSTER_DATA[436] = [[33, 7], [34, 7], [35, 7], [36, 8]] # 도삭산5 : 산신전사, 산신도사, 산신도적, 산신주술사
MAP_MONSTER_DATA[437] = [[33, 7], [34, 7], [35, 7], [36, 8]] # 도삭산6 : 산신전사, 산신도사, 산신도적, 산신주술사
MAP_MONSTER_DATA[438] = [[33, 7], [34, 7], [35, 7], [36, 8]] # 도삭산7 : 산신전사, 산신도사, 산신도적, 산신주술사
MAP_MONSTER_DATA[439] = [[33, 7], [34, 7], [35, 7], [36, 8]] # 도삭산 정상 : 산신전사, 산신도사, 산신도적, 산신주술사

class MrMo_ABS
	def getMapMonsterData
		if MAP_MONSTER_DATA[$game_map.map_id] != nil
			for data in MAP_MONSTER_DATA[$game_map.map_id]
				id = data[0] if data[0] != nil
				num = data[1] if data[1] != nil
				create_abs_monsters(id, num)
			end
		end
	end
end