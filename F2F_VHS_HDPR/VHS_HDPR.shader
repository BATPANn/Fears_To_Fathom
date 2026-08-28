Shader "Custom/VHS_HDRP"
{
    Properties
    {
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _OverlayTex ("Overlay Texture (RGBA)", 2D) = "white" {}
        _BleedAmount ("Chromatic Bleed", Float) = 0.005
        _NoiseAmount ("Noise Strength", Float) = 0.05
        _FisheyeBend ("Fisheye Strength", Float) = 0.2
        _TimeSpeed ("Noise Scroll Speed", Float) = 1.0
        _Strength ("Effect Strength", Range(0, 1)) = 1
        _OverlayStrength ("Overlay Strength", Range(0, 1)) = 0
        [Toggle] _OverlayScreen ("Overlay Screen Blend", Float) = 0
        [Toggle] _BlackBorders ("Black Outside Fisheye", Float) = 1
    }

    SubShader
    {
        Tags { "RenderPipeline" = "HDRenderPipeline" }

        Pass
        {
            Name "VHS"
            ZTest Always
            ZWrite Off
            Cull Off

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma target 4.5

            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/RenderPass/CustomPass/CustomPassCommon.hlsl"

            TEXTURE2D(_NoiseTex);
            SAMPLER(sampler_NoiseTex);
            TEXTURE2D(_OverlayTex);
            SAMPLER(sampler_OverlayTex);

            float _BleedAmount;
            float _NoiseAmount;
            float _FisheyeBend;
            float _TimeSpeed;
            float _Strength;
            float _OverlayStrength;
            float _OverlayScreen;
            float _BlackBorders;
            float _CustomTime;

            float4 Frag(Varyings input) : SV_Target
            {
                float2 uv = input.positionCS.xy * _ScreenSize.zw;

                float3 original = CustomPassSampleCameraColor(uv, 0);

                float2 centered = uv - 0.5;
                float len = length(centered);
                float2 fuv = 0.5 + centered * (1.0 + _FisheyeBend * len * len);

                bool outside = false;
                if (_BlackBorders > 0.5)
                {
                    if (fuv.x < 0.0 || fuv.x > 1.0 || fuv.y < 0.0 || fuv.y > 1.0)
                    {
                        outside = true;
                    }
                }
                else
                {
                    fuv = clamp(fuv, 0.0, 1.0);
                }

                float3 col = float3(0.0, 0.0, 0.0);
                if (!outside)
                {
                    float r = CustomPassSampleCameraColor(fuv + float2(_BleedAmount, 0.0), 0).r;
                    float g = CustomPassSampleCameraColor(fuv, 0).g;
                    float b = CustomPassSampleCameraColor(fuv - float2(_BleedAmount, 0.0), 0).b;
                    col = float3(r, g, b);

                    float2 noiseUV = fuv * 0.25;
                    float scroll = _CustomTime * _TimeSpeed;
                    float noise = SAMPLE_TEXTURE2D(_NoiseTex, sampler_NoiseTex, noiseUV + scroll).r;
                    col += (noise - 0.5) * _NoiseAmount;
                }

                float4 overlay = SAMPLE_TEXTURE2D(_OverlayTex, sampler_OverlayTex, uv);
                if (_OverlayScreen > 0.5)
                {
                    float3 screened = 1.0 - (1.0 - col) * (1.0 - overlay.rgb);
                    col = lerp(col, screened, _OverlayStrength);
                }
                else
                {
                    col = lerp(col, overlay.rgb, overlay.a * _OverlayStrength);
                }

                col = lerp(original, col, _Strength);

                return float4(col, 1.0);
            }
            ENDHLSL
        }
    }

    FallBack Off
}
