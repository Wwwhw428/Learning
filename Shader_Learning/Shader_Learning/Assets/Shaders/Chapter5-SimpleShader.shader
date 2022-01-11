// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Chapter5-SimpleShader"
{
    SubShader
    {
        Pass {
            CGPROGRAM

            // 指定哪个函数包含了顶点着色器/片元着色器
            // #progma vertex/fragment name
            #pragma vertex vert
            #pragma fragment frag

            // a2v：application vertexshader 把数据从应用阶段传递到顶点着色器中
            sturct a2v {
                // POSITION语义：用模型空间的顶点填充vertex变量
                float4 vertex: POSITION;
                // NORMAL语义：用模型空间的法线方向填充normal变量
                float3 normal: NORMAL;
                // TEXCOORD0语义：用模型的第一套纹理坐标填充texcoord变量
                float4 texcoord: TEXCOORD0
            }
            // SV_POSITION：指定顶点着色器的输出为裁剪空间中的顶点坐标
            float4 vert(float4 v : POSITION) : SV_POSITION {
                return UnityObjectToClipPos (V);
            }
            // SV_Target：指定用户的输出颜色存储到一个渲染目标中，此例将输出到默认的帧缓存中
            fixed4 frag() : SV_Target {
                // 表示白色的fixed4类型的变量，每个分量范围为(0,1)
                return fixed4(1.0, 1.0, 1.0, 1.0);
            }

            ENDCG
        }
    }
}
