Shader "Custom/NewSurfaceShader"
{
    Properties
    {

        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Bump ("",2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _Bump;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Bump;
        };






        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

            o.Normal = UnpackNormal(tex2D(_Bump,IN.uv_Bump));
            o.Albedo = c.rgb;

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
