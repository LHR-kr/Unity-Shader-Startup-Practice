Shader "Custom/Alpha blending"
{
    Properties
    {

        _MainTex ("Albedo (RGB)", 2D) = "white" {}

    }
    SubShader
    {
        //"Queue" = "Transparent" : 불투명한 물체 다음에 그리라는 의미
        Tags { "RenderType"="Transparent"  "Queue" = "Transparent"}
        // 양면 모두 렌더링
        cull off
        LOD 200

        CGPROGRAM
        // alpha:fade로 투명하 부분은 안 그림
        #pragma surface surf Lambert alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0 

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };



        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;

            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
