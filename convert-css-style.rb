#!/usr/bin/ruby
require_relative('func.rb')

# Convert linaria css style to vanilla extract css style

full_filepath = ARGV[0]
filename = full_filepath.split("/")[-1]
new_filename = filename.sub("tsx", "css.ts")
filepath = full_filepath.split("/")[0..-2].join("/")
new_fullpath = "#{filepath}/#{new_filename}"

text = ""
File.open(ARGV[0]) do |file|
    text = file.read
end

name_css_hash = {}
text.scan(%r|const (\w+) = styled.*?`(.*?)`|m).each do |name, css|
    list = convert_vanilla_extract_css_style(css)

    name = name.gsub(/^Styled/, '')
    new_name = name[0].downcase + name[1..-1]
    name_css_hash[new_name] = "export const #{new_name}Style = style({" + list.join + "\n" + "\s" * 4 + "}," + "\n);"
end

File.open(new_fullpath, "w") do |io|
    io.write(%q(import {style} from "@vanilla-extract/css";))
    io.write("\n")

    # Can refacotr
    name_css_hash.each do |_, value|
        io.write("\n\n")
        io.write("#{convert_media_query(value)}")
    end
end
