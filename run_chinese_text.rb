#!/usr/bin/env ruby
require 'RMagick'


ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#ALPHABET="abcdefghijklmnopqrstuvwxyz0123456789"
FONTS=Dir["/Library/Fonts/*.tt*"]
DIR="coded_refined_chinese_text_chars"
SIZE_OFFSET=8

ok_chinese_font_idx=[6, 7, 17, 24, 67, 71, 72, 82, 88, 92, 95, 108, 115, 116, 118, 137, 155, 156, 166, 167, 168, 170, 171, 172, 173, 174, 175]

uniq_text="王毅说，新年伊始，习近平主席即远赴沙特、埃及和伊朗，展开今年首场重大外交行动。3国都是中东地区有重要影响的国家，又都同中国有着传统友 好，保持广泛合作。3国领导人多次盛情邀请习近平主席往访。此次习近平主席应约而至，并把3国作为今年的首访，充分体现了中国对发展同3国以及整个中东地 区关系的高度重视。同时，当此世界经济复苏步履维艰、地区热点问题集中频发之际，习近平主席为和平而来，为发展而至，为和解而呼，更令此访受到地区国家和 国际社会的广泛关注与期待。"

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
