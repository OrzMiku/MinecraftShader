#version 330 compatibility

out vec2 texcoord; // 纹理坐标

void main(){
    // gl_Position 是顶点着色器必须计算的值，表示顶点在裁切空间的位置
    // ftransform() 是一个内置函数，用于将顶点位置从模型空间转换到裁切空间，他虽然已经被废弃，但是在这里仍然可以使用
    gl_Position = ftransform();

    // 计算当前顶点的纹理坐标，他是一个从左下角(0, 0)到右上角(1, 1)的二维向量
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}