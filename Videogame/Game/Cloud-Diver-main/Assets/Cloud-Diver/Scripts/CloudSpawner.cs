using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CloudSpawner : MonoBehaviour
{
    public float[] sizes = {1.5f, 2f, 2.5f};
    public float heightSpawnDistance = 0;

    public GameObject CloudPrefab;
    public GameController gameController;

    [Range(-3.375f, 3.375f)]
    public float minSpawnHeight = -3.375f;
    [Range(-3.375f, 3.375f)]
    public float maxSpawnHeight = 3.375f;

    private float lastHeight = - 2;

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void spawnCloud()
    {
        float x = 10;

        float maxY = Mathf.Min(maxSpawnHeight, lastHeight + heightSpawnDistance);
        float y = Random.Range(minSpawnHeight, maxY); 

        lastHeight = y;

        int index = Random.Range (1,(sizes.Length - 1));
        float newSize = sizes[index];

        // How far the cloud has to travel before spawning a new one
        float spawnTriggerPoint =  x - (newSize / 2.0f) - gameController.gameSpeed;
        Vector3 pos = new Vector3(x,y,transform.position.z);

        GameObject newCloud = Instantiate(CloudPrefab, pos, Quaternion.identity);
        newCloud.transform.localScale = new Vector3(newSize, 1, 0);

        Cloud cloudController = newCloud.GetComponent<Cloud>();
        cloudController.spawnTriggerPoint = spawnTriggerPoint;
    }
}