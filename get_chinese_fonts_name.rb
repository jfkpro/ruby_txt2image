#!/usr/bin/env ruby
require 'RMagick'


ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#ALPHABET="abcdefghijklmnopqrstuvwxyz0123456789"
FONTS=Dir["/Library/Fonts/*.tt*"]
FONTS2=Dir["/Library/Fonts/*.ot*"]
DIR="coded_refined_chinese_text_chars"
SIZE_OFFSET=8

#ok_chinese_font_idx=[6, 7, 17, 24, 67, 71, 72, 82, 88, 92, 95, 108, 115, 116, 118, 137, 155, 156, 166, 167, 168, 170, 171, 172, 173, 174, 175]
list=[137,167,174,17,71,82,95,166,173,175,24,72,92]
list2=[30,31,32,33,34,35,36,37]
f_cnt = 0
`mkdir chn_fonts`
FONTS.each do |f|
  if list.include? f_cnt
    puts f
    `cp '#{f}' chn_fonts`
  end
  f_cnt = f_cnt + 1
end
f_cnt = 0
FONTS2.each do |f|
if list2.include? f_cnt
    puts f
    `cp '#{f}' chn_fonts`
  end
  f_cnt = f_cnt + 1
end

exit

uniq_text="王毅说待"

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

class String
  def to_code
    self.unpack("U*").first
  end

end

`mkdir -p #{DIR}`
manifest = File.open(DIR+"/MANIFEST.txt","a")

draw_cnt = 0
uniq_text.split("").uniq.each do |chr|
  if chr==" "
    next
  end
  this_dir = "#{DIR}/#{chr.to_code}"
  `mkdir -p #{this_dir}`
  manifest.write("#{chr.to_code} #{chr}\n")
  f_cnt=0
  FONTS.each do |f|
    if ok_chinese_font_idx.include? f_cnt
      SIZE_OFFSET.times do |offset|
        fn = "#{this_dir}/unicode#{chr.to_code}_#{f_cnt}_#{offset}.png"
        draw_image fn, chr, f, 190+offset * 2
        draw_cnt = draw_cnt + 1 
        puts "#{draw_cnt} #{fn} drawn"
      end
    end
    f_cnt = f_cnt + 1
  end
end


`cd #{DIR}; sh ../rm_chinese_fail_chars.sh`

manifest.close
