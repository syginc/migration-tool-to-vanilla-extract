#!/usr/bin/ruby

def changeKebabWithSnake(props)
    props.map do |key, value|
        [key.gsub(/-([a-z])/) {$1.upcase}, value]
    end
end

def write_selector(selector, props, isProd)
    p = props.map do |key, value|
        %!    "#{key}": "#{value}",!
    end
    ret = %!globalStyle(contentSelector("#{selector}"), {\n#{p.join("\n")}! + "\n" + "});" + "\n"
    puts ret unless isProd
    ret
end

def write_global_style(global_list, isProd)
    global_list.map do |list|
        key, value = list
        write_selector(key, value, isProd)
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

