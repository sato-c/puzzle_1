#!ruby -Ks
require "dxruby"
require 'pp'
#
require './game_board.rb'
require './piece.rb'
#
# drawのzは数値が小さいほど奥
# マウスが持ってるものは、5にするとかそんなかんじか
#
#
# 画面表示位置の設定
#
wx          = 320 - (32 * 8)          # 盤面の左上
wy          = 48                      # 盤面の左上
pw          = 30                      # 駒の幅
ph          = 46                      # 駒の高さ
pw_r        = 32                      # 駒の表示域
ph_r        = 48                      # 駒の表示域
w           = 12                      # ボードのマス目の数
h           = 8                       # ボードのマス目の数
piece_order = 0                       # 手数
piece_max   = 49
order_max   = piece_max - 6           # 全部の石のかず - 初期配置(6個)
board       = Game_Board.new(w, h)    # ボード
pieces      = []                      # 手持ちの石
piece_list  = []                      # 駒
hands       = []                      # 差した順番
#
# 色の設定
#
# 盤面の色
# 画像読み込んでおくと透けるようになってる
line_color   = [96, 192, 192, 192]   # 明るい灰色
corner_color = [96, 128, 128, 128]   # 灰色
edge_color   = [96,  96,  96,  96]   # 暗めの灰色
# メッセージなどの色
color_list   = []
color_list.push ( [255,  0,  0,  0] ) # 黒
color_list.push ( [255,  0, 64,255] ) # 青
color_list.push ( [255,  0,255, 64] ) # 緑
color_list.push ( [255,  0,255,255] ) # シアン
color_list.push ( [255,255,  0, 64] ) # 赤
color_list.push ( [255,255, 64,255] ) # マゼンタ
color_list.push ( [255,192,192, 64] ) # 黄色
color_list.push ( C_WHITE           ) # 白
#
# ゲーム盤の準備
#
screen = Image.new( 640, 480, [255,0,0,0] )
# 枠線を描く
for x in 0..12 do
  screen.line(wx + x * pw_r, wy,            wx + x * pw_r, wy * (h + 1),  line_color)
end
#
for y in 0..11 do
  screen.line(wx,            wy + y * ph_r, wx + pw_r * w, wy + y * ph_r, line_color)
end
# 盤の周りの色を変える
# 今はスタート画面がないので、意味がないけど
# そのうちスタート画面を作ることになったら必要
initial_position = [
  [0, 0], [11, 0], [0, 7], [11, 7],
]
#
initial_position.each do |corner|
  piece = Piece.new
  # 初期位置の座標を計算する
  piece.set( corner[0], corner[1] )
  px, py = piece.get( wx, wy )
  screen.box_fill( px + 1, py + 1, px + 30, py + 46, corner_color )
end
#
for x in 1..10
  piece = Piece.new
  #
  piece.set( x, 0 )
  px, py = piece.get( wx, wy )
  screen.box_fill( px + 1, py + 1, px + 30, py + 46, edge_color )
  #
  piece.set( x, 7 )
  px, py = piece.get( wx, wy )
  screen.box_fill( px + 1, py + 1, px + 30, py + 46, edge_color )
end
#
for y in 1..6
  piece = Piece.new
  #
  piece.set( 0, y )
  px, py = piece.get( wx, wy )
  screen.box_fill( px + 1, py + 1, px + 30, py + 46, edge_color )
  #
  piece.set( 11, y )
  px, py = piece.get( wx, wy )
  screen.box_fill( px + 1, py + 1, px + 30, py + 46, edge_color )
end
# ゲーム自体の初期化
# 表5、色5で25種類を2枚ずつの計50個
for i in 0..piece_max
  pieces[i] = i / 2
end
#
# シャッフルする
#
tw = Random.new(Time.now.to_i)
for i in 0..150
  r_f = tw.rand(50).to_i
  r_t = tw.rand(50).to_i
  #
  tmp         = pieces[r_f]
  pieces[r_f] = pieces[r_t]
  pieces[r_t] = tmp
