// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Skybox/Toon Skybox"
{
    Properties
    {
        _Color1 ("Color 1", Color) = (1, 1, 1, 0)
        _Color2 ("Color 2", Color) = (1, 1, 1, 0)
        _Intensity ("Intensity", Float) = 1.0
        _Exponent ("Exponent", Float) = 1.0

        _Horizon ("Horizon", Range(0, 1)) = 1.0
        _HorizonSize ("Horizon Edge", Range (0, 1)) = 0

    }

    CGINCLUDE

    #include "UnityCG.cginc"
    #define white float4(1, 1, 1, 1)
    #define up float4(0, 1, 0, 0)

    struct appdata
    {
        float4 position : POSITION;
        float3 texcoord : TEXCOORD0;
    };
    
    struct v2f
    {
        float4 position : SV_POSITION;
        float3 texcoord : TEXCOORD0;
    };
    
    half4 _Color1;
    half4 _Color2;

    half _Intensity;
    half _Exponent;
    half _Horizon;
    half _HorizonSize;
	float4 _Gradient_ST;
    
    v2f vert (appdata v)
    {
        v2f o;
        o.position = UnityObjectToClipPos (v.position);
        o.texcoord = v.texcoord;
        return o;
    }
    
    fixed4 frag (v2f i) : COLOR
    {
        half d = dot (normalize (i.texcoord), up) * 0.5f + 0.5f;
        half lerpIndex = pow(d, _Exponent);

        if (lerpIndex > _Horizon)
        {
            return lerp (_Color1, _Color2, lerpIndex) * _Intensity;
        }
        else
        {
            lerpIndex -= _HorizonSize;
            return lerp (_Color1, _Color2, lerpIndex) * _Intensity;
        }
    }

    ENDCG

    SubShader
    {
        Tags { "RenderType"="Background" "Queue"="Background" }
        Pass
        {
            ZWrite Off
            Cull Off
            Fog { Mode Off }
            CGPROGRAM
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}