require "dxruby"
#
# �莝���̋�����
#
# �G�ɂ������ꍇ�́AImage.load�Ɖ摜�����ł�邱��
#
class Piece
  def initialize
    @image = nil
    @x     = 0
    @y     = 0
    @mark  = 0        # 0�͉����Ȃ�
  end

  # ���z��ʏ�̈ʒu
  def set( x, y )
    @x = x
    @y = y
  end

  # ��ʏ�̍��W�����
  def get( wx, wy )
    if wx < 0 || @x < 0
      return @x, @y
    end

    return wx + ( @x * 32 ), wy + ( @y * 48 )
  end

  # �����炵��������
  def new_piece ( base_color, mark, mark_color, width = 31, height = 47 )
    @image = Image.new(width, height, base_color)
    @mark  = mark

    @image.box_fill(8, 16, 24, 32, mark_color)             if mark == 1 # �l�p�h��
    @image.circle_fill(16, 24, 8, mark_color)              if mark == 2 # �ۓh��

    if mark == 3 # ��d��
      @image.circle(16, 24, 8, mark_color)
      @image.circle(16, 24, 4, mark_color)
    end

    @image.triangle_fill(16, 16, 24, 32, 8,32, mark_color) if mark == 4 # �O�p�h��

    if mark == 5                                                        # ���`
      @image.triangle_fill(16, 16, 24, 32,  8,32, mark_color)
      @image.triangle_fill( 8, 20, 24, 20, 16,32, mark_color)
      @image.triangle_fill(16, 28,  8, 32, 24,32, base_color)
    end

    @image.triangle(16, 16, 24, 32, 8,32, mark_color)      if mark == 6 # �O�p�h��
  end

  # �}�[�N�ƃx�[�X�̐F�𕪂���
  def piece_type( seed )

    base = seed % 5
    mark = seed / 5

#    puts ( "no:#{seed}, base:#{base}, mark:#{mark}")

    return base, mark
  end

  # �`��C���[�W��Ԃ�
  def draw
    return @image
  end
end
