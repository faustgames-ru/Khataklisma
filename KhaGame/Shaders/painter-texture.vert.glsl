#version 450

uniform mediump mat4 projection;

in mediump vec2 xy;
in mediump vec2 uv;

out mediump vec2 texCoord;

void main()
{
    gl_Position = projection * vec4(xy, 0.0, 1.0);
    texCoord = uv;
}

