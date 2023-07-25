using I2.Loc;
using UnityEngine;
using UnityEngine.UI;

public class ReviewPanel : MonoBehaviour
{
	public Text TitleText;

	public Button YesButton;

	public Button NoButton;

	private void Start()
	{
		YesButton.onClick.AddListener(delegate
		{
			TitleText.text = LocalizationManager.GetTermTranslation("How about a rating this app on the App Store or Google Play?");
			AskReview();
		});
	}

	private void AskReview()
	{
		YesButton.onClick.RemoveAllListeners();
		YesButton.onClick.AddListener(delegate
		{
			string url;
			switch (Application.platform)
			{
			case RuntimePlatform.Android:
				url = "https://play.google.com/store/apps/details?id=jp.pinbit.flygorilla";
				break;
			case RuntimePlatform.IPhonePlayer:
				url = "https://itunes.apple.com/us/app/%E9%A3%9B%E3%81%B9-%E3%82%B4%E3%83%AA%E3%83%A9/id1365028549";
				break;
			default:
				url = "https://twitter.com/pit_pinbit";
				break;
			}
			Application.OpenURL(url);
			PlayerPrefs.SetInt("ReviewCount", 1);
			base.gameObject.SetActive(value: false);
		});
	}
}
