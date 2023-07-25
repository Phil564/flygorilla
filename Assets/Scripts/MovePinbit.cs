using UnityEngine;

public class MovePinbit : MonoBehaviour
{
	private Rigidbody rb;

	private float randomFloat;

	private void Start()
	{
		rb = GetComponent<Rigidbody>();
		randomFloat = UnityEngine.Random.Range(0f, 30f);
	}

	private void Update()
	{
		rb.position = base.transform.parent.position + Vector3.up + Vector3.right * Mathf.Sin(Time.time + randomFloat) * 2.4f;
	}
}
