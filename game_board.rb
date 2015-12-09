require 'dxruby'

class Game_Board
                  #���@�@�@����
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
    # ���ׂ����ʒu����ʒ[�ɂ�������A�����Ȃ����ƂɂȂ�
    return -1 if x < 0 || x >= @width || y < 0 || y >= @height

    return @board[y * @width + x]
  end

  def set( x, y, p )
    # ��ʒ[�ɂ͉��������Ȃ�
    return -1 if x < 0 || x >= @width || y < 0 || y >= @height

    @board[y * @width + x] = p
  end

  # �}�[�N�ƃx�[�X�̐F�𕪂���
  # piece.rb�̂��g����΂悩�����񂾂���
  def piece_type( seed )
    base = seed % 5
    mark = seed / 5

#    puts ( "no:#{seed}, base:#{base}, mark:#{mark}")

    return base, mark
  end

  def match( p, o )
    return 4 if o == -1
    # �u�����Ƃ��Ă���̂̎��
    base, mark             = piece_type(p)
    check_base, check_mark = piece_type(o)
    # �������v
    return 3 if (base == check_base && mark == check_mark)
    # �F�����v
    return 2 if  base == check_base
    # �L�������v
    return 1 if  mark == check_mark
    # �ǂ��������v���ĂȂ� 
    return 0 # if base != check_base && mark != check_mark
  end

  # �l���̐΂��m�F����
  def put?( x, y, p )
    # �����ɂ͂��łɐ΂�����
    return false if get(x, y) != -1

    result = 0

    # ��̏�
    above = match( p, get(x, y - 1) )
    # ��̏�
    below = match( p, get(x, y + 1) )
    # ���̏�
    left  = match( p, get(x - 1, y) )
    # ���̏�
    right = match( p, get(x + 1, y) )

#puts "#{above}, #{below}, #{left}, #{right}"

    result = false

    # �ǂꂩ�ЂƂ�0�̂Ƃ��͒u���Ȃ�
    if above != 0 && below != 0 && left != 0 && right != 0
      point = above + below + left + right
      # �O�������Ȃ��{�ǂꂩ�L���������͐F����v�A�܂��͗�����v
      result = true
      # 4 + 4 + 4 + 4
      # return true if point == 1 + 2 + 1 + 2   # 4ways
      result = false if point == 4 + 4 + 4 + 4
      result = false if point == 4 + 4 + 1 + 1 || point == 4 + 1 + 1 + 1
      if point == 4 + 4 + 2 + 2
        result = false
        # �ǂ����œ������̂�������
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
