Shader "Custom/MeshTerrainMap"
{
	Properties
	{
		_Mask0("Mask 0", 2D) = "white" {}
		_Mask1("Mask 1", 2D) = "white" {}

		_Tiling("Tiling", Float) = 0.0
		_Layers("Layer 0", 2D) = "white" {}
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

			struct vertData
			{
				float4 vert : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct fragData
			{
				float2 uv0 : TEXCOORD0;
				float4 vert : SV_POSITION;
			};

			sampler2D _Mask0;
			sampler2D _Mask1;
			sampler2D _Layers;
			half _Tiling;

			fragData vert(vertData i)
			{
				fragData o;
				o.vert = UnityObjectToClipPos(i.vert);
				o.uv0 = i.uv;
				return o;
			}

			fixed4 frag(fragData i) : SV_Target
			{
				half4 mask0 = tex2D(_Mask0, i.uv0);
				half4 mask1 = tex2D(_Mask1, i.uv0);
			
				half4 layer0 = tex2D(_Layers, half2(
					frac(i.uv0.x * _Tiling) * .25 + (.25 * 0.),
					frac(i.uv0.y * _Tiling) * .25 + (.25 * 3.)));

				half4 layer1 = tex2D(_Layers, half2(
					frac(i.uv0.x * _Tiling) * .25 + (.25 * 1.),
					frac(i.uv0.y * _Tiling) * .25 + (.25 * 3.)));

				half4 layer2 = tex2D(_Layers, half2(
					frac(i.uv0.x * _Tiling) * .25 + (.25 * 2.),
					frac(i.uv0.y * _Tiling) * .25 + (.25 * 3.)));

				half4 layer3 = tex2D(_Layers, half2(
					frac(i.uv0.x * _Tiling) * .25 + (.25 * 3.),
					frac(i.uv0.y * _Tiling) * .25 + (.25 * 3.)));

				half4 layer4 = tex2D(_Layers, half2(
					frac(i.uv0.x * _Tiling) * .25 + (.25 * 0.),
					frac(i.uv0.y * _Tiling) * .25 + (.25 * 2.)));

				half4 layer5 = tex2D(_Layers, half2(
					frac(i.uv0.x * _Tiling) * .25 + (.25 * 1.),
					frac(i.uv0.y * _Tiling) * .25 + (.25 * 2.)));

				half3 col =
				//Mask0
					(layer0.rgb * mask1.r) +
					(layer1.rgb * mask1.g) +
					(layer2.rgb * mask1.b) +
				//Mask1
					(layer3.rgb * mask0.r) +
					(layer4.rgb * mask0.g) +
					(layer5.rgb * mask0.b);
				
				return half4(col.rgb, 1.);
			}
			ENDCG
		}
	}
}