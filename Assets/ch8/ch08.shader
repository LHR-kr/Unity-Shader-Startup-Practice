Shader "Custom/ch08"
{
    Properties
    {
        _Metalic ("metalic",Range(0,1)) = 0
        _Smoothness("smoothness",Range(0,1)) = 0
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NormalTex ("normal Map",2D) = "white" {}

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

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        float _Metalic;
        float _Smoothness;
        sampler2D _NormalTex;


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) ;
            o.Albedo = c.rgb;
            o.Metallic = 0;
            o.Smoothness = 0;

            float3 n = UnpackNormal(tex2D(_NormalTex, IN.uv_BumpMap));

            o.Normal = float3 (n.x, n.y, n.z);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
