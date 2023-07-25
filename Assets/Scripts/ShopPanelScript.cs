using UnityEngine;
using UnityEngine.UI;

public class ShopPanelScript : MonoBehaviour
{
	public Button offlineEarningsButton;

	public Button coinValueButton;

	public Text offlineEarningsTitleText;

	public Text coinValueTitleText;

	public AudioClip registerSound;

	private string offlineEarningsTitle;

	private string coinValueTitle;

	private void Start()
	{
		offlineEarningsTitle = offlineEarningsTitleText.text;
		coinValueTitle = coinValueTitleText.text;
		setTitleText();
		SetBuyButtons();
		offlineEarningsButton.onClick.AddListener(delegate
		{
			onBuyButtonClicked(ShopItem.OfflineEarnings);
		});
		coinValueButton.onClick.AddListener(delegate
		{
			onBuyButtonClicked(ShopItem.CoinValue);
		});
	}

	private void onBuyButtonClicked(ShopItem item)
	{
		if (ShopManager.CheckBuyable(item))
		{
			ShopManager.BuyItem(item);
		}
		base.gameObject.GetComponentInParent<AudioSource>().PlayOneShot(registerSound);
		SetBuyButtons();
		setTitleText();
	}

	private void SetBuyButtons()
	{
		offlineEarningsButton.interactable = ShopManager.CheckBuyable(ShopItem.OfflineEarnings);
		offlineEarningsButton.GetComponentInChildren<Text>().text = "Level Up\n$" + ShopManager.getPrice(ShopItem.OfflineEarnings);
		coinValueButton.interactable = ShopManager.CheckBuyable(ShopItem.CoinValue);
		coinValueButton.GetComponentInChildren<Text>().text = "Level Up\n$" + ShopManager.getPrice(ShopItem.CoinValue);
	}

	private void setTitleText()
	{
		offlineEarningsTitleText.text = offlineEarningsTitle.Replace("@", ShopManager.GetShopItemLevel(ShopItem.OfflineEarnings).ToString());
		coinValueTitleText.text = coinValueTitle.Replace("@", ShopManager.GetShopItemLevel(ShopItem.CoinValue).ToString());
	}
}
