    Shader "Custom/Kira"
    {
        Properties
        {
            _StarColor ("Star Color", Color) = (1.0, 0.918, 0.62,1)
            _BaseColor ("Base Color", Color) = (0.067,0.318,0.365,1)
            _Repeat ("Repeat Count", int) = 4

        }
        SubShader
        {
            Tags
            {
                "RenderType" = "Transparent"
                "Queue" = "Transparent"
            }
            Blend SrcAlpha OneMinusSrcAlpha


            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv : TEXCOORD0;
                };

                struct v2f
                {
                    float4 vertex : SV_POSITION;
                    float2 uv : TEXCOORD0;
                };

                float rand(float2 uv)
                {
                    return frac(sin(dot(uv.xy, float2(12.9898, 78.233))) * 43758.5453);
                }

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = v.uv;
                    return o;
                }

                float4 _StarColor;
                float4 _BaseColor;
                float _Repeat;
                fixed4 frag(v2f i) : SV_Target
                {
                    float2 uv = i.uv*_Repeat;
                    float x = frac(uv.x) - 0.5;
                    float y = frac(uv.y) - 0.5;
                    float noised = rand(floor(i.uv / (1.0 / _Repeat)) * (1.0 / _Repeat));
                    float index = frac((_Time.y+noised)*(-1))*0.75;
                    if (pow(abs(x), index) + pow(abs(y), index) < 0.5){
                        return _StarColor.rgba;
                    }else{
                        return _BaseColor.rgba;
                    }

                }

                ENDCG
            }
        }
    }
