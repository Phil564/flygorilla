using UnityEngine;

namespace SocialConnector
{
	public class SocialConnector
	{
		private static AndroidJavaObject clazz = new AndroidJavaClass("com.unity3d.player.UnityPlayer");

		private static AndroidJavaObject activity = clazz.GetStatic<AndroidJavaObject>("currentActivity");

		private static void _Share(string text, string url, string textureUrl)
		{
			using (AndroidJavaObject androidJavaObject = new AndroidJavaObject("android.content.Intent"))
			{
				androidJavaObject.Call<AndroidJavaObject>("setAction", new object[1]
				{
					"android.intent.action.SEND"
				});
				androidJavaObject.Call<AndroidJavaObject>("setType", new object[1]
				{
					(!string.IsNullOrEmpty(textureUrl)) ? "image/png" : "text/plain"
				});
				if (!string.IsNullOrEmpty(url))
				{
					text = text + "\t" + url;
				}
				if (!string.IsNullOrEmpty(text))
				{
					androidJavaObject.Call<AndroidJavaObject>("putExtra", new object[2]
					{
						"android.intent.extra.TEXT",
						text
					});
				}
				if (!string.IsNullOrEmpty(textureUrl))
				{
					AndroidJavaClass androidJavaClass = new AndroidJavaClass("android.net.Uri");
					AndroidJavaObject androidJavaObject2 = new AndroidJavaObject("java.io.File", textureUrl);
					androidJavaObject.Call<AndroidJavaObject>("putExtra", new object[2]
					{
						"android.intent.extra.STREAM",
						androidJavaClass.CallStatic<AndroidJavaObject>("fromFile", new object[1]
						{
							androidJavaObject2
						})
					});
				}
				AndroidJavaObject androidJavaObject3 = androidJavaObject.CallStatic<AndroidJavaObject>("createChooser", new object[2]
				{
					androidJavaObject,
					string.Empty
				});
				androidJavaObject3.Call<AndroidJavaObject>("putExtra", new object[2]
				{
					"android.intent.extra.EXTRA_INITIAL_INTENTS",
					androidJavaObject
				});
				activity.Call("startActivity", androidJavaObject3);
			}
		}

		public static void Share(string text)
		{
			Share(text, null, null);
		}

		public static void Share(string text, string url)
		{
			Share(text, url, null);
		}

		public static void Share(string text, string url, string textureUrl)
		{
			_Share(text, url, textureUrl);
		}
	}
}
