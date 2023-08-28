Shader "Custom/2Pass"
{
    Properties
    {

        _MainTex ("Albedo (RGB)", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        //normal 뒤집기
        cull front
        // 1 Pass
        CGPROGRAM
        
        //vertex 키워드로 vect함수를 vertex shader로 사용하겠다는 것을 명시
        //vertex:vet 에서 띄어쓰기 하면 적용이 안되므로 주의
        //외곽선은 빛 계산할 필요 없으니 Lambert와 빛을 다 지워준다.
        //라이팅 함수를 먼저 적고, 버텍스 쉐이더를 적어야 한다;
        #pragma surface surf Lambert vertex:vert  noambient
        #pragma target 3.0

        sampler2D _MainTex;

        //미리 선언된 구조체 appdata_full을 사용한다.
        //inout 키워드를 통해 쉐이더끼리 데이터를 주고 받는 다는 것을 명시
        void vert(inout appdata_full v)
        {
            //local 좌표의  y좌표를 1씩 위로
            v.vertex.xyz = v.vertex.xyz+ v.normal.xyz*0.003;
        }
        struct Input
        {
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            
        }

        float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0,0,0,1);
        }
        ENDCG


        cull back

        // 2 Pass
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
            //half Lambert
            int step = 5;
            int specPow = 20;
            float ndotl = dot(lightDir,s.Normal) * 0.5 + 0.5;
            if(ndotl > 0.6)
            {
                ndotl = 0.5;
            }
            else{
                ndotl = 0;
            }


            //specular
            float3 halfvec = normalize(lightDir+viewDir);
            float spec = saturate(dot(halfvec, s.Normal));
            spec = pow(spec,specPow);

            if(spec > 0.4)
            {
                spec = 1;
            }
            else{
                spec = 0;
            }

            return ndotl * float4(s.Albedo,0) + spec;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
