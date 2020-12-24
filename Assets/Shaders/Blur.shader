/*
カメラに対してのぼかし半径なので、2D向け
*/

Shader "Custom/Blur"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Blur("Blur Radius", Range(1,100)) = 10
        _Coefficient("Const Gaussian Coefficient", float) = 5
    }
    SubShader
    {

        Tags{ 
        "RenderType" = "Transparent"
        "Queue" = "Transparent"
        }

        GrabPass
        {   
        }

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
                fixed4 color : COLOR;
            };

            struct v2f
            {
                float4 grabPos : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 vertColor : COLOR;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.grabPos = ComputeGrabScreenPos(o.pos);
                o.vertColor = v.color;
                return o;
            }

            sampler2D _GrabTexture;
            fixed4  _GrabTexture_TexelSize;
            
            float _Blur;
            float _Coefficient;
            float gaussian(float pos, float blur_radius){
                return exp(-0.5 * pow(abs(pos / blur_radius), 2) * _Coefficient);
            }

            half4 frag(v2f i) : SV_Target
            {
                float blur = _Blur;
                fixed4 col = (0.0, 0.0, 0.0, 0.0);
                float weight_total = 0;

                for (float x = -blur; x <= blur; x += 1)
                {
                    float weight = gaussian(x, blur);
                    weight_total += weight;
                    col += tex2Dproj(_GrabTexture, i.grabPos + float4(x * _GrabTexture_TexelSize.x, 0, 0, 0)) * weight;
                }
                col /= weight_total;
                return col;
            }
            ENDCG
        }
        GrabPass
        {   
        }
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
                fixed4 color : COLOR;
            };

            struct v2f
            {
                float4 grabPos : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 vertColor : COLOR;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.grabPos = ComputeGrabScreenPos(o.pos);
                o.vertColor = v.color;
                return o;
            }

            sampler2D _GrabTexture;
            fixed4  _GrabTexture_TexelSize;
            
            float _Blur;
            float _Coefficient;
            float gaussian(float pos, float blur_radius){
                return exp(-0.5 * pow(abs(pos / blur_radius), 2) * _Coefficient);
            }

            half4 frag(v2f i) : SV_Target
            {
                float blur = _Blur;
                fixed4 col = (0.0, 0.0, 0.0, 0.0);
                float weight_total = 0;

                for (float y = -blur; y <= blur; y += 1)
                {
                    float weight = gaussian(y, blur);
                    weight_total += weight;
                    col += tex2Dproj(_GrabTexture, i.grabPos + float4(y * _GrabTexture_TexelSize.y, 0, 0, 0)) * weight;
                }
                col /= weight_total;
                return col;
            }
            ENDCG
        }
    }
}