Shader "Custom/Chapter5-SimpleShader"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader
    {
        Pass {
            CGPROGRAM

            // 指定哪个函数包含了顶点着色器/片元着色器
            // #progma vertex/fragment name
            #pragma vertex vert
            #pragma fragment frag

            // 顶点着色器的输入 a2v：application vertexshader 把数据从应用阶段传递到顶点着色器中
            struct a2v {
                // POSITION语义：用模型空间的顶点填充vertex变量
                float4 vertex: POSITION;
                // NORMAL语义：用模型空间的法线方向填充normal变量
                float3 normal: NORMAL;
                // TEXCOORD0语义：用模型的第一套纹理坐标填充texcoord变量
                float4 texcoord: TEXCOORD0;
            };
            // 顶点着色器的输出 v2f：
            struct v2f {
                // 指定pos里包含顶点在裁剪空间中的位置信息
                float4 pos: SV_POSITION;
                // COLOR0语义用于存储颜色信息
                fixed3 color: COLOR0;
            };
            // 顶点着色器的输出结构中必须包含一个变量，语义是SV_POSITION，否则渲染器将无法得到裁剪空间中的顶点坐标 （新版Unity中不必须）
            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                // v.normal包含顶点的法线方向，其分量范围为(-1.0, 1.0)，下面的代码将其分量映射到了(0.0, 1.0)，存储到o.color中传递给片元着色器
                o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
                return o;
            }
            // SV_Target：指定用户的输出颜色存储到一个渲染目标中，此例将输出到默认的帧缓存中
            // 片元着色器的输入实际上是把顶点着色器的输出进行插值后得到的结果
            fixed4 frag(v2f i) : SV_Target {
                // 表示白色的fixed4类型的变量，每个分量范围为(0,1)
                // return fixed4(i.color, 1.0);

                fixed3 c = i.color;
                c *= _Color.rgb;
                return fixed4(c, 1.0);
            }

            ENDCG
        }
    }
}
