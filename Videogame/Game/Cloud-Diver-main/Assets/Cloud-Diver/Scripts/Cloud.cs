using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cloud: MonoBehaviour  // generates ground object, that also gets this script 
{                                    // and can use it to generate another ground object (loops till game is over)
    private GameController gameController;
    private CloudSpawner spawner;
    private bool hasSpawnedCloud = false;

    [HideInInspector]
    public float spawnTriggerPoint = 0;

    private void Awake()              //runs when game is launched
    {
        gameController= GameObject.Find("GameController").GetComponent<GameController>();
        spawner = GameObject.Find("CloudSpawner").GetComponent<CloudSpawner>();
    }
    
    private void move(){
        Vector2 pos = transform.position;
        pos.x -= gameController.gameSpeed * Time.deltaTime;
        transform.position = pos;
    }

    private void destroy(){
        if (transform.position.x <= (-6 - gameController.gameSpeed)){
            Destroy(gameObject);
        }
    }
    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        this.move();
        this.destroy();

        if (transform.position.x <= this.spawnTriggerPoint && !hasSpawnedCloud)
        {
            this.hasSpawnedCloud = true;
            spawner.spawnCloud();
        }

    }
}
