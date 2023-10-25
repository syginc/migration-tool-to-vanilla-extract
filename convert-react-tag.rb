#!/usr/bin/ruby

# Convert react tag into vanilla extract style

filepath = ARGV[0]
filename = filepath.split("/")[-1]
new_filename = filename.gsub("tsx", "css")

File.open(ARGV[0]) do |file|
    text = file.read

    list = text.scan(%r|const (\w+) = styled.(.*?)`.*?`|m)
    new_name_list = []
    list.each do |name, tag|
        name = name.gsub(/^Styled/, '')
        new_name = name[0].downcase + name[1..-1] + "Style"
        new_name_list.append(new_name)

        regex = %r|<#{name}(.*)<\/#{name}>|m

        if text.match(regex)
            text.gsub!(regex) do
                "<#{tag} classname={#{new_name}}#{$1}</#{tag}>"
            end
        else
            text.gsub!(%r|<#{name}(.*?)\/>|m) do
                "<#{tag} classname={#{new_name}}#{$1}/>"
            end
        end
    end

    puts %Q(import {#{new_name_list.join(", ")}} from "#{new_filename}")
    puts text
end
