# 몬스터의 스펙을 저장해놓았습니다.
class ABS_enemy_spec
	attr_accessor :enemy
	def initialize
		@enemy = {}
		# 공격성 : 0(공격하지 않음) 1(시야에 있을 경우 공격) 2(들을 수 있을 경우 공격) 3(보거나 들을 수 있을 때) 4(동료를 공격하면 공격함) 5(3 + 4) 6(건드려야 공격)
		# 시야 : 0~99
		# 듣는 소리 : 0~99 (이건 잘 모르겠음.)
		# 적이 가까이 있으면 다가감 : false/true
		# 적대시 하는 그룹 : 0(플레이어), 나머지 숫자는 적 id
		# 공격 속도 : n * 45프레임 (1초가 60프레임)
		# 이동 속도 : 
		# 이동 빈도 : 
		# 스위치 여부 : 0(스위치 없음) 1 n(n번 스위치를 작동) 2 n1 n2(n1번 변수 값을 n2까지 1증가 한다) 3 n(셀프 스위치 작동(1 : A, 2 : B, 3 : C, 4 : D))
		# 젠 타임 여부 : n(n/10 초, 즉 60이면 6초)
		
		# 공격성, 시야, 소리, 다가감, 적그룹, 공격 속도, 이동속도, 이동 빈도, 스위치, 젠 타임
		# 기타
		@enemy[37] = [0, 6, 6, true, [0], 1, 2, 3, [0], 60] # 무적토끼
		
		# 왕초보사냥터
		@enemy[1] = [6, 5, 2, true, [0,6], 1, 2, 3, [0], 300] # 토끼
		@enemy[2] = [6, 5, 2, true, [0,6], 1, 2, 3, [0], 300] # 다람쥐
		
		# 일본세작
		@enemy[100] = [1, 15, 15, true, [0], 1, 3, 3, [0], 600] # 일본세작
		@enemy[101] = [1, 30, 30, true, [0], 1, 4, 3, [0], 3000] # 일본세작대장
		
		# 흉가
		@enemy[34] = [1, 30, 30, true, [0], 1, 3, 3, [0], 300] # 달걀귀신
		@enemy[35] = [1, 30, 30, true, [0], 1, 3, 3, [0], 300] # 몽달귀신
		@enemy[39] = [1, 30, 30, true, [0], 1, 3, 3, [0], 280] # 불귀신
		@enemy[36] = [1, 30, 30, true, [0], 1, 4, 3, [0], 6000] # 처녀귀신
		
		# 파티퀘스트
		@enemy[45] = [1, 15, 15, true, [0, 42, 43, 44, 46], 1, 3, 3, [1, 105], 2000] # 추격군사
		
		# 이벤트
		@enemy[49] = [6, 7, 7, false, [0], 1, 3, 3, [1, 1001], 0] # 고래
		
		
		# 여우굴
		@enemy[54] = [1, 9, 9, true, [0], 1, 3, 3, [0], 1000] # 불여우
		@enemy[82] = [1, 30, 30, true, [0], 1, 3, 4, [0], 3000] # 구미호
		@enemy[83] = [1, 30, 30, true, [0], 1, 3, 4, [0], 3000] # 불구미호
		
		# 2차 퀘
		@enemy[58] = [1, 30, 30, true, [0], 1, 5, 3, [0], 5000] # 수룡
		@enemy[59] = [1, 30, 30, true, [0], 1, 5, 3, [0], 5000] # 화룡
		@enemy[86] = [1, 30, 30, true, [0], 1, 3, 3, [0], 800] # 용
		
		# 3차 퀘
		@enemy[61] = [1, 20, 20, true, [0], 1, 3, 4, [0], 5000] # 주작
		@enemy[62] = [1, 20, 20, true, [0], 1, 3, 4, [0], 5000] # 백호
		@enemy[87] = [1, 10, 10, true, [0], 1, 3, 3, [0], 400] # 수호구미호
		
		# 4차 퀘
		@enemy[102] = [1, 99, 99, true, [0], 0.8, 3, 4, [0], 4000] # 반고
		@enemy[131] = [1, 99, 99, true, [0], 1, 4, 4, [0], 700] # 악어왕
		
		# 극지방
		@enemy[109] = [1, 17, 17, true, [0], 1, 3, 3, [0], 400] # 눈괴물
		@enemy[110] = [1, 17, 17, true, [0], 1, 3, 3, [0], 400] # 북극사슴
		@enemy[105] = [1, 30, 30, true, [0], 1, 4, 3, [0], 6000] # 에메랄드인형
		
		# 용궁
		@enemy[141] = [1, 19, 19, true, [0], 1, 3, 3, [0], 400] # 복돌
		@enemy[142] = [1, 19, 19, true, [0], 1, 3, 3, [0], 400] # 복순
		@enemy[143] = [1, 20, 20, true, [0], 1, 3, 4, [1, 384], 6000] # 복어장군
		
		@enemy[144] = [1, 9, 9, true, [0], 1, 3, 3, [0], 400] # 새끼게
		@enemy[145] = [1, 9, 9, true, [0], 1, 3, 3, [0], 800] # 사산게
		@enemy[146] = [1, 20, 20, true, [0], 1, 3, 4, [1, 384], 6000] # 게장군
		
		@enemy[147] = [1, 20, 20, true, [0], 1, 3, 4, [1, 384], 6000] # 문어장군
		
		@enemy[148] = [1, 9, 9, true, [0], 1, 3, 3, [0], 400] # 해마
		@enemy[149] = [1, 9, 9, true, [0], 1, 3, 3, [2, 7], 400] # 해마병사
		@enemy[150] = [1, 15, 15, true, [0], 1, 3, 4, [1, 384], 8000] # 해마장군
		
		@enemy[151] = [1, 9, 9, true, [0], 1, 3, 3, [0], 400] # 고양인어
		@enemy[152] = [1, 9, 9, true, [0], 1, 3, 3, [0], 400] # 이쁜이인어
		@enemy[153] = [1, 20, 20, true, [0], 0.8, 3, 4, [1, 384], 8000] # 인어장군
		
		@enemy[154] = [1, 15, 15, true, [0], 1, 3, 3, [0], 600] # 외칼상어
		@enemy[155] = [1, 15, 15, true, [0], 1, 3, 3, [0], 600] # 쌍칼상어
		@enemy[156] = [1, 20, 20, true, [0], 0.8, 3, 4, [1, 384], 10000] # 상어장군
		
		@enemy[157] = [1, 15, 15, true, [0], 1, 3, 3, [0], 600] # 해파리수하
		@enemy[158] = [1, 40, 40, true, [0], 0.8, 3, 4, [1, 384], 10000] # 해파리장군
		
		@enemy[159] = [1, 50, 50, true, [0], 0.7, 3, 5, [1, 384], 15000] # 거북장군
		@enemy[160] = [1, 15, 15, true, [0], 1, 3, 3, [0], 1200] # 염유왕
		
		# 일본
		@enemy[193] = [1, 40, 40, true, [0], 1, 3, 4, [1, 38], 0] # 파괴왕
		
		# 중국
		@enemy[202] = [1, 9, 9, true, [0], 1, 3, 3, [0], 400] # 청인묘
		@enemy[203] = [1, 9, 9, true, [0], 1, 3, 3, [0], 400] # 자인묘
		@enemy[204] = [1, 15, 15, true, [0], 1, 3, 5, [0], 4000] # 인묘
		
		@enemy[205] = [1, 9, 9, true, [0], 1, 3, 3, [0], 400] # 청염유
		@enemy[206] = [1, 9, 9, true, [0], 1, 3, 3, [0], 400] # 자염유
		@enemy[207] = [1, 15, 15, true, [0], 1, 3, 4, [0], 1000] # 염유장군
		@enemy[208] = [1, 15, 15, true, [0], 1, 4, 5, [0], 5000] # 염유왕
		
		@enemy[209] = [1, 9, 9, true, [0], 1, 3, 3, [0], 500] # 청기린
		@enemy[210] = [1, 9, 9, true, [0], 1, 3, 3, [0], 500] # 자기린
		@enemy[211] = [1, 15, 15, true, [0], 1, 4, 5, [0], 1000] # 흑마기린
		@enemy[212] = [1, 15, 15, true, [0], 1, 4, 5, [0], 6000] # 기린왕
		
		@enemy[213] = [1, 9, 9, true, [0], 1, 3, 3, [0], 600] # 청악어
		@enemy[214] = [1, 9, 9, true, [0], 1, 3, 3, [0], 600] # 자악어
		@enemy[215] = [1, 15, 15, true, [0], 0.8, 3, 5, [0], 6000] # 악어왕
		
		@enemy[216] = [1, 9, 9, true, [0], 1, 3, 3, [0], 600] # 연청산소
		@enemy[217] = [1, 9, 9, true, [0], 1, 3, 3, [0], 600] # 연자산소
		@enemy[218] = [1, 9, 9, true, [0], 1, 3, 3, [0], 1000] # 청산소괴
		@enemy[219] = [1, 9, 9, true, [0], 1, 3, 3, [0], 1000] # 황산소괴
		@enemy[220] = [1, 15, 15, true, [0], 0.8, 3, 5, [0], 8000] # 산소괴왕
		
		@enemy[221] = [1, 9, 9, true, [0], 1, 3, 3, [0], 800] # 청괴성
		@enemy[222] = [1, 9, 9, true, [0], 1, 3, 3, [0], 800] # 자괴성
		@enemy[223] = [1, 13, 13, true, [0], 1, 4, 4, [0], 800] # 동괴성
		@enemy[224] = [1, 15, 15, true, [0], 0.6, 3, 5, [0], 10000] # 괴성왕
		
		@enemy[225] = [1, 9, 9, true, [0], 1, 3, 3, [0], 800] # 뇌신'청
		@enemy[226] = [1, 9, 9, true, [0], 1, 3, 3, [0], 800] # 뇌신'자
		@enemy[227] = [1, 9, 9, true, [0], 1, 5, 3, [0], 800] # 뇌신'태
		@enemy[228] = [1, 17, 17, true, [0], 0.6, 3, 5, [0], 10000] # 뇌신왕
		
		@enemy[229] = [1, 9, 9, true, [0], 1, 3, 3, [0], 800] # 연청천구
		@enemy[230] = [1, 9, 9, true, [0], 1, 3, 3, [0], 800] # 연자천구
		@enemy[231] = [1, 88, 88, true, [0], 0.6, 3, 5, [0], 10000] # 천구왕
	end
	def spec(id)
		return @enemy[id]
	end
end

$enemy_spec = ABS_enemy_spec.new