Shader "Custom/DiffuseWarping"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpTex("normal map",2D) = "white"{}
        _RampTex ( "", 2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf warp fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;
        sampler2D _BumpTex;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpTex;
        };



        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpTex,IN.uv_BumpTex));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 Lightingwarp(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            //half Lambert로 diffuse 계산
            float ndotl = dot(s.Normal,lightDir)*0.5 + 0.5;
        
            // blinn phong으로 specular 계산
            float3 halfVector = normalize((viewDir + lightDir)) ;
            float spec = pow(saturate(dot(halfVector, s.Normal)),1);

            //RampTex에서 (ndotl, spec) 위치의 색을 가져온다.
            //RampTex 텍스쳐의 wrapp 모드는 Repeat가 아닌 Clamp로 설정해야한다.
            float4 ramp = tex2D(_RampTex,float2(ndotl,spec));
           
            return ramp;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
