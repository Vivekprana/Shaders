Shader "Unlit/VertexExperiment"
{
    Properties
    {
        // _MainTex ("Texture", 2D) = "white" {}
        _ColorA ("ColorA", Color) = (1,1,1,1)
        _ColorB ("ColorB", Color) = (1,1,1,1)
        _ColorStart ("ColorStart", Range(0,1)) = 1
        _ColorEnd("ColorEnd", Range(0,1)) = 0

        _Scale ("UV Scale", Float) = 1
        _Offset ("UV Offset", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            // #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv0 : TEXCOORD0;
                float3 normals: NORMAL;
            };

            struct v2f
            {
                // float2 uv : TEXCOORD0;
                // UNITY_FOG_COORDS(1)
                float3 normal : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 uv: TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float fakeBool = 0;
            float4 _ColorA;
            float4 _ColorB;
            // float _Scale;
            float _Offset;

            float _ColorStart;
            float _ColorEnd;

            v2f vert (appdata v)
            {
                v2f o;
                // if(fakeBool > 0.5) {
                //     // v.vertex.x += sin(_Time.y * 100);
                //     // fakeBool = 0;
                // }
                // else {
                //     fakeBool = 1;
                // }
                // printf("fakebool", fakeBool);
                // if(fakeBool < 1)
                // {
                //     v.vertex.x += sin(_Time.y);
                //     fakeBool += 1;
                // }
                o.vertex = UnityObjectToClipPos(v.vertex); // Local Space to Clip space
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0 ;
                // + _Offset * sin(_Time.y);
                // o.uv = (v.uv0 + _Offset) * _Scale;
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                // UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float inverseLerp(float a, float b, float v) {
                return (v-a)/(b-a);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Blend between two color s

                float t = saturate (inverseLerp(_ColorStart, _ColorEnd, i.uv.x));
                float4 outColor = lerp( _ColorA, _ColorB, t );


                return outColor;
                // return outColor;
                // return float4(i.uv, 0, 1);
            }
            ENDCG
        }
    }
}
