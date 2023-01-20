using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlyingObstacleController : MonoBehaviour
{

    public float speedMultiplier = 1.5f;
    private GameController gameController;

    // Start is called before the first frame update
    void Awake()
    {
        gameController = GameObject.Find("GameController").GetComponent<GameController>();
    }

    // Update is called once per frame
    void Update()
    {
        Vector2 pos = transform.position;
        pos.x -= gameController.gameSpeed * speedMultiplier * Time.deltaTime;
        transform.position = pos;

        if (transform.position.x < -15f){
            Destroy(this);
        }
    }

    void FixedUpdate()
    {
    }
}
