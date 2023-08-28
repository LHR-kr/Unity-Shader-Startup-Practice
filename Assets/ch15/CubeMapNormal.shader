Shader "Custom/CubeMapNormal"
{
    Properties
    {
        //큐브맵에 사용 될 텍스쳐
        _Cube("cube map",Cube) = ""{}
        _BumpMap("normal",2D) ="white" {}
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
        sampler2D _BumpMap;
        samplerCUBE _Cube;
        
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            //기본적으로 정의되어 있는 3차원 반사벡터
            //worldRefl은 버텍스 노말이다.
            //INTERNAL_DATA 키워드를 사용해주어 버텍스 노말을 픽셀 노말로 변환해준다.
            float3 worldRefl;
            INTERNAL_DATA
        };




        void surf (Input IN, inout SurfaceOutput o)
        {
            // UnpackNormal 은 탄젠트 노말(픽셀이 중심인 좌표계)이며, 픽셀 노말이다.
            // worldRefl 과 UnpackNormal을 함께 사용할 경우, 버텍스 노말과 픽셀 노말을 함께 충돌이 일어난다.
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            //WorldReflectionVector 함수를 이용하여 픽셀 월드 노말을 계산한다.
            // 버텍스 노말 vs 픽셀 노말, 탄젠트 좌표계 vs 월드 좌표계의 충돌을 모두 해결한다.
            float4 re = texCUBE(_Cube,WorldReflectionVector(IN,o.Normal));
            o.Albedo = 0;
            //반사는 주변 물체를 반사하기만 하고, 밝기와는 상관이 없기 때문에 emission으로 지정한다.
            o.Emission = re.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
