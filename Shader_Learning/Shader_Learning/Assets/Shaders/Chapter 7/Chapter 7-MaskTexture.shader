Shader "Custom/Chapter 7/MaskTexture"
{
    
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" { }
        _BumpTex ("Bump Map", 2D) = "bump" { }
        _BumpScale ("Bump Scale", float) = 1.0
        _SpecularMask ("Specular Mask", 2D) = "white" { }
        _SpecularScale ("Specular Scale", float) = 1.0
        _Gloss ("Gloss", Range(0.8, 256)) = 20
    }
    SubShader
    {
        pass
        {
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

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 texcoord : TEXCOORD0;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 LightDir : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;

                TANGENT_SPACE_ROTATION;
                o.LightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;

                return o;
            }
            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed3 tangentNormal = UnpackNormal(tex2D(_BumpTex, i.uv));
                tangentNormal.xy *= _BumpScale;
                tangentNormal.z = sqrt(1 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

                fixed3 tangentLightDir = normalize(i.LightDir);
                fixed3 tangentViewDir = normalize(i.viewDir);

                // compute albedo color
                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;

                // compute diffuse color
                fixed3 diffuse = albedo * _LightColor0.rgb * saturate(dot(tangentNormal, tangentLightDir));
                
                // compute specular color
                fixed3 halfDir = normalize(tangentViewDir + tangentLightDir);
                fixed specularMask = tex2D(_SpecularMask, i.uv).r * _SpecularScale;
                fixed3 specular = _Specular.rgb * _LightColor0.rgb * specularMask * pow(saturate(dot(tangentNormal, halfDir)), _Gloss);

                return fixed4(ambient + diffuse + specular, 1.0);
            }


            ENDCG

        }
    }
}