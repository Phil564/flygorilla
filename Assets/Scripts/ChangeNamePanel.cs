using UnityEngine;
using UnityEngine.UI;

public class ChangeNamePanel : MonoBehaviour
{
	private InputField inputField;

	private void OnEnable()
	{
		inputField = base.transform.Find("InputField").GetComponent<InputField>();
		inputField.text = UserData.userName;
	}

	public void ChangeName()
	{
		UserData.SetName(inputField.text);
	}
}
