require 'chasen'                        # (1)

module Morph
  def init_analyzer                     # (2)
    Chasen::setarg('-F%m %P-\t');
  end

  def analyze(text)                     # (3)
    return Chasen::analyze(text).chomp.split(/\t/).map do |part|
      part.split(/ /)
    end
  end

  def keyword?(part)                    # (4)
    return /����-(���|�ŗL����|�T�ϐڑ�|�`�e�����ꊲ)/ =~ part
  end

  module_function :init_analyzer, :analyze, :keyword?
end
