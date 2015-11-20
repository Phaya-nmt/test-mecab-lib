require 'vr/vruby'
require 'vr/vrcontrol'
require 'vr/vrtimer'

class NobyCanvas < VRCanvasPanel
  include VRTimerFeasible

  def load_bmps
    addTimer(100)
    @patterns = {
      'normal' => Normal.new('normal'),
      'blink' => Blink.new('blink'),
      'lookaround' => LookAround.new('lookaround'),
      'talk' => Talk.new('talk'),

      'happy' => Happy.new('happy'),
      'happy_blink' => HappyBlink.new('happy_blink'),
      'giggle' => Giggle.new('giggle'),
      'happy_talk' => HappyTalk.new('happy_talk'),

      'more_happy' => MoreHappy.new('more_happy'),
      'more_happy_blink' => MoreHappyBlink.new('more_happy_blink'),
      'blush' => Blush.new('blush'),
      'more_happy_talk' => MoreHappyTalk.new('more_happy_talk'),

      'angry' => Angry.new('angry'),
      'knock' => Knock.new('knock'),
      'sigh' => Sigh.new('sigh'),
      'angry_talk' => AngryTalk.new('angry_talk'),

      'more_angry' => MoreAngry.new('more_angry'),
      'snap' => Snap.new('snap'),
      'armfold' => ArmFold.new('armfold'),
      'more_angry_talk' => MoreAngryTalk.new('more_angry_talk')
    }
    @now_pattern = @patterns['normal']
  end

  def self_timer
    canvas.drawBitmap(@now_pattern.next_bmp, 0, 0)
    dopaint{self_paint}
    change_pattern(@now_pattern.next_pattern)
  end

  def change_pattern(ptn)
    return if ptn.nil?
    @now_pattern = @patterns[ptn]
    @now_pattern.reset
  end
  
  class Pattern
    def initialize(ptn_name)
      @bmps = []
      dirname = "bmps/#{ptn_name}"
      Dir.glob("#{dirname}/*.bmp").sort.each do |filename|
        @bmps.push(SWin::Bitmap.loadFile(filename))
      end
      reset
    end

    def next_bmp
      bmp = @bmps[@idx]
      @idx += 1
      if @idx >= @bmps.size
        @idx = 0
        @loop += 1
      end
      return bmp
    end

    def next_pattern
      return nil
    end

    def reset
      @idx = @loop = 0
    end
  end

  class Normal < Pattern
    def next_pattern
      return nil if @loop <= 20
      @loop = 0
      case rand(10)
      when 0, 1, 2, 3
        return 'blink'
      when 4, 5
        return 'lookaround'
      else
        return nil
      end
    end
  end

  class Blink < Pattern
    def next_pattern
      return (@loop >= 2)? 'normal' : nil
    end
  end

  class LookAround < Pattern
    def next_pattern
      return (@loop >= 1)? 'normal' : nil
    end
  end

  class Talk < Pattern
    def next_pattern
      return (@loop >= 2)? 'normal' : nil
    end
  end

  class Happy < Pattern
    def next_pattern
      return nil if @loop <= 20
      @loop = 0
      case rand(10)
      when 0, 1, 2, 3
        return 'happy_blink'
      when 4, 5
        return 'giggle'
      else
        return nil
      end
    end
  end

  class HappyBlink < Pattern
    def next_pattern
      return (@loop >= 2)? 'happy' : nil
    end
  end

  class Giggle < Pattern
    def next_pattern
      return (@loop >= 1)? 'happy' : nil
    end
  end

  class HappyTalk < Pattern
    def next_pattern
      return (@loop >= 2)? 'happy' : nil
    end
  end

  class MoreHappy < Pattern
    def next_pattern
      return nil if @loop <= 20
      @loop = 0
      case rand(10)
      when 0, 1, 2, 3
        return 'more_happy_blink'
      when 4, 5
        return 'blush'
      else
        return nil
      end
    end
  end

  class MoreHappyBlink < Pattern
    def next_pattern
      return (@loop >= 2)? 'more_happy' : nil
    end
  end

  class Blush < Pattern
    def next_pattern
      return (@loop >= 1)? 'more_happy' : nil
    end
  end

  class MoreHappyTalk < Pattern
    def next_pattern
      return (@loop >= 2)? 'more_happy' : nil
    end
  end

  class Angry < Pattern
    def next_pattern
      return nil if @loop <= 20
      @loop = 0
      case rand(10)
      when 0, 1, 2, 3
        return 'knock'
      when 4, 5
        return 'sigh'
      else
        return nil
      end
    end
  end

  class Knock < Pattern
    def next_pattern
      return (@loop >= 2)? 'angry' : nil
    end
  end

  class Sigh < Pattern
    def next_pattern
      return (@loop >= 1)? 'angry' : nil
    end
  end

  class AngryTalk < Pattern
    def next_pattern
      return (@loop >= 2)? 'angry' : nil
    end
  end

  class MoreAngry < Pattern
    def next_pattern
      return nil if @loop <= 20
      @loop = 0
      case rand(10)
      when 0, 1, 2, 3
        return 'snap'
      when 4, 5
        return 'armfold'
      else
        return nil
      end
    end
  end

  class Snap < Pattern
    def next_pattern
      return (@loop >= 2)? 'more_angry' : nil
    end
  end

  class ArmFold < Pattern
    def next_pattern
      return (@loop >= 1)? 'more_angry' : nil
    end
  end

  class MoreAngryTalk < Pattern
    def next_pattern
      return (@loop >= 2)? 'more_angry' : nil
    end
  end
end
