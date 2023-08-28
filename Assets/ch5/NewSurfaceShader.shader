Shader "Custom/tex"
{
    Properties
    {
        _MainTex ("main texture",2D) = "white"{} 
        _MainTex2("main texture 2", 2D) = "white"{}
        _Mix("how much mix",Range(0,1)) = 0
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
        fixed _Mix;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;
        };


       

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 d  = tex2D(_MainTex2,IN.uv_MainTex2);
            o.Albedo = lerp(c.rgb,d.rgb,1-c.a-0.4);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
