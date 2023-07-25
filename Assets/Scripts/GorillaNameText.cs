using UnityEngine;
using UnityEngine.UI;

public class GorillaNameText : MonoBehaviour
{
	private string startText;

	private Text myText;

	private void Start()
	{
		myText = GetComponent<Text>();
		startText = myText.text;
		SetName();
	}

	public void SetName()
	{
		myText.text = startText.Replace("@", UserData.userName);
	}
}
