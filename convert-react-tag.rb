#!/usr/bin/ruby

# Convert react tag into vanilla extract style

filepath = ARGV[0]
filename = filepath.split("/")[-1]
new_filename = filename.gsub("tsx", "css")

linaria_style_regex = %r|const (\w+) = styled.(.*?)`.*?`;|m

text = ""
File.open(ARGV[0]) do |file|
    text = file.read
end

list = text.scan(linaria_style_regex)
new_name_list = []
list.each do |name, tag|
    name = name.gsub(/^Styled/, '')
    new_name = name[0].downcase + name[1..-1] + "Style"
    new_name_list.append(new_name)

    regex = %r|<#{name}(.*)<\/#{name}>|m

    if text.match(regex)
        text.gsub!(regex) do
            "<#{tag} className={#{new_name}}#{$1}</#{tag}>"
        end
    else
        text.gsub!(%r|<#{name}(.*?)\/>|m) do
            "<#{tag} className={#{new_name}}#{$1}/>"
        end
    end
end

File.open(ARGV[0], 'w') do |io|
    if new_name_list.length > 0
        io.write(%Q(import {#{new_name_list.join(", ")}} from "./#{new_filename}";\n))
    end
    io.write(text
      .gsub(linaria_style_regex, '')
      .gsub(%r|\n{3,}|) { "\n\n" }
    )
end
