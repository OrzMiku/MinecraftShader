#version 330 compatibility

uniform sampler2D colortex0; // 颜色纹理

in vec2 texcoord; // 纹理坐标

// 使用 DRAWBUFFERS: 0 告诉着色器写回 colortex0
// localtion = 0 并不是因为 DRAWBUFFERS: 0，而是因为 0 是DRAWBUFFERS的第一个索引
// 这会初始化一个 color 变量，这个变量会被写回 colortex0
/* DRAWBUFFERS: 0 */
layout(location = 0) out vec4 color;

void main(){
    // 从颜色纹理中获取颜色
    color = texture(colortex0, texcoord);
}