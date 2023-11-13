#!/usr/bin/ruby

text = DATA.read

def changeKebabWithSnake(props)
    props.map do |key, value|
        [key.gsub(/-([a-z])/) {$1.upcase}, value]
    end
end

def write_selector(selector, props)
    p = props.map do |key, value|
        %!    #{key}: #{value},!
    end
    puts %Q%globalStyle(contentSelector(#{selector}),\n#{p.join("\n")}%
    puts "\n"
    puts "});"
    puts "\n"
end

def write_global_style(global_list)
    global_list.each do |list|
        key, value = list
        write_selector(key, value)
    end
end

def scan_props(partial, space_size)
    props_regex = /^\s{#{space_size + 4}}([^\s].*?):\s(.*?);/
    partial.scan(props_regex)
end

def scan_css_partial(partial, space_size)
    selector_regex = /^\s{#{space_size + 4}}([^\s][^\n]*?) \{(.*?)^\s{#{space_size + 4}}\}/m
    partial.scan(selector_regex)
end

def process_css_partial(partial, selector, space_size)
    partial.map do |child_selector, sub_partial|
        child_props = scan_props(sub_partial, space_size + 4)
        ["#{selector} #{child_selector}", changeKebabWithSnake(child_props)]
    end
end

regex = /export const (\w+) = css`(.*)`;/m
text.scan(regex) do
    css = $2
    aom_global_regex = /:global\(\) \{(.*)\}/m
    aom_article_body_regex = /\.article-body \{(.*)\}/m
    group_regex = /(\s+)(.*?) \{(.*?)(\1)\}/m
    strip_template = aom_article_body_regex.match(aom_global_regex.match(css).to_a[1]).to_a[1]
    global_style_key_props = []
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
    write_global_style(global_style_key_props)
end

__END__
import {css} from "linaria";

import {
    mediaMiddleUp,
    mediaUpToSmall,
    themeBackgroundColorLight,
} from "../../../styles/common-variables";
import {adjacentToBlockSelector} from "../../styles/block-elements";

export const globals = css`
    :global() {
        .article-body {
            ${adjacentToBlockSelector("comment")} {
                margin-top: 16px;
            }

            .comment {
                background-color: ${themeBackgroundColorLight};
                display: grid;
                ${mediaUpToSmall} {
                    padding: 16px 16px 32px;
                    gap: 12px 8px;
                }
                ${mediaMiddleUp} {
                    padding: 20px 20px 36px;
                    gap: 16px 12px;
                }

                grid-template-columns: auto 1fr;
                grid-template-rows: 1fr auto;

                grid-template-areas:
                    "heading-left heading-right"
                    "body body";

                > .comment-heading {
                    display: contents;

                    .comment-heading-left {
                        grid-area: heading-left;
                    }

                    .comment-heading-right {
                        grid-area: heading-right;
                    }
                }

                > .comment-body {
                    grid-area: body;
                }

                p {
                    margin: 0;
                }
            }
        }
    }
`;
