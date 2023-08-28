Shader "Custom/FakeSpecular"
{
    Properties
    {

        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("", 2D) = "white"{}

        _specCol ("", Color) = (1,1,1,1)
        _specPow("",Range(10,200)) = 100
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf BP 

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _specCol;
        float _specPow;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };



        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) ;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Alpha = c.a;
        }

        //함수 인자들의 순서를 바꾸면 안 된다.
        float4 LightingBP(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float4 final;
            //diffuse light
            float ndotl = saturate(dot(s.Normal, lightDir));
            //_LightColor0은 내장 변수
            float3 diffColor = s.Albedo * ndotl * atten * _LightColor0.rgb;

            //Blinn Phong light
            float3 halfVector = normalize(lightDir + viewDir);
            float spec = saturate(dot(halfVector, s.Normal));
            spec = pow(spec,_specPow);
            float3 specCol = spec * _specCol;

            //rim term
            float rim =saturate(dot(viewDir, s.Normal));
            float invRim = 1-rim;
            float3 rimCol = pow(invRim,15) * (0.9,0.9,0.9);

            //fake specular
            float3 fakeSpecCol = pow(rim,15) * float3(0,1,0);

            //final term
            // Lambert와 다르게 더해진다.
            final.rgb =diffColor + specCol + rimCol + fakeSpecCol;
            final.a = s.Alpha;
            return final;
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
