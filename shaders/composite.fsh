#version 330 compatibility

uniform sampler2D colortex0; // 颜色纹理
uniform sampler2D colortex1; // 光照数据
uniform sampler2D colortex2; // 法线数据
uniform vec3 shadowLightPosition; // 太阳光照位置，白天返回太阳位置，晚上返回月亮位置
uniform mat4 gbufferModelViewInverse; // 视图矩阵逆矩阵，用于将视图空间转换到世界空间

in vec2 texcoord; // 纹理坐标

// 使用 DRAWBUFFERS: 0 告诉着色器写回 colortex0
// localtion = 0 并不是因为 DRAWBUFFERS: 0，而是因为 0 是DRAWBUFFERS的第一个索引
// 这会初始化一个 color 变量，这个变量会被写回 colortex0
/* DRAWBUFFERS: 0 */
layout(location = 0) out vec4 color;

// 一些假的光照颜色
const vec3 torchColor = vec3(1.0, 0.5, 0.08); // 火把光照颜色
const vec3 skyColor = vec3(0.05, 0.15, 0.3); // 天空光照颜色
const vec3 sunlightColor = vec3(1.0); // 太阳光照颜色
const vec3 ambientColor = vec3(0.1); // 环境光照颜色

void main(){
    // 从颜色纹理中获取颜色
    color = texture(colortex0, texcoord);
    // 从光照数据中获取光照数据
    vec2 lightmap = texture(colortex1, texcoord).rg;
    // 从法线数据中获取法线数据
    vec3 normalEncoded = texture(colortex2, texcoord).rgb;
    // 解码法线数据，归一化确保法线长度为1
    vec3 normal = normalize((normalEncoded - 0.5) * 2.0);
    
    // 方块光照存储在红色通道，天空光照存储在绿色通道，可使用下面的代码测试
    // color.rgb = vec3(lightmap, 0.0);

    // 计算光照颜色
    vec3 blocklight = lightmap.r * torchColor;
    vec3 skylight = lightmap.g * skyColor;
    vec3 ambient = ambientColor;

    // 计算太阳光照
    vec3 lightVector = normalize(shadowLightPosition); // 光照方向
    vec3 worldLightVector = mat3(gbufferModelViewInverse) * lightVector; // 将光照方向从视图空间转换到世界空间
    // 太阳光照方向与法线的点积可以得到太阳光照的强度
    vec3 sunlight = sunlightColor * dot(worldLightVector, normal) * lightmap.g;

    // 应用光照
    color.rgb *= blocklight + skylight + ambient + sunlight;
}