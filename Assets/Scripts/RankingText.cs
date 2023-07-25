using Firebase.Database;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;

public class RankingText : MonoBehaviour
{
	private Text thisText;

	private string rankingText = string.Empty;

	private void Start()
	{
		if (!(rankingText != string.Empty))
		{
			thisText = GetComponent<Text>();
			FirebaseController.highScoreDb.OrderByChild("score").LimitToLast(100).GetValueAsync()
				.ContinueWith(delegate(Task<DataSnapshot> task)
				{
					if (task.IsFaulted)
					{
						UnityEngine.Debug.Log("sippai");
					}
					else if (task.IsCompleted)
					{
						DataSnapshot result = task.Result;
						IEnumerator<DataSnapshot> enumerator = result.Children.GetEnumerator();
						int num = (int)result.ChildrenCount;
						UnityEngine.Debug.Log(result);
						UnityEngine.Debug.Log(enumerator);
						while (enumerator.MoveNext())
						{
							DataSnapshot current = enumerator.Current;
							string text = (string)current.Child("name").GetValue(useExportFormat: true);
							string text2 = (string)current.Child("score").GetValue(useExportFormat: true);
							rankingText = num + "位 スコア" + text2 + " " + text + "さん\n" + rankingText;
							num--;
						}
					}
				});
		}
	}

	private void Update()
	{
		thisText.text = rankingText;
	}
}
