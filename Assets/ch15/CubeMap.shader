Shader "Custom/CubeMap"
{
    Properties
    {
        //큐브맵에 사용 될 텍스쳐
        _Cube("cube map",Cube) = ""{}
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
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
        samplerCUBE _Cube;
        
        struct Input
        {
            float2 uv_MainTex;
            //기본적으로 정의되어 있는 3차원 반사벡터
            float3 worldRefl;
            INTERNAL_DATA
        };




        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            float4 re = texCUBE(_Cube,IN.worldRefl);
            o.Albedo = 0;
            //반사는 주변 물체를 반사하기만 하고, 밝기와는 상관이 없기 때문에 emission으로 지정한다.
            o.Emission = re.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
