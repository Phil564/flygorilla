using System.Collections;
using UnityEngine;

public class ShopButtonHighliter : MonoBehaviour
{
	private void OnEnable()
	{
		if (ShopManager.CheckBuyable(ShopItem.CoinValue) || ShopManager.CheckBuyable(ShopItem.OfflineEarnings))
		{
			StartCoroutine("shake");
		}
	}

	private IEnumerator shake()
	{
		float t = 0f;
		while (true)
		{
			t += Time.deltaTime;
			base.transform.localScale = Vector3.one * (1f + Mathf.Sin(t * 20f) * 0.05f);
			yield return new WaitForEndOfFrame();
		}
	}
}
