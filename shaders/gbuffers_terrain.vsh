#version 330 compatibility

uniform mat4 gbufferModelViewInverse; // 模型视图矩阵的逆矩阵

out vec2 texcoord; // 纹理坐标
out vec2 lmcoord; // 光照贴图坐标
out vec4 glcolor; // 颜色
out vec3 normal; // 法线

void main(){
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

    // 光照贴图的实际范围存储在gl_MultiTexCoord1中，乘以gl_TextureMatrix[1]得到实际的纹理坐标
    lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    // 范围为~0.003-~0.997，因此需要映射到0-1
    lmcoord = (lmcoord * 33.05 / 32.0) - (1.05 / 32.0);

    // gl_Normal 存储了模型空间中的法线，乘以gl_NormalMatrix得到玩家空间中的法线
    normal = gl_Normal * gl_NormalMatrix;
    // 乘以模型视图矩阵的逆矩阵得到世界空间中的法线，范围为-1到1
    normal = normal * mat3(gbufferModelViewInverse);
    
    // 部分方块具有基于生物群系渲染的颜色
    // 他们的的颜色是存储在gl_Color中的，材质的颜色实际是灰色的，可以使用下面代码进行测试
    // glcolor = vec4(1.0, 1.0, 1.0, 1.0);
    glcolor = gl_Color;
}