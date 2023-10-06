Shader "Unlit/Vertex Offset"
{
    Properties
    {
        // _MainTex ("Texture", 2D) = "white" {}
        _ColorA ("ColorA", Color) = (1,1,1,1)
        _ColorB ("ColorB", Color) = (1,1,1,1)
        _ColorStart ("ColorStart", Range(0,1)) = 1
        _ColorEnd("ColorEnd", Range(0,1)) = 0

        _WaveAmp ("Wave Amplitude", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque" // Tag to inform the render pipeline of what type it is.. useful for postprocessing
            "Queue"="Geometry" // This is necessary for making something transparent, (Render queue)

        }



        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            // #pragma multi_compile_fog

            #include "UnityCG.cginc"

            #define TAU 6.28318530718

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
            float _WaveAmp;

            v2f vert (appdata v)
            {
                v2f o;



                float wave = cos((v.uv0.y - _Time.y *0.1 )* TAU * 5);
                v.vertex.y = wave * _WaveAmp;
                o.vertex = UnityObjectToClipPos(v.vertex); // Local Space to Clip space
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;
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


                // float xOffset = cos(i.uv.x * TAU * 8 ) * 0.01;
                float t = cos((i.uv.y - _Time.y *0.1 )* TAU * 5)*0.5 + 0.5;

                
                // float4 outColor = lerp( _ColorA, _ColorB, t );
                t *= 1-i.uv.y - 0.05;
                return t;
                float topBottomRemover = (abs(i.normal.y) < 0.999);

                float waves = t * topBottomRemover;
                float4 gradient = lerp( _ColorA, _ColorB, i.uv.y);

                return gradient * waves;


                // return t * ; // abs > .9999 removes top part of mesh and bottom part;
            }
            ENDCG
        }
    }
}
