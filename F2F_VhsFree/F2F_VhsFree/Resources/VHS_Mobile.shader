//Shader"Custom/VHS_Mobile"
//{
//    Properties
//    {
//        _MainTex("Main Texture", 2D) = "white" {}
//        _NoiseTex("Noise Texture", 2D) = "white" {} // low-res noise
//        _BleedAmount("Bleed Amount", Float) = 0.005
//        _NoiseAmount("Noise Amount", Float) = 0.05
//        _FisheyeBend("Fisheye Bend", Float) = 0.2
//        _TimeSpeed("Time Speed", Float) = 1.0
//    }

//    SubShader
//    {
//        Tags { "RenderType"="Opaque" }
//        Pass
//        {
//ZTest Always

//Cull Off

//ZWrite Off

//            CGPROGRAM
//            #pragma vertex vert_img
//            #pragma fragment frag
//#include "UnityCG.cginc"

//sampler2D _MainTex;
//sampler2D _NoiseTex;
//float _BleedAmount;
//float _NoiseAmount;
//float _FisheyeBend;
//float _TimeSpeed;

//float rand(float2 co)
//{
//    return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
//}

//fixed4 frag(v2f_img i) : SV_Target
//{
//    float2 uv = i.uv;

//                // Fisheye effect
//    float2 centered = uv - 0.5;
//    float len = length(centered);
//    uv = 0.5 + centered * (1.0 + _FisheyeBend * len * len);

//                // Chromatic bleed
//    float2 rUV = uv + float2(_BleedAmount, 0);
//    float2 gUV = uv;
//    float2 bUV = uv - float2(_BleedAmount, 0);

//    fixed r = tex2D(_MainTex, rUV).r;
//    fixed g = tex2D(_MainTex, gUV).g;
//    fixed b = tex2D(_MainTex, bUV).b;
//    fixed4 col = fixed4(r, g, b, 1.0);

//                // Noise (low-res)
//    float2 noiseUV = uv * 0.25; // 1/4 resolution
//    float n = tex2D(_NoiseTex, noiseUV + _Time.y * _TimeSpeed).r;
//    col.rgb += (n - 0.5) * _NoiseAmount;

//    return col;
//}
//            ENDCG
//        }
//    }

//FallBack"Diffuse"
//}



Shader"Custom/VHS_Mobile_BlackFisheye"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _NoiseTex("Noise Texture", 2D) = "white" {} // low-res noise
        _BleedAmount("Bleed Amount", Float) = 0.005
        _NoiseAmount("Noise Amount", Float) = 0.05
        _FisheyeBend("Fisheye Bend", Float) = 0.2
        _TimeSpeed("Time Speed", Float) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
ZTest Always

Cull Off

ZWrite Off

            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
#include "UnityCG.cginc"

sampler2D _MainTex;
sampler2D _NoiseTex;
float _BleedAmount;
float _NoiseAmount;
float _FisheyeBend;
float _TimeSpeed;

float rand(float2 co)
{
    return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
}

fixed4 frag(v2f_img i) : SV_Target
{
    float2 uv = i.uv;

                // Fisheye effect with black borders
    float2 centered = uv - 0.5;
    float len = length(centered);
    uv = 0.5 + centered * (1.0 + _FisheyeBend * len * len);

                // If uv goes outside the [0,1] range, make it black
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0)
    {
        return fixed4(0, 0, 0, 1); // black outside
    }

                // Chromatic bleed
    float2 rUV = uv + float2(_BleedAmount, 0);
    float2 gUV = uv;
    float2 bUV = uv - float2(_BleedAmount, 0);

    fixed r = tex2D(_MainTex, rUV).r;
    fixed g = tex2D(_MainTex, gUV).g;
    fixed b = tex2D(_MainTex, bUV).b;
    fixed4 col = fixed4(r, g, b, 1.0);

                // Noise (low-res)
    float2 noiseUV = uv * 0.25; // 1/4 resolution
    float n = tex2D(_NoiseTex, noiseUV + _Time.y * _TimeSpeed).r;
    col.rgb += (n - 0.5) * _NoiseAmount;

    return col;
}
            ENDCG
        }
    }

FallBack"Diffuse"
}

