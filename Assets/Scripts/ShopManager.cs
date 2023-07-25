using UnityEngine;

public static class ShopManager
{
	private static int offlineEarningsLevel;

	private static int coinValueLevel;

	static ShopManager()
	{
		offlineEarningsLevel = PlayerPrefs.GetInt(ShopItem.OfflineEarnings.ToString(), 1);
		coinValueLevel = PlayerPrefs.GetInt(ShopItem.CoinValue.ToString(), 1);
	}

	public static void BuyItem(ShopItem item)
	{
		MoneyManager.EarnMoney(-getPrice(item), isSave: true);
		levelUpItem(item);
		saveItemLevel();
	}

	private static void levelUpItem(ShopItem item)
	{
		switch (item)
		{
		case ShopItem.OfflineEarnings:
			offlineEarningsLevel++;
			break;
		case ShopItem.CoinValue:
			coinValueLevel++;
			break;
		}
	}

	public static bool CheckBuyable(ShopItem item)
	{
		return MoneyManager.Money >= getPrice(item);
	}

	public static int GetShopItemLevel(ShopItem item)
	{
		switch (item)
		{
		case ShopItem.OfflineEarnings:
			return offlineEarningsLevel;
		case ShopItem.CoinValue:
			return coinValueLevel;
		default:
			return 0;
		}
	}

	public static int getPrice(int lv)
	{
		return 80 + lv * lv * 20;
	}

	public static int getPrice(ShopItem item)
	{
		int shopItemLevel = GetShopItemLevel(item);
		return getPrice(shopItemLevel);
	}

	private static void saveItemLevel()
	{
		PlayerPrefs.SetInt(ShopItem.OfflineEarnings.ToString(), GetShopItemLevel(ShopItem.OfflineEarnings));
		PlayerPrefs.SetInt(ShopItem.CoinValue.ToString(), GetShopItemLevel(ShopItem.CoinValue));
	}
}