end
#
# pp pieces
#
piece_list = []
#
initial_position = [
  [0, 0], [11, 0], [0, 7], [11, 7],
  [5, 3], [6, 4],
]
#
# 先頭の6個を初期配置にして、配列から削除する
#
for i in 0..5 do
  piece    = Piece.new
  piece_no = pieces.shift
  #
  base, mark = piece.piece_type(piece_no)
  piece.new_piece( color_list[base + 2], mark + 1, color_list[7])
  piece.set( initial_position[i][0], initial_position[i][1] )
  #
  px, py = piece.get(wx, wy)
  screen.draw( px, py, piece.draw, 1 )
  #
  board.set( initial_position[i][0], initial_position[i][1], piece_no )
end
#
# board.display
#
# pp pieces
#
# 手持ちリストを初期化
piece_list = []
# 残りの石表示
last_piece = Image.new( 8, 8, C_BLACK )
last_piece.box_fill( 0, 0, 6, 6, C_WHITE )
#
# 描画用スクリーン
#
render_screen = RenderTarget.new(640,480,[255,0,0,0])
#
# メインループ
#
Window.loop do
  #
  # ゲームロジック
  #
  # 左上 : NEXT 表示
  if !hands[piece_order] && piece_order <= order_max
    piece              = Piece.new
    base, mark         = piece.piece_type(pieces[piece_order])
    piece.new_piece( color_list[base + 2], mark + 1, color_list[7])
    piece.set( -1, -1 )          # 左上に表示する

    hands[piece_order] = piece
  end
  # 石を置く
  if Input.mousePush?( M_LBUTTON )
    x = Input.mousePosX
    y = Input.mousePosY

    if x >= wx && x <= wx + (w * pw_r) && y >= wy && y <= wy + (h * ph_r)
      bx = ( x - wx ) / pw_r
      by = ( y - wy ) / ph_r
      # 石の数がまだあって、盤面に何も置かれてないならば、置いても良い
      if piece_order <= order_max && board.put?( bx, by, pieces[piece_order] )
        board.set( bx, by, pieces[piece_order] )
        hands[piece_order].set( bx, by )
        piece_order += 1
# pp piece_order
# board.display
      end
    end
  # 一手戻す
  elsif Input.mousePush?( M_RBUTTON )
    # 置いたあとは+1されているから
    if piece_order > 0 && piece_order < order_max
      # NEXT表示されているものを消す
      hands[piece_order] = nil if hands[piece_order]
      # 1つ戻す
      piece_order -= 1
      # NEXT表示に変更する
      bx, by = hands[piece_order].get( -1, -1 )
      board.set( bx, by, -1 )
      hands[piece_order].set(-1, -1) if hands[piece_order]
# board.display
    end
  end
  #
  # ここから描画
  #
  # ボード描画/画面全消去
  render_screen.draw( 0, 0, screen, 0 )
  # 残りの石の数を表示する
  for i in piece_order..order_max
    # 右下から減らしたい
    x = ((order_max - i) % 5) 
    y = ((order_max - i) / 5) 
    # 残り石を画面にコピーする
    render_screen.draw( wx + ( 14 * pw_r ) + ( x * 8 ) - pw_r / 4, wy + ( 2 * ph_r ) + ( y * 8 ), last_piece )
  end
  # バッファにある駒を全表示
  piece_list.each do |piece|
    px, py = piece.get(wx, wy)
    render_screen.draw( px, py, piece.draw, 1 )
  end
  #
  hands.each do |piece|
    # undoしたときはnilになっているから
    next if !piece
    # ゲーム内の位置を取得
    x, y = piece.get( -1, -1 )
    # xとyが0未満のときは左上に表示する
    if x < 0
      render_screen.draw( wx + ( 14 * 32 ), wy + ( 0 * 48 ), piece.draw, 1 )
    # 場所を持っている場合は、そこに描画する
    else
      px, py = piece.get(wx, wy)
      render_screen.draw( px, py, piece.draw, 1 )
    end
  end
  # 全体を描画する
  Window.draw( 0, 0, render_screen )
  # ESC押したら終わり
  break if Input.key_push?(K_ESCAPE)
end
#
#
#
