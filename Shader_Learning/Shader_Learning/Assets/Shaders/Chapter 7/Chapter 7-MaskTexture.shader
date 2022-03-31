Shader "Custom/Chapter 7/MaskTexture" {
    
    Properties {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _BumpTex ("Bump Map", 2D) = "bump" {}
        _BumpScale ("Bump Scale", float) = 1.0
        _SpecularMask ("Specular Mask", 2D) = "white" {}
        _SpecularScale ("Specular Scale", float) = 1.0
        _Gloss ("Gloss", Range(0.8, 256)) = 20
    }
    SubShader {
        pass {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "lighting.cginc"

            fixed4 _Color;
            fixed4 _Specular;
            float _Gloss;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpTex;
            float _BumpScale;
            float4 _BumpTex_ST;
            sampler2D _SpecularMask;
            float _SpecularScale;
            float4 _SpecularMask_ST;

            struct a2v {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord : TEXCOORD0;
            };
            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 LightDir : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            v2f vert (a2v v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

            }


            ENDCG
        }
    }
}