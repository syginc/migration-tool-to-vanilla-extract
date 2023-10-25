#!/usr/bin/ruby

# Replace linaria styled`` to vanilla-extract style({})

File.open(ARGV[0]) do |file|
    text = file.read

    regex = %r|const (\w+) = styled.*?`(.*?)`|m
    name_css_hash = {}
    text.scan(regex).each do |name, css|
        list = css.split(/;/).map do |s|
            pair = s.split(/:/)
            pair[0].gsub!(%r|-([a-z])|) { $1.upcase }
            pair[1].gsub!(%r|^(\s*)(.*?)(\s*)$|, '\1"\2"\3') if pair[1]
            pair.join(":")
        end

        name = name.gsub(/^Styled/, '')
        new_name = name[0].downcase + name[1..-1]
        name_css_hash[new_name] = "export const #{new_name}Style = style({" + list.join(",") + "})"
    end

    puts %q(import {style} from "@vanilla-extract/css";)
    name_css_hash.each do |_, value|
        puts value
        puts
    end
end
