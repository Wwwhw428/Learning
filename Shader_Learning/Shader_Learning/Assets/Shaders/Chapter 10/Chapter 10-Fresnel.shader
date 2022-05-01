Shader "Custom/Chapter 10/Fresnel"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _FresnelCubemap ("Fresnel Cubemap", Cube) = "_Skybox" { }
        _FresnelScale ("Fresnel Scale", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "lighting.cginc"

            fixed4 _Color;
            samplerCUBE _FresnelCubemap;
            float _FresnelScale;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldViewDir : TEXCOORD1;
                float3 worldLightDir : TEXCOORD2;
                float3 reflect : TEXCOORD3;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldViewDir = WorldSpaceViewDir(worldPos);
                o.worldLightDir = WorldSpaceLightDir(worldPos);

                o.reflect = reflect(-o.worldViewDir, o.worldNormal);
                
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldViewDir = normalize(i.worldViewDir);
                fixed3 worldLightDir = normalize(i.worldLightDir);

                fixed3 reflection = texCUBE(_FresnelCubemap, i.reflect).rgb;

                float3 fresneltion = _FresnelScale + (1 - _FresnelScale) * pow((1 - dot(worldViewDir, worldNormal)), 5);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

                fixed3 diffuse = _Color.rgb * _LightColor0.rgb * saturate(dot(worldLightDir, worldNormal));

                return fixed4(ambient + lerp(diffuse, reflection, saturate(fresneltion)), 1.0);
            }
            ENDCG

        }
    }
}
