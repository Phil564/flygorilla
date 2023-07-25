using UnityEngine;

public class CameraController : MonoBehaviour
{
	public GameObject player;

	private Vector3 diffPos;

	private Vector3 startEuler;

	private void Start()
	{
		diffPos = base.transform.position - player.transform.position;
		startEuler = base.transform.eulerAngles;
	}

	private void LateUpdate()
	{
		Transform transform = base.transform;
		Vector3 position = player.transform.position;
		float x = position.x * 0.4f;
		Vector3 position2 = player.transform.position;
		float y = position2.y;
		Vector3 position3 = player.transform.position;
		transform.position = new Vector3(x, y, position3.z) + diffPos;
		Transform transform2 = base.transform;
		Vector3 position4 = base.transform.position;
		transform2.rotation = Quaternion.Euler(new Vector3(0f, 0f, 2f * position4.x) + startEuler);
	}
}
