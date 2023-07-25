using UnityEngine;

public class TitleCameraScript : MonoBehaviour
{
	private Vector3 acce;

	private Vector3 startPosition;

	private Vector3 lookPos;

	private Vector3 lowPassValue;

	private void Start()
	{
		startPosition = base.transform.position;
		lookPos = base.transform.forward * 1f + base.transform.position;
	}

	private void Update()
	{
		acce = LowPassFilterAccelerometer();
		acce = new Vector3(lowPassValue.x, lowPassValue.y * -1f, 0f);
		base.transform.position = acce * 0.2f + startPosition;
		base.transform.LookAt(lookPos);
	}

	private Vector3 LowPassFilterAccelerometer()
	{
		lowPassValue = Vector3.Lerp(lowPassValue, Input.acceleration, 0.5f);
		return lowPassValue;
	}
}
