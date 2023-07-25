using UnityEngine;

public class ChunkController : MonoBehaviour
{
	public int chunkProgress;

	public GameObject[] chunk;

	public GameObject player;

	public GameObject[] stagePartsPrefab;

	public GameObject[] stagePartsInEachChunk;

	private void Start()
	{
		stagePartsInEachChunk = new GameObject[chunk.Length];
		for (int i = 0; i < chunk.Length; i++)
		{
			stagePartsInEachChunk[i] = UnityEngine.Object.Instantiate(stagePartsPrefab[0], chunk[i].transform);
		}
	}

	private void Update()
	{
		Vector3 position = player.transform.position;
		if (position.z - 20f > (float)(chunkProgress * 15))
		{
			ChunkUpdate();
		}
	}

	private void ChunkUpdate()
	{
		chunk[chunkProgress % chunk.Length].transform.position = Vector3.forward * ((chunk.Length + chunkProgress) * 15);
		UnityEngine.Object.Destroy(stagePartsInEachChunk[chunkProgress % chunk.Length]);
		stagePartsInEachChunk[chunkProgress % chunk.Length] = UnityEngine.Object.Instantiate(stagePartsPrefab[Random.Range(0, stagePartsPrefab.Length)], chunk[chunkProgress % chunk.Length].transform);
		chunkProgress++;
	}
}
