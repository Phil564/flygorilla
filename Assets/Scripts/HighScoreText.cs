using UnityEngine;
using UnityEngine.UI;

public class HighScoreText : MonoBehaviour
{
	private string startText;

	private void Start()
	{
		Text component = GetComponent<Text>();
		startText = component.text;
		component.text = startText.Replace("@", PlayerPrefs.GetInt("BestScore").ToString());
	}
}
