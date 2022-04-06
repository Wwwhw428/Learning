Shader "Custom/Chapter 8/Alpha Blend" {
    Properties {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _AlphaScale ("Alpha Scale", Range(0, 1.0)) = 0.5
    }
    SubShader {
        Tags { "Queue" = "Transparent" "IgnoreProject" = "True" "RenderType" = "Transparent"}
        
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        pass {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "lighting.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _AlphaScale;

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float3 texcoord : TEXCOORD0;
            };
            struct v2f {
                float4 pos : SV_POSITION;
                float4 worldPos : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            v2f vert (a2v v) {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_WorldToObject, v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;

                return o;
            }
            fixed4 frag (v2f i) : SV_TARGET {
                fixed3 lightDir = normalize(WorldSpaceLightDir(i.worldPos)).xyz;
                fixed3 worldNormal = normalize(i.worldNormal);

                fixed4 texColor = tex2D(_MainTex, i.uv);
                fixed3 albedo = texColor.rgb * _Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                
                fixed3 diffuse = albedo * _LightColor0.rgb * saturate(dot(worldNormal, lightDir));
                
                return fixed4 (ambient + diffuse, texColor.a * _AlphaScale);
            }
            ENDCG
        }
    }
}