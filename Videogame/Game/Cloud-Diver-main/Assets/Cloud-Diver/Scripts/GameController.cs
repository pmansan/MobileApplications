using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameController : MonoBehaviour
{
    public CloudSpawner cloudSpawner;
    public UIController uiController;
    public Player player;
    public float distance = 0;

    public float gameSpeed = 4;
    public bool gameover = false;

    private void GameOver(){
        if(gameover)
            return;

        int finalDistance = (int) Mathf.Floor(distance);
        this.gameSpeed = 0;
        uiController.displayGameOverScreen(finalDistance);
        gameover = true;
    }

    // Start is called before the first frame update
    void Start()
    {
        cloudSpawner.spawnCloud();
        cloudSpawner.heightSpawnDistance = player.jumpHeight;
    }

    // Update is called once per frame
    void Update()
    {
        if (player.isDead){
            GameOver();
        }else{

            distance += gameSpeed * Time.deltaTime;
            int roundedDist = (int) Mathf.Floor(distance);
            uiController.updateDistanceText(roundedDist);
        }
    }
}
