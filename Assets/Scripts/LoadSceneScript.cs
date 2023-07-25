using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneScript : MonoBehaviour
{
	private void Start()
	{
		Invoke("LoadTitle", 1.5f);
	}

	private void LoadTitle()
	{
		SceneManager.LoadScene("Title");
	}
}
