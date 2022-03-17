Shader "Custom/Chapter 7/Single Texture"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("MainTex", 2D) = "white" {}
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8.0, 256)) = 20
    }
    SubShader
    {
        pass
        {
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "UnityCG.cginc"

            fixed4    _Color;
            sampler2D _MainTex;
            float4    _MainTex_ST;
            fixed4    _Specular;
            float     _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };
            struct v2f {
                float4 pos : SV_POSITION;
                float4 worldPos : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                // pass uv location
                o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                // o.uv = TRENSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET
            {
                float3 worldNormal = normalize(i.worldNormal);
                float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 worldViewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                float3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                fixed3 diffuse = _LightColor0.rgb * albedo.rgb * saturate(dot(worldNormal, worldLightDir));

                float3 halfVector = normalize(worldLightDir + worldViewDir);
                fixed3 specular = _Specular.rgb * _LightColor0.rgb * pow(saturate(dot(halfVector, worldNormal)), _Gloss);

                return fixed4(ambient + diffuse + specular, 1.0);
            }

            ENDCG
        }
    }
}
