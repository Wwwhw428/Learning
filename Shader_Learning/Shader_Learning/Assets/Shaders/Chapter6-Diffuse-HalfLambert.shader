Shader "custom/Chapter6-Diffuse-HalfLambert"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        pass
        {
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM

            ENDCG
        }
    }
}