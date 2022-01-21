Shader "Custom/NewSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        pass {
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            struct a2v {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                fixed4 color : COLOR;
            };

            v2f vert(a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex)
                
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
