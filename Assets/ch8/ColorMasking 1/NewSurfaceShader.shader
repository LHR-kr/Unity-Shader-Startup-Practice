Shader "Custom/VertextColorMaskShader"
{
    Properties
    {

        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("",2D) = "white"{}
         _MainTex3 ("",2D) = "white"{}
          _MainTex4 ("",2D) = "white"{}
          _BumpMap ("",2D) = "bump"{}

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
        sampler2D _MainTex2;
        sampler2D _MainTex3;
        sampler2D _MainTex4;
        sampler2D _BumpMap;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;
            float2 uv_MainTex3;
            float2 uv_MainTex4;
            float2 uv_BumpMap;
            float4 color : COLOR;
        };


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //각 연산들이 버텍스마다 실행된다고 생각해보자.
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D (_MainTex2, IN.uv_MainTex2);
            fixed4 e = tex2D (_MainTex3, IN.uv_MainTex3);
            fixed4 f = tex2D (_MainTex4, IN.uv_MainTex4);
            o.Albedo = lerp(c.rgb, d.rgb, IN.color.r);
            o.Albedo = lerp(o.Albedo.rgb, e.rgb, IN.color.g);
            o.Albedo = lerp(o.Albedo.rgb, f.rgb, IN.color.b);
            // Metallic and smoothness come from slider variables

            o.Normal = UnpackNormal(tex2D(_BumpMap,IN.uv_BumpMap));
            o.Metallic = 0.0f;
            o.Smoothness = IN.color.b;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
