#version 330 compatibility

in vec2 texcoord; // 纹理坐标
in vec2 lmcoord; // 光照贴图坐标
in vec4 glcolor; // 颜色
in vec3 normal; // 法线

uniform sampler2D colortex0; // 颜色纹理
uniform sampler2D lightmap; // 光照贴图

/* DRAWBUFFERS: 0 */
layout(location = 0) out vec4 color; // 输出颜色

void main(){
    // 贴图颜色乘以群系颜色
    color = texture(colortex0, texcoord) * glcolor;
    
    // TODO：光照
    color *= texture(lightmap, lmcoord);

    // 透明度小于0.1的片段被丢弃，不会被渲染
    if(color.a < 0.1) { discard; }
}