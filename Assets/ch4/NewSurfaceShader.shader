Shader "Custom/NewSurfaceShader"
{
    Properties
    {
        _Brightness("Brightness", Range(-1,1)) = 0
        _TestColor("TestColor",Color) = (1,1,1,1)
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        _Red ("Red",Range(0,1)) = 0
        _Green("Green",Range(0,1)) = 0
        _Blue("Blue",Range(0,1)) = 0
  
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
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float4 _TestColor;
        float _Red;
        float _Green;
        float _Blue;

        float _Brightness;


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = float3(_Red,_Green,_Blue) + _Brightness;
            // Metallic and smoothness come from slider variables

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
