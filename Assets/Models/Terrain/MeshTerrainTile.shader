Shader "Custom/MeshTerrainTile"
{
	Properties
	{
		_Mask0("Mask 0", 2D) = "white" {}
		_Mask1("Mask 1", 2D) = "white" {}

		_Layer0("Layer 0", 2D) = "white" {}
		_Layer1("Layer 1", 2D) = "white" {}
		_Layer2("Layer 2", 2D) = "white" {}
		_Layer3("Layer 3", 2D) = "white" {}
		_Layer4("Layer 4", 2D) = "white" {}
		_Layer5("Layer 5", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				UNITY_FOG_COORDS(2)
				float4 vertex : SV_POSITION;
			};

			sampler2D _Mask0;
			sampler2D _Mask1;

			sampler2D _Layer0;
			sampler2D _Layer1;
			sampler2D _Layer2;
			sampler2D _Layer3;
			sampler2D _Layer4;
			sampler2D _Layer5;

			float4 _Mask0_ST;
			float4 _Layer0_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv0 = TRANSFORM_TEX(v.uv, _Mask0);
				o.uv1 = TRANSFORM_TEX(v.uv, _Layer0);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				half4 mask0 = tex2D(_Mask0, i.uv0);
				half4 mask1 = tex2D(_Mask1, i.uv0);
			
				half4 layer0 = tex2D(_Layer0, i.uv1);
				half4 layer1 = tex2D(_Layer1, i.uv1);
				half4 layer2 = tex2D(_Layer2, i.uv1);
				half4 layer3 = tex2D(_Layer3, i.uv1);
				half4 layer4 = tex2D(_Layer4, i.uv1);
				half4 layer5 = tex2D(_Layer5, i.uv1);

				half3 col =

					((layer0.rgb * mask1.r) +
					(layer1.rgb * mask1.g) +
					(layer2.rgb * mask1.b)) +

					((layer3.rgb * mask0.r) +
					(layer4.rgb * mask0.g) +
					(layer5.rgb * mask0.b));
				
				half4 result = half4(col.rgb, 1.);
				UNITY_APPLY_FOG(i.fogCoord, result);
				return result;
			}
			ENDCG
		}
	}
}
