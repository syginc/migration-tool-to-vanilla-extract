#!/usr/bin/ruby

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

regex = %r|const (\w+) = styled.*?`(.*?)`|m
name_css_hash = {}
css_variables = []
text.scan(regex).each do |name, css|
    list = css.split(/;/).map do |s|
        pair = s.split(/:/)
        key = pair[0].gsub(%r|-([a-z])|) { $1.upcase }
        value = pair[1].gsub(%r|^(\s*)(.*?)(\s*)$|, '\1"\2"\3') if pair[1]
        regex = %r|\"\$\{(.*)\}\"|
        if regex.match(value)
            var = value.gsub(regex, '\1')
            css_variables.append(var.strip)
            "#{key}:#{var}"
        else
            "#{key}:#{value}"
        end
    end

    name = name.gsub(/^Styled/, '')
    new_name = name[0].downcase + name[1..-1]
    name_css_hash[new_name] = "export const #{new_name}Style = style({" + list.join(",") + "})"
end

File.open(new_fullpath, "w") do |io|
    io.write(%q(import {style} from "@vanilla-extract/css";))
    io.write("\n")

    css_variables.each do |var|
        path = text.scan(%r|import \{.*#{var}.*\} from \"(.*)\";|)[0][0]
        io.write(%Q(import {#{var}} from "#{path}";))
    end

    name_css_hash.each do |_, value|
        io.write("\n\n")
        io.write("#{value};")
    end
end
