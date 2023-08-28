Shader "Custom/RimLight"
{
    Properties
    {
        _RimColor  ("",Color) = (1,1,1,1)
        _RimIntensity  ("",Range(0,10)) = 0
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("",2D) = "white"{}

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

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float2 uv_BumpMap;
        };

        float4 _RimColor;
        float _RimIntensity;
        sampler2D _BumpMap;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

            float rim = saturate(dot(o.Normal, IN.viewDir));
            o.Emission = pow(1-rim,_RimIntensity) * _RimColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
