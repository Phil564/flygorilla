using System.Collections.Generic;
using System.Threading.Tasks;
using Firebase;
using Firebase.Auth;
using Firebase.Database;
using Firebase.Unity.Editor;
using GoogleMobileAds.Api;
using UnityEngine;

public class FirebaseController : MonoBehaviour
{
	private static GameObject Instance;

	public static DatabaseReference highScoreDb;

	private static FirebaseUser newUser;

	private static InterstitialAd interstitial;

	private void Start()
	{
		if (Instance != null)
		{
			UnityEngine.Object.Destroy(base.gameObject);
		}
		Object.DontDestroyOnLoad(base.gameObject);
		Instance = base.gameObject;
		RequestInterstitial();
		interstitial.OnAdClosed += delegate
		{
			interstitial.Destroy();
			RequestInterstitial();
		};
		RequestBanner();
		AnonymouslyLogin();
		highScoreDb = FirebaseDatabase.DefaultInstance.GetReference("HighScoreRank2");
		FirebaseApp.DefaultInstance.SetEditorDatabaseUrl("https://flygorilla-93dfc.firebaseio.com/");
	}

	private void RequestBanner()
	{
		string adUnitId = "ca-app-pub-7195447205842611/8791662070";
		BannerView bannerView = new BannerView(adUnitId, AdSize.Banner, AdPosition.Bottom);
		AdRequest request = new AdRequest.Builder().Build();
		bannerView.LoadAd(request);
	}

	private void RequestInterstitial()
	{
		string adUnitId = "ca-app-pub-3940256099942544/1033173712";
		interstitial = new InterstitialAd(adUnitId);
		AdRequest request = new AdRequest.Builder().Build();
		interstitial.LoadAd(request);
	}

	public static void ShowInterstitial()
	{
		if (interstitial.IsLoaded())
		{
			interstitial.Show();
		}
	}

	private void AnonymouslyLogin()
	{
		FirebaseAuth defaultInstance = FirebaseAuth.DefaultInstance;
		defaultInstance.SignInAnonymouslyAsync().ContinueWith(delegate(Task<FirebaseUser> task)
		{
			if (task.IsCanceled)
			{
				UnityEngine.Debug.LogError("SignInAnonymouslyAsync was canceled.");
			}
			else if (task.IsFaulted)
			{
				UnityEngine.Debug.LogError("SignInAnonymouslyAsync encountered an error: " + task.Exception);
			}
			else
			{
				newUser = task.Result;
				UnityEngine.Debug.LogFormat("User signed in successfully: {0} ({1})", newUser.DisplayName, newUser.UserId);
			}
		});
	}

	public static void SendRankingData(int score)
	{
		if (PlayerPrefs.GetInt("RankingScore") <= score)
		{
			PlayerPrefs.SetInt("RankingScore", score);
			string userId = newUser.UserId;
			Dictionary<string, object> dictionary = new Dictionary<string, object>();
			dictionary.Add("name", UserData.userName);
			dictionary.Add("score", scoreFill0(score.ToString()));
			Dictionary<string, object> dictionary2 = new Dictionary<string, object>();
			dictionary2.Add(userId, dictionary);
			highScoreDb.UpdateChildrenAsync(dictionary2);
		}
	}

	public static void SendNameChanged()
	{
		string userId = newUser.UserId;
		Dictionary<string, object> dictionary = new Dictionary<string, object>();
		dictionary.Add("name", UserData.userName);
		dictionary.Add("score", scoreFill0(PlayerPrefs.GetInt("RankingScore").ToString()));
		Dictionary<string, object> dictionary2 = new Dictionary<string, object>();
		dictionary2.Add(userId, dictionary);
		highScoreDb.UpdateChildrenAsync(dictionary2);
	}

	private static string scoreFill0(string score)
	{
		string text = score;
		while (text.Length <= 10)
		{
			text = "0" + text;
		}
		return text;
	}
}
