require "dxruby"
#
# 手持ちの駒を作る
#
# 絵にしたい場合は、Image.loadと画像分割でやること
#
class Piece
  def initialize
    @image = nil
    @x     = 0
    @y     = 0
    @mark  = 0        # 0は何もなし
  end

  # 仮想画面上の位置
  def set( x, y )
    @x = x
    @y = y
  end

  # 画面上の座標を取る
  def get( wx, wy )
    if wx < 0 || @x < 0
      return @x, @y
    end

    return wx + ( @x * 32 ), wy + ( @y * 48 )
  end

  # あたらしい駒を作る
  def new_piece ( base_color, mark, mark_color, width = 31, height = 47 )
    @image = Image.new(width, height, base_color)
    @mark  = mark

    @image.box_fill(8, 16, 24, 32, mark_color)             if mark == 1 # 四角塗り
    @image.circle_fill(16, 24, 8, mark_color)              if mark == 2 # 丸塗り

    if mark == 3 # 二重丸
      @image.circle(16, 24, 8, mark_color)
      @image.circle(16, 24, 4, mark_color)
    end

    @image.triangle_fill(16, 16, 24, 32, 8,32, mark_color) if mark == 4 # 三角塗り

    if mark == 5                                                        # 星形
      @image.triangle_fill(16, 16, 24, 32,  8,32, mark_color)
      @image.triangle_fill( 8, 20, 24, 20, 16,32, mark_color)
      @image.triangle_fill(16, 28,  8, 32, 24,32, base_color)
    end

    @image.triangle(16, 16, 24, 32, 8,32, mark_color)      if mark == 6 # 三角塗り
  end

  # マークとベースの色を分ける
  def piece_type( seed )

    base = seed % 5
    mark = seed / 5

#    puts ( "no:#{seed}, base:#{base}, mark:#{mark}")

    return base, mark
  end

  # 描画イメージを返す
  def draw
    return @image
  end
end
