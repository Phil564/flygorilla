using UnityEngine;

public static class UserData
{
	public static string userName;

	static UserData()
	{
		userName = PlayerPrefs.GetString("GorillaName", "名無し");
	}

	public static void SetName(string name)
	{
		userName = name;
		PlayerPrefs.SetString("GorillaName", name);
		FirebaseController.SendNameChanged();
	}
}
