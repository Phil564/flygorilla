using SocialConnector;
using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameController : MonoBehaviour
{
	public static int PlayCount;

	public GameObject ReviewPopUp;

	public GameObject gamePlayPanel;

	public GameObject gameOverPanel;

	public GameObject player;

	public GameObject chunks;

	public GameObject congratuateText;

	public Text gpText;

	private void Start()
	{
		MoneyManager.gameController = this;
		PlayCount++;
		UpdateMoneyText();
	}

	public void UpdateMoneyText()
	{
		gpText.text = string.Empty + MoneyManager.Money;
	}

	public IEnumerator GameOver()
	{
		Time.timeScale = 0.2f;
		Time.fixedDeltaTime *= 0.2f;
		Rigidbody playerRb = player.GetComponent<Rigidbody>();
		playerRb.isKinematic = false;
		playerRb.useGravity = true;
		yield return new WaitForEndOfFrame();
		StartCoroutine("ShakeCamera");
		PlayerController pc = player.GetComponent<PlayerController>();
		playerRb.velocity = Vector3.forward * pc.speed;
		yield return new WaitForEndOfFrame();
		GameObject.FindWithTag("MainCamera").GetComponent<CameraController>().enabled = false;
		chunks.GetComponent<ChunkController>().enabled = false;
		yield return new WaitForSecondsRealtime(1f);
		MoneyManager.SaveMoney();
		yield return new WaitForSecondsRealtime(2f);
		Time.timeScale = 1f;
		Time.fixedDeltaTime *= 5f;
		GetComponent<AudioSource>().Play();
		pc.enabled = false;
		SetHighScore(pc.score);
		gamePlayPanel.SetActive(value: false);
		gameOverPanel.SetActive(value: true);
		gameOverPanel.transform.Find("Display Score Content/Score Text").GetComponent<Text>().text = string.Empty + pc.score;
		if (PlayCount == 3 && PlayerPrefs.GetInt("ReviewCount", 0) == 0)
		{
			ReviewPopUp.SetActive(value: true);
		}
		FirebaseController.SendRankingData(pc.score);
	}

	private IEnumerator ShakeCamera()
	{
		Transform cam = GameObject.FindWithTag("MainCamera").transform.GetChild(0);
		float time = 0f;
		while (time < 0.2f)
		{
			yield return new WaitForEndOfFrame();
			time += Time.unscaledDeltaTime;
			cam.localPosition = Vector3.right * Mathf.Sin(time * 100f) * (0.2f - time);
		}
		cam.localPosition = Vector3.zero;
	}

	private void SetHighScore(int score)
	{
		int @int = PlayerPrefs.GetInt("BestScore");
		if (score >= @int)
		{
			congratuateText.SetActive(value: true);
			PlayerPrefs.SetInt("BestScore", score);
		}
	}

	public void GoGamePlay()
	{
		Invoke("sss", 1f);
		if (PlayCount % 2 == 1 && UnityEngine.Random.Range(0f, 1f) < 0.8f && PlayerPrefs.GetInt("BestScore") > 10000)
		{
			FirebaseController.ShowInterstitial();
		}
	}

	private void sss()
	{
		SceneManager.LoadScene("GamePlay");
	}

	public void GoTitle()
	{
		SceneManager.LoadScene("Title");
	}

	public void ShareScore()
	{
		string text = "【スマホゲ\u30fcム、飛べ！ゴリラ】「" + UserData.userName + "」というゴリラのベストスコアは" + PlayerPrefs.GetInt("BestScore") + "でした。↓のURLからインスト\u30fcルして挑戦しよう！";
		SocialConnector.SocialConnector.Share(text, "http://www.pinbit.jp/p/blog-page_25.html");
	}
}
