#version 430

uniform sampler2D texture;

in vec4 color;
out vec4 fragcolor;
in vec2 uu;

void main()
{

	fragcolor = texture2D(texture, uu)*1/2+color*1/2;
} 