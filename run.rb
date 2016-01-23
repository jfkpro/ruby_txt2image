#!/usr/bin/env ruby
require 'RMagick'


def draw_image fn, text, fontsize=200
  canvas = Magick::Image.new(256, 256){self.background_color = 'white'}
  gc = Magick::Draw.new
  gc.pointsize=fontsize
  gc.font = '/Library/Fonts/华文细黑.ttf'

  gc.text((256-fontsize)/2, fontsize, text)

  gc.draw(canvas)
  canvas.write(fn)
end


draw_image "abc.png", "好", 190+rand(30)
