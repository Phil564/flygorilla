using System;
using UnityEngine;
using UnityEngine.UI;

public class PlayerController : MonoBehaviour
{
	public GameObject gameController;

	public float speed = 3f;

	public int score;

	public Text scoreText;

	public Text gpText;

	public AudioClip collideSound;

	public AudioClip getCoinSound;

	public AudioClip pigSound;

	public AudioSource bgmAudioSource;

	public AudioSource splashAudioSource;

	public ParticleSystem splashParticleL;

	public ParticleSystem splashParticleR;

	public ParticleSystem speedParticle;

	public GameObject getCoinParticle;

	private float targetPosition;

	private bool isGameOver;

	private float baseMousePositionX;

	private AudioSource audioSource;

	private float inputX;

	private Rigidbody rb;

	private string startScoreText;

	private void Start()
	{
		rb = GetComponent<Rigidbody>();
		audioSource = GetComponent<AudioSource>();
		targetPosition = 0f;
		startScoreText = scoreText.text;
	}

	private void Update()
	{
		if (isGameOver)
		{
			return;
		}
		float num = 0f;
		if (Input.GetButtonDown("Fire1"))
		{
			Vector3 mousePosition = UnityEngine.Input.mousePosition;
			baseMousePositionX = mousePosition.x;
		}
		else if (Input.GetButton("Fire1"))
		{
			Vector3 mousePosition2 = UnityEngine.Input.mousePosition;
			num = Mathf.Clamp((mousePosition2.x - baseMousePositionX) * 10f / (float)Screen.width, -1f, 1f);
		}
		else
		{
			num = 0f;
		}
		if (inputX > num)
		{
			inputX -= Time.deltaTime * 8f;
			if (inputX < num)
			{
				inputX = num;
			}
		}
		else if (inputX < num)
		{
			inputX += Time.deltaTime * 8f;
			if (inputX > num)
			{
				inputX = num;
			}
		}
		targetPosition = inputX * 2f;
		splashEffectUpdate();
		Vector3 position = base.transform.position;
		speed = Mathf.Clamp(Mathf.Sqrt(position.z * 0.3f + 400f), 0f, 50f);
		bgmAudioSource.pitch = 0.5f + (speed - 20f) * (71f / (678f * (float)Math.PI));
		speedParticle.startSpeed = ((!(speed > 40f)) ? 0f : speed);
		SetScoreText();
	}

	private void FixedUpdate()
	{
		if (!isGameOver)
		{
			Rigidbody rigidbody = rb;
			float x = targetPosition;
			Vector3 position = base.transform.position;
			float y = position.y;
			Vector3 position2 = base.transform.position;
			rigidbody.MovePosition(new Vector3(x, y, position2.z + speed * Time.fixedDeltaTime));
			rb.MoveRotation(Quaternion.Euler(new Vector3(0f, 0f, 75f * inputX)));
		}
	}

	private void splashEffectUpdate()
	{
		Vector3 position = base.transform.position;
		if (position.x > 1.6f)
		{
			splashParticleL.emissionRate = 15f;
			if (!splashAudioSource.isPlaying)
			{
				splashAudioSource.Play();
				UnityEngine.Debug.Log("hidari");
			}
			return;
		}
		Vector3 position2 = base.transform.position;
		if (position2.x < -1.6f)
		{
			splashParticleR.emissionRate = 15f;
			if (!splashAudioSource.isPlaying)
			{
				splashAudioSource.Play();
				UnityEngine.Debug.Log("migi");
			}
			return;
		}
		splashParticleL.emissionRate = 0f;
		splashParticleR.emissionRate = 0f;
		if (splashAudioSource.isPlaying)
		{
			splashAudioSource.Pause();
			UnityEngine.Debug.Log("nasi");
		}
	}

	private void OnTriggerEnter(Collider other)
	{
		if (!isGameOver)
		{
			if (other.CompareTag("Obstacle"))
			{
				isGameOver = true;
				bgmAudioSource.Stop();
				speedParticle.startSpeed = 0f;
				splashAudioSource.Stop();
				audioSource.PlayOneShot(collideSound);
				gameController.SendMessage("GameOver");
			}
			else if (other.CompareTag("GP"))
			{
				UnityEngine.Object.Destroy(UnityEngine.Object.Instantiate(getCoinParticle, other.transform.position, Quaternion.identity, base.transform), 1f);
				other.GetComponent<Renderer>().enabled = false;
				MoneyManager.EarnMoney(ShopManager.GetShopItemLevel(ShopItem.CoinValue));
				audioSource.PlayOneShot(getCoinSound);
				other.tag = "Untagged";
			}
		}
	}

	private void OnCollisionEnter(Collision other)
	{
		if (other.transform.CompareTag("Decoration"))
		{
			audioSource.PlayOneShot(pigSound);
			other.transform.tag = "Untagged";
		}
	}

	private void SetScoreText()
	{
		Vector3 position = base.transform.position;
		score = Mathf.FloorToInt(position.z * 10f);
		scoreText.text = startScoreText.Replace("@", score.ToString());
	}
}
