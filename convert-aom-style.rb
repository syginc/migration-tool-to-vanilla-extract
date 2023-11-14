#!/usr/bin/ruby

require_relative('func-aom.rb')

# Convert aom css style.ts with vanilla extract css.ts

full_filepath = ARGV[0]
filename = full_filepath.split("/")[-1]
new_filename = filename.sub("-styles", ".css")
filepath = full_filepath.split("/")[0..-2].join("/")
new_fullpath = "#{filepath}/#{new_filename}"

text = ""
File.open(ARGV[0]) do |file|
    text = file.read
end

text = text
  .gsub("mediaMiddleUp", "screenMiddleUp")
  .gsub("mediaUpToSmall", "screenUpToSmall")

global_style_key_props = []
regex = /export const (\w+) = css`(.*)`;/m

text.scan(regex) do
    css = $2
    aom_global_regex = /:global\(\) \{(.*)\}/m
    aom_article_body_regex = /\.article-body \{(.*)\}/m
    group_regex = /(\s+)(.*?) \{(.*?)(\1)\}/m
    strip_template = aom_article_body_regex.match(aom_global_regex.match(css).to_a[1]).to_a[1]
    strip_template.scan(group_regex) do
        space = $1
        selector = $2
        partial = $3
        space_size = space.length - 1

        global_style_key_props.append([selector, changeKebabWithSnake(scan_props(partial, space_size))])
        
        child_partial = scan_css_partial(partial, space_size)

        unless child_partial.empty?
            processing = process_css_partial(child_partial, selector, space_size)
            processing.each do |key, value|
                global_style_key_props.append([key, value])
            end
            partial2 = child_partial.map do |child_selector, grand_child_partial|

                partial3 = scan_css_partial(grand_child_partial, space_size + 4)
                unless partial3.empty?
                    processing = process_css_partial(partial3, "#{selector} #{child_selector}", space_size + 4)
                    processing.each do |key, value|
                        global_style_key_props.append([key, value])
                    end
                end
            end
        end
    end
end

import_libraries = []
text.scan(/(import {.*?} from ".*?";)/m) do
    matched = $1
    npm_library = matched.match(/import {.*?} from "(.*?)";/m).to_a[1]
    if npm_library != "linaria"
        import_libraries.append(matched)
    end
end

File.open(new_fullpath, 'w') do |io|
    io.write(%!import {globalStyle} from "@vanilla-extract/css";! + "\n")
    io.write(%!import {contentSelector} from "../../../styles/utility/content-selector";! + "\n\n")
    import_libraries.each do |library|
        io.write(library + "\n\n")
    end
    output = write_global_style(global_style_key_props, true)
    output.each do |styles|
        io.write(styles + "\n")
    end
end
