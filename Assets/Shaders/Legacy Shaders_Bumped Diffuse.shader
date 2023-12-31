// Upgrade NOTE: commented out 'float4 unity_DynamicLightmapST', a built-in variable
// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable

Shader "Legacy Shaders/Bumped Diffuse"
{
  Properties
  {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB)", 2D) = "white" {}
    _BumpMap ("Normalmap", 2D) = "bump" {}
  }
  SubShader
  {
    Tags
    { 
      "RenderType" = "Opaque"
    }
    LOD 300
    Pass // ind: 1, name: FORWARD
    {
      Name "FORWARD"
      Tags
      { 
        "LIGHTMODE" = "FORWARDBASE"
        "RenderType" = "Opaque"
        "SHADOWSUPPORT" = "true"
      }
      LOD 300
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile DIRECTIONAL
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4 unity_WorldTransformParams;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _MainTex_ST;
      uniform float4 _BumpMap_ST;
      //uniform float4 _WorldSpaceLightPos0;
      uniform float4 _LightColor0;
      uniform sampler2D _MainTex;
      uniform sampler2D _BumpMap;
      uniform float4 _Color;
      struct appdata_t
      {
          float4 tangent :TANGENT;
          float4 vertex :POSITION;
          float3 normal :NORMAL;
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float4 xlv_TEXCOORD0 :TEXCOORD0;
          float4 xlv_TEXCOORD1 :TEXCOORD1;
          float4 xlv_TEXCOORD2 :TEXCOORD2;
          float4 xlv_TEXCOORD3 :TEXCOORD3;
          float4 xlv_TEXCOORD6 :TEXCOORD6;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 xlv_TEXCOORD0 :TEXCOORD0;
          float4 xlv_TEXCOORD1 :TEXCOORD1;
          float4 xlv_TEXCOORD2 :TEXCOORD2;
          float4 xlv_TEXCOORD3 :TEXCOORD3;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          float3 worldBinormal_1;
          float tangentSign_2;
          float3 worldTangent_3;
          float4 tmpvar_4;
          float4 tmpvar_5;
          float4 tmpvar_6;
          tmpvar_6.w = 1;
          tmpvar_6.xyz = in_v.vertex.xyz;
          tmpvar_4.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          tmpvar_4.zw = TRANSFORM_TEX(in_v.texcoord.xy, _BumpMap);
          float3 tmpvar_7;
          tmpvar_7 = mul(unity_ObjectToWorld, in_v.vertex).xyz;
          float3x3 tmpvar_8;
          tmpvar_8[0] = conv_mxt4x4_0(unity_WorldToObject).xyz;
          tmpvar_8[1] = conv_mxt4x4_1(unity_WorldToObject).xyz;
          tmpvar_8[2] = conv_mxt4x4_2(unity_WorldToObject).xyz;
          float3 tmpvar_9;
          tmpvar_9 = normalize(mul(in_v.normal, tmpvar_8));
          float3x3 tmpvar_10;
          tmpvar_10[0] = conv_mxt4x4_0(unity_ObjectToWorld).xyz;
          tmpvar_10[1] = conv_mxt4x4_1(unity_ObjectToWorld).xyz;
          tmpvar_10[2] = conv_mxt4x4_2(unity_ObjectToWorld).xyz;
          float3 tmpvar_11;
          tmpvar_11 = normalize(mul(tmpvar_10, in_v.tangent.xyz));
          worldTangent_3 = tmpvar_11;
          float tmpvar_12;
          tmpvar_12 = (in_v.tangent.w * unity_WorldTransformParams.w);
          tangentSign_2 = tmpvar_12;
          float3 tmpvar_13;
          tmpvar_13 = (((tmpvar_9.yzx * worldTangent_3.zxy) - (tmpvar_9.zxy * worldTangent_3.yzx)) * tangentSign_2);
          worldBinormal_1 = tmpvar_13;
          float4 tmpvar_14;
          tmpvar_14.x = worldTangent_3.x;
          tmpvar_14.y = worldBinormal_1.x;
          tmpvar_14.z = tmpvar_9.x;
          tmpvar_14.w = tmpvar_7.x;
          float4 tmpvar_15;
          tmpvar_15.x = worldTangent_3.y;
          tmpvar_15.y = worldBinormal_1.y;
          tmpvar_15.z = tmpvar_9.y;
          tmpvar_15.w = tmpvar_7.y;
          float4 tmpvar_16;
          tmpvar_16.x = worldTangent_3.z;
          tmpvar_16.y = worldBinormal_1.z;
          tmpvar_16.z = tmpvar_9.z;
          tmpvar_16.w = tmpvar_7.z;
          out_v.vertex = mul(unity_MatrixVP, mul(unity_ObjectToWorld, tmpvar_6));
          out_v.xlv_TEXCOORD0 = tmpvar_4;
          out_v.xlv_TEXCOORD1 = tmpvar_14;
          out_v.xlv_TEXCOORD2 = tmpvar_15;
          out_v.xlv_TEXCOORD3 = tmpvar_16;
          out_v.xlv_TEXCOORD6 = tmpvar_5;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          float3 tmpvar_1;
          float3 tmpvar_2;
          float3 worldN_3;
          float4 c_4;
          float3 tmpvar_5;
          float3 lightDir_6;
          float3 _unity_tbn_2_7;
          float3 _unity_tbn_1_8;
          float3 _unity_tbn_0_9;
          float3 tmpvar_10;
          tmpvar_10 = in_f.xlv_TEXCOORD1.xyz;
          _unity_tbn_0_9 = tmpvar_10;
          float3 tmpvar_11;
          tmpvar_11 = in_f.xlv_TEXCOORD2.xyz;
          _unity_tbn_1_8 = tmpvar_11;
          float3 tmpvar_12;
          tmpvar_12 = in_f.xlv_TEXCOORD3.xyz;
          _unity_tbn_2_7 = tmpvar_12;
          float3 tmpvar_13;
          tmpvar_13 = _WorldSpaceLightPos0.xyz;
          lightDir_6 = tmpvar_13;
          float4 tmpvar_14;
          tmpvar_14 = (tex2D(_MainTex, in_f.xlv_TEXCOORD0.xy) * _Color);
          float3 tmpvar_15;
          tmpvar_15 = ((tex2D(_BumpMap, in_f.xlv_TEXCOORD0.zw).xyz * 2) - 1);
          float tmpvar_16;
          tmpvar_16 = dot(_unity_tbn_0_9, tmpvar_15);
          worldN_3.x = tmpvar_16;
          float tmpvar_17;
          tmpvar_17 = dot(_unity_tbn_1_8, tmpvar_15);
          worldN_3.y = tmpvar_17;
          float tmpvar_18;
          tmpvar_18 = dot(_unity_tbn_2_7, tmpvar_15);
          worldN_3.z = tmpvar_18;
          float3 tmpvar_19;
          tmpvar_19 = normalize(worldN_3);
          worldN_3 = tmpvar_19;
          tmpvar_5 = tmpvar_19;
          tmpvar_1 = _LightColor0.xyz;
          tmpvar_2 = lightDir_6;
          float4 c_20;
          float4 c_21;
          float diff_22;
          float tmpvar_23;
          tmpvar_23 = max(0, dot(tmpvar_5, tmpvar_2));
          diff_22 = tmpvar_23;
          c_21.xyz = ((tmpvar_14.xyz * tmpvar_1) * diff_22);
          c_21.w = tmpvar_14.w;
          c_20.w = c_21.w;
          c_20.xyz = c_21.xyz;
          c_4.xyz = c_20.xyz;
          c_4.w = 1;
          out_f.color = c_4;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 2, name: FORWARD
    {
      Name "FORWARD"
      Tags
      { 
        "LIGHTMODE" = "FORWARDADD"
        "RenderType" = "Opaque"
      }
      LOD 300
      ZWrite Off
      Blend One One
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile POINT
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4 unity_WorldTransformParams;
      //uniform float4x4 unity_MatrixVP;
      uniform float4x4 unity_WorldToLight;
      uniform float4 _MainTex_ST;
      uniform float4 _BumpMap_ST;
      //uniform float4 _WorldSpaceLightPos0;
      uniform float4 _LightColor0;
      uniform sampler2D _LightTexture0;
      uniform sampler2D _MainTex;
      uniform sampler2D _BumpMap;
      uniform float4 _Color;
      struct appdata_t
      {
          float4 tangent :TANGENT;
          float4 vertex :POSITION;
          float3 normal :NORMAL;
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float4 xlv_TEXCOORD0 :TEXCOORD0;
          float3 xlv_TEXCOORD1 :TEXCOORD1;
          float3 xlv_TEXCOORD2 :TEXCOORD2;
          float3 xlv_TEXCOORD3 :TEXCOORD3;
          float3 xlv_TEXCOORD4 :TEXCOORD4;
          float3 xlv_TEXCOORD5 :TEXCOORD5;
          float4 xlv_TEXCOORD6 :TEXCOORD6;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 xlv_TEXCOORD0 :TEXCOORD0;
          float3 xlv_TEXCOORD1 :TEXCOORD1;
          float3 xlv_TEXCOORD2 :TEXCOORD2;
          float3 xlv_TEXCOORD3 :TEXCOORD3;
          float3 xlv_TEXCOORD4 :TEXCOORD4;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          float3 worldBinormal_1;
          float tangentSign_2;
          float3 worldTangent_3;
          float4 tmpvar_4;
          float4 tmpvar_5;
          float4 tmpvar_6;
          tmpvar_6.w = 1;
          tmpvar_6.xyz = in_v.vertex.xyz;
          tmpvar_4.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          tmpvar_4.zw = TRANSFORM_TEX(in_v.texcoord.xy, _BumpMap);
          float3x3 tmpvar_7;
          tmpvar_7[0] = conv_mxt4x4_0(unity_WorldToObject).xyz;
          tmpvar_7[1] = conv_mxt4x4_1(unity_WorldToObject).xyz;
          tmpvar_7[2] = conv_mxt4x4_2(unity_WorldToObject).xyz;
          float3 tmpvar_8;
          tmpvar_8 = normalize(mul(in_v.normal, tmpvar_7));
          float3x3 tmpvar_9;
          tmpvar_9[0] = conv_mxt4x4_0(unity_ObjectToWorld).xyz;
          tmpvar_9[1] = conv_mxt4x4_1(unity_ObjectToWorld).xyz;
          tmpvar_9[2] = conv_mxt4x4_2(unity_ObjectToWorld).xyz;
          float3 tmpvar_10;
          tmpvar_10 = normalize(mul(tmpvar_9, in_v.tangent.xyz));
          worldTangent_3 = tmpvar_10;
          float tmpvar_11;
          tmpvar_11 = (in_v.tangent.w * unity_WorldTransformParams.w);
          tangentSign_2 = tmpvar_11;
          float3 tmpvar_12;
          tmpvar_12 = (((tmpvar_8.yzx * worldTangent_3.zxy) - (tmpvar_8.zxy * worldTangent_3.yzx)) * tangentSign_2);
          worldBinormal_1 = tmpvar_12;
          float3 tmpvar_13;
          tmpvar_13.x = worldTangent_3.x;
          tmpvar_13.y = worldBinormal_1.x;
          tmpvar_13.z = tmpvar_8.x;
          float3 tmpvar_14;
          tmpvar_14.x = worldTangent_3.y;
          tmpvar_14.y = worldBinormal_1.y;
          tmpvar_14.z = tmpvar_8.y;
          float3 tmpvar_15;
          tmpvar_15.x = worldTangent_3.z;
          tmpvar_15.y = worldBinormal_1.z;
          tmpvar_15.z = tmpvar_8.z;
          out_v.vertex = mul(unity_MatrixVP, mul(unity_ObjectToWorld, tmpvar_6));
          out_v.xlv_TEXCOORD0 = tmpvar_4;
          out_v.xlv_TEXCOORD1 = tmpvar_13;
          out_v.xlv_TEXCOORD2 = tmpvar_14;
          out_v.xlv_TEXCOORD3 = tmpvar_15;
          float4 tmpvar_16;
          tmpvar_16 = mul(unity_ObjectToWorld, in_v.vertex);
          out_v.xlv_TEXCOORD4 = tmpvar_16.xyz;
          out_v.xlv_TEXCOORD5 = mul(unity_WorldToLight, tmpvar_16).xyz;
          out_v.xlv_TEXCOORD6 = tmpvar_5;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          float3 tmpvar_1;
          float3 tmpvar_2;
          float3 worldN_3;
          float4 c_4;
          float atten_5;
          float3 lightCoord_6;
          float3 tmpvar_7;
          float3 lightDir_8;
          float3 _unity_tbn_2_9;
          float3 _unity_tbn_1_10;
          float3 _unity_tbn_0_11;
          _unity_tbn_0_11 = in_f.xlv_TEXCOORD1;
          _unity_tbn_1_10 = in_f.xlv_TEXCOORD2;
          _unity_tbn_2_9 = in_f.xlv_TEXCOORD3;
          float3 tmpvar_12;
          tmpvar_12 = normalize((_WorldSpaceLightPos0.xyz - in_f.xlv_TEXCOORD4));
          lightDir_8 = tmpvar_12;
          float4 tmpvar_13;
          tmpvar_13 = (tex2D(_MainTex, in_f.xlv_TEXCOORD0.xy) * _Color);
          float3 tmpvar_14;
          tmpvar_14 = ((tex2D(_BumpMap, in_f.xlv_TEXCOORD0.zw).xyz * 2) - 1);
          float4 tmpvar_15;
          tmpvar_15.w = 1;
          tmpvar_15.xyz = in_f.xlv_TEXCOORD4;
          lightCoord_6 = mul(unity_WorldToLight, tmpvar_15).xyz;
          float tmpvar_16;
          float _tmp_dvx_0 = dot(lightCoord_6, lightCoord_6);
          tmpvar_16 = tex2D(_LightTexture0, float2(_tmp_dvx_0, _tmp_dvx_0)).x;
          atten_5 = tmpvar_16;
          float tmpvar_17;
          tmpvar_17 = dot(_unity_tbn_0_11, tmpvar_14);
          worldN_3.x = tmpvar_17;
          float tmpvar_18;
          tmpvar_18 = dot(_unity_tbn_1_10, tmpvar_14);
          worldN_3.y = tmpvar_18;
          float tmpvar_19;
          tmpvar_19 = dot(_unity_tbn_2_9, tmpvar_14);
          worldN_3.z = tmpvar_19;
          float3 tmpvar_20;
          tmpvar_20 = normalize(worldN_3);
          worldN_3 = tmpvar_20;
          tmpvar_7 = tmpvar_20;
          tmpvar_1 = _LightColor0.xyz;
          tmpvar_2 = lightDir_8;
          tmpvar_1 = (tmpvar_1 * atten_5);
          float4 c_21;
          float4 c_22;
          float diff_23;
          float tmpvar_24;
          tmpvar_24 = max(0, dot(tmpvar_7, tmpvar_2));
          diff_23 = tmpvar_24;
          c_22.xyz = ((tmpvar_13.xyz * tmpvar_1) * diff_23);
          c_22.w = tmpvar_13.w;
          c_21.w = c_22.w;
          c_21.xyz = c_22.xyz;
          c_4.xyz = c_21.xyz;
          c_4.w = 1;
          out_f.color = c_4;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 3, name: PREPASS
    {
      Name "PREPASS"
      Tags
      { 
        "LIGHTMODE" = "PREPASSBASE"
        "RenderType" = "Opaque"
      }
      LOD 300
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4 unity_WorldTransformParams;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _BumpMap_ST;
      uniform sampler2D _BumpMap;
      struct appdata_t
      {
          float4 tangent :TANGENT;
          float4 vertex :POSITION;
          float3 normal :NORMAL;
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float2 xlv_TEXCOORD0 :TEXCOORD0;
          float4 xlv_TEXCOORD1 :TEXCOORD1;
          float4 xlv_TEXCOORD2 :TEXCOORD2;
          float4 xlv_TEXCOORD3 :TEXCOORD3;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 xlv_TEXCOORD0 :TEXCOORD0;
          float4 xlv_TEXCOORD1 :TEXCOORD1;
          float4 xlv_TEXCOORD2 :TEXCOORD2;
          float4 xlv_TEXCOORD3 :TEXCOORD3;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          float3 worldBinormal_1;
          float tangentSign_2;
          float3 worldTangent_3;
          float4 tmpvar_4;
          tmpvar_4.w = 1;
          tmpvar_4.xyz = in_v.vertex.xyz;
          float3 tmpvar_5;
          tmpvar_5 = mul(unity_ObjectToWorld, in_v.vertex).xyz;
          float3x3 tmpvar_6;
          tmpvar_6[0] = conv_mxt4x4_0(unity_WorldToObject).xyz;
          tmpvar_6[1] = conv_mxt4x4_1(unity_WorldToObject).xyz;
          tmpvar_6[2] = conv_mxt4x4_2(unity_WorldToObject).xyz;
          float3 tmpvar_7;
          tmpvar_7 = normalize(mul(in_v.normal, tmpvar_6));
          float3x3 tmpvar_8;
          tmpvar_8[0] = conv_mxt4x4_0(unity_ObjectToWorld).xyz;
          tmpvar_8[1] = conv_mxt4x4_1(unity_ObjectToWorld).xyz;
          tmpvar_8[2] = conv_mxt4x4_2(unity_ObjectToWorld).xyz;
          float3 tmpvar_9;
          tmpvar_9 = normalize(mul(tmpvar_8, in_v.tangent.xyz));
          worldTangent_3 = tmpvar_9;
          float tmpvar_10;
          tmpvar_10 = (in_v.tangent.w * unity_WorldTransformParams.w);
          tangentSign_2 = tmpvar_10;
          float3 tmpvar_11;
          tmpvar_11 = (((tmpvar_7.yzx * worldTangent_3.zxy) - (tmpvar_7.zxy * worldTangent_3.yzx)) * tangentSign_2);
          worldBinormal_1 = tmpvar_11;
          float4 tmpvar_12;
          tmpvar_12.x = worldTangent_3.x;
          tmpvar_12.y = worldBinormal_1.x;
          tmpvar_12.z = tmpvar_7.x;
          tmpvar_12.w = tmpvar_5.x;
          float4 tmpvar_13;
          tmpvar_13.x = worldTangent_3.y;
          tmpvar_13.y = worldBinormal_1.y;
          tmpvar_13.z = tmpvar_7.y;
          tmpvar_13.w = tmpvar_5.y;
          float4 tmpvar_14;
          tmpvar_14.x = worldTangent_3.z;
          tmpvar_14.y = worldBinormal_1.z;
          tmpvar_14.z = tmpvar_7.z;
          tmpvar_14.w = tmpvar_5.z;
          out_v.vertex = mul(unity_MatrixVP, mul(unity_ObjectToWorld, tmpvar_4));
          out_v.xlv_TEXCOORD0 = TRANSFORM_TEX(in_v.texcoord.xy, _BumpMap);
          out_v.xlv_TEXCOORD1 = tmpvar_12;
          out_v.xlv_TEXCOORD2 = tmpvar_13;
          out_v.xlv_TEXCOORD3 = tmpvar_14;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          float4 res_1;
          float3 worldN_2;
          float3 tmpvar_3;
          float3 _unity_tbn_2_4;
          float3 _unity_tbn_1_5;
          float3 _unity_tbn_0_6;
          float3 tmpvar_7;
          tmpvar_7 = in_f.xlv_TEXCOORD1.xyz;
          _unity_tbn_0_6 = tmpvar_7;
          float3 tmpvar_8;
          tmpvar_8 = in_f.xlv_TEXCOORD2.xyz;
          _unity_tbn_1_5 = tmpvar_8;
          float3 tmpvar_9;
          tmpvar_9 = in_f.xlv_TEXCOORD3.xyz;
          _unity_tbn_2_4 = tmpvar_9;
          float3 tmpvar_10;
          tmpvar_10 = ((tex2D(_BumpMap, in_f.xlv_TEXCOORD0).xyz * 2) - 1);
          float tmpvar_11;
          tmpvar_11 = dot(_unity_tbn_0_6, tmpvar_10);
          worldN_2.x = tmpvar_11;
          float tmpvar_12;
          tmpvar_12 = dot(_unity_tbn_1_5, tmpvar_10);
          worldN_2.y = tmpvar_12;
          float tmpvar_13;
          tmpvar_13 = dot(_unity_tbn_2_4, tmpvar_10);
          worldN_2.z = tmpvar_13;
          float3 tmpvar_14;
          tmpvar_14 = normalize(worldN_2);
          worldN_2 = tmpvar_14;
          tmpvar_3 = tmpvar_14;
          res_1.xyz = float3(((tmpvar_3 * 0.5) + 0.5));
          res_1.w = 0;
          out_f.color = res_1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 4, name: PREPASS
    {
      Name "PREPASS"
      Tags
      { 
        "LIGHTMODE" = "PREPASSFINAL"
        "RenderType" = "Opaque"
      }
      LOD 300
      ZWrite Off
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4 _ProjectionParams;
      //uniform float4 unity_SHAr;
      //uniform float4 unity_SHAg;
      //uniform float4 unity_SHAb;
      //uniform float4 unity_SHBr;
      //uniform float4 unity_SHBg;
      //uniform float4 unity_SHBb;
      //uniform float4 unity_SHC;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _MainTex_ST;
      uniform sampler2D _MainTex;
      uniform float4 _Color;
      uniform sampler2D _LightBuffer;
      struct appdata_t
      {
          float4 vertex :POSITION;
          float3 normal :NORMAL;
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float2 xlv_TEXCOORD0 :TEXCOORD0;
          float3 xlv_TEXCOORD1 :TEXCOORD1;
          float4 xlv_TEXCOORD2 :TEXCOORD2;
          float4 xlv_TEXCOORD3 :TEXCOORD3;
          float3 xlv_TEXCOORD4 :TEXCOORD4;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 xlv_TEXCOORD0 :TEXCOORD0;
          float4 xlv_TEXCOORD2 :TEXCOORD2;
          float3 xlv_TEXCOORD4 :TEXCOORD4;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          float4 tmpvar_1;
          float3 tmpvar_2;
          float4 tmpvar_3;
          float4 tmpvar_4;
          tmpvar_4.w = 1;
          tmpvar_4.xyz = in_v.vertex.xyz;
          tmpvar_3 = mul(unity_MatrixVP, mul(unity_ObjectToWorld, tmpvar_4));
          float4 o_5;
          float4 tmpvar_6;
          tmpvar_6 = (tmpvar_3 * 0.5);
          float2 tmpvar_7;
          tmpvar_7.x = tmpvar_6.x;
          tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
          o_5.xy = (tmpvar_7 + tmpvar_6.w);
          o_5.zw = tmpvar_3.zw;
          tmpvar_1.zw = float2(0, 0);
          tmpvar_1.xy = float2(0, 0);
          float3x3 tmpvar_8;
          tmpvar_8[0] = conv_mxt4x4_0(unity_WorldToObject).xyz;
          tmpvar_8[1] = conv_mxt4x4_1(unity_WorldToObject).xyz;
          tmpvar_8[2] = conv_mxt4x4_2(unity_WorldToObject).xyz;
          float4 tmpvar_9;
          tmpvar_9.w = 1;
          tmpvar_9.xyz = float3(normalize(mul(in_v.normal, tmpvar_8)));
          float4 normal_10;
          normal_10 = tmpvar_9;
          float3 res_11;
          float3 x_12;
          x_12.x = dot(unity_SHAr, normal_10);
          x_12.y = dot(unity_SHAg, normal_10);
          x_12.z = dot(unity_SHAb, normal_10);
          float3 x1_13;
          float4 tmpvar_14;
          tmpvar_14 = (normal_10.xyzz * normal_10.yzzx);
          x1_13.x = dot(unity_SHBr, tmpvar_14);
          x1_13.y = dot(unity_SHBg, tmpvar_14);
          x1_13.z = dot(unity_SHBb, tmpvar_14);
          res_11 = (x_12 + (x1_13 + (unity_SHC.xyz * ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y)))));
          float3 tmpvar_15;
          float _tmp_dvx_1 = max(((1.055 * pow(max(res_11, float3(0, 0, 0)), float3(0.4166667, 0.4166667, 0.4166667))) - 0.055), float3(0, 0, 0));
          tmpvar_15 = float3(_tmp_dvx_1, _tmp_dvx_1, _tmp_dvx_1);
          res_11 = tmpvar_15;
          tmpvar_2 = tmpvar_15;
          out_v.vertex = tmpvar_3;
          out_v.xlv_TEXCOORD0 = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          out_v.xlv_TEXCOORD1 = mul(unity_ObjectToWorld, in_v.vertex).xyz;
          out_v.xlv_TEXCOORD2 = o_5;
          out_v.xlv_TEXCOORD3 = tmpvar_1;
          out_v.xlv_TEXCOORD4 = tmpvar_2;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          float4 tmpvar_1;
          float4 c_2;
          float4 light_3;
          float4 tmpvar_4;
          tmpvar_4 = (tex2D(_MainTex, in_f.xlv_TEXCOORD0) * _Color);
          float4 tmpvar_5;
          tmpvar_5 = tex2D(_LightBuffer, in_f.xlv_TEXCOORD2);
          light_3 = tmpvar_5;
          light_3 = (-log2(max(light_3, float4(0.001, 0.001, 0.001, 0.001))));
          light_3.xyz = (light_3.xyz + in_f.xlv_TEXCOORD4);
          float4 c_6;
          c_6.xyz = (tmpvar_4.xyz * light_3.xyz);
          c_6.w = tmpvar_4.w;
          c_2.xyz = c_6.xyz;
          c_2.w = 1;
          tmpvar_1 = c_2;
          out_f.color = tmpvar_1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 5, name: DEFERRED
    {
      Name "DEFERRED"
      Tags
      { 
        "LIGHTMODE" = "DEFERRED"
        "RenderType" = "Opaque"
      }
      LOD 300
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4 unity_WorldTransformParams;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _MainTex_ST;
      uniform float4 _BumpMap_ST;
      uniform sampler2D _MainTex;
      uniform sampler2D _BumpMap;
      uniform float4 _Color;
      struct appdata_t
      {
          float4 tangent :TANGENT;
          float4 vertex :POSITION;
          float3 normal :NORMAL;
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float4 xlv_TEXCOORD0 :TEXCOORD0;
          float4 xlv_TEXCOORD1 :TEXCOORD1;
          float4 xlv_TEXCOORD2 :TEXCOORD2;
          float4 xlv_TEXCOORD3 :TEXCOORD3;
          float4 xlv_TEXCOORD4 :TEXCOORD4;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 xlv_TEXCOORD0 :TEXCOORD0;
          float4 xlv_TEXCOORD1 :TEXCOORD1;
          float4 xlv_TEXCOORD2 :TEXCOORD2;
          float4 xlv_TEXCOORD3 :TEXCOORD3;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
          float4 color1 :SV_Target1;
          float4 color2 :SV_Target2;
          float4 color3 :SV_Target3;
      };
      
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          float3 worldBinormal_1;
          float tangentSign_2;
          float3 worldTangent_3;
          float4 tmpvar_4;
          float4 tmpvar_5;
          float4 tmpvar_6;
          tmpvar_6.w = 1;
          tmpvar_6.xyz = in_v.vertex.xyz;
          tmpvar_4.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          tmpvar_4.zw = TRANSFORM_TEX(in_v.texcoord.xy, _BumpMap);
          float3 tmpvar_7;
          tmpvar_7 = mul(unity_ObjectToWorld, in_v.vertex).xyz;
          float3x3 tmpvar_8;
          tmpvar_8[0] = conv_mxt4x4_0(unity_WorldToObject).xyz;
          tmpvar_8[1] = conv_mxt4x4_1(unity_WorldToObject).xyz;
          tmpvar_8[2] = conv_mxt4x4_2(unity_WorldToObject).xyz;
          float3 tmpvar_9;
          tmpvar_9 = normalize(mul(in_v.normal, tmpvar_8));
          float3x3 tmpvar_10;
          tmpvar_10[0] = conv_mxt4x4_0(unity_ObjectToWorld).xyz;
          tmpvar_10[1] = conv_mxt4x4_1(unity_ObjectToWorld).xyz;
          tmpvar_10[2] = conv_mxt4x4_2(unity_ObjectToWorld).xyz;
          float3 tmpvar_11;
          tmpvar_11 = normalize(mul(tmpvar_10, in_v.tangent.xyz));
          worldTangent_3 = tmpvar_11;
          float tmpvar_12;
          tmpvar_12 = (in_v.tangent.w * unity_WorldTransformParams.w);
          tangentSign_2 = tmpvar_12;
          float3 tmpvar_13;
          tmpvar_13 = (((tmpvar_9.yzx * worldTangent_3.zxy) - (tmpvar_9.zxy * worldTangent_3.yzx)) * tangentSign_2);
          worldBinormal_1 = tmpvar_13;
          float4 tmpvar_14;
          tmpvar_14.x = worldTangent_3.x;
          tmpvar_14.y = worldBinormal_1.x;
          tmpvar_14.z = tmpvar_9.x;
          tmpvar_14.w = tmpvar_7.x;
          float4 tmpvar_15;
          tmpvar_15.x = worldTangent_3.y;
          tmpvar_15.y = worldBinormal_1.y;
          tmpvar_15.z = tmpvar_9.y;
          tmpvar_15.w = tmpvar_7.y;
          float4 tmpvar_16;
          tmpvar_16.x = worldTangent_3.z;
          tmpvar_16.y = worldBinormal_1.z;
          tmpvar_16.z = tmpvar_9.z;
          tmpvar_16.w = tmpvar_7.z;
          tmpvar_5.zw = float2(0, 0);
          tmpvar_5.xy = float2(0, 0);
          out_v.vertex = mul(unity_MatrixVP, mul(unity_ObjectToWorld, tmpvar_6));
          out_v.xlv_TEXCOORD0 = tmpvar_4;
          out_v.xlv_TEXCOORD1 = tmpvar_14;
          out_v.xlv_TEXCOORD2 = tmpvar_15;
          out_v.xlv_TEXCOORD3 = tmpvar_16;
          out_v.xlv_TEXCOORD4 = tmpvar_5;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          float4 outEmission_1;
          float3 worldN_2;
          float3 tmpvar_3;
          float3 _unity_tbn_2_4;
          float3 _unity_tbn_1_5;
          float3 _unity_tbn_0_6;
          float3 tmpvar_7;
          tmpvar_7 = in_f.xlv_TEXCOORD1.xyz;
          _unity_tbn_0_6 = tmpvar_7;
          float3 tmpvar_8;
          tmpvar_8 = in_f.xlv_TEXCOORD2.xyz;
          _unity_tbn_1_5 = tmpvar_8;
          float3 tmpvar_9;
          tmpvar_9 = in_f.xlv_TEXCOORD3.xyz;
          _unity_tbn_2_4 = tmpvar_9;
          float3 tmpvar_10;
          tmpvar_10 = (tex2D(_MainTex, in_f.xlv_TEXCOORD0.xy) * _Color).xyz;
          float3 tmpvar_11;
          tmpvar_11 = ((tex2D(_BumpMap, in_f.xlv_TEXCOORD0.zw).xyz * 2) - 1);
          float tmpvar_12;
          tmpvar_12 = dot(_unity_tbn_0_6, tmpvar_11);
          worldN_2.x = tmpvar_12;
          float tmpvar_13;
          tmpvar_13 = dot(_unity_tbn_1_5, tmpvar_11);
          worldN_2.y = tmpvar_13;
          float tmpvar_14;
          tmpvar_14 = dot(_unity_tbn_2_4, tmpvar_11);
          worldN_2.z = tmpvar_14;
          float3 tmpvar_15;
          tmpvar_15 = normalize(worldN_2);
          worldN_2 = tmpvar_15;
          tmpvar_3 = tmpvar_15;
          float4 emission_16;
          float3 tmpvar_17;
          float3 tmpvar_18;
          tmpvar_17 = tmpvar_10;
          tmpvar_18 = tmpvar_3;
          float4 outGBuffer2_19;
          float4 tmpvar_20;
          tmpvar_20.xyz = float3(tmpvar_17);
          tmpvar_20.w = 1;
          float4 tmpvar_21;
          tmpvar_21.xyz = float3(0, 0, 0);
          tmpvar_21.w = 0;
          float4 tmpvar_22;
          tmpvar_22.w = 1;
          tmpvar_22.xyz = float3(((tmpvar_18 * 0.5) + 0.5));
          outGBuffer2_19 = tmpvar_22;
          float4 tmpvar_23;
          tmpvar_23.w = 1;
          tmpvar_23.xyz = float3(0, 0, 0);
          emission_16 = tmpvar_23;
          emission_16.xyz = emission_16.xyz;
          outEmission_1.w = emission_16.w;
          outEmission_1.xyz = exp2((-emission_16.xyz));
          out_f.color = tmpvar_20;
          out_f.color1 = tmpvar_21;
          out_f.color2 = outGBuffer2_19;
          out_f.color3 = outEmission_1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 6, name: Meta
    {
      Name "Meta"
      Tags
      { 
        "LIGHTMODE" = "META"
        "RenderType" = "Opaque"
      }
      LOD 300
      Cull Off
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4 unity_WorldTransformParams;
      //uniform float4x4 unity_MatrixVP;
      // uniform float4 unity_LightmapST;
      // uniform float4 unity_DynamicLightmapST;
      uniform float4 unity_MetaVertexControl;
      uniform float4 _MainTex_ST;
      uniform sampler2D _MainTex;
      uniform float4 _Color;
      uniform float4 unity_MetaFragmentControl;
      uniform float unity_OneOverOutputBoost;
      uniform float unity_MaxOutputValue;
      uniform float unity_UseLinearSpace;
      struct appdata_t
      {
          float4 tangent :TANGENT;
          float4 vertex :POSITION;
          float3 normal :NORMAL;
          float4 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
      };
      
      struct OUT_Data_Vert
      {
          float2 xlv_TEXCOORD0 :TEXCOORD0;
          float4 xlv_TEXCOORD1 :TEXCOORD1;
          float4 xlv_TEXCOORD2 :TEXCOORD2;
          float4 xlv_TEXCOORD3 :TEXCOORD3;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 xlv_TEXCOORD0 :TEXCOORD0;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          float3 worldBinormal_1;
          float tangentSign_2;
          float3 worldTangent_3;
          float4 vertex_4;
          vertex_4 = in_v.vertex;
          if(unity_MetaVertexControl.x)
          {
              vertex_4.xy = ((in_v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
              float tmpvar_5;
              if((in_v.vertex.z>0))
              {
                  tmpvar_5 = 0.0001;
              }
              else
              {
                  tmpvar_5 = 0;
              }
              vertex_4.z = tmpvar_5;
          }
          if(unity_MetaVertexControl.y)
          {
              vertex_4.xy = ((in_v.texcoord2.xy * unity_DynamicLightmapST.xy) + unity_DynamicLightmapST.zw);
              float tmpvar_6;
              if((vertex_4.z>0))
              {
                  tmpvar_6 = 0.0001;
              }
              else
              {
                  tmpvar_6 = 0;
              }
              vertex_4.z = tmpvar_6;
          }
          float4 tmpvar_7;
          tmpvar_7.w = 1;
          tmpvar_7.xyz = vertex_4.xyz;
          float3 tmpvar_8;
          tmpvar_8 = mul(unity_ObjectToWorld, in_v.vertex).xyz;
          float3x3 tmpvar_9;
          tmpvar_9[0] = conv_mxt4x4_0(unity_WorldToObject).xyz;
          tmpvar_9[1] = conv_mxt4x4_1(unity_WorldToObject).xyz;
          tmpvar_9[2] = conv_mxt4x4_2(unity_WorldToObject).xyz;
          float3 tmpvar_10;
          tmpvar_10 = normalize(mul(in_v.normal, tmpvar_9));
          float3x3 tmpvar_11;
          tmpvar_11[0] = conv_mxt4x4_0(unity_ObjectToWorld).xyz;
          tmpvar_11[1] = conv_mxt4x4_1(unity_ObjectToWorld).xyz;
          tmpvar_11[2] = conv_mxt4x4_2(unity_ObjectToWorld).xyz;
          float3 tmpvar_12;
          tmpvar_12 = normalize(mul(tmpvar_11, in_v.tangent.xyz));
          worldTangent_3 = tmpvar_12;
          float tmpvar_13;
          tmpvar_13 = (in_v.tangent.w * unity_WorldTransformParams.w);
          tangentSign_2 = tmpvar_13;
          float3 tmpvar_14;
          tmpvar_14 = (((tmpvar_10.yzx * worldTangent_3.zxy) - (tmpvar_10.zxy * worldTangent_3.yzx)) * tangentSign_2);
          worldBinormal_1 = tmpvar_14;
          float4 tmpvar_15;
          tmpvar_15.x = worldTangent_3.x;
          tmpvar_15.y = worldBinormal_1.x;
          tmpvar_15.z = tmpvar_10.x;
          tmpvar_15.w = tmpvar_8.x;
          float4 tmpvar_16;
          tmpvar_16.x = worldTangent_3.y;
          tmpvar_16.y = worldBinormal_1.y;
          tmpvar_16.z = tmpvar_10.y;
          tmpvar_16.w = tmpvar_8.y;
          float4 tmpvar_17;
          tmpvar_17.x = worldTangent_3.z;
          tmpvar_17.y = worldBinormal_1.z;
          tmpvar_17.z = tmpvar_10.z;
          tmpvar_17.w = tmpvar_8.z;
          out_v.vertex = mul(unity_MatrixVP, tmpvar_7);
          out_v.xlv_TEXCOORD0 = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          out_v.xlv_TEXCOORD1 = tmpvar_15;
          out_v.xlv_TEXCOORD2 = tmpvar_16;
          out_v.xlv_TEXCOORD3 = tmpvar_17;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          float4 tmpvar_1;
          float3 tmpvar_2;
          float3 tmpvar_3;
          tmpvar_3 = (tex2D(_MainTex, in_f.xlv_TEXCOORD0) * _Color).xyz;
          tmpvar_2 = tmpvar_3;
          float4 res_4;
          res_4 = float4(0, 0, 0, 0);
          if(unity_MetaFragmentControl.x)
          {
              float4 tmpvar_5;
              tmpvar_5.w = 1;
              tmpvar_5.xyz = float3(tmpvar_2);
              res_4.w = tmpvar_5.w;
              float3 tmpvar_6;
              float _tmp_dvx_2 = clamp(unity_OneOverOutputBoost, 0, 1);
              tmpvar_6 = clamp(pow(tmpvar_2, float3(_tmp_dvx_2, _tmp_dvx_2, _tmp_dvx_2)), float3(0, 0, 0), float3(unity_MaxOutputValue, unity_MaxOutputValue, unity_MaxOutputValue));
              res_4.xyz = float3(tmpvar_6);
          }
          if(unity_MetaFragmentControl.y)
          {
              float3 emission_7;
              if(int(unity_UseLinearSpace))
              {
                  emission_7 = float3(0, 0, 0);
              }
              else
              {
                  emission_7 = float3(0, 0, 0);
              }
              float4 tmpvar_8;
              tmpvar_8.w = 1;
              tmpvar_8.xyz = float3(emission_7);
              res_4 = tmpvar_8;
          }
          tmpvar_1 = res_4;
          out_f.color = tmpvar_1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Legacy Shaders/Diffuse"
}
