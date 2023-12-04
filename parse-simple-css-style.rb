#!/usr/bin/ruby
require_relative('func.rb')

text = DATA.read

puts convert_media_query(convert_vanilla_extract_css_style(text))

__END__

export const centeringContainer = `
  position: relative;
  overflow: hidden;
`;

export const centeringHorizontal = `
  position: absolute;
  top: 50%;
  left: 0;
  width: 100%;
  transform: translateY(-50%);  
`;

export const centeringVertical = `
  position: absolute;
  top: 0;
  left: 50%;
  height: 100%;
  transform: translateX(-50%);  
`;

export const centeringScaleDown = `
  position: absolute;
  margin: auto;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  max-width: 100%;
  max-height: 100%;  
`;
