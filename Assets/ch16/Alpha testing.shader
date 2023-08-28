Shader "Custom/Alpha testing"
{
    //알파 테스팅이 알파 블렌딩보다 pc에선 더 빠르다.
    //반투명은 없다.
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _CutOff("" ,Range(0,1)) = 0.5

    }
    SubShader
    {
    //queue를 AlphaTest로 지정
        Tags { "RenderType"="TransparentCutout" "Queue" = "AlphaTest"}
        LOD 200

        CGPROGRAM
        //프로퍼티로 선언한 _CutOff 인자를 사용한다.
        #pragma surface surf Lambert alphatest:_CutOff

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };


        fixed4 _Color;


        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Lagacy Shaders/Transparent/Cutout/VertexLit"
}
