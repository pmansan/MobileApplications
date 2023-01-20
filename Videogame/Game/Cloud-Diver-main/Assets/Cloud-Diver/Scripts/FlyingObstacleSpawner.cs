using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlyingObstacleSpawner : MonoBehaviour
{

    public GameObject FlyingObstaclePrefab;
    public float initialBirdDelay = 3f;
    public float birdSpawnRate = 3f;
    private GameObject player;
    private GameController gameController;
    private IEnumerator spawnCoRoutine;

    // Start is called before the first frame update
    void Start()
    {
        gameController = GameObject.Find("GameController").GetComponent<GameController>();
        player = GameObject.Find("Player");
        spawnCoRoutine = Spawn();
        StartCoroutine(spawnCoRoutine);

    }

    // Update is called once per frame
    void Update()
    {
        if (gameController.gameover){
            StopCoroutine(spawnCoRoutine);
        }
    }

  IEnumerator Spawn()
  {
    yield return new WaitForSeconds(initialBirdDelay);

    while (!gameController.gameover)
    {

      float y = player.transform.position.y;
      y = Mathf.Min(y, 3f);
      float x = 8.75f;

      Vector3 pos = new Vector3(x, y, transform.position.z);

      Instantiate(FlyingObstaclePrefab, pos, Quaternion.identity);

      yield return new WaitForSeconds(birdSpawnRate);
    }

    yield return null;

  }
}
