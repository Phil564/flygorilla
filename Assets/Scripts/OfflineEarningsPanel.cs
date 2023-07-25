using System;
using UnityEngine;
using UnityEngine.UI;

public class OfflineEarningsPanel : MonoBehaviour
{
	public Button AquireButton;

	public Button AdButton;

	public Text RewardText;

	private DateTime lastReceivedTime;

	private void Start()
	{
		if (PlayerPrefs.GetString("LastReceivedTime") == string.Empty)
		{
			PlayerPrefs.SetString("LastReceivedTime", DateTime.Now.ToBinary().ToString());
		}
		int reward = calculateOfflineEarnings();
		if (reward == 0)
		{
			base.gameObject.SetActive(value: false);
			return;
		}
		RewardText.text = "$" + reward;
		AquireButton.GetComponentInChildren<Text>().text = AquireButton.GetComponentInChildren<Text>().text.Replace("@", reward.ToString());
		AdButton.GetComponentInChildren<Text>().text = AdButton.GetComponentInChildren<Text>().text.Replace("@", (reward * 2).ToString());
		AquireButton.onClick.AddListener(delegate
		{
			MoneyManager.EarnMoney(reward);
		});
		AquireButton.onClick.AddListener(delegate
		{
			MoneyManager.EarnMoney(reward);
		});
	}

	private int calculateOfflineEarnings()
	{
		lastReceivedTime = DateTime.FromBinary(Convert.ToInt64(PlayerPrefs.GetString("LastReceivedTime", DateTime.Now.ToBinary().ToString())));
		float num = Mathf.Clamp((float)(DateTime.Now - lastReceivedTime).TotalMinutes, 0f, 720f);
		UnityEngine.Debug.Log(num);
		PlayerPrefs.SetString("LastReceivedTime", DateTime.Now.ToBinary().ToString());
		return Mathf.FloorToInt(num * 0.15f * (float)ShopManager.GetShopItemLevel(ShopItem.OfflineEarnings));
	}
}
