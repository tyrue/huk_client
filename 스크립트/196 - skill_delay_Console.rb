#==============================================================================
# ■ Console
#------------------------------------------------------------------------------
# 　콘솔 표시용의 스프라이트입니다.
#==============================================================================

class Skill_Delay_Console < Sprite
	#--------------------------------------------------------------------------
	# ● 오브젝트 초기화
	#     x        : 묘화처 X 좌표
	#     y        : 묘화처 Y 좌표
	#     width    : 묘화처의 폭
	#     height   : 묘화처의 높이
	#     max_line : 최대 줄 수
	#--------------------------------------------------------------------------
	attr_accessor :console_log
	attr_accessor :tog
	def initialize(x, y, width, height, max_line = 8)
		@console_viewport = Viewport.new(x, y, width, height)
		@console_viewport.z = 999
		super(@console_viewport)
		self.bitmap = Bitmap.new(width, height)
		self.z = 999
		@console_width = width
		@console_height = height
		@console_max_line = max_line
		@console_log = {}
		@tog = true
		# 스킬 딜레이 갱신 id, 배열값
		for skill_mash in SKILL_MASH_TIME
			if skill_mash[1][1] > 0
				sprite = Sprite_Chat.new(@console_viewport)
				@console_log[skill_mash[0]] = [sprite, SKILL_MASH_TIME[skill_mash[0]][1]]
			end
		end
		
		# 버프 지속시간 갱신
		for skill_mash in SKILL_BUFF_TIME
			if skill_mash[1][1] > 0
				sprite = Sprite_Chat.new(@console_viewport)
				@console_log[skill_mash[0]] = [sprite, SKILL_BUFF_TIME[skill_mash[0]][1]]
			end
		end
		
		@back_sprite = Sprite.new(@console_viewport)
		@back_sprite.bitmap = Bitmap.new(@console_viewport.rect.width, @console_viewport.rect.height)
		@back_sprite.bitmap.fill_rect(@back_sprite.bitmap.rect, Color.new(0, 0, 0, 100)) # 꽉찬 네모
		@back_sprite.visible = true
		self.bitmap.font.color.set(255, 255, 255, 255)
	end
	
	#--------------------------------------------------------------------------
	# ● 리프레쉬
	#--------------------------------------------------------------------------
	def refresh
		if @console_log.size <= 0
			@back_sprite.visible = false
			return 
		end
		
		@back_sprite.visible = true
		
		i = 0
		for log in @console_log
			if SKILL_MASH_TIME[log[0]] != nil
				if SKILL_MASH_TIME[log[0]][1].to_i == 0 
					@console_log[log[0]][0].dispose
					@console_log.delete(log[0])
					next
				end
				
				if ('%.1f' % (SKILL_MASH_TIME[log[0]][1] / 60.0)) != ('%.1f' % (log[1][1].to_i / 60.0))
					@console_log[log[0]][1] = SKILL_MASH_TIME[log[0]][1]
					
					@console_log[log[0]][0].dispose
					sprite = Sprite_Chat.new(@console_viewport)
					sprite.bitmap = Bitmap.new(width, 32)
					sprite.bitmap.font.size = 12
					sprite.bitmap.font.color.set(255, 204, 0, 255)
					sprite.x = 0
					sprite.y = (i) * 16
					@console_log[log[0]][0] = sprite
					@console_log[log[0]][0].bitmap.draw_text(0, 0, @console_width, 32, "#{$data_skills[log[0]].name} : #{'%.1f' % (@console_log[log[0]][1]/60.0)}초") 
					# x, y, width, height, string
					
				end
			end
			
			if SKILL_BUFF_TIME[log[0]] != nil
				if SKILL_BUFF_TIME[log[0]][1].to_i == 0 
					@console_log[log[0]][0].dispose
					@console_log.delete(log[0])
					next
				end
				if ('%.1f' % (SKILL_BUFF_TIME[log[0]][1] / 60.0)) != ('%.1f' % (log[1][1].to_i / 60.0))
					@console_log[log[0]][1] = SKILL_BUFF_TIME[log[0]][1] 
					
					@console_log[log[0]][0].dispose
					sprite = Sprite_Chat.new(@console_viewport)
					sprite.bitmap = Bitmap.new(width, 32)
					sprite.bitmap.font.size = 12
					sprite.bitmap.font.color.set(0, 255, 0, 255)
					sprite.x = 0
					sprite.y = (i) * 16
					@console_log[log[0]][0] = sprite
					@console_log[log[0]][0].bitmap.draw_text(0, 0, @console_width, 32, "#{$data_skills[log[0]].name} : #{'%.1f' % (@console_log[log[0]][1]/60.0)}초")
					# x, y, width, height, string
					
				end
			end
			i += 1
		end
	end
	
	#--------------------------------------------------------------------------
	# ● 텍스트 출력
	#     text : 출력하는 문자열
	#--------------------------------------------------------------------------
	def write_line(id)
		@console_log[id][0].dispose if @console_log[id] != nil and !@console_log[id][0].disposed?
		sprite = Sprite_Chat.new(@console_viewport)
		
		if SKILL_MASH_TIME[id] != nil
			if SKILL_MASH_TIME[id][1] > 0
				@console_log[id] = [sprite, SKILL_MASH_TIME[id][1]]
			end
		end
		
		if SKILL_BUFF_TIME[id] != nil
			if SKILL_BUFF_TIME[id][1] > 0
				@console_log[id] = [sprite, SKILL_BUFF_TIME[id][1]]
			end
		end
		
	end
	#--------------------------------------------------------------------------
	# ● 보인다
	#--------------------------------------------------------------------------
	def show
		self.opacity = 255
	end
	
	def toggle
		if @back_sprite.visible 
			@back_sprite.visible = false
			@tog = false
			for sprite in @console_log
				sprite[1][0].visible = false
			end
		elsif
			@back_sprite.visible = true
			@tog = true
			for sprite in @console_log
				sprite[1][0].visible = true
			end
		end
	end
	
	#--------------------------------------------------------------------------
	# ● 숨긴다
	#--------------------------------------------------------------------------
	def hide
		self.opacity = 0
	end
	#--------------------------------------------------------------------------
	# ● 클리어
	#--------------------------------------------------------------------------
	def clear
		# 윈도우 내용을 클리어
		self.bitmap.clear
	end
	#--------------------------------------------------------------------------
	# ● 해방
	#--------------------------------------------------------------------------
	def dispose
		if self.bitmap != nil
			self.bitmap.dispose
		end
		super
	end
end