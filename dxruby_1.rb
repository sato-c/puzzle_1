#!ruby -Ks
require "dxruby"
require 'pp'
#
require './game_board.rb'
require './piece.rb'
#
# draw��z�͐��l���������قǉ�
# �}�E�X�������Ă���̂́A5�ɂ���Ƃ�����Ȃ��񂶂�
#
#
# ��ʕ\���ʒu�̐ݒ�
#
wx          = 320 - (32 * 8)          # �Ֆʂ̍���
wy          = 48                      # �Ֆʂ̍���
pw          = 30                      # ��̕�
ph          = 46                      # ��̍���
pw_r        = 32                      # ��̕\����
ph_r        = 48                      # ��̕\����
w           = 12                      # �{�[�h�̃}�X�ڂ̐�
h           = 8                       # �{�[�h�̃}�X�ڂ̐�
piece_order = 0                       # �萔
piece_max   = 49
order_max   = piece_max - 6           # �S���̐΂̂��� - �����z�u(6��)
board       = Game_Board.new(w, h)    # �{�[�h
pieces      = []                      # �莝���̐�
piece_list  = []                      # ��
hands       = []                      # ����������
#
# �F�̐ݒ�
#
# �Ֆʂ̐F
# �摜�ǂݍ���ł����Ɠ�����悤�ɂȂ��Ă�
line_color   = [96, 192, 192, 192]   # ���邢�D�F
corner_color = [96, 128, 128, 128]   # �D�F
edge_color   = [96,  96,  96,  96]   # �Â߂̊D�F
# ���b�Z�[�W�Ȃǂ̐F
color_list   = []
color_list.push ( [255,  0,  0,  0] ) # ��
color_list.push ( [255,  0, 64,255] ) # ��
color_list.push ( [255,  0,255, 64] ) # ��
color_list.push ( [255,  0,255,255] ) # �V�A��
color_list.push ( [255,255,  0, 64] ) # ��
color_list.push ( [255,255, 64,255] ) # �}�[���^
color_list.push ( [255,192,192, 64] ) # ���F
color_list.push ( C_WHITE           ) # ��
#
# �Q�[���Ղ̏���
#
screen = Image.new( 640, 480, [255,0,0,0] )
# �g����`��
for x in 0..12 do
  screen.line(wx + x * pw_r, wy,            wx + x * pw_r, wy * (h + 1),  line_color)
end
#
for y in 0..11 do
  screen.line(wx,            wy + y * ph_r, wx + pw_r * w, wy + y * ph_r, line_color)
end
# �Ղ̎���̐F��ς���
# ���̓X�^�[�g��ʂ��Ȃ��̂ŁA�Ӗ����Ȃ�����
# ���̂����X�^�[�g��ʂ���邱�ƂɂȂ�����K�v
initial_position = [
  [0, 0], [11, 0], [0, 7], [11, 7],
]
#
initial_position.each do |corner|
  piece = Piece.new
  # �����ʒu�̍��W���v�Z����
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
# �Q�[�����̂̏�����
# �\5�A�F5��25��ނ�2�����̌v50��
for i in 0..piece_max
  pieces[i] = i / 2
end
#
# �V���b�t������
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
# �擪��6�������z�u�ɂ��āA�z�񂩂�폜����
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
# �莝�����X�g��������
piece_list = []
# �c��̐Ε\��
last_piece = Image.new( 8, 8, C_BLACK )
last_piece.box_fill( 0, 0, 6, 6, C_WHITE )
#
# �`��p�X�N���[��
#
render_screen = RenderTarget.new(640,480,[255,0,0,0])
#
# ���C�����[�v
#
Window.loop do
  #
  # �Q�[�����W�b�N
  #
  # ���� : NEXT �\��
  if !hands[piece_order] && piece_order <= order_max
    piece              = Piece.new
    base, mark         = piece.piece_type(pieces[piece_order])
    piece.new_piece( color_list[base + 2], mark + 1, color_list[7])
    piece.set( -1, -1 )          # ����ɕ\������

    hands[piece_order] = piece
  end
  # �΂�u��
  if Input.mousePush?( M_LBUTTON )
    x = Input.mousePosX
    y = Input.mousePosY

    if x >= wx && x <= wx + (w * pw_r) && y >= wy && y <= wy + (h * ph_r)
      bx = ( x - wx ) / pw_r
      by = ( y - wy ) / ph_r
      # �΂̐����܂������āA�Ֆʂɉ����u����ĂȂ��Ȃ�΁A�u���Ă��ǂ�
      if piece_order <= order_max && board.put?( bx, by, pieces[piece_order] )
        board.set( bx, by, pieces[piece_order] )
        hands[piece_order].set( bx, by )
        piece_order += 1
# pp piece_order
# board.display
      end
    end
  # ���߂�
  elsif Input.mousePush?( M_RBUTTON )
    # �u�������Ƃ�+1����Ă��邩��
    if piece_order > 0 && piece_order < order_max
      # NEXT�\������Ă�����̂�����
      hands[piece_order] = nil if hands[piece_order]
      # 1�߂�
      piece_order -= 1
      # NEXT�\���ɕύX����
      bx, by = hands[piece_order].get( -1, -1 )
      board.set( bx, by, -1 )
      hands[piece_order].set(-1, -1) if hands[piece_order]
# board.display
    end
  end
  #
  # ��������`��
  #
  # �{�[�h�`��/��ʑS����
  render_screen.draw( 0, 0, screen, 0 )
  # �c��̐΂̐���\������
  for i in piece_order..order_max
    # �E�����猸�炵����
    x = ((order_max - i) % 5) 
    y = ((order_max - i) / 5) 
    # �c��΂���ʂɃR�s�[����
    render_screen.draw( wx + ( 14 * pw_r ) + ( x * 8 ) - pw_r / 4, wy + ( 2 * ph_r ) + ( y * 8 ), last_piece )
  end
  # �o�b�t�@�ɂ�����S�\��
  piece_list.each do |piece|
    px, py = piece.get(wx, wy)
    render_screen.draw( px, py, piece.draw, 1 )
  end
  #
  hands.each do |piece|
    # undo�����Ƃ���nil�ɂȂ��Ă��邩��
    next if !piece
    # �Q�[�����̈ʒu���擾
    x, y = piece.get( -1, -1 )
    # x��y��0�����̂Ƃ��͍���ɕ\������
    if x < 0
      render_screen.draw( wx + ( 14 * 32 ), wy + ( 0 * 48 ), piece.draw, 1 )
    # �ꏊ�������Ă���ꍇ�́A�����ɕ`�悷��
    else
      px, py = piece.get(wx, wy)
      render_screen.draw( px, py, piece.draw, 1 )
    end
  end
  # �S�̂�`�悷��
  Window.draw( 0, 0, render_screen )
  # ESC��������I���
  break if Input.key_push?(K_ESCAPE)
end
#
#
#
