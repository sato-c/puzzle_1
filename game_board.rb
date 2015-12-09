require 'dxruby'

class Game_Board
                  #幅　　　高さ
  def initialize ( width, height )
    @width  = width
    @height = height
    @board  = []

    clear
  end

  def clear
    @board = Array.new( @height * @width, -1 )
  end

  def get( x, y )
    # 調べたい位置が画面端にあったら、何もないことになる
    return -1 if x < 0 || x >= @width || y < 0 || y >= @height

    return @board[y * @width + x]
  end

  def set( x, y, p )
    # 画面端には何もおけない
    return -1 if x < 0 || x >= @width || y < 0 || y >= @height

    @board[y * @width + x] = p
  end

  # マークとベースの色を分ける
  # piece.rbのを使えればよかったんだけど
  def piece_type( seed )
    base = seed % 5
    mark = seed / 5

#    puts ( "no:#{seed}, base:#{base}, mark:#{mark}")

    return base, mark
  end

  def match( p, o )
    return 4 if o == -1
    # 置こうとしてるものの種類
    base, mark             = piece_type(p)
    check_base, check_mark = piece_type(o)
    # 両方合致
    return 3 if (base == check_base && mark == check_mark)
    # 色が合致
    return 2 if  base == check_base
    # 記号が合致
    return 1 if  mark == check_mark
    # どっちも合致してない 
    return 0 # if base != check_base && mark != check_mark
  end

  # 四方の石を確認する
  def put?( x, y, p )
    # そこにはすでに石がある
    return false if get(x, y) != -1

    result = 0

    # 上の状況
    above = match( p, get(x, y - 1) )
    # 上の状況
    below = match( p, get(x, y + 1) )
    # 左の状況
    left  = match( p, get(x - 1, y) )
    # 左の状況
    right = match( p, get(x + 1, y) )

#puts "#{above}, #{below}, #{left}, #{right}"

    result = false

    # どれかひとつが0のときは置けない
    if above != 0 && below != 0 && left != 0 && right != 0
      point = above + below + left + right
      # 三方何もなし＋どれか記号もしくは色が一致、または両方一致
      result = true
      # 4 + 4 + 4 + 4
      # return true if point == 1 + 2 + 1 + 2   # 4ways
      result = false if point == 4 + 4 + 4 + 4
      result = false if point == 4 + 4 + 1 + 1 || point == 4 + 1 + 1 + 1
      if point == 4 + 4 + 2 + 2
        result = false
        # どこかで同じものを見つけた
        result = true  if above == 3 || below == 3 || left == 3 || right == 3
      end
    end

    return result
  end

  def display
    for y in 0..@height - 1
      for x in 0..@width - 1
        print sprintf("%3d", get( x, y ))
      end

      print "\n"
    end
  end
end
