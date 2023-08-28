Shader "Custom/BasicLambert"
{
    Properties
    {

        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("", 2D) = "white"{}
 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf BlinnPhong 

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 viewDir;
        };



        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) ;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Alpha = c.a;
        }

        float4 LightingBlinnPhong(SurfaceOutput s, float3 lightDir, float atten)
        {
            float ndotl = saturate(dot(s.Normal, lightDir));
            float4 final;
            final.rgb = s.Albedo * ndotl * atten * _LightColor0.rgb;
            final.a = s.Alpha;
            return final;
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
