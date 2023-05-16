class PFA

  PFA_WIDTH   = 4000 # 4000px (en 300dpi)
  PFA_HEIGHT  = PFA_WIDTH / 4
  # PFA_HEIGHT  = (PFA_WIDTH.to_f / 1.6).to_i
  PFA_LEFT_MARGIN   = 150
  PFA_RIGHT_MARGIN  = 150
  LINE_HEIGHT = (PFA_HEIGHT.to_f / 15).to_i

  # ImageMagick
  CONVERT_CMD = 'convert' # avant : /usr/local/bin/convert

end
