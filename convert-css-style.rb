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

File.open(new_fullpath, "w") do |io|
    io.write(%q(import {style} from "@vanilla-extract/css";))
    io.write("\n")

    output = convert_media_query(convert_vanilla_extract_css_style(convert_style_name(text)))
    styles = scan_vanilla_css(output)

    styles.each do |style|
    io.write("\n")
        io.write(style)
    end
end
