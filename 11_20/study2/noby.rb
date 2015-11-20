#! ruby -Ks
require 'unmo'
require 'vr/vruby'
require 'vr/vrcontrol'
require 'vr/vrhandler'
require 'vr/vrrichedit'
require 'nobycanvas'

class NobyForm < VRForm
  include VRDrawable
  include VRMenuUseable
  include VRDestroySensitive

  def construct
    # �m�r�B����
    @noby = Unmo.new('noby')
    Morph::init_analyzer
    
    # �E�B���h�E�^�C�g��
    self.caption = 'Unmo System : ' + @noby.name

    # �t�H���g�̏���
    @font = @screen.factory.newfont('�l�r �o�S�V�b�N', 12)

    # ���j���[
    menu = newMenu
    menu.set([
               ['�t�@�C��(&F)',[['�I��(&X)', 'exit']]],
               ['�I�v�V����(&O)',[['Responder��\��(&R)', 'resp_opt']]]
             ])
    setMenu(menu)

    # �A�j���[�V�����̈�
    addControl(NobyCanvas, 'noby_canvas', '', 15, 15, 290, 190)
    @noby_canvas.createCanvas(290, 190)
    @noby_canvas.load_bmps

    # �������b�Z�[�W�\���̈�
    addControl(VRStatic, 'response_area', '', 15, 240, 290, 110)
    @response_area.setFont(@font)

    # �Θb���O�̈�
    addControl(VRText, 'log_area', '', 320, 10, 305, 350,
               WStyle::WS_VSCROLL|WStyle::ES_READONLY)
    @log_area.setFont(@font)

    # ���͗̈�
    addControl(ChatEdit, 'input_area', '', 10, 380, 525, 20)
    @input_area.setFont(@font)

    # [�b��]�{�^��
    addControl(VRButton, 'talk_btn', '�b��', 545, 380, 80, 20)
    @talk_btn.setFont(@font)

    # WM_ACTIVATE���󂯎�鏀��
    acceptEvents([WMsg::WM_ACTIVATE])
    addHandler(WMsg::WM_ACTIVATE, 'active', MSGTYPE::ARGINTINT, nil)

    # �t�H�[�J�X����͗̈��
    @input_area.focus

    # ���O
    @log = ["Unmo System : #{@noby.name} Log -- #{Time.now}"]
  end

  def input_area_enter
    talk
  end

  def talk_btn_clicked
    talk
  end

  def exit_clicked
    close
  end

  def self_destroy
    @noby.save

    open('log.txt', 'a') do |f|
      f.puts(@log)
      f.puts
    end
  end

  def resp_opt_clicked
    @resp_opt.checked = !@resp_opt.checked?
  end

  def talk
    return if @input_area.text.empty?

    response = @noby.dialogue(@input_area.text)

    @response_area.caption = response
    putlog('> ' + @input_area.text)
    putlog(prompt + response)
    @input_area.text = ''

    change_looks
  end

  def putlog(log)
    @log_area.text += "#{log}\n"
    @log_area.scrollTo(@log_area.countLines-1, 1)
    @log.push(log)
  end

  def prompt
    p = @noby.name
    p += '�F' + @noby.responder_name if @resp_opt.checked?
    return p + '> '
  end

  def change_looks
    case @noby.mood
    when -5..5
      @noby_canvas.change_pattern('talk')
    when -10..-5
      @noby_canvas.change_pattern('angry_talk')
    when -15..-10
      @noby_canvas.change_pattern('more_angry_talk')
    when 5..10
      @noby_canvas.change_pattern('happy_talk')
    when 10..15
      @noby_canvas.change_pattern('more_happy_talk')
    end
  end

  def self_paint
    setPen(RGB(0,0,0))
    drawLine(10, 230, 30, 230)
    drawLine(30, 230, 40, 220)
    drawLine(40, 220, 50, 230)
    drawLine(50, 230, 310, 230)
    drawLine(10, 355, 310, 355)
    drawLine(10, 230, 10, 355)
    drawLine(310, 230, 310, 355)
  end

  def self_active(flgs, hWnd)
    active = LOWORD(flgs)
    @input_area.focus if active > 0
    return SKIP_DEFAULTHANDLER   # �f�t�H���g�̃n���h�����Ăяo���Ȃ�
  end
end

class ChatEdit < VREdit
  include VRKeyFeasible
  def self_char(keycode, keydata)
    call_parenthandler('enter') if keycode == 0x0d
  end
end

VRLocalScreen.start(NobyForm, 100, 100, 640, 480)
