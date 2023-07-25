using UnityEngine;

public static class MoneyManager
{
	private static int money;

	public static GameController gameController;

	public static int Money
	{
		get
		{
			return money;
		}
		set
		{
			money = value;
			gameController.UpdateMoneyText();
		}
	}

	static MoneyManager()
	{
		money = PlayerPrefs.GetInt("TotalGP");
	}

	public static void EarnMoney(int val, bool isSave = false)
	{
		Money += val;
		if (isSave)
		{
			SaveMoney();
		}
	}

	public static void SaveMoney()
	{
		PlayerPrefs.SetInt("TotalGP", Money);
	}
}
