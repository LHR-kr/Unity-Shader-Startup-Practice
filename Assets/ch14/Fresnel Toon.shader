Shader "Custom/Presnel Toon"
{
    Properties
    {

        _MainTex ("Albedo (RGB)", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Toon 
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

        float4 LightingToon(SurfaceOutput s, float3 lightDir,  float3 viewDir,float atten)
        {
            //temp Lambert
            int step = 5;
            int specPow = 20;
            float ndotl = saturate(dot(lightDir,s.Normal));
            


            //fresnel
            // N벡터가 V 벡터와 직각인 곳만 필요해서 saturate가 아니라 abs
            float rim = abs(dot(s.Normal,viewDir));

            //Ami
            if(rim > 0.3)
            {
                rim = 0;
            }
            else{
                rim = -1;
            }

            return float4(ndotl *atten*_LightColor0.rgb + rim,1) ;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
