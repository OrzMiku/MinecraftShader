#version 330 compatibility

in vec2 texcoord; // 纹理坐标
in vec2 lmcoord; // 光照贴图坐标
in vec4 glcolor; // 颜色
in vec3 normal; // 法线

uniform sampler2D colortex0; // 颜色纹理
uniform sampler2D lightmap; // 光照贴图

/* DRAWBUFFERS: 012 */
layout(location = 0) out vec4 color; // 输出颜色
layout(location = 1) out vec4 lightmapData; // 输出光照数据
layout(location = 2) out vec4 normalEncoded; // 输出法线数据

void main(){
    // 贴图颜色乘以群系颜色
    color = texture(colortex0, texcoord) * glcolor;
    
    // 这里Alpha始终为1.0，这是为了确保数据始终被写入，如果Alpha为0.0，数据可能会被丢弃
    // 法线编码
    normalEncoded = vec4(normal * 0.5 + 0.5, 1.0);
    // 光照数据
    lightmapData = vec4(lmcoord, 0.0, 1.0);

    // TODO：光照
    // color *= texture(lightmap, lmcoord);

    // 透明度小于0.1的片段被丢弃，不会被渲染
    if(color.a < 0.1) { discard; }

    // 伽马校正
    color.rgb = pow(color.rgb, vec3(2.2));
}