#!/usr/bin/env ruby
require 'RMagick'


ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#ALPHABET="abcdefghijklmnopqrstuvwxyz0123456789"
FONTS=Dir["/Library/Fonts/*.tt*"]
DIR="english_chars"
SIZE_OFFSET=10

def draw_image fn, text, font, fontsize=200
  xsize = 256
  canvas = Magick::Image.new(xsize, xsize){self.background_color = 'white'}
  gc = Magick::Draw.new
  gc.pointsize=fontsize
  gc.font = font
  gc.text((xsize-fontsize)/2, fontsize, text)

  gc.draw(canvas)
  canvas.write(fn)
end


draw_cnt = 0
ALPHABET.split("").each do |chr|
  this_dir = "#{DIR}/#{chr}"
  `mkdir -p #{this_dir}`
  f_cnt=0
  FONTS.each do |f|
    SIZE_OFFSET.times do |offset|
      fn = "#{this_dir}/#{chr}_#{f_cnt}_#{offset}.png"
      draw_image fn, chr, f, 190+offset * 2
      draw_cnt = draw_cnt + 1 
      puts "#{draw_cnt} #{fn} drawn"
    end
    f_cnt = f_cnt + 1
  end
end
