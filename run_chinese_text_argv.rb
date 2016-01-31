#!/usr/bin/env ruby
require 'rmagick'


ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#ALPHABET="abcdefghijklmnopqrstuvwxyz0123456789"
FONTS=Dir["chn_fonts/*"]
DIR="coded_refined_chinese_text_argv_chars_#{Time.now.to_i}"
SIZE_OFFSET=8
ROTATE=15

text = File.read(ARGV[0])

NOISE_TYPES = [Magick::UniformNoise, Magick::GaussianNoise,
               Magick::MultiplicativeGaussianNoise,
               Magick::ImpulseNoise, Magick::LaplacianNoise,
               Magick::PoissonNoise]

def draw_image fn, text, font, fontsize=200, rotate=0 
  xsize = 200
  canvas = Magick::Image.new(xsize, xsize){self.background_color = 'white'}
  gc = Magick::Draw.new
  gc.pointsize=fontsize
  gc.font = font
  gc.gravity = Magick::CenterGravity
  #gc.text((xsize-fontsize)/2, fontsize, text)
  gc.text(0, 0, text)
  gc.draw(canvas)
  canvas = canvas.rotate(rotate)
  #canvas = canvas.add_noise(NOISE_TYPES[1])
  canvas.write(fn)
end

class String
  def to_code
    self.unpack("U*").first
  end

end

`mkdir -p #{DIR}`
manifest = File.open(DIR+"/MANIFEST.txt","a")

draw_cnt = 0
text.split("").uniq.each do |chr|
  if chr==" "
    next
  end
  this_dir = "#{DIR}/#{chr.to_code}"
  `mkdir -p #{this_dir}`
  manifest.write("#{chr.to_code} #{chr}\n")
  f_cnt=0
  FONTS.each do |f|
    if true #ok_chinese_font_idx.include? f_cnt
      SIZE_OFFSET.times do |offset|
        ROTATE.times do |r|
          angle = ((rand - 0.5) * r).round(1)
          fn = "#{this_dir}/unicode#{chr.to_code}_#{f_cnt}_#{offset}_#{(angle*10).round}.png"
          draw_image fn, chr, f, 96+offset * 12, angle
          draw_cnt = draw_cnt + 1 
          puts "#{draw_cnt} #{fn} drawn"
        end
      end
    end
    f_cnt = f_cnt + 1
  end
end


#`cd #{DIR}; sh ../rm_chinese_fail_chars.sh`

manifest.close
