class Jindow_Login < Jindow
  attr_reader :type_username
  attr_reader :type_password
  def initialize
    super(0, 0, 135, 110)
    self.name = "로그인"
    @head = true
    @mark = true
    @drag = true
    self.refresh "Login"
    self.x = 640 / 2 - self.max_width / 2
    self.y = 480 / 2 - self.max_height / 2 + 180
    @username_s = Sprite.new(self)
    @username_s.y = 3
    @username_s.bitmap = Bitmap.new(40, 32)
    @username_s.bitmap.font.color.set(0, 0, 0, 255)
    @username_s.bitmap.draw_text(0, 0, 40, 32, "아이디")
    @password_s = Sprite.new(self)
    @password_s.y = 23
    @password_s.bitmap = Bitmap.new(40, 32)
    @password_s.bitmap.font.color.set(0, 0, 0, 255)
    @password_s.bitmap.draw_text(0, 0, 40, 32, "비밀번호")
    @type_username = J::Type.new(self).refresh(40, 12, self.width - 40, 18)
    @type_password = J::Type.new(self).refresh(40, 30, self.width - 40, 18)
    @type_password.hide = true
    @a = J::Button.new(self).refresh(60, "접속하기")
    @c = J::Button.new(self).refresh(60, "회원가입")
    @a.y = 63
    @c.x = 70
    @c.y = 63

    @text104 = J::Text_Box.new(self)
    @text104.set("tb_6", 2).refresh(190, 0)
    @text104.font.alpha = 1
    @text104.bitmap.font.size = 12
    @text104.bitmap.font.color.set(0, 0, 0, 255)
    @text104.bitmap.draw_text(0, 0, @text104.width, @text104.height, "흑부엉(jaaaong/네이버)", 0)
    @text104.y = 90
    
  end
  
  def update
    super
    if @a.click  # 확인
      @type_username.bluck = false
      @type_password.bluck = false
      @type_password.hide = false
      Network::Main.update
      Network::Main.send_login(@type_username.result.to_s, @type_password.result.to_s)
    elsif @c.click and not Hwnd.include?("Register")  # 가입하기
      Jindow_Register.new
    end
  end
end