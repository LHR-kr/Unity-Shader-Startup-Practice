Shader "Custom/CybeMapMask"
{
    Properties
    {
        _CubeMap ("cube map",Cube) = ""{}
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("normal bump",2D) = "white"{}
        _MaskMap("mask", 2D) = "white"{}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _MaskMap;
        samplerCUBE _CubeMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_MaskMap;
            float3 worldRefl;
            INTERNAL_DATA
        };





        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            float4 c = tex2D(_MainTex,IN.uv_MainTex); 
            float4 mask = tex2D(_MaskMap,IN.uv_MaskMap);
            float4 re = texCUBE(_CubeMap,WorldReflectionVector(IN, o.Normal));
            
            o.Albedo = c.rgb * (1-mask.r);
            o.Emission = re.rgb * mask.r;
            //o.Emission = lerp(o.Albedo, re.rgb , mask.r * 0.3);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
