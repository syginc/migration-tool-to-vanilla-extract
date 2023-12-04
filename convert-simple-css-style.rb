#!/usr/bin/ruby
require_relative('func.rb')

# Simply convert linaria css style to vanilla extract css style

text = ""
File.open(ARGV[0]) do |file|
    text = file.read
end

File.open(ARGV[0], "w") do |io|
    output = convert_vanilla_extract_css_style(text)

    io.write(output)
end
